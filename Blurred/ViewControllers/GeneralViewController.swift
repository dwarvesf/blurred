//
//  GeneralViewController.swift
//  Blurred
//
//  Created by phucld on 3/17/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Cocoa
import SwiftUI

class GeneralViewController: NSHostingController<GeneralView> {

    @objc required dynamic init?(coder: NSCoder) {
        super.init(coder: coder, rootView: GeneralView(setting: DimManager.sharedInstance.setting))
        preferredContentSize = CGSize(width: 600, height: 600)
    }
    
    class func initWithStoryboard() -> GeneralViewController {
        return NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "GeneralViewController") as! GeneralViewController
    }
}
