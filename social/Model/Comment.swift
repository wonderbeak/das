//
//  Comment.swift
//  social
//
//  Created by Jaroslavs Rogacs on 30/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation

class Comment {
    private var _commentKey: String!
    private var _authorId: String!
    private var _postId: String!
    private var _content: String!
    private var _date: Date!
    
    var commentKey: String {
        return _commentKey
    }
    
    var authorId: String {
        return _authorId
    }
    
    var postId: String {
        return _postId
    }
    
    var date: Date {
        return _date
    }
    
    var content: String {
        return _content
    }
    
    init(commentKey: String, authorId: String, postId: String, date: Date, content: String) {
        self._commentKey = commentKey
        self._authorId = authorId
        self._postId = postId
        self._content = content
        self._date = date
    }
    
    init(commentKey: String, commentData: Dictionary<String, Any>) {
        self._commentKey = commentKey
        if let authorId = commentData["authorId"] as! String? {
            self._authorId = authorId
        }
        if let postId = commentData["postId"] as! String? {
            self._postId = postId
        }
        if let content = commentData["content"] as! String? {
            self._content = content
        }
        if let date = commentData["date"] as! Date? {
            self._date = date
        }
    }
    
}
