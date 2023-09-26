//
//  SkinTypeViewController.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-23.
//

import Foundation
import UIKit

class SkinTypeViewController: UIViewController {
    
    var skinTypes: [SkinType] = [.type1, .type2, .type3, .type4, .type5, .type6]
    private let viewModel: UVIndexViewModel
    
    init(viewModel: UVIndexViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setUpViews()
    }
    
    private func setUpViews() {
        let titleLabel = UILabel.makeLabel(with: "Fitzpatrick Skin Types &\nSafe Exposure Time Calculation", font: UIFont.systemFont(ofSize: 20, weight: .semibold), textColor: .black, textAlignment: .center, numberOfLines: 2)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(40)
            make.left.right.equalTo(self.view).inset(20)
        }
        
        let readMoreButton = ReadMoreSkinTypesButton()
        readMoreButton.addTarget(self, action: #selector(openReadMoreAboutSkinTypes(_ :)), for: .touchUpInside)
        self.view.addSubview(readMoreButton)
        readMoreButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
            make.left.right.equalTo(self.view).inset(40)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width-40, height: 145)
        
        let skinTypeCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        skinTypeCollectionView.backgroundColor = .white
        skinTypeCollectionView.register(SkinTypeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SkinTypeCollectionViewCell.self))
        
        self.view.addSubview(skinTypeCollectionView)
        skinTypeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(readMoreButton.snp.bottom).offset(20)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        skinTypeCollectionView.delegate = self
        skinTypeCollectionView.dataSource = self
        skinTypeCollectionView.reloadData()
    }
    
    @objc func openReadMoreAboutSkinTypes(_ sender: UIButton) {
        if let url = URL(string: "https://www.westdermatology.com/2022/03/11/find-your-fitzpatrick-skin-type/") {
            UIApplication.shared.open(url)
        }
    }
}

extension SkinTypeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.skinTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SkinTypeCollectionViewCell.self), for: indexPath) as? SkinTypeCollectionViewCell else { return .init() }
        
        cell.skinType = skinTypes[indexPath.row]
        cell.setUpViews()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(skinTypes[indexPath.row].rawValue, forKey: "skinType")
        viewModel.delegate?.onSetSkinType(with: skinTypes[indexPath.row], and: viewModel.data)
        collectionView.reloadData()
    }
}
