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
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var contentField: UITextField!
    
    var postId: String?
    
    var imagePicker: UIImagePickerController!
    static var imageCache:  NSCache<NSString, UIImage> = NSCache()
    var posts = [Post]()
    var imageSelected = false
    
    let ds = DataService.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        ds.REF_POSTS.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("FEEDVC: Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let key = document.documentID
                    let post = Post.init(postKey: key, postData: document.data())
                    self.posts.append(post)
                }
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    // TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            let url = ds.getImage(uid: post.image)
            print(url)
            //var image: UIImage!
            if let img = FeedVC.imageCache.object(forKey: url as NSString) {
                cell.configureCell(post: post, image: img)
                postId = post.postKey
                return cell
            } else {
                cell.configureCell(post: post)
                postId = post.postKey
                return cell
            }
        } else {
            return PostCell()
        }
    }
    
    // IMAGE PICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
        } else {
            print("FEEDVC: A valid image was not selected.")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    // BUTTONS
    @IBAction func addImageButton(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("FEEDVC: Caption must be entered")
            return
        }
        guard let image = addImage.image, imageSelected == true else {
            print("FEEDVC: Image must be entered")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            ds.STORAGE.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("FEEDVC: Unable to upload image to Firebase storage.")
                } else {
                    print("FEEDVC: Successfully uploaded to Firebase storage.")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: downloadURL!)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let image: Dictionary<String, Any> = [
            "name": NSUUID().uuidString,
            "url": imgUrl,
            "date": Date()
        ]
        let firebaseImage = ds.REF_IMAGES.addDocument(data: image)
        
        let post: Dictionary<String, Any> = [
            "caption": captionField.text as Any,
            "image": firebaseImage.documentID,
            "content": contentField.text as Any,
            "date": Date(),
            "likes": 0
        ]
        let firebasePost = ds.REF_POSTS.addDocument(data: post)
        let user = ds.REF_USER_CURRENT
        user.collection("posts").addDocument(data: ["postId": firebasePost.documentID])
        
        captionField.text = ""
        contentField.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "icon-add-image")
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        print("FEEDVC: Sign out performed")
        //print(DataService.init().fetchPost(uid: "46daiPsVmhArL0nx1JEf"))
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    @IBAction func profileButton(_ sender: Any) {
        //performSegue(withIdentifier: "goToProfile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToComments" {
            if let destinationViewController = segue.destination as? CommentVC {
                destinationViewController.post = postId
            }
        }
    }
    
    @IBAction func commentsButton(_ sender: Any) {
        //performSegue(withIdentifier: "goToComments", sender: nil)
    }
    
}
