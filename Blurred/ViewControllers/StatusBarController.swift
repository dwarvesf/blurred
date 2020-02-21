//
//  StatusBarController.swift
//  Dimmer Bar
//
//  Created by Trung Phan on 1/7/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Foundation
import Cocoa
import Combine
import SwiftUI

class StatusBarController{
    
    private let menuStatusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    private let slider = NSSlider()
    private var subscriptions = Set<AnyCancellable>()
    
    lazy private var window: NSWindow = {
        let contentView = PreferenceView(setting: DimManager.sharedInstance.setting)
        let window = PreferencesWindow(
            contentRect: NSRect.zero,
            styleMask: [.borderless,.titled,.closable],
            backing: .buffered, defer: false)
        
        window.center()
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: contentView)
        window.level = .floating
        return window
    }()
    
    init() {
        setupView()
        setupSlider()
        DimManager.sharedInstance.prepareForDim()
        autoReloadWhenSettingChanged()
    }
    
    private func autoReloadWhenSettingChanged() {
        DimManager.sharedInstance.setting.objectWillChange
            .receive(on: RunLoop.main)
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { _ in
                DimManager.sharedInstance.dim(runningApplication: DimManager.sharedInstance.getFrontMostApplication())
        }
        .store(in: &subscriptions)
    }
    
    private func setupView() {
        if let button = menuStatusItem.button {
            button.image = #imageLiteral(resourceName: "ico_menu")
        }
        menuStatusItem.menu = getContextMenu()
    }
    
    @objc private func handleGesture(gestureRecognizer: NSMagnificationGestureRecognizer) {
        switch gestureRecognizer.state {
        case .changed:
            print(gestureRecognizer)
        default: break
        }
    }

    private func setupSlider() {
        slider.minValue = 10.0
        slider.maxValue = 100.0
        slider.doubleValue = DimManager.sharedInstance.setting.alpha
        
        DimManager.sharedInstance.setting.objectWillChange
            .receive(on: RunLoop.main)
            .sink {[weak self] _ in
            self?.slider.doubleValue = DimManager.sharedInstance.setting.alpha
            self?.slider.isEnabled = DimManager.sharedInstance.setting.isEnabled
        }
        .store(in: &subscriptions)
        
        slider.target = self
        slider.action = #selector(sliderChanged)
    }
    
    @objc private func sliderChanged() {
        DimManager.sharedInstance.setting.alpha = slider.doubleValue
        DimManager.sharedInstance.dim(runningApplication: DimManager.sharedInstance.getFrontMostApplication())
    }
    
    private func getContextMenu() -> NSMenu {
        let menu = NSMenu()
        let sliderMenuItem = NSMenuItem()
        let titleEnable = DimManager.sharedInstance.setting.isEnabled ? "Disable" : "Enable"
        
        let enableButton = NSMenuItem(title: titleEnable, action: #selector(toggleEnable), keyEquivalent: "E")
        enableButton.target = self
        DimManager.sharedInstance.setting.objectWillChange
            .receive(on: RunLoop.main)
            .sink {[weak enableButton] _ in
                let title = DimManager.sharedInstance.setting.isEnabled ? "Disable" : "Enable"
                enableButton?.title = title
        }
        .store(in: &subscriptions)
        
        let view = NSView()
        view.setFrameSize(NSSize(width: 100, height: 22))
        view.autoresizingMask = .width
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: slider, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: slider, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: slider, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: slider, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
        sliderMenuItem.view = view
        menu.addItem(withTitle: "Slide to set Dim level", action: nil, keyEquivalent: "")
        menu.addItem(sliderMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(enableButton)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.item(withTitle: "Preferences...")?.target = self
        return menu
    }
    
    @objc private func toggleEnable() {
        DimManager.sharedInstance.setting.isEnabled.toggle()
        DimManager.sharedInstance.dim(runningApplication: DimManager.sharedInstance.getFrontMostApplication())
    }
    
    @objc func openPreferences() {
        window.makeKeyAndOrderFront(nil)
    }
}
