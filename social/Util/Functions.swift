//
//  Functions.swift
//  social
//
//  Created by Jaroslavs Rogacs on 27/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
