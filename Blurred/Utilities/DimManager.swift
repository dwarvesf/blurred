//
//  DimManager.swift
//  Dimmer Bar
//
//  Created by Trung Phan on 12/23/19.
//  Copyright © 2019 Dwarves Foundation. All rights reserved.
//

import Foundation
import Cocoa

enum DimMode: Int {
    case single
    case parallel
}

class DimManager {
    //MARK: - Init
    static let sharedInstance = DimManager()
    
    private init() {}
    
    //MARK: - Variable(s)
    var didReciptActiveApplicationChanged: ((NSRunningApplication?) -> Void)?
    
    let setting = SettingObservable()
    private var windows:[NSWindow] = []
    
}

//MARK: - Core function Helper Methods
extension DimManager {
    func getFrontMostApplication() -> NSRunningApplication? {
        return NSWorkspace.shared.frontmostApplication
    }
    
    func windows(color: NSColor, didCreateWindows: @escaping ([NSWindow])->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let strongSelf = self else {return}
            let windowInfos = strongSelf.getWindowInfos()
            
            let screens = NSScreen.screens
            let windows = screens.map{screen in
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
}

extension DimManager {
    func observerActiveWindowChanged() {
        let nc = NSWorkspace.shared.notificationCenter
        nc.addObserver(self, selector: #selector(workspaceDidReceiptAppllicatinActiveNotification), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }
    
    private func removeAllNotification() {
        NSWorkspace.shared.notificationCenter.removeObserver(self, name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }
    
    @objc private func workspaceDidReceiptAppllicatinActiveNotification(ntf: Notification) {
        if let activeAppDict = ntf.userInfo as? [AnyHashable : NSRunningApplication],
            let didReciptActiveApplicationChanged = self.didReciptActiveApplicationChanged,
            let activeApplication = activeAppDict["NSWorkspaceApplicationKey"] {
            didReciptActiveApplicationChanged(activeApplication)
        }
    }
}

extension DimManager {
    func prepareForDim() {
        DimManager.sharedInstance.observerActiveWindowChanged()
        DimManager.sharedInstance.didReciptActiveApplicationChanged = {[weak self] runningApplication in
            self?.dim(runningApplication: runningApplication)
        }
    }
    
    func dim(runningApplication: NSRunningApplication?) {
        
        if DimManager.sharedInstance.setting.isEnabled == false {return}
        
        if let bundle = runningApplication?.bundleIdentifier, bundle == "com.apple.finder" {
            return
        }
        let color = NSColor.black.withAlphaComponent(CGFloat(DimManager.sharedInstance.setting.alpha/100.0))
        
        DimManager.sharedInstance.windows(color: color) { [weak self] windows in
            guard let strongSelf = self else {return}
            strongSelf.removeAllOverlay()
            
            strongSelf.windows = windows
        }
    }
    
    private func removeAllOverlay() {
        for overlayWindow in self.windows {
            overlayWindow.close()
        }
        self.windows.removeAll()
    }
    
    private func getWindowInfos() -> [WindowInfo] {
        let options = CGWindowListOption([.optionOnScreenOnly, .excludeDesktopElements])
        let windowsListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
        let infoList = windowsListInfo as! [[String:Any]]
        let windowInfos = infoList.map { WindowInfo.init(dict: $0) }.filter { $0.layer == 0 }
        return windowInfos
    }
}
