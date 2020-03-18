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
    
    @Published var isStartWhenLogin: Bool = UserDefaults.isStartWhenLogin {
        didSet {
            UserDefaults.isStartWhenLogin = self.isStartWhenLogin
        }
    }
    
    @Published var isOpenPrefWhenOpenApp: Bool = UserDefaults.isOpenPrefWhenOpenApp {
        didSet {
            UserDefaults.isOpenPrefWhenOpenApp = self.isOpenPrefWhenOpenApp
        }
    }
    
    @Published var dimMode: DimMode = DimMode(rawValue: UserDefaults.dimMode) ?? .single  {
        didSet {
            UserDefaults.dimMode = self.dimMode.rawValue
        }
    }
    
    @Published var alpha: Double = UserDefaults.alpha {
        didSet {
            UserDefaults.alpha = self.alpha
        }
    }
    
    @Published var isEnabled: Bool = UserDefaults.isEnabled {
        didSet {
            UserDefaults.isEnabled = self.isEnabled
        }
    }
    
    @Published var globalHotkey: GlobalKeybindPreferences? = UserDefaults.globalKey {
        didSet {
            UserDefaults.globalKey = self.globalHotkey
        }
    }
    
    @Published var currentHotkeyLabel: String = UserDefaults.globalKey?.description ?? "Set Hotkey"
    
    @Published var isListenningForHotkey: Bool = false
    
}
