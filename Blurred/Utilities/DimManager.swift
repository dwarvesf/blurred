//
//  DimManager.swift
//  Dimmer Bar
//
//  Created by Trung Phan on 12/23/19.
//  Copyright © 2019 Dwarves Foundation. All rights reserved.
//

import Foundation
import Cocoa
import Combine

enum DimMode: Int {
    case single
    case parallel
}

class DimManager {
    //MARK: - Variable(s)
    static let sharedInstance = DimManager()
    let setting = SettingObservable()
    
    private var windows: [NSWindow] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    //MARK: - Init
    private init() {
        self.observerActiveWindowChanged()
        self.observeSettingChanged()
    }
    
    func dim(runningApplication: NSRunningApplication?) {
        
        guard DimManager.sharedInstance.setting.isEnabled else {
            self.removeAllOverlay()
            return
        }
        
        // Remove dim if user click to desktop
        // This will also remove dim if user click to finder
        // Improve: Find the other way to check if user click to desktop
        if let bundle = runningApplication?.bundleIdentifier, bundle == "com.apple.finder" {
            self.removeAllOverlay()
            return
        }
        
        let color = NSColor.black.withAlphaComponent(CGFloat(DimManager.sharedInstance.setting.alpha/100.0))
        
        DimManager.sharedInstance.windows(color: color) { [weak self] windows in
            guard let strongSelf = self else {return}
            strongSelf.removeAllOverlay()
            strongSelf.windows = windows
        }
    }
    
    func toggleDimming(isEnable: Bool) {
        isEnable ? self.dim(runningApplication: self.getFrontMostApplication()) : self.removeAllOverlay()
    }
    
    func adjustDimmingLevel(alpha: Double) {
        for overlayWindow in self.windows {
            overlayWindow.backgroundColor = NSColor.black.withAlphaComponent(CGFloat(alpha/100.0))
        }
    }
}

//MARK: - Core function Helper Methods
extension DimManager {
    private func getFrontMostApplication() -> NSRunningApplication? {
        return NSWorkspace.shared.frontmostApplication
    }
    
    private func windows(color: NSColor, didCreateWindows: @escaping ([NSWindow])->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let strongSelf = self else {return}
            let windowInfos = strongSelf.getWindowInfos()
            
            let screens = NSScreen.screens
            let windows = screens.map { screen in
                return strongSelf.windowForScreen(screen: screen, windowInfos: windowInfos, color: color)
            }
            
            didCreateWindows(windows)
        }
    }
    
    private func windowForScreen(screen: NSScreen, windowInfos: [WindowInfo], color: NSColor) -> NSWindow {
        
        let frame = NSRect(origin: .zero, size: screen.frame.size)
        let overlayWindow = NSWindow.init(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false, screen: screen)
        overlayWindow.isReleasedWhenClosed = false
        overlayWindow.animationBehavior = .none
        overlayWindow.backgroundColor = color
        overlayWindow.ignoresMouseEvents = true
        overlayWindow.collectionBehavior = [.transient, .fullScreenNone]
        overlayWindow.level = .normal
        
        var windowNumber = 0
        switch self.setting.dimMode {
        case .single:
            windowNumber = windowInfos[safe: 0]?.number ?? 0
        case .parallel:
            // Get frontmost window of each screen
            let newScreen = NSRect(x: screen.frame.minX, y: NSScreen.screens[0].frame.maxY - screen.frame.maxY, width: screen.frame.width, height: screen.frame.height)
            let windowInfo = windowInfos.first(where: {
                return  newScreen.minX <= $0.bounds!.midX &&
                    newScreen.maxX >= $0.bounds!.midX &&
                    newScreen.minY <= $0.bounds!.midY &&
                    newScreen.maxY >= $0.bounds!.midY
            })
            
            windowNumber = windowInfo?.number ?? 0
        }
        
        overlayWindow.order(.below, relativeTo: windowNumber)
        return overlayWindow
    }
    
    private func removeAllOverlay() {
        for overlayWindow in self.windows {
            overlayWindow.close()
        }
        self.windows.removeAll()
    }
    
    /// This func will return the window info of windows on all the screen
    private func getWindowInfos() -> [WindowInfo] {
        let options = CGWindowListOption([.excludeDesktopElements, .optionOnScreenOnly])
        let windowsListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
        let infoList = windowsListInfo as! [[String:Any]]
        let windowInfos = infoList.map { WindowInfo.init(dict: $0) }.filter { $0.layer == 0 } // Filter out all the other item like Status Bar icon.
        return windowInfos
    }
}

extension DimManager {
    private func observeSettingChanged() {
        
        // DON'T receive this publisher on Main scheduler
        // It will cause delay
        // Still don't know why :-?
        self.setting.$alpha
            .removeDuplicates()
            .sink(receiveValue: adjustDimmingLevel)
            .store(in: &cancellableSet)
        
        self.setting.$isEnabled
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: toggleDimming)
            .store(in: &cancellableSet)
        
        self.setting.$dimMode
            .receive(on: DispatchQueue.main)
            .map { _ in return nil }
            .sink(receiveValue: dim)
            .store(in: &cancellableSet)
    }
    
    private func observerActiveWindowChanged() {
        
        let nc = NSWorkspace.shared.notificationCenter
        nc.addObserver(self, selector: #selector(workspaceDidReceiptAppllicatinActiveNotification), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }
    
    @objc private func workspaceDidReceiptAppllicatinActiveNotification(ntf: Notification) {
        guard
            let activeAppDict = ntf.userInfo as? [AnyHashable : NSRunningApplication],
            let activeApplication = activeAppDict["NSWorkspaceApplicationKey"]
            else { return }
        
        self.dim(runningApplication: activeApplication)
    }
}
