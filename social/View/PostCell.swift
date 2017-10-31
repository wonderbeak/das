//
//  FancyTableView.swift
//  social
//
//  Created by Jaroslavs Rogacs on 28/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var comments: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var imageUrl: String!
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.content.text = post.content
        self.usernameLabel.text = post.caption
        if KeychainWrapper.standard.string(forKey: KEY_UID) == post.authorId {
            deleteButton.isHidden = false
        }
        if post.likes > 0 {
            self.likesImage.image = UIImage(named: "icon-like")
        }
        DataService.init().REF_USERS.document(post.authorId).getDocument { (document, error) in
            if let document = document {
                let key = document.documentID
                let user = User.init(userKey: key, userData: document.data())
                let profileImage = DataService.init().getImage(uid: user.avatar)
                print(profileImage.documentID)
                profileImage.getDocument { (document, error) in
                    if let document = document {
                        //print("POSTCELL: image is here")
                        let key = document.documentID
                        let image = Image.init(imageKey: key, postData: document.data())
                        //print("POSTCELL: image url \(image.url)")
                        let ref = Storage.storage().reference(forURL: image.url)
                        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if error != nil {
                                print("POSTCELL: Unable to download profile image from Firebase storage.")
                            } else {
                                print("POSTCELL: Profile Image downloaded from Firebase storage")
                                if let imageData = data {
                                    if let img = UIImage(data: imageData) {
                                        self.profileImage.image = img
                                        FeedVC.imageCache.setObject(img, forKey: image.url as! NSString)
                                    }
                                }
                            }
                        }
                    } else {
                        print("POSTCELL: Profile Image does not exist")
                    }
                }
            } else {
                print("PROFILEVC: User data does not exist")
            }
        }
        
        if image != nil {
            self.postImage.image = image
        } else {
            let image = DataService.init().getImage(uid: post.image)
            print(image.documentID)
            image.getDocument { (document, error) in
                if let document = document {
                    //print("POSTCELL: image is here")
                    let key = document.documentID
                    let image = Image.init(imageKey: key, postData: document.data())
                    //print("POSTCELL: image url \(image.url)")
                    let ref = Storage.storage().reference(forURL: image.url)
                    ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if error != nil {
                            print("POSTCELL: Unable to download image from Firebase storage.")
                        } else {
                            print("POSTCELL: Image downloaded from Firebase storage")
                            if let imageData = data {
                                if let img = UIImage(data: imageData) {
                                    self.postImage.image = img
                                    FeedVC.imageCache.setObject(img, forKey: image.url as! NSString)
                                }
                            }
                        }
                    }
                } else {
                    print("POSTCELL: Image does not exist")
                }
            }
        }
    }
    let ds = DataService.init()
    @IBAction func deleteButton(_ sender: Any) {
        for comment in self.post.comments {
            ds.REF_COMMENTS.document(comment).delete()
        }
        ds.REF_IMAGES.document(post.image).delete()
        ds.REF_POSTS.document(post.postKey).delete()
    }
    
}
