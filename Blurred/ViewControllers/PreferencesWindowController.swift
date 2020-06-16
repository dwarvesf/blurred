//
//  PreferencesWindowController.swift
//  Blurred
//
//  Created by phucld on 3/13/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Cocoa
import SwiftUI
import HotKey

class PreferencesWindowController: NSWindowController {
    
    @IBOutlet weak var segmentController: NSSegmentedControl!
    
    enum MenuSegment: Int {
        case general
        case about
    }
    
    static let shared: PreferencesWindowController = {
        let wc = NSStoryboard(name:"Main", bundle: nil).instantiateController(withIdentifier: "PreferencesWindowController") as! PreferencesWindowController
        return wc
    }()
    
    private var menuSegment: MenuSegment = .general {
        didSet {
            if oldValue != menuSegment {
                updateVC()
            }
        }
    }
    
    private let generalVC = GeneralViewController.initWithStoryboard()
    
    private let aboutVC = AboutViewController.initWithStoryboard()
    
    private let setting = DimManager.sharedInstance.setting
    
    override func windowDidLoad() {
        super.windowDidLoad()
        updateVC()
        
        // Set localized titles for segment labels
        self.segmentController.setLabel("General".localized, forSegment: 0)
        self.segmentController.setLabel("About".localized, forSegment: 1)
    }
    
    
    @IBAction func switchSegment(_ sender: NSSegmentedControl) {
        guard let segment = MenuSegment(rawValue: sender.indexOfSelectedItem) else {return}
        menuSegment = segment
    }
    
    private func updateVC() {
        switch menuSegment {
        case .general:
            self.window?.contentViewController = generalVC
            self.window?.title = "General".localized
        case .about:
            self.window?.contentViewController = aboutVC
            self.window?.title = "About".localized
        }
        
        var windowOrigin = CGPoint(x: 0, y: 0)
        
        if
            let window = window,
            let windowScreen = window.screen {
            
            let windowOriginX = windowScreen.frame.midX - 300
            
            let windowOriginY = windowScreen.frame.midY
            
            windowOrigin = CGPoint(x: windowOriginX, y: windowOriginY)
        }
        
        self.window?.setFrameOrigin(windowOrigin)
    }
    
}

extension PreferencesWindowController {
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        guard self.setting.isListenningForHotkey else {return}
        updateGlobalShortcut(event)
    }
    
    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        if event.keyCode == 53 { // Esc
            self.setting.isListenningForHotkey = false
            self.setting.currentHotkeyLabel = setting.globalHotkey?.description ?? "Set Hotkey"
        }
    }
    
    override func flagsChanged(with event: NSEvent) {
        super.flagsChanged(with: event)
        guard self.setting.isListenningForHotkey else {return}
        updateModiferFlags(event)
    }
    
    
    private func updateGlobalShortcut(_ event: NSEvent) {
        
        guard let characters = event.charactersIgnoringModifiers else {return}
        
        self.setting.isListenningForHotkey = false
        
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
        
        guard newGlobalKeybind.description.count != 1 else {
            self.resetKeyBind()
            return
        }
        
        self.setting.globalHotkey = newGlobalKeybind
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
        
        self.setting.currentHotkeyLabel = globalKeybindPreference.description
        
        if globalKeybindPreference.description.isEmpty {
            resetKeyBind()
        }
    }
    
    private func resetKeyBind() {
        self.setting.currentHotkeyLabel = setting.globalHotkey?.description ?? "Set Hotkey"
        self.setting.isListenningForHotkey = false
        if setting.globalHotkey == nil {
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.hotKey = nil
        }
    }
}
