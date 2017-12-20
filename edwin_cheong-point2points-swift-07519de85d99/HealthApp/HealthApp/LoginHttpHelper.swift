//
//  LoginHttpHelper.swift
//  HealthApp
//
//  Created by Edwin Cheong on 14/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import Alamofire
import EZLoadingActivity
import SwiftyJSON
import ObjectMapper

class LoginHttpHelper: NSObject {
    static let baseLink:String! = "http://api.backendless.com/v1/users/login"
    
    public static func loginUser(model:Login) -> Bool {
        var loginFailed = true
        
        let loginParamater:Dictionary<String,AnyObject> = [
            "login": model.userName as AnyObject,
            "password": model.password as AnyObject
        ]
        
        if Utilities.isObjectNil(object: model as AnyObject!) != false {
            EZLoadingActivity.show("Logging In", disableUI: false)
            
            Alamofire.request(baseLink, method: .post, parameters: loginParamater,encoding:JSONEncoding.default,headers:RegHttpHelper.headers).responseJSON { response in //get error
                switch response.result {
                case .success(let data):
                    print(data)
                    
                    let json = JSON(data)
                    let code = json["code"].stringValue
                    
                    print(code)
                    
                    if code == "3003" {
                        
                        EZLoadingActivity.hide(false, animated: false)
                        print("Invalid email or password")
                        loginFailed = false
                    } else {
                        let jsonData = Mapper<LoginDataModel>().map(JSONObject: data)
                        LoginCRUDHelper.insert(item: jsonData! as LoginDataModel)
                        loginFailed = true
                    }

                    
                case .failure(let error):
                    //Error report
                    EZLoadingActivity.hide(false, animated: true)
                    print("Request failed with error:\n " + String(describing: error))
                }
            }
        } else {
            print("Empty Object : Model")
        }
        
        return loginFailed
    }
    
    public static func postUpdateUser(user: LoginDataModel) {
        let userLink = " https://api.backendless.com/v1/users/" + user.objectID
       
        let headers:HTTPHeaders = [
            "application-id": "B4344DD7-F3DF-4BA3-FFC4-5699F23F1900",
            "secret-key":  "F8C99EDF-9C49-9B7A-FF2D-9555D3849300",
            "Content-Type" : "application/json",
            "application-type" : "REST",
            "user-token" : user.userToken
        ]
        
        let updateParamater:Dictionary<String,AnyObject> = [
            "name" : user.userName as AnyObject,
            "profilePic" : user.profilePic as AnyObject
//            "UserExp": user.userExp as AnyObject,
//            "UserLevel": user.userLevel as AnyObject,
//            "UserMoney" : user.userMoney as AnyObject,
//            "UserTotalDistance" : user.userTotalDistance as AnyObject,
//            "UserBaseLevel" : user.userBaseLevel as AnyObject,
//            "UserZombieNumber" : user.userZombieNumber as AnyObject
        ]
        
        EZLoadingActivity.show("Updating Profile", disableUI: false)
        
        Alamofire.request(userLink, method: .put, parameters: updateParamater, encoding: JSONEncoding.default, headers: headers).responseJSON { response in //get error
            switch response.result {
            case .success(let data):
                print(data)
                
            case .failure(let error):
                //Error report
                EZLoadingActivity.hide(false, animated: true)
                print("Request failed with error:\n " + String(describing: error))
            }
        }

    }
    
    public static func uploadProfilePic(profilePic:UIImage,picName:String) -> Bool {
        if Utilities.isObjectNil(object: profilePic as AnyObject!) != false  {
            let link = "http://api.backendless.com/v1/files/profilePic/" + picName + ".png"
            let paramaters = ["file_name" : picName + ".png"]
            
            EZLoadingActivity.show("Uploading Picture", disableUI: false)
            
            //Upload image to server
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(profilePic, 1)!, withName: "photo_path", fileName: picName, mimeType: "image/png")
                for (key, value) in paramaters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: link, headers:RegHttpHelper.headers)
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
                    EZLoadingActivity.hide(true, animated: true)
                case .failure(let encodingError):
                    print(encodingError.localizedDescription)
                    EZLoadingActivity.hide(false, animated: false)
                }
            }
            return true
        } else {
            print("Image is empty")
            return false
        }
        
    }
    
}
