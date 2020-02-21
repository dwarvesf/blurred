//
//  AppDelegate.swift
//  dimmerBarLauncher
//
//  Created by phucld on 1/7/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppIdentifier = "foundation.dwarves.blurred"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty
        
        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self,
                                                                selector: #selector(self.terminate),
                                                                name: Notification.Name("killLauncher"),
                                                                object: mainAppIdentifier)
            
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast(3)
            components.append("MacOS")
            let appName = "Blurred"
            components.append(appName) //main app name
            let newPath = NSString.path(withComponents: components)
            NSWorkspace.shared.launchApplication(newPath)
        }
        else {
            self.terminate()
        }
    }
}
