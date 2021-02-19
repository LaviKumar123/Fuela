//
//  WebAPIs.swift
//  Camel
//
//  Created by CallSoft on 03/12/18.
//  Copyright © 2018 Lavi Motwal. All rights reserved.
//

import Foundation
import Alamofire

var imageURL  = ""

class WebAPI {
    
    static var shared = WebAPI()
    
    class func requestToGetType(_ urlString: String, completion: @escaping(_ receivedData: AnyObject, _ isSuccess: Bool)-> Void) {
      let url = URLConstant.baseURL + urlString
        print(url)
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in

            if response.response != nil {

                if let json = response.result.value {
                    completion(json as AnyObject, true)
                }else {
                    self.gotToLogin()
                    completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
                }
            }else {
                completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
            }
        }
    }
    
    class func requestToPostType(_ urlString : String, params getParams: [String : AnyObject], completion: @escaping(_ receivedData: AnyObject, _ isSuccess : Bool)-> Void) {
        
        let url = URLConstant.baseURL + urlString
        
        print(url)
        
        Alamofire.request(url, method: .post, parameters: getParams as Parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.response != nil {
                if let json = response.result.value {
                    completion(json as AnyObject, true)
                }else {
                    self.gotToLogin()
                    completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
                }
            }else {
                completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
            }
        }
    }
    
    class func requestToPostWithDataWithoutHeader(_ urlString: String, params getParams: [String:String]?,fileData: Data?, fileKey:String, fileName: String, completion: @escaping(_ responseData: AnyObject, _ isSuccess: Bool)-> Void) {
        
        let url = URLConstant.baseURL + urlString
        
        print(url)

        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            
            if let data = fileData {
                multipartFormData.append(data, withName: fileKey,fileName: "\(fileName).jpeg" , mimeType: "image/jpeg")
            }
            
            if let params = getParams {
                for (key, value) in params
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, usingThreshold:UInt64.init(),
           to: url, //URL Here
            method: .post,
            encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        if let json = response.result.value {
                            completion(json as AnyObject, true)
                        }else {
                            self.gotToLogin()
                            completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
                        }
                    }
                    break
                case .failure(let encodingError):
                        completion(["Error" : encodingError.localizedDescription] as AnyObject, false)
                    break
                }
        })
    }
    
    class func requestToPostWithData(_ urlString: String, params getParams: [String:String]?,header: [String:Any],fileData: Data?, fileKey:String, fileName: String, completion: @escaping(_ responseData: AnyObject, _ isSuccess: Bool)-> Void) {
        
        let url = URLConstant.baseURL + urlString
        
        print(url)
        print(header)

        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            
            if let data = fileData {
                multipartFormData.append(data, withName: fileKey,fileName: "\(fileName).png" , mimeType: "image/png")
            }
            
            if let params = getParams as? [String:String] {
                for (key, value) in params
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, usingThreshold:UInt64.init(),
           to: url, //URL Here
            method: .post,
            headers: (header as! HTTPHeaders), //pass header dictionary here
            encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        if let json = response.result.value {
                            completion(json as AnyObject, true)
                        }else {
                            self.gotToLogin()
                            completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
                        }
                    }
                    break
                case .failure(let encodingError):
                        completion(["Error" : encodingError.localizedDescription] as AnyObject, false)
                    break
                }
        })
    }
    
    class func requestToPostMultiImagesWithHeader(_ urlString: String, params getParams: [String:String],header: [String:Any],fileData: [Data], fileKey:String, completion: @escaping(_ responseData: AnyObject, _ isSuccess: Bool)-> Void) {
        
        let url = URLConstant.baseURL + urlString
        
        print(url)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            var i = 0
            for data in fileData {
                multipartFormData.append(data, withName: fileKey + "[\(i)]",fileName: "furkan.png" , mimeType: "image/png")
                i += 1
            }
            
            for (key, value) in getParams{
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold:UInt64.init(),
           to: url, //URL Here
            method: .post,
            headers: (header as! HTTPHeaders), //pass header dictionary here
            encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        if let json = response.result.value {
                            completion(json as AnyObject, true)
                        }else {
                            completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
                        }
                    }
                case .failure(let encodingError): break
                completion(["Error" : encodingError.localizedDescription] as AnyObject, false)
                }
        })
    }
    
    class func requestToPOSTWithHeader(_ strURL : String, params : [String : AnyObject]?, headers : [String : AnyObject]?, completion:@escaping (_ receivedData: AnyObject, _ isSuccess : Bool) -> Void) {
        
        let url = URLConstant.baseURL + strURL
        
        print(url)
        
        let httpHeader = headers
//        httpHeader!["Content-Type"] = "application/json" as AnyObject
        
        let finalHeaders: HTTPHeaders = httpHeader as! HTTPHeaders
        
        print(finalHeaders)
        
        let urlValue = URL(string: url)!
        
        Alamofire.request(urlValue, method: .post, parameters: params, encoding: JSONEncoding.default, headers:finalHeaders).responseJSON { response in
            
            if response.response != nil {
                
                if let json = response.result.value {
                    completion(json as AnyObject, true)
                }else {
                    self.gotToLogin()
                    completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
                }
            }else {
                completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
            }
        }
    }
    
    class func requestToPostWithBodyForm(_ urlString : String, params : [String : AnyObject]?, headers : [String : AnyObject]?, completion:@escaping (_ receivedData: AnyObject, _ isSuccess : Bool) -> Void) {
        
         let url = URLConstant.baseURL + urlString
        
         let finalHeaders: HTTPHeaders = headers as! HTTPHeaders
        
        do {
            var request = try URLRequest(url: url, method: .post, headers: finalHeaders)
            request.httpBody = try JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
            request.timeoutInterval = 500
            
            Alamofire.request(request).responseString(completionHandler: { (response) in
                
                if "\(response.result)" != "FAILURE" {
                    if let json = response.result.value {
                        completion(json as AnyObject, true)
                    }else {
                        
                        completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
                    }
                }else {
                    self.gotToLogin()
                }
            })
        } catch {
            print(error)
            completion(["Error" : error.localizedDescription] as AnyObject, false)
        }
    }
    
    class func requestToPostBodyWithHeader(_ urlString: String,_ params: [String: Any], header: [String:Any],completion: @escaping(_ receivedData: AnyObject, _ isSuccess: Bool)-> Void) {
        
        
        let postData = NSMutableData()
        
        for (key,value) in params {
            if postData.length == 0 {
                postData.append("\(key)=\(value)".data(using: String.Encoding.utf8)!)
            }else {
                postData.append("&\(key)=\(value)".data(using: String.Encoding.utf8)!)
            }
        }
        let url = URLConstant.baseURL + urlString
        print(url)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = (header as! [String : String])
        request.httpBody = postData as Data
        request.timeoutInterval = 500
        
        Alamofire.request(request).responseJSON { response in
            if response.response != nil {
                if "\(response.result)" != "FAILURE" {
                    if let json = response.result.value {
                        completion(json as AnyObject, true)
                    }else {
                        
                        completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
                    }
                }else {
                    self.gotToLogin()
                }
            }else {
                completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
            }
        }
    }
    
    class func requestToGetWithHeader(_ urlString : String, header: [String: AnyObject], completion: @escaping(_ receivedData: AnyObject, _ isSuccess : Bool)-> Void) {
        
        var url = urlString
        
        if !url.contains("http") {
            url = URLConstant.baseURL + urlString
        }
        
        print(url)
        
        let httpHeader = header
        //      httpHeader["Content-Type"] = "application/json" as AnyObject
        
        let finalHeaders: HTTPHeaders = httpHeader as! HTTPHeaders
        
        print(finalHeaders)
        
        Alamofire.request(url, headers: finalHeaders).responseJSON { response in
            
            if response.response != nil {
                
                if "\(response.result)" != "FAILURE" {
                    if let json = response.result.value {
                       completion(json as AnyObject, true)
                    }else {
                        
                        completion(["message" : response.error?.localizedDescription] as AnyObject, false)
                    }
                }else {
                    self.gotToLogin()
                }
            }else {
                completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
            }
        }
    }
    
    class func requestToPostWithoutBaseURL(_ urlString : String, params getParams: [String : AnyObject], completion: @escaping(_ receivedData: AnyObject, _ isSuccess : Bool)-> Void) {
        
        let url = urlString
        
        print(url)
        
        Alamofire.request(url, method: .get, parameters: getParams as Parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.response != nil {
                if "\(response.result)" != "FAILURE" {
                    if let json = response.result.value {
                        completion(json as AnyObject, true)
                    }else {
                        
                        completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
                    }
                }else {
                    self.gotToLogin()
                }
            }else {
                completion(["Error" : response.error?.localizedDescription] as AnyObject, false)
            }
        }
    }
    
    class func gotToLogin(){
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            rootVC.showAlert(title: "Error", message: "Your session Expired, You have to login again.", completion: { (isYes) in
                UserDefaults.standard.removeObject(forKey: "Loggin User")
                
//                APP_DELEGATE.navigationController.popViewController(animated: true)
            })
        }
    }
}

