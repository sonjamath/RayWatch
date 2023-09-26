//
//  UVContentView.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-22.
//

import Foundation
import UIKit
import SnapKit

class UVContentView: UIView {
    var inset = 15
    var contentLabel: UILabel!
    
    init(title: String, contentDescription: String, content: String) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true

        setUpViews(title: title, contentDescription: contentDescription, content: content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpViews(title: String, contentDescription: String, content: String) {
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
        
        let descriptionLabel = UILabel.makeLabel(with: contentDescription, font: UIFont.systemFont(ofSize: 14, weight: .regular), textColor: .white, textAlignment: .left, numberOfLines: -1)
        contentStackView.addArrangedSubview(descriptionLabel)
        
        contentLabel = UILabel.makeLabel(with: content, font: UIFont.systemFont(ofSize: 28, weight: .medium), textColor: .white, textAlignment: .left, numberOfLines: -1)
        contentStackView.addArrangedSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bgView).offset(-inset)
        }

        let paddingView = UIView()
        contentStackView.addArrangedSubview(paddingView)
        paddingView.backgroundColor = .clear
        paddingView.snp.makeConstraints { make in
            make.height.equalTo(inset)
            make.left.right.equalTo(self).inset(inset)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.left.right.equalTo(bgView).inset(inset)
            make.top.equalTo(self).offset(inset)
            make.bottom.equalTo(contentLabel.snp.bottom).offset(inset)
        }
    }
}

