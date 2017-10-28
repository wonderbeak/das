//
//  ViewController.swift
//  social
//
//  Created by Jaroslavs Rogačs on 08/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    @IBOutlet weak var errorField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("FOUND!!!")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
            if error != nil {
                self.alert(text: "Unable to authenticate with Firebase.", flag: false)
            } else {
                self.alert(text: "Successfully authenticated with Firebase.", flag: true)
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
                if error == nil {
                    self.alert(text: "Email user authenticated with Firebase.", flag: true)
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    if isValidEmail(testStr: email) {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
                            if error != nil {
                                self.alert(text: "Unable to authenticate with Firebase", flag: false)
                                } else {
                                self.alert(text: "Successfully created new user in Firebase.", flag: true)
                                if let user = user {
                                    self.completeSignIn(id: user.uid)
                                }
                            }
                        })
                        self.alert(text: "Authentication rejected by Firebase.", flag: false)
                    } else {
                        self.alert(text: "Please provide correct email address.", flag: false)
                    }
                }
            })
        }
    }
    
    func alert(text: String!, flag: Bool) {
        if (flag) {
            self.errorField.text = text
            self.errorField.textColor = UIColor.darkGray
        }  else {
            self.errorField.text = text
            self.errorField.textColor = UIColor.red
        }
        self.errorField.isHidden = false
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID) // problemo here
        print("Data successfully saved to keychain: \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

