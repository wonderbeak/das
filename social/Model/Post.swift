//
//  Post.swift
//  social
//
//  Created by Jaroslavs Rogacs on 29/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation

class Post {
    private var _postKey: String!
    private var _caption: String!
    private var _image: String!
    private var _content: String!
    private var _date: Date!
    private var _likes: Int!
    private var _comments: [String]!
    private var _authorId: String!
    
    var caption: String {
        return _caption
    }
    
    var image: String {
        return _image
    }
    
    var content: String {
        return _content
    }
    
    var date: Date {
        return _date
    }
    
    var comments: [String] {
        return _comments
    }
    
    var postKey: String {
        return _postKey
    }
    
    var likes: Int {
        return _likes
    }
    
    var authorId: String {
        return _authorId
    }
    
    init(caption: String, image: String, content: String, date: Date, likes: Int, comments: [String], authorId: String) {
        self._caption = caption
        self._image = image
        self._content = content
        self._likes = likes
        self._date = date
        self._comments = comments
        self._authorId = authorId
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        self._postKey = postKey
        if let caption = postData["caption"] as! String? {
            self._caption = caption
        }
        if let image = postData["image"] as! String? {
            self._image = image
        }
        if let content = postData["content"] as! String? {
            self._content = content
        }
        if let date = postData["date"] as! Date? {
            self._date = date
        }
        if let likes = postData["likes"] as! Int? {
            self._likes = likes
        }
        if let authorId = postData["authorId"] as! String? {
            self._authorId = authorId
        }
        if let comments = postData["comments"] {
            if comments is [String], comments != nil {
                self._comments = comments as! [String]
                print(comments)
            }
        }
    }
    
}
