//
//  ListingViewController.swift
//  LoginRegisterViewDemo
//
//  Created by Zin Thuzar Win on 8/2/19.
//  Copyright © 2019 Zin Thuzar Win. All rights reserved.
//

import Foundation
import UIKit
import FMDB

class ListingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var filePath:String = ""
    var userArr: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.filePath = self.databaseFilePath()
        print(self.filePath)
        
        
        
        UserDAO.shared.RetrieveDatafromAPI { (response, error) in
           print(response)
            if response!.count > 0 {
                self.userArr = response!
                self.tableView.reloadData()
            }
            
            
        }
//        let url = "http://localhost:4000/users"
//        APIRequest.shareInstance.getDataFromURL(urlString: url, completion: { (result, error) in
//            if error == nil {
//                print(result)
//                
//                // show result data from url data in tableView
//                let db = FMDatabase(path: self.filePath)
//                
//                do {
//                    if db.open() ?? false {
//                        if let results = db.executeQuery("SELECT * FROM Users", withArgumentsIn: []) {
//                            while results.next() {
//                                let data_row = NSMutableDictionary()
//                                let id =  results.int(forColumnIndex: 0) as! Int32
//                                data_row.setObject(id, forKey: "id" as NSCopying)
//                                data_row.setObject(results.string(forColumnIndex: 1) as! String, forKey: "firstname" as NSCopying)
//                                data_row.setObject(results.string(forColumnIndex: 2) as! String, forKey: "lastname" as NSCopying)
//                                data_row.setObject(results.string(forColumnIndex: 3) as! String, forKey: "username" as NSCopying)
//                                self.userArr.add(data_row)
//                                self.tableView.reloadData()
//                            }
//                        }
//
//                    } else { print("error") }
//
//                } catch { print("error") }
//            }
//        })
        
        
        
        // Register Custom Cell
        let nib = UINib.init(nibName: "ListingView", bundle: Bundle.main) //className
        tableView.register(nib, forCellReuseIdentifier: "cellCustom")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logoutNotification), name: NSNotification.Name(rawValue: "logoutNotify"), object: nil)
        
    } //end ViewDidLoad
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func logoutNotification(_ notification: Notification) {
        print("Log out")
    }
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "getToken")
        let notify = NSNotification(name: NSNotification.Name(rawValue: "logoutNotify"), object: nil)
        NotificationCenter.default.post(notify as Notification)
    }
    
} //end class

extension ListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ListingCell
        let object = self.userArr[indexPath.row] as! NSDictionary
        let id = object.object(forKey: "_id") as? String
        let firstname = object.object(forKey: "firstName") as? String
        let lastname = object.object(forKey: "lastName") as? String
        let username = object.object(forKey: "username") as? String
        
        cell.lbID.text = "\(id!)"
        cell.lbFirstName.text = "\(firstname!)"
        cell.lbLastName.text = "\(lastname!)"
        cell.lbEmail.text = "\(username!)"
        
      //  let taging = (indexPath.section * 10000) + indexPath.row
    //    cell.btClick.addTarget(self, action: #selector(<#T##@objc method#>), for: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
} //end extension
