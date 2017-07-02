//
//  ViewController.swift
//  Networking
//
//  Created by Saiteja Alle on 3/3/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import UserNotifications


class ViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var passswordTF: UITextField!
    
    var firebase:BaseFire!
    
    var userDefaults:UserDefaults!
    
//    var posts:[Posts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebase = BaseFire()
        
        
        if userDefaults != nil {
            print("userDefaults has a value")
           self.performSegue(withIdentifier: "successFul", sender: self)
        }
        
        
        
        
//        let databaseRef = FIRDatabase.database().reference().child("posts")
//        
//        databaseRef.queryOrderedByKey().observe(.childAdded, with: { snapshot in
//            
//            let post = snapshot.value as? Posts
//            
//            print("------------>", post)
////            self.posts.insert(post!, at: 0)
//            
//        })

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logInAction(_ sender: Any) {
        
        print("Login button Pressed")
        firebase.loginUser(userName: userNameTF.text!, password: passswordTF.text!) {[unowned self](user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "successFul", sender: self)
                self.userDefaults = UserDefaults.standard
                self.userDefaults.set(self.userNameTF.text!, forKey: "Username")
                self.userDefaults.set(self.passswordTF.text, forKey: "Password")

            }
            else {
                print("Something is Wrong")
            }
        }
        
    }
    
    
    @IBAction func unwindToPresentLogin(segue:UIStoryboardSegue) {
        print("segue unwinded")
    }

}

