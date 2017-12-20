//
//  RegHttpHelper.swift
//  HealthApp
//
//  Created by Edwin Cheong on 14/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import EZLoadingActivity

class RegHttpHelper: NSObject {
    static let baseLink = "http://api.backendless.com/v1/data/Users"
    
    public static let headers:HTTPHeaders = [
        "application-id": "B4344DD7-F3DF-4BA3-FFC4-5699F23F1900",
        "secret-key":  "F8C99EDF-9C49-9B7A-FF2D-9555D3849300",
        "Content-Type": "application/json",
        "application-type": "REST"
    ]
    
    //Registering user to backendless
    public static func postToUser(model: Register) -> Bool {
        let registerParamater: Dictionary<String,AnyObject> = [
            "name": model.regUserName as AnyObject,
            "email":model.regEmail as AnyObject,
            "password": model.regPassword as AnyObject,
            "profilePic":model.regProfilePic as AnyObject
        ]
        
        //let uploaded = uploadProfilePic(profilePic: model.regProfilePic!, picName: model.regUserName!)
        
        EZLoadingActivity.showWithDelay("Registering User", disableUI: false, seconds: 2)
        
        if Utilities.isObjectNil(object: model as AnyObject!) != false {
            Alamofire.request(baseLink, method: .post, parameters: registerParamater, encoding: JSONEncoding.default, headers: self.headers).responseJSON { response in //get error
                switch response.result {
                case .success(var data):
                    data = response.result.value.debugDescription
                    print("JSON = " + String(describing: data) + "\n")
                    
                    //Parsing user
                    let json = JSON(data)
                    let userStatus = json["userStatus"].stringValue
                    let code = json["code"].stringValue
                    
                    print("User Status: " + userStatus)
                    
                    if code == "3003" {
                        EZLoadingActivity.hide(false, animated: false)
                        print("Same user details")
                    }
                    
                case .failure(let error):
                    //Error report
                    EZLoadingActivity.hide(false, animated: true)
                    print("Request failed with error:\n " + String(describing: error))
                }}
            return true
        } else{
            print("Object is null")
            return false
        }
    }
    
    //Uploading image to server
    private static func uploadProfilePic(profilePic:UIImage,picName:String) -> Bool {
        if Utilities.isObjectNil(object: profilePic as AnyObject!) != false  {
            let link = "http://api.backendless.com/v1/files/profilePic/" + picName + ".png"
            let paramaters = ["file_name" : picName + ".png"]
            
            //Upload image to server
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(profilePic, 1)!, withName: "photo_path", fileName: picName, mimeType: "image/png")
                for (key, value) in paramaters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: link, headers:self.headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                        print(progress)
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                    }
                    
                case .failure(let encodingError):
                    print(encodingError.localizedDescription)
                }
            }
            return true
        } else {
            print("Image is empty")
            return false
        }
        
    }
}
