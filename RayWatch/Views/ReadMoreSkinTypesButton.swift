//
//  ReadMoreSkinTypesButton.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-24.
//

import Foundation
import UIKit

class ReadMoreSkinTypesButton: HoverButton {
    convenience init() {
        self.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor(hexString: "F3F3F3")
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 10

        let stackView = UIStackView.makeHStack(spacing: 5, alignment: .center, distribution: .equalCentering)
        self.addSubview(stackView)
        
        let informationLabel = UILabel.makeLabel(with: "Read more about skintypes", font: UIFont.systemFont(ofSize: 16, weight: .medium), textColor: .black, textAlignment: .center, numberOfLines: 1)
        informationLabel.isUserInteractionEnabled = false
        stackView.addArrangedSubview(informationLabel)

        let arrowIcon = UIImageView(image: UIImage(systemName: "arrow.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)))
        arrowIcon.tintColor = .black
        arrowIcon.isUserInteractionEnabled = false
        stackView.addArrangedSubview(arrowIcon)
        
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
    }
}
