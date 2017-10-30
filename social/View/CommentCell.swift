//
//  CommentCell.swift
//  social
//
//  Created by Jaroslavs Rogacs on 30/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation
import Firebase

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentField: UITextView!
    
    var comment: Comment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(comment: Comment) {
        self.comment = comment
        self.contentField.text = comment.content
        //date format
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let date = formatter.string(from: comment.date)
        
        self.dateLabel.text = date
        
//        if image != nil {
//            self.postImage.image = image
//        } else {
//            //print(post.image)
//            let url = DataService.init().getImage(uid: post.image)
//            print(url)
//            let ref = Storage.storage().reference(forURL: url)
//            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                if error != nil {
//                    print("Unable to download image from Firebase storage.")
//                } else {
//                    print("Image downloaded from Firebase storage")
//                    if let imageData = data {
//                        if let img = UIImage(data: imageData) {
//                            self.postImage.image = img
//                            FeedVC.imageCache.setObject(img, forKey: url as NSString)
//                        }
//                    }
//                }
//            }
//        }
    }
    
}
