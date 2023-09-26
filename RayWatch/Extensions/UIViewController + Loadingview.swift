//
//  UIViewController + Loadingview.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-23.
//

import Foundation
import UIKit

extension UIViewController {
    func showLoader() -> UIView {
        let loaderView = UIView(frame: view.bounds)
        loaderView.backgroundColor = .clear
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = loaderView.center
        activityIndicator.startAnimating()
        
        loaderView.addSubview(activityIndicator)
        view.addSubview(loaderView)
        
        return loaderView
    }
    
    func hideLoader(_ loaderView: UIView) {
        loaderView.removeFromSuperview()
    }
}
