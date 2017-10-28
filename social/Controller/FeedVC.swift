//
//  FeedVCViewController.swift
//  social
//
//  Created by Jaroslavs Rogacs on 28/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signOutButton(_ sender: Any) {
        print("Sign out performed")
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
}
