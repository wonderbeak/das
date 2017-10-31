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
import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    @IBOutlet weak var errorField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
//            performSegue(withIdentifier: "goToFeed", sender: nil)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            if error != nil {
                self.alert(text: "SIGNINVC: Unable to authenticate with Firebase.", flag: false)
            } else {
                self.alert(text: "SIGNINVC: Successfully authenticated with Firebase.", flag: true)
                if let user = user {
                    let userData: Dictionary<String, Any> = ["avatar": "0POW0X248Apdl2dEHwgJ",
                                                             "name": "",
                                                             "birth": "",
                                                             "bio": "",
                                                             "uid": user.uid,
                                                             "date": Date(),
                                                             "posts": [String]()
                    ]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    @IBAction func facebookButton(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("SIGNINVC: Unable to authenticate with facebook.")
            } else if result?.isCancelled == true {
                print("SIGNINVC: User cancelled facebook authentication.")
            } else {
                print("SIGNINVC: Successfully authenticated with facebook.")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                if error == nil {
                    self.alert(text: "SIGNINVC: Email user authenticated with Firebase.", flag: true)
                    if let user = user {
                        let userData: Dictionary<String, Any> = ["date": Date()]
                        self.completeUpdatedSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    if isValidEmail(testStr: email) {
                        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                            if error != nil {
                                self.alert(text: "SIGNINVC: Unable to authenticate with Firebase", flag: false)
                                } else {
                                self.alert(text: "SIGNINVC: Successfully created new user in Firebase.", flag: true)
                                if let user = user {
                                    let userData: Dictionary<String, Any> = ["avatar": "0POW0X248Apdl2dEHwgJ",
                                                                             "name": "",
                                                                             "birth": "",
                                                                             "bio": "",
                                                                             "uid": user.uid,
                                                                             "date": Date(),
                                                                             "posts": [String]()
                                                                             ]
                                    self.completeSignIn(id: user.uid, userData: userData)
                                }
                            }
                        })
                        self.alert(text: "SIGNINVC: Authentication rejected by Firebase.", flag: false)
                    } else {
                        self.alert(text: "SIGNINVC: Please provide correct email address.", flag: false)
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
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("SIGNINVC: Data successfully saved to keychain: \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    func completeUpdatedSignIn(id: String, userData: Dictionary<String, Any>) {
        DataService.init().updateUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("SIGNINVC: Data successfully saved to keychain: \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

