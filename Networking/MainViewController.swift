//
//  MainViewController.swift
//  Networking
//
//  Created by Saiteja Alle on 3/3/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

import UIKit

struct PostStructure {
    let message:String!
    let image:UIImage!
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var postTableView: UITableView!
    var likeButton: UIButton!
    var likeCountLabel: UILabel!
    
    var posts:[PostStructure] = []
    var firebase:BaseFire!
    var animateImage:Animation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        firebase = appDelegate.firebase
        
        self.posts = firebase.postArray
        self.postTableView.reloadData()
        
        animateImage = Animation()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToPresentMainViewController(segue: UIStoryboardSegue) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return posts.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let messageLBL = cell?.viewWithTag(2) as! UILabel
        messageLBL.text = posts[indexPath.row].message
        
        let postImageView = cell?.viewWithTag(3) as! UIImageView
        postImageView.image = posts[indexPath.row].image
        
        self.likeCountLabel = cell?.viewWithTag(4) as! UILabel
        
        self.likeButton = cell?.viewWithTag(5) as! UIButton
        likeButton.addTarget(self, action: #selector(likePressed), for: .touchUpInside)
        
        cell?.setNeedsDisplay()

        return cell!
    }
    
    func likePressed() {
        
        
        self.animateImage.likeButtonCenter = likeButton.center
        self.animateImage.labelButtonCenter = likeCountLabel.center
        
        print("Like Button Pressed \(self.animateImage.likeButtonCenter), \(animateImage.labelButtonCenter)")
        self.animateImage.draw(self.postTableView.frame)
        
    }
    
    
    
}
