//
//  UILabel + Extensions.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-22.
//

import Foundation
import UIKit

extension UILabel {
    static func makeLabel(with text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 0) -> UILabel {
        var label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        return label
    }
}

