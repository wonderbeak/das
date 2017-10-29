//
//  FeedVCViewController.swift
//  social
//
//  Created by Jaroslavs Rogacs on 28/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.init().REF_POSTS.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let key = document.documentID
                    let post = Post.init(postKey: key, postData: document.data())
                    self.posts.append(post)
                    //print("\(document.documentID) => \(document.data())")
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            return cell
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
        } else {
            print("A valid image was not selected.")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButton(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func signOutButton(_ sender: Any) {
        print("Sign out performed")
        //print(DataService.init().fetchPost(uid: "46daiPsVmhArL0nx1JEf"))
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
}
