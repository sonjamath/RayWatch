//
//  UIStackView + Extensions.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-22.
//

import Foundation
import UIKit

extension UIStackView {
    static func makeHStack(spacing: CGFloat, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution = .equalSpacing) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        return stackView
    }
    
    static func makeVStack(spacing: CGFloat, alignment: UIStackView.Alignment = .top, distribution: UIStackView.Distribution = .equalSpacing) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        return stackView
    }
}


