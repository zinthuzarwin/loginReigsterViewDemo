//
//  RegisterViewController.swift
//  LoginRegisterViewDemo
//
//  Created by Zin Thuzar Win on 8/2/19.
//  Copyright © 2019 Zin Thuzar Win. All rights reserved.
//

import Foundation
import UIKit
import FMDB

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var viewBackground: UIView!
    
    var filePath:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //save db filePath
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
    
    @IBAction func Register(_ sender: UIButton) {
        
       let firstName = txtFirstName.text!
       let lastName = txtLastName.text!
       let email = txtEmail.text!
       let password = txtPassword.text!
        
        guard txtEmail.text != "" else {
            //show alert
            return
        }
        guard txtPassword.text != "" else {
            //show alert
            return
        }
        guard txtFirstName.text != "" else {
            //show alert
            return
        }
        guard txtLastName.text != "" else {
            //show alert
            return
        }
        
        let params = [
            "username": txtEmail.text!,
            "password": txtPassword.text!,
            "firstname": txtFirstName.text!,
            "lastname": txtLastName.text!
        ]
        
        UserDAO.shared.RegisterfromAPI(params: params as [String : AnyObject]) { (response, errro) in
            self.txtEmail.text = ""
            self.txtPassword.text = ""
            self.txtFirstName.text = ""
            self.txtLastName.text = ""
        }
        
    } //end Register
    
    @IBAction func Login(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginView") as? ViewController
        self.present(vc!, animated: true, completion: nil)
    }
}
