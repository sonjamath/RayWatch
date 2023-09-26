//
//  GetUVIndexRequestModel.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-25.
//

import Foundation

struct GetUVIndexRequestModel: Encodable {
    let altitude: Double
    let longitude: Double
    let latitude: Double
    let date: String
}
