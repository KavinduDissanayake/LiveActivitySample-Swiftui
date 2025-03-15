//
//  UserDefault.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//
import Foundation


@propertyWrapper
struct Storage<T> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


struct AppData {
    @Storage(key: "DeviceToken", defaultValue: nil)
    static var deviceToken: String?
    
    // 🔥 Live Activity Token
    @Storage(key: "LiveActivityToken", defaultValue: nil)
    static var liveActivityToken: String?
}
