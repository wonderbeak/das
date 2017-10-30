//
//  CommentVC.swift
//  social
//
//  Created by Jaroslavs Rogacs on 29/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation

import Firebase
import SwiftKeychainWrapper

class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField: UITextView!
    let ds = DataService.init()
    
    var post: Post!
    var comments = [Comment]()
    var array: [String]!
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if post.likes == 0 {
            print("HOLA")
        } else {
            if post.comments.count > 0 {
                for commentId in post.comments {
                    print(commentId)
                    ds.REF_COMMENTS.document(commentId).getDocument { (document, error) in
                        if let document = document {
                            let key = document.documentID
                            let comment = Comment.init(commentKey: key, commentData: document.data())
                            self.comments.append(comment)
                        } else {
                            print("COMMENTVC: Comment does not exist")
                        }
                        self.viewDidAppear(true)
                    }
                }
            }
        }
    }
    
    // TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell {
            cell.configureCell(comment: comment)
            return cell
        } else {
            return CommentCell()
        }
    }

    @IBAction func addPostButton(_ sender: Any) {
        // firebase post comment
        commentToFirebase()
    }

    func commentToFirebase() {
        let userKey = KeychainWrapper.standard.string(forKey: KEY_UID)
        let comment: Dictionary<String, Any> = [
            "authorId": userKey as Any,
            "content": inputField.text as Any,
            "postId": post.postKey,
            "date": Date()
        ]
        let commentKey = ds.REF_COMMENTS.addDocument(data: comment)
        array = post.comments
        array.append(commentKey.documentID)
        let postData: Dictionary<String, Any> = [
            "likes": post.likes + 1,
            "comments": array
        ]
        ds.REF_POSTS.document(post.postKey).updateData(postData)
        
        inputField.text = ""
    }
    
    @IBAction func backBut(_ sender: Any) {
        performSegue(withIdentifier: "backToFeed", sender: nil)
    }
}
