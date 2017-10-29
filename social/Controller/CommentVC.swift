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

class CommentVC: UIViewController {

    var post: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(post)
    }
    
    @IBAction func backBut(_ sender: Any) {
        performSegue(withIdentifier: "backToFeed", sender: nil)
    }
}
