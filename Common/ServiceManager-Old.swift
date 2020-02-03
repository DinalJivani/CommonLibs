
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
    
    //GET Service Calling
    func callWebServiceWithGET(webpath: String?, withTag tagname: String?) {
        
        Alamofire.request(webpath!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: "", password: "").responseSwiftyJSON(completionHandler:{ (response) in
                        
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
            else{
                if (self.delegate?.responds(to: #selector(self.delegate?.webServiceCallFailure(_:forTag:))))! {
                    self.delegate?.webServiceCallFailure(response.result.error, forTag: tagname)
                }

            }
            
        })
    }
    
    //POST Service Calling
    func callWebServiceWithPOST(webpath: String?, withTag tagname: String?, params: Parameters) {
        
        Alamofire.request(webpath!, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: "", password: "").responseSwiftyJSON(completionHandler:{ (response) in
                        
            if let json = response.result.value { 
              /*  guard !json["data"].isEmpty else{
                    return
                }*/
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
            else{
                if (self.delegate?.responds(to: #selector(self.delegate?.webServiceCallFailure(_:forTag:))))! {
                    self.delegate?.webServiceCallFailure(response.result.error, forTag: tagname)
                }
            }
            
        })
    }
    
    func callWebServiceWithPOST(webpath: String?, withTag tagname: String?, params: Parameters, imgArray:[AttachmentViewModel])  {
        let unit64:UInt64 = 10_000_000
        Alamofire.upload(multipartFormData: { (multipartFormData) in
           
            for model in imgArray  {
                let imgData = UIImageJPEGRepresentation(model.Image, 0.7)
                multipartFormData.append(imgData!, withName: model.ImageFileName, fileName: model.ImageFileName, mimeType: "image/png")
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
