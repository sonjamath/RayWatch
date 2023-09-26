//
//  UVIndexModel.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-23.
//

import Foundation
import UIKit
import CoreLocation

enum SkinType: String {
    case type1 = "type1"
    case type2 = "type2"
    case type3 = "type3"
    case type4 = "type4"
    case type5 = "type5"
    case type6 = "type6"
}

enum SunState {
    case sunrise, sunset
}

struct UVIndexDataModel {
    
    let uv: CGFloat
    let maxUv: CGFloat
    let maxUvTime: String
    let safeSunExposureTimes: SafeExposureTime
    let sunriseTime: String
    let sunsetTime: String
    
    init?(uvData: UVData?) {
        guard let uv = uvData?.result.uv,
              let maxUv = uvData?.result.uv_max,
              let maxUvTime = uvData?.result.uv_max_time,
              let safeSunExposureTimes = uvData?.result.safe_exposure_time,
              let sunriseTime = uvData?.result.sun_info.sun_times.sunrise,
              let sunsetTime = uvData?.result.sun_info.sun_times.sunset else { return nil }
        
        
        self.uv = round(10 * uv) / 10
        self.maxUv = round(10 * maxUv) / 10
        self.maxUvTime = maxUvTime
        self.safeSunExposureTimes = safeSunExposureTimes
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
    }
    
    func maxUVTime() -> String? {
        let timestamp = self.maxUvTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = dateFormatter.date(from: timestamp) {
            dateFormatter.dateFormat = "HH:mm"
            let formattedTime = dateFormatter.string(from: date)
            return formattedTime
        }
        
        return nil
    }
    
    func sunTime(forSunState sunState: SunState) -> String {
        var timestamp = ""
        switch sunState {
        case .sunrise:
            timestamp = self.sunriseTime
        case .sunset:
            timestamp = self.sunsetTime
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = dateFormatter.date(from: timestamp) {
            dateFormatter.dateFormat = "HH:mm"
            let formattedTime = dateFormatter.string(from: date)
            return formattedTime
        }
        
        return ""
    }
    
    func safeExposureTime(forSkinType skinType: SkinType) -> String {
        var exposureTimeInMinutes = 0
        switch skinType {
        case .type1:
            exposureTimeInMinutes = safeSunExposureTimes.st1
        case .type2:
            exposureTimeInMinutes = safeSunExposureTimes.st2
        case .type3:
            exposureTimeInMinutes = safeSunExposureTimes.st3
        case .type4:
            exposureTimeInMinutes = safeSunExposureTimes.st4
        case .type5:
            exposureTimeInMinutes = safeSunExposureTimes.st5
        case .type6:
            exposureTimeInMinutes = safeSunExposureTimes.st6
        }
        
        let hours = exposureTimeInMinutes / 60
        let minutes = exposureTimeInMinutes % 60
        
        var formattedTime = ""
        
        if hours > 0 {
            formattedTime = "\(hours) hour\(hours > 1 ? "s" : "")"
        }
        
        if minutes > 0 {
            if !formattedTime.isEmpty {
                formattedTime += " "
            }
            formattedTime += "\(minutes) minute\(minutes > 1 ? "s" : "")"
        }
        
        if formattedTime.isEmpty {
            formattedTime = "0 minutes"
        }
        
        return formattedTime
    }
    
    func getUVIndexMeaning() -> (color: UIColor, levelName: String) {
        switch uv {
        case 0..<3:
            return (UIColor(hexString: "9CDAA2"), "Low UV")
        case 4..<6:
            return (UIColor(hexString: "FFB571"), "Moderate UV")
        case 6..<8:
            return (UIColor(hexString: "FF9B71"), "High UV")
        case 8..<11:
            return (UIColor(hexString: "FE7372"), "Very high UV")
        case 11...:
            return (UIColor(hexString: "A872FE"), "Exreme UV")
        default:
            return (UIColor(hexString: "4EBD59"), "")
        }
    }
}
