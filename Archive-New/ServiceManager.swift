//
//  ServiceManager.swift
//  SwiftProjectStructure
//
//  Created by Dinal Jivani on 14/12/19.
//  Copyright © 2018 Dinal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

@objc protocol ServiceManagerDelegate:NSObjectProtocol{
    func webServiceCallSuccess(_ response: Any?, forTag tagname: String?)
    func webServiceCallFailure(_ error: Error?, forTag tagname: String?)
}

class ServiceManager: NSObject {

    var delegate:ServiceManagerDelegate?
    
    
    //MARK:- GET Service API Calling
    func callWebServiceWithGET(webpath: String?, withTag tagname: String?) {
        
        let return_token = USERDEFAULTS.value(forKey: kReturnToken)as? String ?? ""
        let other_user_return_token = USERDEFAULTS.value(forKey: kOtherReturnToken)as? String ?? ""

        let header = ["returned_token":return_token,
                      "other_returned_token":other_user_return_token]
        print("Header Get Method:\(header)")
        
        var Request = URLRequest(url: URL(string: webpath!)!)
        Request.httpMethod = "GET"
        Request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Request.setValue(return_token, forHTTPHeaderField: "returned_token")
        Request.setValue(other_user_return_token, forHTTPHeaderField: "other_returned_token")
        Request.timeoutInterval = 120 // 120 secs
        
        Alamofire.request(Request as URLRequestConvertible).responseJSON {
            response in
            
            if let json = response.result.value {
                let dictResponse = json as! NSDictionary
                if (self.delegate?.responds(to: #selector(self.delegate?.webServiceCallSuccess(_:forTag:))))! {
                    self.delegate?.webServiceCallSuccess(dictResponse, forTag: tagname)
                }
            }
            else{
                if (self.delegate?.responds(to: #selector(self.delegate?.webServiceCallFailure(_:forTag:))))! {
                    self.delegate?.webServiceCallFailure(response.result.error, forTag: tagname)
                }
            }
        }
        
    }
    
    //MARK:-  POST Service API Calling
    func callWebServiceWithPOST(webpath: String?, withTag tagname: String?, params: Parameters) {
        
        let return_token = USERDEFAULTS.value(forKey: kReturnToken)as? String ?? ""
        let jwt_token = USERDEFAULTS.value(forKey: kJWTToken)as? String ?? ""
        
        let other_user_return_token = USERDEFAULTS.value(forKey: kOtherReturnToken)as? String ?? ""
        
        var Request = URLRequest(url: URL(string: webpath!)!)
        Request.httpMethod = "POST"
        Request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Request.setValue(return_token, forHTTPHeaderField: "returned_token")
        Request.setValue(jwt_token, forHTTPHeaderField: "Authorization")
        Request.setValue(other_user_return_token, forHTTPHeaderField: "other_returned_token")
        Request.timeoutInterval = 120 // 120 secs
        Request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        print("Header Post Method:\(String(describing: Request.allHTTPHeaderFields!))")
        
        Alamofire.request(Request as URLRequestConvertible).responseJSON {
            response in
            
            if let json = response.result.value {
                let dictResponse = json as! NSDictionary
                if (self.delegate?.responds(to: #selector(self.delegate?.webServiceCallSuccess(_:forTag:))))! {
                    self.delegate?.webServiceCallSuccess(dictResponse, forTag: tagname)
                }
            }
            else{
                if (self.delegate?.responds(to: #selector(self.delegate?.webServiceCallFailure(_:forTag:))))! {
                    self.delegate?.webServiceCallFailure(response.result.error, forTag: tagname)
                }
            }
        }
    }
    
    //MARK:-  POST Service API Calling with Image uploading
    func callWebServiceWithPOST(webpath: String?, withTag tagname: String?, params: Parameters, imgArray:[AttachmentViewModel])  {
        let unit64:UInt64 = 10_000_000
        
        let return_token = USERDEFAULTS.value(forKey: kReturnToken)as? String ?? ""
        let other_user_return_token = USERDEFAULTS.value(forKey: kOtherReturnToken)as? String ?? ""
        
        let header = ["returned_token":return_token,
                      "other_returned_token":other_user_return_token]
        print("Header Post Image Method:\(header)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
           
            for model in imgArray  {
                let imageData = model.Image.jpegData(compressionQuality: 0.7)
                multipartFormData.append(imageData!, withName: model.ImageFileName, fileName: model.ImageFileName + ".jpg", mimeType: "image/png")
                
            }
            
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using:String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!, withName: key)
            }
            
        }, usingThreshold: unit64, to: webpath!, method: .post, headers: header, encodingCompletion: { (encodingResult) in
            print("encoding result:\(encodingResult)")
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    //send progress using delegate
                })
                upload.responseSwiftyJSON(completionHandler: { (response) in
                    print("response:==>\(response)")
                    
                    if let json = response.result.value {
                        guard !json["data"].isEmpty else{
                            return
                        }
                        guard let rawData = try? json.rawData() else {
                            return
                        }
                        
                        var dicResponse : [String : AnyObject] = [:]
                        do {
                            dicResponse =  (try JSONSerialization.jsonObject(with: rawData, options: []) as? [String:AnyObject])!
                            print(dicResponse)
                        } catch let error as NSError {
                            print(error)
                        }
                        
                        if (self.delegate?.responds(to: #selector(self.delegate?.webServiceCallSuccess(_:forTag:))))! {
                            self.delegate?.webServiceCallSuccess(dicResponse, forTag: tagname)
                        }
                        
                    }
                })
                
            case .failure(let encodingError):
                if (self.delegate?.responds(to: #selector(self.delegate?.webServiceCallFailure(_:forTag:))))! {
                    self.delegate?.webServiceCallFailure(encodingError, forTag: tagname)
                }
            }
        })
    }
}
