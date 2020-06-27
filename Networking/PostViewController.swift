//
//  PostViewController.swift
//  Networking
//
//  Created by Saiteja Alle on 3/3/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var userSelectedIV: UIImageView!
    
    @IBOutlet weak var messageTF: UITextField!
    
    var firebase:BaseFire!
    
    var dbReference:FIRDatabaseReference!
    var storage:FIRStorage!
    var imageTitle:String!
    var imageURL:URL!
    var thread:ManageThread!
    
    
    var userEmail:String!
    var userMessage:String!
    var userImageDownloadURL:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thread = ManageThread()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        firebase = appDelegate.firebase
        
        dbReference = FIRDatabase.database().reference()
        storage = FIRStorage.storage()
       
        
         // Do any additional setup after loading the view.
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -7.0, 7.0, -5.0, 5.0, 0.0 ]
        userSelectedIV.layer.add(animation, forKey: "shake")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func choosePicture(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alert = UIAlertController(title: "Camera", message: "Choose style", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (cameraAction) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (photoLibraryAction) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos", style: .default) {  (savedPhotosAction) in
            picker.sourceType = .savedPhotosAlbum
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(savedPhotosAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {[unowned self] in
            self.userSelectedIV.image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage?
            self.imageURL = info[UIImagePickerController.InfoKey.referenceURL.rawValue] as! URL

            self.imageTitle = NSUUID().uuidString
            let storageRef = self.storage.reference().child(self.imageTitle)
            
            
            
            let data = self.userSelectedIV.image!.pngData()
            
            let workItem = DispatchWorkItem(block: { 
                let upload = storageRef.put(data!, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    else {
                        print("successfully uploaded")
                        self.userImageDownloadURL = metadata?.downloadURL()?.absoluteString
                    }
                }
            })
            
            self.thread.dataQueue(work: workItem)
            
        }
    }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        userMessage = self.messageTF.text
       
        if self.userImageDownloadURL != nil {
            firebase.postUpload(message: userMessage, imageURL: userImageDownloadURL)
            firebase.dataDownload()
            print("successfully saved to database")
        }else {
            let alert = UIAlertController(title: "Photo", message: "select image", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.show(alert, sender: self)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTF.resignFirstResponder()
        return true
    }
    
}
