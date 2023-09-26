//
//  URL+Extension.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-25.
//

import Foundation

extension URL {
//    static private var baseURL: String { return "http://localhost:5002/scrl"}
    static private var baseURL: String { return "https://api.openuv.io/api/v1"}
    
    static func makeForEndpoint(_ endpoint: String, for baseURL: String = URL.baseURL) -> URL {
        URL(string: "\(URL.baseURL)\(endpoint)")!
    }
}
