//
//  String+Extension.swift
//  Blurred
//
//  Created by Peter Luo on 2020/6/16.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
