//
//  AboutViewController.swift
//  Blurred
//
//  Created by phucld on 3/17/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Cocoa
import SwiftUI

class AboutViewController: NSHostingController<AboutView> {

    @objc required dynamic init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AboutView())
        preferredContentSize = CGSize(width: 500, height: 360)
        preferredScreenOrigin = .init(x: 0.5, y: 0.5)
    }
    
    class func initWithStoryboard() -> AboutViewController {
        return NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "AboutViewController") as! AboutViewController
    }
}
