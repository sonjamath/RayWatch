//
//  Endpoint.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-25.
//

import Foundation


protocol FakeRouter {
    var fakeStatusCode: Int { get }
    var fakeJSONPath: String? { get }
}

enum Endpoint {
    case getUVIndex(GetUVIndexRequestModel)
}

extension Endpoint {
    enum RequestType {
        case normal, multipart
    }
    
    var url: URL {
        switch self {
        case .getUVIndex(let model):
            return .makeForEndpoint("/uv")
                .appending("lat", value: "\(model.latitude)")
                .appending("lng", value: "\(model.longitude)")
                .appending("alt", value: "\(model.altitude)")
                .appending("dt", value: "\(model.date)")
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .getUVIndex:
            return "GET"
        }
    }
    
    private var body: Data? {
        switch self {
        default: return nil
        }
    }
    
    private var requestType: RequestType {
        switch self {
        default: return .normal
        }
    }
    
    func asURLRequest(with header: [String: String]) -> URLRequest {
        var urlRequest = URLRequest(url: self.url)
        urlRequest.httpMethod = httpMethod
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("openuv-burlmv1e21i-io", forHTTPHeaderField: "x-access-token")
        header.forEach({
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        })
        
        urlRequest.httpBody = self.body
        return urlRequest
    }
    
    func multipartData() -> Data{
        guard let data = self.body,
              self.requestType == .multipart
        else { fatalError("Data can not be null")}
        
        return data
    }
}

extension Endpoint: FakeRouter {
    
    var fakeStatusCode: Int {
        switch self {
        default: return 200
        }
    }
    
    var fakeJSONPath: String? {
        switch self {
        default: return "uv_index"
        }
    }
}

extension URL {
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
