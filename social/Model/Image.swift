//
//  Image.swift
//  social
//
//  Created by Jaroslavs Rogacs on 29/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation


class Image {
    private var _imageKey: String!
    private var _name: String!
    private var _url: String!
    private var _date: Date!
    
    var imageKey: String {
        return _imageKey
    }
    
    var url: String {
        return _url
    }
    
    var name: String {
        return _name
    }
    
    var date: Date {
        return _date
    }
    
    init(imageKey: String, url: String, name: String, date: Date) {
        self._imageKey = imageKey
        self._url = url
        self._name = name
        self._date = date
    }
    
    init(imageKey: String, postData: Dictionary<String, Any>) {
        self._imageKey = imageKey
        if let url = postData["url"] as! String? {
            self._url = url
        }
        if let name = postData["name"] as! String? {
            self._name = name
        }
        if let date = postData["date"] as! Date? {
            self._date = date
        }
    }
    
}
