//
//  URLSession + Extension.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-26.
//

import Foundation

extension URLSession {
    func dataMultipart(from endpoint: Endpoint) async throws -> (Data, URLResponse) {
         try await withCheckedThrowingContinuation { continuation in
             let task = self.uploadTask(with: endpoint.asURLRequest(with: [:]), from: endpoint.multipartData()) { data, response, error in
                 guard let data = data, let response = response else {
                     let error = error ?? URLError(.badServerResponse)
                     return continuation.resume(throwing: error)
                 }

                 continuation.resume(returning: (data, response))
             }

             task.resume()
        }
    }
    
    func data(from urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}

