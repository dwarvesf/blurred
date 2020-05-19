//
//  MySwipeStatusBar.swift
//  Blurred
//
//  Created by Trung Phan on 5/19/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Cocoa

class StatusBarSwipeToSetAlphaView: NSView {
    override func wantsScrollEventsForSwipeTracking(on axis: NSEvent.GestureAxis) -> Bool {
        if axis == .vertical {
            return true
        }
        return false
    }
    
    override func scrollWheel(with event: NSEvent) {
        
        if event.deltaY > 0 { if (DimManager.sharedInstance.setting.alpha > 10.0) { DimManager.sharedInstance.setting.alpha -= 1.0}}
        if event.deltaY < 0 { if (DimManager.sharedInstance.setting.alpha < 100) { DimManager.sharedInstance.setting.alpha += 1 }}
    }
}
