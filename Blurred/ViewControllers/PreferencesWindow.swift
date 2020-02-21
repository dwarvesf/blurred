//
//  PreferencesWindow.swift
//  Blurred
//
//  Created by phucld on 2/19/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Cocoa
import HotKey

class PreferencesWindow: NSWindow {
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        guard DimManager.sharedInstance.setting.isListenningForHotkey else {return}
        updateGlobalShortcut(event)
    }
    
    override func flagsChanged(with event: NSEvent) {
        super.flagsChanged(with: event)
        guard DimManager.sharedInstance.setting.isListenningForHotkey else {return}
        updateModiferFlags(event)
    }
    
    
    private func updateGlobalShortcut(_ event: NSEvent) {
        
        DimManager.sharedInstance.setting.isListenningForHotkey = false
        
        guard let characters = event.charactersIgnoringModifiers else {return}
        
        let newGlobalKeybind = GlobalKeybindPreferences(
            function: event.modifierFlags.contains(.function),
            control: event.modifierFlags.contains(.control),
            command: event.modifierFlags.contains(.command),
            shift: event.modifierFlags.contains(.shift),
            option: event.modifierFlags.contains(.option),
            capsLock: event.modifierFlags.contains(.capsLock),
            carbonFlags: event.modifierFlags.carbonFlags,
            characters: characters,
            keyCode: uint32(event.keyCode))
                
        if newGlobalKeybind.description.count != 1 {
            DimManager.sharedInstance.setting.globalHotkey = newGlobalKeybind
        }
        
        updateKeybindButton(newGlobalKeybind)
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: UInt32(event.keyCode), carbonModifiers: event.modifierFlags.carbonFlags))
    }
    
    private func updateModiferFlags(_ event: NSEvent) {
        let newGlobalKeybind = GlobalKeybindPreferences(
            function: event.modifierFlags.contains(.function),
            control: event.modifierFlags.contains(.control),
            command: event.modifierFlags.contains(.command),
            shift: event.modifierFlags.contains(.shift),
            option: event.modifierFlags.contains(.option),
            capsLock: event.modifierFlags.contains(.capsLock),
            carbonFlags: 0,
            characters: nil,
            keyCode: uint32(event.keyCode))
        
        updateKeybindButton(newGlobalKeybind)
    }
    
    // Set the shortcut button to show the keys to press
    private func updateKeybindButton(_ globalKeybindPreference : GlobalKeybindPreferences) {
        
        DimManager.sharedInstance.setting.currentHotkeyLabel = globalKeybindPreference.description
        
        if globalKeybindPreference.description.isEmpty {
            DimManager.sharedInstance.setting.currentHotkeyLabel = "Set Hotkey"
            DimManager.sharedInstance.setting.globalHotkey = nil
            DimManager.sharedInstance.setting.isListenningForHotkey = false
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.hotKey = nil
        }
    }
    
}
