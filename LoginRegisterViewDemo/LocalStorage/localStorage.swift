//
//  localStorage.swift
//  LoginRegisterViewDemo
//
//  Created by Zin Thuzar Win on 8/2/19.
//  Copyright © 2019 Zin Thuzar Win. All rights reserved.
//

import Foundation
import UIKit

class localStorage {
    static let sharedInstance = localStorage()
    
    func getEmail() -> String {
        let defaults = UserDefaults.standard
        let result =  defaults.object(forKey: "getEmail") != nil ? defaults.object(forKey: "getEmail") as! String : ""
        return result
    }
    func setEmail(email: String) {
        let defaults = UserDefaults.standard
        defaults.set("email",forKey: "getEmail")
    }
    
    func getPassword() -> String {
        let defaults = UserDefaults.standard
        let result =  defaults.object(forKey: "getPassword") != nil ? defaults.object(forKey: "getPassword") as! String : ""
        return result
    }
    func setPassword(pwd: String) {
        let defaults = UserDefaults.standard
        defaults.set("password",forKey: "getPassword")
    }
    
    func getToken() -> String {
        let defaults = UserDefaults.standard
        let result =  defaults.object(forKey: "getToken") != nil ? defaults.object(forKey: "getToken") as! String : ""
        return result
    }
    func setToken(token: String) {
        let defaults = UserDefaults.standard
        defaults.set(token,forKey: "getToken")
        print(token)
    }
}
