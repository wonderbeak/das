//
//  FancyTableView.swift
//  social
//
//  Created by Jaroslavs Rogacs on 28/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var comments: UIButton!
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.content.text = post.content
        self.usernameLabel.text = post.caption
        
        if image != nil {
            self.postImage.image = image
        } else {
            let url = DataService.init().getImage(uid: post.image)
            let ref = Storage.storage().reference(forURL: url)
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    print("POSTCELL: Unable to download image from Firebase storage.")
                } else {
                    print("POSTCELL: Image downloaded from Firebase storage")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: url as NSString)
                        }
                    }
                }
            }
        }
    }
}
