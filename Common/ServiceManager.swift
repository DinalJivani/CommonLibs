
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
                
        var Request = URLRequest(url: URL(string: webpath!)!)
        Request.httpMethod = "GET"
        Request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Request.timeoutInterval = 120
        
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
        
        var Request = URLRequest(url: URL(string: webpath!)!)
        Request.httpMethod = "POST"
        Request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Request.timeoutInterval = 120
        Request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
                
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
                
        Alamofire.upload(multipartFormData: { (multipartFormData) in
           
            for model in imgArray  {
                let imageData = model.Image.jpegData(compressionQuality: 0.7)
                multipartFormData.append(imageData!, withName: model.ImageFileName, fileName: model.ImageFileName + ".jpg", mimeType: "image/png")
                
            }
            
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using:String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!, withName: key)
            }
            
        }, usingThreshold: unit64, to: webpath!, method: .post, headers: nil, encodingCompletion: { (encodingResult) in
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
