//
//  SunContentView.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-22.
//

import Foundation
import UIKit

class SunContentView: UIView {
    var inset = 15
    
    init(title: String, imageName: String, content: String) {
        super.init(frame: .zero)

        setUpViews(title: title, imageName: imageName, content: content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(title: String, imageName: String, content: String) {
        self.backgroundColor = .clear
        let bgView = UIView()
        bgView.layer.cornerRadius = 10
        bgView.layer.cornerCurve = .continuous
        bgView.clipsToBounds = true
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        bgView.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalTo(bgView)
        }
        
        let contentStackView = UIStackView.makeVStack(spacing: 10, alignment: .leading)
        self.addSubview(contentStackView)
        
        let titleLabel = UILabel.makeLabel(with: title, font: UIFont.systemFont(ofSize: 14, weight: .regular), textColor: .white, textAlignment: .left, numberOfLines: -1)
        contentStackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentStackView).inset(inset)
        }
        
        let seperatorView = UIView()
        contentStackView.addArrangedSubview(seperatorView)
        seperatorView.backgroundColor = .lightGray.withAlphaComponent(0.6)
        seperatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalTo(contentStackView).inset(inset)
        }
        
        let iconTimeStackView = UIStackView.makeHStack(spacing: 2, alignment: .center, distribution: .equalCentering)
        contentStackView.addArrangedSubview(iconTimeStackView)
        iconTimeStackView.snp.makeConstraints { make in
            make.centerX.equalTo(contentStackView)
        }
        
        let icon = UIImageView(image: UIImage(systemName: imageName)?.withConfiguration(UIImage
            .SymbolConfiguration(pointSize: 15)))
        icon.tintColor = .white
        iconTimeStackView.addArrangedSubview(icon)
        
        let timeLabel = UILabel.makeLabel(with: content, font: UIFont.systemFont(ofSize: 24, weight: .semibold), textColor: .white)
        iconTimeStackView.addArrangedSubview(timeLabel)
        
        contentStackView.snp.makeConstraints { make in
            make.left.right.equalTo(bgView).inset(inset)
            make.top.equalTo(self).offset(inset)
            make.bottom.equalTo(iconTimeStackView.snp.bottom).offset(inset)
        }
        
        let contentSize = contentStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.snp.makeConstraints { make in
            make.height.equalTo(Int(contentSize.height) + 2 * inset)
        }
    }
}
