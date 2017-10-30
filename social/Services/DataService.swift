//
//  DataService.swift
//  social
//
//  Created by Jaroslavs Rogacs on 29/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    public var REF_USERS = Firestore.firestore().collection("users")
    public var REF_POSTS = Firestore.firestore().collection("posts")
    public var REF_COMMENTS = Firestore.firestore().collection("comments")
    public var REF_IMAGES = Firestore.firestore().collection("images")
    
    public var STORAGE = STORAGE_BASE.child("post-pics")
    
    // USERS
    // create
    func createUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.document(uid).setData(userData)
    }
    
    // select
    var REF_USER_CURRENT: DocumentReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.document(uid!)
        return user
    }
    
    // update
    func updateUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.document(uid).updateData(userData)
    }
    
    // POSTS
    // create
    func createPost(uid: String, userData: Dictionary<String, Any>){
        REF_POSTS.document(uid).setData(userData)
    }
    
    // select
    func fetchPost(uid: String) -> Any {
        return REF_POSTS.document(uid)
    }
    
    func getImage(uid: String) -> DocumentReference {
        print("DataService: Fetching image: \(uid)")
        return REF_IMAGES.document(uid)
    }
    
    // COMMENTS
    // create
    func createComment(uid: String, userData: Dictionary<String, Any>){
        REF_COMMENTS.document(uid).setData(userData)
    }
    // select

    
    // IMAGES
    // create
    func createImage(uid: String, userData: Dictionary<String, Any>){
        REF_IMAGES.document(uid).setData(userData)
    }
}
