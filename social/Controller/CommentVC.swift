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
    
    let ds = DataService.init()
    
    var post: Post!
    var comments = [Comment]()
    
    
    
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
                        self.tableView.reloadData()
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

    
    @IBAction func backBut(_ sender: Any) {
        performSegue(withIdentifier: "backToFeed", sender: nil)
    }
}
