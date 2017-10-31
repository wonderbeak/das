//
//  User.swift
//  social
//
//  Created by Jaroslavs Rogacs on 29/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation
class User {
    private var _uid: String!
    private var _name: String!
    private var _bio: String!
    private var _birth: String!
    private var _date: Date!
    private var _avatar: String!
    private var _posts: [String]!
    

    var name: String {
        return _name
    }

    var bio: String {
        return _bio
    }

    var birth: String {
        return _birth
    }

    var date: Date {
        return _date
    }

    var uid: String {
        return _uid
    }
    
    var avatar: String {
        return _avatar
    }
    
    var posts: [String] {
        return _posts
    }

    func remove(post: String) {
        _posts = _posts.filter{ $0 != post }
    }
    
    init(name: String, bio: String, birth: String, date: Date, avatar: String, posts: [String]) {
        self._name = name
        self._bio = bio
        self._birth = birth
        self._date = date
        self._avatar = avatar
        self._posts = posts
    }

    init(userKey: String, userData: Dictionary<String, Any>) {
        self._uid = userKey
        if let name = userData["name"] as! String? {
            self._name = name
        }
        if let bio = userData["bio"] as! String? {
            self._bio = bio
        }
        if let birth = userData["birth"] as! String? {
            self._birth = birth
        }
        if let date = userData["date"] as! Date? {
            self._date = date
        }
        if let avatar = userData["avatar"] as! String? {
            self._avatar = avatar
        }
        if let posts = userData["posts"] {
            if posts is [String], posts != nil {
                self._posts = posts as! [String]
                print(posts)
            }
        }
    }
}

