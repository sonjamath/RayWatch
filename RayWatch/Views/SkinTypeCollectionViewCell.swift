//
//  SkinTypeCollectionViewCell.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-23.
//

import Foundation
import UIKit


class SkinTypeCollectionViewCell: UICollectionViewCell {
    
    struct SkinTypeAttributes {
        let color: String
        let title: String
        let description: String
        let reactionToSun: String
    }

    var skinType: SkinType?
    var checkMarkIcon: UIImageView!
    
    func setUpViews() {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        self.contentView.backgroundColor = UIColor(hexString: "F3F3F3")
        
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        if let attributes = getSkinTypeAttributes() {
            
            let skinTypeColorView = UIView()
            skinTypeColorView.layer.cornerCurve = .circular
            skinTypeColorView.layer.cornerRadius = 46/2
            skinTypeColorView.backgroundColor = UIColor(hexString: attributes.color)
            self.contentView.addSubview(skinTypeColorView)
            skinTypeColorView.snp.makeConstraints { make in
                make.left.top.equalTo(self.contentView).inset(15)
                make.height.width.equalTo(45)
            }
            
            checkMarkIcon = UIImageView(image: UIImage(systemName: "checkmark"))
            checkMarkIcon.tintColor = .white
            checkMarkIcon.contentMode = .center
            checkMarkIcon.isHidden = true
            
            // If skin type has been set previously and stored
            if let skinTypeSaved = UserDefaults.standard.value(forKey: "skinType") as? String {
                if self.skinType == SkinType(rawValue: skinTypeSaved) {
                    checkMarkIcon.isHidden = false
                }
            
            // If no skin type has been set previously, set type 1 as default
            } else if skinType == .type1 {
                checkMarkIcon.isHidden = false
            }

            skinTypeColorView.addSubview(checkMarkIcon)
            checkMarkIcon.snp.makeConstraints { make in
                make.centerX.centerY.equalTo(skinTypeColorView)
            }
            
            let titleLabel = UILabel.makeLabel(with: attributes.title, font: UIFont.systemFont(ofSize: 16, weight: .bold), textColor: .black)
            self.contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(skinTypeColorView.snp.right).offset(8)
                make.centerY.equalTo(skinTypeColorView)
            }
            
            let descriptionLabel = UILabel.makeLabel(with: attributes.description, font: UIFont.systemFont(ofSize: 16, weight: .regular), textColor: .black, numberOfLines: -1)
            self.contentView.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(skinTypeColorView.snp.bottom).offset(15)
                make.left.equalTo(skinTypeColorView)
                make.right.equalTo(self.contentView.snp.right).inset(15)
            }
            
            let reactionToSunLabel = UILabel.makeLabel(with: attributes.reactionToSun, font: UIFont.systemFont(ofSize: 16, weight: .regular), textColor: .black)
            self.contentView.addSubview(reactionToSunLabel)
            reactionToSunLabel.snp.makeConstraints { make in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
                make.left.equalTo(skinTypeColorView)
            }
        }
    }
    
    func getSkinTypeAttributes() -> SkinTypeAttributes? {
        guard let skinType = self.skinType else {
            return nil
        }
        
        let attributes: SkinTypeAttributes
        
        switch skinType {
        case .type1:
            attributes = SkinTypeAttributes(
                color: "ECD2B5",
                title: "Type I",
                description: "Very fair skin, white; red or blond hair; light-colored eyes; freckles likely",
                reactionToSun: "Always burns, does not tan"
            )
        case .type2:
            attributes = SkinTypeAttributes(
                color: "DDB795",
                title: "Type II",
                description: "Fair skin, white; light eyes; light hair",
                reactionToSun: "Burns easily, tans poorly"
            )
        case .type3:
            attributes = SkinTypeAttributes(
                color: "C8A182",
                title: "Type III",
                description: "Fair skin, cream white; any eye or hair color",
                reactionToSun: "Tans after initial burn"
            )
        case .type4:
            attributes = SkinTypeAttributes(
                color: "AD7B58",
                title: "Type IV",
                description: "Olive skin, typical Mediterranean Caucasian skin; dark brown hair; medium to heavy pigmentation",
                reactionToSun: "Burns minimally, tans easily"
            )
        case .type5:
            attributes = SkinTypeAttributes(
                color: "986137",
                title: "Type V",
                description: "Brown skin, dark hair; rarely sun sensitive",
                reactionToSun: "Rarely burns, tans darkly easily"
            )
        case .type6:
            attributes = SkinTypeAttributes(
                color: "4D3A39",
                title: "Type VI",
                description: "Black skin; rarely sun sensitive",
                reactionToSun: "Never burns, always tans darkly"
            )
        }
        
        return attributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.checkMarkIcon.isHidden = true
    }
}
