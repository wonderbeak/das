//
//  DataService.swift
//  social
//
//  Created by Jaroslavs Rogacs on 29/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation
import Firebase

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
    
    // POSTS
    // create
    func createPost(uid: String, userData: Dictionary<String, Any>){
        REF_POSTS.document(uid).setData(userData)
    }
    // select
    func fetchPost(uid: String) -> Any {
        return REF_POSTS.document(uid)
    }
    
    var imageUrl: String = "gs://utgard-a8029.appspot.com/post-pics/usa.jpg"
    
    func getImage(uid: String) -> String {
        print("LALALALALALA \(uid)")
        REF_IMAGES.document(uid).getDocument { (document, error) in
            if let document = document {
                let key = document.documentID
                let image = Image.init(imageKey: key, postData: document.data())
                self.imageUrl = image.url
            } else {
                print("JAR: Image does not exist")
            }
        }
        return imageUrl
    }
    
//    var posts = [Post]()
//
//    func fetchPosts() -> [Post] {
//        REF_POSTS.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    let key = document.documentID
//                    let post = Post.init(postKey: key, postData: document.data())
//                    self.posts.append(post)
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
//        return posts
//    }
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
