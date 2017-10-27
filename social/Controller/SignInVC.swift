//
//  ViewController.swift
//  social
//
//  Created by Jaroslavs Rogačs on 08/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase.")
            } else {
                print("Successfully authenticated with Firebase.")
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
                if error == nil {
                    print("Email user authenticated with Firebase.")
                } else {
                    if isValidEmail(testStr: email) {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
                            if error != nil {
                                print("Unable authenticate with Firebase")
                            } else {
                                print("Successfully authenticated with Firebase.")
                            }
                        })
                        print("Authentication rejected by Firebase.")
                    } else {
                        print("Please provide correct email address.")
                    }
                }
            })
        }
    }
    
}

