//
//  UIColor + Hex.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-23.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString:String) {
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        if hexString.hasSuffix("-p3") {
            let c = UIColor(displayP3Red:red, green:green, blue:blue, alpha:1)
            if let cgc = c.cgColor.converted(to: CGColorSpace(name: CGColorSpace.displayP3)!, intent: .absoluteColorimetric, options: nil) {
                self.init(cgColor: cgc)
            }
            else {
                self.init(displayP3Red:red, green:green, blue:blue, alpha:1)
            }
        }
        else {
            self.init(red:red, green:green, blue:blue, alpha:1)
        }
    }
}
