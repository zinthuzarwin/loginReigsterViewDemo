//
//  ViewController.swift
//  LoginRegisterViewDemo
//
//  Created by Zin Thuzar Win on 8/2/19.
//  Copyright © 2019 Zin Thuzar Win. All rights reserved.
//

import UIKit
import FMDB
import Alamofire
import AlamofireObjectMapper

class ViewController: UIViewController {
    
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    var filePath:String = ""
    var userArr: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set backgroundImage
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //Save DB FilePath
        self.filePath = self.databaseFilePath()
        print(self.filePath)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.txtEmail.becomeFirstResponder()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(gesture:)))
        self.viewBackground.addGestureRecognizer(gesture)
        
    }
    
    @objc func dismissKeyboard(gesture: UIGestureRecognizer) {
        
        //self.txtEmail.resignFirstResponder()
        //self.txtPassword.becomeFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardFrame =  (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            }
        }
        
    }
    
    //Locating DB FilePath
    func databaseFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths[0] as NSString
        let db_path = dir.appendingPathComponent("Info.db")
        let source_localdb = (Bundle.main.resourcePath! as NSString).appendingPathComponent("UserList/Info.db")
        
        if !FileManager.default.fileExists(atPath: db_path){
            do {
                try FileManager.default.copyItem(atPath: source_localdb, toPath: db_path as String)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error)")
            } }
        return dir.appendingPathComponent("Info.db")
        
    }
    
    @IBAction func Login(_ sender: UIButton) {
        guard txtEmail.text != "" else {
            //show alert
            return
        }
        guard txtPassword.text != "" else {
            //show alert
            return
        }
        let params = [
            "username": txtEmail.text!,
            "password": txtPassword.text!
        ]
        
        UserDAO.shared.loginfromAPI(params: params as [String : AnyObject]) { (response, errro) in
            localStorage.sharedInstance.setToken(token:  response?.token! ?? "")
            let storyboard = UIStoryboard(name: "Listing", bundle: Bundle.main)
            let nav = storyboard.instantiateViewController(withIdentifier: "listingView") as? UINavigationController
            let vc = nav?.topViewController as! ListingViewController
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(nav!, animated: true, completion: nil)
        }
//        // getting data from url
//       let url = "http://localhost:4000/users"
//
//        APIRequest.shareInstance.getDataFromURL(urlString: url, completion: { (result, error) in
//            if error == nil {
//                let db = FMDatabase(path: self.filePath)
//                do {
//                    if db.open() {
//                        if let rs = try? db.executeQuery("SELECT * FROM User WHERE email=? and password=?", values: [uemail, upassword]) {
//                            print(rs)
//                            print(rs.columnCount)
//                            if rs.columnCount > 0 {
//
//                                localStorage.sharedInstance.setEmail(email: "\(uemail)")
//                                localStorage.sharedInstance.setPassword(pwd: "\(upassword)")
//                                let storyboard = UIStoryboard(name: "Listing", bundle: Bundle.main)
//                                let nav = storyboard.instantiateViewController(withIdentifier: "listingView") as? UINavigationController
//                                let vc = nav?.topViewController as! ListingViewController
//                                vc.modalTransitionStyle = .crossDissolve
//                                vc.modalPresentationStyle = .overCurrentContext
//                                self.present(nav!, animated: true, completion: nil)
//
//                            } else { print("Error") }
//
//                        } else { print("error") }
//
//                    } else { print("error") }
//
//                } catch { print("error") }
//            }
//        })
//
    } //end login
    
    
    @IBAction func Register(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Register", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "registerView") as? RegisterViewController
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "logoutNotify"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

