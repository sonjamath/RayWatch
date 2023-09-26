//
//  SkinTypeButton.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-23.
//

import Foundation
import UIKit

class SkinTypeButton: HoverButton {
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        self.backgroundColor = .clear
        
        let informationLabel = UILabel.makeLabel(with: "Change your skintype or learn more", font: UIFont.systemFont(ofSize: 16, weight: .medium), textColor: .white, textAlignment: .left, numberOfLines: 1)
        informationLabel.isUserInteractionEnabled = false
        self.addSubview(informationLabel)
        informationLabel.snp.makeConstraints { make in
            make.left.equalTo(self)
        }
        
        let arrowIcon = UIImageView(image: UIImage(systemName: "arrow.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)))
        arrowIcon.tintColor = .white
        arrowIcon.isUserInteractionEnabled = false
        self.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { make in
            make.left.equalTo(informationLabel.snp.right).offset(5)
        }
    }
}
