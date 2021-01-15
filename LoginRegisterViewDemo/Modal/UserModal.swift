//
//  UserModal.swift
//  LoginRegisterViewDemo
//
//  Created by Zin Thuzar Win on 8/3/19.
//  Copyright © 2019 Zin Thuzar Win. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: Mappable {
    var _id: String?
    var firstName: String?
    var lastName: String?
    var username: String?
    var createdDate: String?
    var token: String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        username <- map["username"]
        createdDate <- map["createdDate"]
        token <- map["token"]
    }
}
