//
//  Firebase.swift
//  Networking
//
//  Created by Saiteja Alle on 3/24/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class BaseFire {
    
    var thread:ManageThread!
    var postArray:[PostStructure]!
    var storage:FIRStorage!
    var databaseRef:FIRDatabaseReference!

    
    init() {
        print("Firebase is initialized")
        thread = ManageThread()
        postArray = []
        print("Thread is initialized")
        storage = FIRStorage.storage()
        databaseRef = FIRDatabase.database().reference().child("posts")

    }
    
    func loginUser(userName:String, password:String, completion:FIRAuthResultCallback?) {
        
        let workItem = DispatchWorkItem { 
            FIRAuth.auth()?.signIn(withEmail: userName, password: password, completion: { (user, error) in
                if error == nil {
                    completion!((user, error))
                }
            })
        }
        thread.networkingQueue(work: workItem)
    }
    
    func dataDownload(){
        
        print("Data download started")
        
        let workItem = DispatchWorkItem { 
            self.databaseRef.queryOrderedByKey().observe(.childAdded, with: { snapshot in
                let postDictionary = snapshot.value as? [String:String] ?? [:]
                
                if postDictionary["postDownloadURL"] != nil {
                
                let httpsReference = self.storage.reference(forURL: postDictionary["postDownloadURL"]!)
                    httpsReference.data(withMaxSize: 20 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("Error:", error)
                        }else {
                            self.postArray.insert(PostStructure(message: postDictionary["message"] , image: UIImage(data: data!)), at: 0)
                        }
                    }
                }

            })
        }
        thread.dataQueue(work: workItem)
    }
    
//    func imageUpload(imageTitle:String, data:Data) {
//        
//        let storageRef = self.storage.reference().child(imageTitle)
//
//        let upload = storageRef.put(data, metadata: nil) { (metadata, error) in
//            if error == nil {
//                print("successfully uploaded")
////                self.userImageDownloadURL = metadata?.downloadURL()?.absoluteString
//            }
//        }
//
//    }
    
    
    func postUpload(message:String, imageURL:String) {
        self.databaseRef.childByAutoId().setValue(["message":message, "postDownloadURL": imageURL])
    }
    
    
    
}
