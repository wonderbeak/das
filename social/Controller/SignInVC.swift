//
//  ViewController.swift
//  social
//
//  Created by Jaroslavs Rogačs on 08/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
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

    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            if error != nil {
                self.alert(text: "Unable to authenticate with Firebase.", flag: false)
            } else {
                self.alert(text: "Successfully authenticated with Firebase.", flag: true)
                if let user = user {
                    let userData = ["avatar": "kkk",
                                    "name": "Jaroslavs",
                                    "birth": "14.07.1989",
                                    "uid": user.uid]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                if error == nil {
                    self.alert(text: "Email user authenticated with Firebase.", flag: true)
                    if let user = user {
                        let userData = ["avatar": "kkk",
                                        "name": "Jaroslavs",
                                        "birth": "14.07.1989",
                                        "uid": user.uid]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    if isValidEmail(testStr: email) {
                        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                            if error != nil {
                                self.alert(text: "Unable to authenticate with Firebase", flag: false)
                                } else {
                                self.alert(text: "Successfully created new user in Firebase.", flag: true)
                                if let user = user {
                                    let userData = ["avatar": "kkk",
                                                    "name": "Jaroslavs",
                                                    "birth": "14.07.1989",
                                                    "uid": user.uid]
                                    self.completeSignIn(id: user.uid, userData: userData)
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
    
    func completeSignIn(id: String, userData: Dictionary<String, Any>) {
        DataService.init().createUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID) // problemo here
        print("Data successfully saved to keychain: \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

