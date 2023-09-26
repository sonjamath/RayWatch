//
//  HoverButton.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-23.
//

import Foundation
import UIKit

class HoverButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.alpha != 0.0 {
            if self.isHighlighted {
                self.alpha = 0.7
                
                for subview in self.subviews {
                    if subview.alpha != 0.0 {
                        subview.alpha = 0.7
                    }
                }
            } else if !self.isEnabled {
                for subview in self.subviews {
                    if subview.alpha != 0.0 {
                        subview.alpha = 0.5
                    }
                }
            } else  {
                self.alpha = 1
                for subview in self.subviews {
                    subview.alpha = 1.0
                }
            }
        }
    }
}
