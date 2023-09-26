//
//  UVIndexViewController.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-21.
//

import Foundation
import UIKit
import SnapKit
import CoreLocation

class UVIndexViewController: UIViewController {
    
    enum Constants {
        static let inset = 20
    }
    
    private var safeExposureContentView: UVContentView?
    private let viewModel: UVIndexViewModel
    
    init(viewModel: UVIndexViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.askForLocationPermissions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setUpViews(with data: UVIndexDataModel) {
        let uvIndexMeanings = data.getUVIndexMeaning()
        self.view.backgroundColor = uvIndexMeanings.color
        
        let topStack = UIStackView.makeVStack(spacing: 8, alignment: .center)
        topStack.axis = .vertical
        topStack.alignment = .center
        topStack.spacing = 8
        self.view.addSubview(topStack)
        topStack.snp.makeConstraints { make in
            make.top.centerX.equalTo(self.view).offset(65)
            make.left.right.equalTo(self.view).inset(Constants.inset)
        }
        
        let currentLocationLabel = UILabel.makeLabel(with: "Current Location", font: UIFont.systemFont(ofSize: 28, weight: .regular), textColor: .white)
        topStack.addArrangedSubview(currentLocationLabel)

        let UVLabel = UILabel.makeLabel(with: "\(data.uv)", font: UIFont.systemFont(ofSize: 96, weight: .thin), textColor: .white)
        topStack.addArrangedSubview(UVLabel)
        
        let UVLevelNameLabel = UILabel.makeLabel(with: uvIndexMeanings.levelName, font: UIFont.systemFont(ofSize: 17, weight: .bold), textColor: .white)
        topStack.addArrangedSubview(UVLevelNameLabel)
        
        let maxUVLevelTodayLabel = UILabel.makeLabel(with: "Max Today: \(data.maxUv)", font: UIFont.systemFont(ofSize: 16, weight: .regular), textColor: .white)
        topStack.addArrangedSubview(maxUVLevelTodayLabel)
        
        var maxIndexContentString = "UV \(data.maxUv) today"
        if let maxTime = data.maxUVTime() {
            maxIndexContentString = maxIndexContentString.appending(" today at \(maxTime)")
        }
        
        let maxIndexContentView = UVContentView(title: "Seek shade during midday hours! Slip on a shirt, slop on sunscreen and slap on hat!", contentDescription: "Max UV Index Today", content: maxIndexContentString)
        self.view.addSubview(maxIndexContentView)
        maxIndexContentView.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom).offset(Constants.inset)
            make.left.right.equalTo(self.view).inset(Constants.inset)
        }
        
        // If skin type has been set previously and stored
        var skinType = SkinType.type1
        if let skinTypeSaved = UserDefaults.standard.value(forKey: "skinType") as? String {
            skinType = SkinType(rawValue: skinTypeSaved) ?? .type1
        }
        
        safeExposureContentView = UVContentView(title: "Safe Exposure Time Calculation", contentDescription: "Safe exposure time for your skin type", content: "\(data.safeExposureTime(forSkinType: skinType))")
        
        safeExposureContentView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(skinContentViewPressed(_ :))))
        
        self.view.addSubview(safeExposureContentView!)
        safeExposureContentView!.snp.makeConstraints { make in
            make.top.equalTo(maxIndexContentView.snp.bottom).offset(Constants.inset)
            make.left.right.equalTo(self.view).inset(Constants.inset)
        }
        
        let skinTypeButton = SkinTypeButton()
        skinTypeButton.addTarget(self, action: #selector(skinTypeButtonPressed(_ :)), for: .touchUpInside)
        self.view.addSubview(skinTypeButton)
        skinTypeButton.snp.makeConstraints { make in
            make.top.equalTo(safeExposureContentView!.snp.bottom).offset(15)
            make.left.right.equalTo(self.view).inset(Constants.inset)
            make.height.equalTo(15)
        }
        
        let sunStackView = UIStackView.makeHStack(spacing: 25, alignment: .center)
        self.view.addSubview(sunStackView)
        sunStackView.snp.makeConstraints { make in
            make.top.equalTo(skinTypeButton.snp.bottom).offset(Constants.inset)
            make.left.right.equalTo(self.view).inset(Constants.inset)
        }
        
        let sunriseContentView = SunContentView(title: "Sunrise", imageName: "sunrise", content: data.sunTime(forSunState: .sunrise))
        sunStackView.addArrangedSubview(sunriseContentView)
        sunriseContentView.snp.makeConstraints { make in
            make.width.equalTo(sunStackView.snp.width).dividedBy(2).inset(Constants.inset/2)
        }
        
        let sunsetContentView = SunContentView(title: "Sunset", imageName: "sunset", content: data.sunTime(forSunState: .sunset))
        sunStackView.addArrangedSubview(sunsetContentView)
        sunsetContentView.snp.makeConstraints { make in
            make.width.equalTo(sunStackView.snp.width).dividedBy(2).inset(Constants.inset/2)
        }
    }
    
    @objc func skinTypeButtonPressed(_ sender: UIButton) {
        self.openSkinTypeView()
    }
    
    @objc func skinContentViewPressed(_ sender: UITapGestureRecognizer) {
        self.openSkinTypeView()
    }
    
    func openSkinTypeView() {
        let skinTypeVC = SkinTypeViewController(viewModel: self.viewModel)
        skinTypeVC.modalPresentationStyle = .popover
        
        self.present(skinTypeVC, animated: true)
    }
}

extension UVIndexViewController: UVIndexViewModelDelegate {
    func onFetchData(with data: UVIndexDataModel) {
        setUpViews(with: data)
    }
    
    func onSetSkinType(with skinType: SkinType, and data: UVIndexDataModel?) {
        guard let data = data else { return }
        self.safeExposureContentView?.contentLabel.text = data.safeExposureTime(forSkinType: skinType)
    }
}