extension UIImageView {
    
    func setImageWith(_ imageName: String , PlaceholderImage: UIImage) {
        
        self.image = PlaceholderImage
        
        self.accessibilityHint = (imageURL + imageName).replacingOccurrences(of: " ", with: "%20")
        
        //print(imgURL + ImageURL)
        if !imageURL.contains("<null>") && imageURL != ""{
            
            Alamofire.request((imageURL + imageName).replacingOccurrences(of: " ", with: "%20")).responseData { (response) in
                
                if "\(response.request!)" == self.accessibilityHint {
                    
                    if response.error == nil {
                        
                        if let data = response.data {
                            
                            if UIImage(data: data) != nil {
                                
                                self.image = UIImage(data: data)
                                
                            }else {
                                
                                self.image = PlaceholderImage
                                
                            }
                        }
                    }
                }
            }
        }else {
            self.image = PlaceholderImage
        }
    }
    
    func setImageWithoutBaseURL(_ imageURL: String , PlaceholderImage: UIImage) {
        
        self.image = PlaceholderImage
        
        if !imageURL.contains("<null>") && imageURL != ""{
            
            self.accessibilityHint = imageURL.replacingOccurrences(of: " ", with: "%20")
            
            Alamofire.request(imageURL.replacingOccurrences(of: " ", with: "%20")).responseData { (response) in
                
//                print(imageURL)
                
                if "\(response.request!)" == self.accessibilityHint {
                    
                    if response.error == nil {
                        
                        if let data = response.data {
                            
                            if UIImage(data: data) != nil {
                                
                                self.image = UIImage(data: data)
                                
                            }else {
                                self.image = PlaceholderImage
                            }
                        }
                    }
                }
            }
        }else {
            self.image = PlaceholderImage
        }
    }
    
    
    func setImageWithoutBase(imageURL: String) {
        
        self.accessibilityHint = imageURL.replacingOccurrences(of: " ", with: "%20")
        
        if !imageURL.contains("<null>") && imageURL != ""{
            
            Alamofire.request(imageURL.replacingOccurrences(of: " ", with: "%20")).responseData { (response) in
                
                if "\(response.request!)" == self.accessibilityHint {
                    
                    if response.error == nil {
                        
                        if let data = response.data {
                            
                            if UIImage(data: data) != nil {
                                
                                self.image = UIImage(data: data)
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

extension String {
    public func addingPercentEncodingForQueryParameter() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        
        return allowed
    }()
}
