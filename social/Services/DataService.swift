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
    
    private var REF_USERS = Firestore.firestore().collection("users")
    private var REF_POSTS = Firestore.firestore().collection("posts")
    private var REF_COMMENTS = Firestore.firestore().collection("comments")
    private var REF_IMAGES = Firestore.firestore().collection("images")
    //FirebaseApp.configure()
    
    // USERS
    // create
    func createUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.document(uid).setData(userData)
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
    func fetchPosts() -> Any {
        return REF_POSTS.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
//
//    .getDocument{ (document, error) in
//    if let document = document {
//    print(document.data())
//    } else {
//    print("Document does not exist")
//    }
//    }
    
    // COMMENTS
    // create
    func createComment(uid: String, userData: Dictionary<String, Any>){
        REF_COMMENTS.document(uid).setData(userData)
    }
    
    // IMAGES
    // create
    func createImage(uid: String, userData: Dictionary<String, Any>){
        REF_IMAGES.document(uid).setData(userData)
    }
}
