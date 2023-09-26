//
//  UVIndexViewModel.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-25.
//

import Foundation
import UIKit
import CoreLocation

protocol UVIndexViewModelDelegate: AnyObject {
    func onFetchData(with data: UVIndexDataModel)
    func onSetSkinType(with skinType: SkinType, and data: UVIndexDataModel?)
}

final class UVIndexViewModel: NSObject {
    
    private let router: NetworkTurnpike
    private var locationManager = CLLocationManager()
    var data: UVIndexDataModel?
    weak var delegate: UVIndexViewModelDelegate?
    
    private var lastKnownLocation: GetUVIndexRequestModel? {
        didSet {
            fetchUVIndex()
        }
    }
    
    init(router: NetworkTurnpike = NetworkTurnpike(agent: FakeAPIManager())) {
        self.router = router
    }

    func fetchUVIndex() {
        guard let lastKnownLocation = lastKnownLocation else { return }
        Task {
            let response = try await router.getUVIndex(.getUVIndex(.init(altitude: lastKnownLocation.altitude, longitude: lastKnownLocation.longitude, latitude: lastKnownLocation.latitude, date: lastKnownLocation.date)))
            await MainActor.run {
                guard let data = UVIndexDataModel(uvData: response) else { return }
                delegate?.onFetchData(with: data)
                self.data = data
            }
        }
    }
    
    func askForLocationPermissions() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func onSetSkinType(with skinType: SkinType) {
        delegate?.onSetSkinType(with: skinType, and: self.data)
    }
    
    
    private func getTodaysDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
}

extension UVIndexViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        self.lastKnownLocation = .init(altitude: location.altitude, longitude: location.coordinate.longitude, latitude: location.coordinate.latitude, date: self.getTodaysDate())
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedWhenInUse, .authorized, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
}
