//
//  SettingObservable.swift
//  Dimmer Bar
//
//  Created by Trung Phan on 1/7/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Foundation
import Combine

final class SettingObservable: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var isStartWhenLogin: Bool = UserDefaults.isStartWhenLogin {
        willSet {
            UserDefaults.isStartWhenLogin = newValue
            objectWillChange.send()
        }
    }
    
    var isOpenPrefWhenOpenApp: Bool = UserDefaults.isOpenPrefWhenOpenApp {
          willSet {
              UserDefaults.isOpenPrefWhenOpenApp = newValue
              objectWillChange.send()
          }
    }
    
    var dimMode: DimMode = DimMode(rawValue: UserDefaults.dimMode) ?? .single  {
        willSet {
            UserDefaults.dimMode = newValue.rawValue
            objectWillChange.send()
        }
    }
    
    var alpha: Double = UserDefaults.alpha {
        willSet {
            UserDefaults.alpha = newValue
            objectWillChange.send()
        }
    }
    
    var isEnabled: Bool = UserDefaults.isEnabled {
        willSet {
            UserDefaults.isEnabled = newValue
            objectWillChange.send()
        }
    }
    
    var globalHotkey: GlobalKeybindPreferences? = UserDefaults.globalKey {
        willSet {
            UserDefaults.globalKey = newValue
            objectWillChange.send()
        }
    }
    
    var currentHotkeyLabel: String = UserDefaults.globalKey?.description ?? "Set Hotkey" {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isListenningForHotkey: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
}
