//
//  UVResult.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-22.
//

import Foundation

struct UVResult: Codable {
    let ozone: CGFloat
    let ozone_time: String
    let safe_exposure_time: SafeExposureTime
    let sun_info: SunInfo
    let uv: CGFloat
    let uv_max: CGFloat
    let uv_max_time: String
    let uv_time: String
}
