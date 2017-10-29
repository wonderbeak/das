//
//  DataService.swift
//  social
//
//  Created by Jaroslavs Rogacs on 29/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation
import Firebase


class DataService {
    
    //static let ds = DataService()
    
    public var REF_USERS = Firestore.firestore().collection("users")
    public var REF_POSTS = Firestore.firestore().collection("posts")
    public var REF_COMMENTS = Firestore.firestore().collection("comments")
    public var REF_IMAGES = Firestore.firestore().collection("images")
    //FirebaseApp.configure()
    
    func createUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.document(uid).setData(userData)
    }
    
    func createPost(uid: String, userData: Dictionary<String, Any>){
        REF_POSTS.document(uid).setData(userData)
    }
    
    func createComment(uid: String, userData: Dictionary<String, Any>){
        REF_COMMENTS.document(uid).setData(userData)
    }
    
    func createImage(uid: String, userData: Dictionary<String, Any>){
        REF_IMAGES.document(uid).setData(userData)
    }
}
