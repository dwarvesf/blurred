//
//  Collection+Extension.swift
//  Dimmer Bar
//
//  Created by phucld on 1/8/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
