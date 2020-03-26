//
//  UserDefaults+Extension.swift
//  Dimmer Bar
//
//  Created by Trung Phan on 1/7/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Foundation
import Cocoa

let defaultAlpha = 70.0


extension UserDefaults {
    private struct Key {
        static let isStartWhenLogin = "IS_START_WHEN_LOGIN"
        static let alpha = "ALPHA"
        static let isEnabled = "IS_ENABLED"
        static let isActiveSceenMode = "IS_ACTIVE_SCREEN_MODE"
        static let isOpenPrefWhenOpenApp = "IS_OPEN_PREF_WHEN_OPEN_APP"
        static let dimMode = "DIM_MODE"
        static let globalKey = "GLOBAL_KEY"
    }
    
    static var isStartWhenLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.isStartWhenLogin)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.isStartWhenLogin)
            Util.setUpAutoStart(isAutoStart: newValue)
        }
    }
    
    static var isOpenPrefWhenOpenApp: Bool {
        get {
            UserDefaults.standard.register(defaults: [Key.isOpenPrefWhenOpenApp : true])
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.isOpenPrefWhenOpenApp)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.isOpenPrefWhenOpenApp)
        }
    }
    
    static var dimMode: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Key.dimMode)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.dimMode)
        }
    }
    
    static var alpha: Double {
        get {
            let alpha = UserDefaults.standard.double(forKey: UserDefaults.Key.alpha)
            if alpha == 0.0 {
                UserDefaults.standard.set(defaultAlpha, forKey: UserDefaults.Key.alpha)
                return defaultAlpha
            }else {
               return alpha
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.alpha)
        }
    }
    
    static var isEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.isEnabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.isEnabled)
        }
    }
    
    static var isActiveSceenMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.isActiveSceenMode)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.isActiveSceenMode)
        }
    }
    
    static var globalKey: GlobalKeybindPreferences? {
          get {
              guard let data = UserDefaults.standard.value(forKey: UserDefaults.Key.globalKey) as? Data else { return nil }
              return try? JSONDecoder().decode(GlobalKeybindPreferences.self, from: data)
          }

          set {
              guard let data = try? JSONEncoder().encode(newValue) else { return }
              UserDefaults.standard.set(data, forKey: UserDefaults.Key.globalKey)
          }
      }
}
