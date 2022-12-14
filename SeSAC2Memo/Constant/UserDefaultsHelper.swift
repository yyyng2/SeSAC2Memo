//
//  UserDefaultsHelper.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

class UserDefaultsHelper{
    
    private init(){}
    
    static let standard = UserDefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String{
        case first
    }
    
    var first: Bool {
        get {
            return userDefaults.bool(forKey: Key.first.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.first.rawValue)
        }
    }

}
