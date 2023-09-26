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
    
    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}
