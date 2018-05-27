//
//  File.swift
//  FollowLifeFramework
//
//  Created by Hugo Andres on 26/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation

public class Preference {
    private let preferences: UserDefaults
    
    public init() {
        preferences = UserDefaults.standard
    }
    
    public func saveData(key: String, value: String) {
        preferences.set(value, forKey: key)
        
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Error saving \(value) in UserDefaults")
        }
    }
    
    public func retreiveData(key: String) -> String {
        let value: String = preferences.string(forKey: key)!
        
        return value
    }
    
    public func retreiveData(key: String) -> Int {
        let value: Int = preferences.integer(forKey: key)
        
        return value
    }
}
