//
//  UserDAO.swift
//  LoginRegisterViewDemo
//
//  Created by Thant Han Linn on 3/8/19.
//  Copyright © 2019 Zin Thuzar Win. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class UserDAO {
    static let shared = UserDAO()
    func loginfromAPI(params: [String: AnyObject], completion: @escaping (_ usersList: UserModel?, _ error: NSError?) -> Void) {
        
        // use your url file path
        let url = URL(string: Constant.url + Constant.login)
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<UserModel>) in
                var userModel: UserModel?
                var error: NSError?
                guard response.result.isSuccess else {
                    completion(userModel, error)
                    return
                }
                userModel = response.result.value
                completion(userModel, error)
        }
    }
    
    func RegisterfromAPI(params: [String: AnyObject], completion: @escaping (_ usersList: UserModel?, _ error: NSError?) -> Void) {
        
        // use your url file path
        let url = URL(string: Constant.url + Constant.register)
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<UserModel>) in
                var userModel: UserModel?
                var error: NSError?
                guard response.result.isSuccess else {
                    completion(userModel, error)
                    return
                }
                userModel = response.result.value
                completion(userModel, error)
        }
    }


    func RetrieveDatafromAPI(completion: @escaping (_ usersList: [UserModel]?, _ error: NSError?) -> Void) {
        
        let token = localStorage.sharedInstance.getToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        print(headers)
        // use your url file path
        let url = URL(string: Constant.url + Constant.user_list)
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseArray { (response: DataResponse<[UserModel]>) in
                var userModel: [UserModel] = []
                var error: NSError?
                guard response.result.isSuccess else {
                    completion(userModel, error)
                    return
                }
                userModel = response.result.value!
                print(response.result.value?.count)
                completion(userModel, error)
                print(userModel)
        }
    }

}
