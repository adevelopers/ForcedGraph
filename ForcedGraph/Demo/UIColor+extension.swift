//
//  UIColor+extension.swift
//  ForcedGraph
//
//  Created by Kirill Khudyakov on 08.11.17.
//  Copyright © 2017 Conrad Kramer. All rights reserved.
//

import UIKit

extension UIColor {
    fileprivate convenience init(rgbaValue: UInt32) {
        let max = CGFloat(UInt8.max)
        self.init(red: CGFloat((rgbaValue >> 24) & 0xFF) / max,
                  green: CGFloat((rgbaValue >> 16) & 0xFF) / max,
                  blue: CGFloat((rgbaValue >> 8) & 0xFF) / max,
                  alpha: CGFloat(rgbaValue & 0xFF) / max)
    }
}
