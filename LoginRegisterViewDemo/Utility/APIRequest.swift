//
//  APIRequest.swift
//  LoginRegisterViewDemo
//
//  Created by Zin Thuzar Win on 8/2/19.
//  Copyright © 2019 Zin Thuzar Win. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class APIRequest {
    static let shareInstance = APIRequest()
    
    // this is call back function
    func getDataFromLocalPath(completion: @escaping (_ usersList: NSMutableArray?, _ error: NSError?) -> Void) {
        // use your local local json File
        if let path = Bundle.main.path(forResource: "User.postman_collection", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            
            let parameters = [
                "username": localStorage.sharedInstance.getEmail(), //email
                "password": localStorage.sharedInstance.getPassword() //password
            ]
            
            // add headers after getting login
            let headers: HTTPHeaders = [
                "Authorization": "76843279-f15c-49ab-93bf-ebe84332dc9d",
                "Accept": "application/json"
            ]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
                .validate(contentType: ["application/json"])
                .responseJSON {
                    response in
                    var error: NSError?
                    let dataArr: NSMutableArray = []
                    guard response.result.isSuccess else {
                        error = NSError(domain: "User", code: 123, userInfo: ["Error":"Parse Request", "ErrorType":response.result.error.debugDescription])
                        completion([], error)
                        return
                    }
                    dataArr.addObjects(from: response.result.value as! [Any])
                    completion(dataArr as? NSMutableArray, error)
                    print(dataArr)
            }
        }
    }
    

    func getDataFromURL (urlString: String, completion: @escaping (_ usersList: UserModel?, _ error: NSError?) -> Void) {
        
        // use your url file path
        let url = URL(string: Constant.url + Constant.login)
        
        let parameters = [
            "username": localStorage.sharedInstance.getEmail(), //email
            "password": localStorage.sharedInstance.getPassword() //password
        ]
        
        // add headers after getting login
        let headers: HTTPHeaders = [
            "Authorization": "76843279-f15c-49ab-93bf-ebe84332dc9d",
            "Accept": "application/json"
        ]
       
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseObject {(response: DataResponse<UserModel>) in
                var error: NSError?
                var object: UserModel?
                guard response.result.isSuccess else {
                    error = NSError(domain: "User", code: 123, userInfo: ["Error":"Parse Request", "ErrorType":response.result.error.debugDescription])
                    completion(object, error)
                    return
                }
                object = response.result.value as! UserModel
                completion(object, error)

        }
    }
}
