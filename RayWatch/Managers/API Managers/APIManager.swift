//
//  APIManager.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-25.
//

import Foundation
import UIKit

struct Response<T, U> {
    let value: T?
    let error: U?
    let response: URLResponse
}

protocol RealAPIManager {
    var session: URLSession { get }
    
    func run<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func runMultipart<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

extension RealAPIManager {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}


struct APIManager: RealAPIManager {
    var session: URLSession = URLSession.shared
    
    func run<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var (data, response): (Data, URLResponse)
        if #available(iOS 15.0, *) {
            (data, response) = try await URLSession.shared.data(for: endpoint.asURLRequest(with: [:]), delegate: nil)
            print("url: \(endpoint.asURLRequest(with: [:]))")
        } else {
            (data, response) = try await URLSession.shared.data(from: endpoint.asURLRequest(with: [:]))
        }
                
        if (response as! HTTPURLResponse).statusCode != 200 {
            let error = try decoder.decode(APIErrorResponseModel.self, from: data)
            throw NetworkError.serverError(error)
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func runMultipart<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var (data, response) = try await URLSession.shared.dataMultipart(from: endpoint)
        if (response as! HTTPURLResponse).statusCode != 200 {
            let error = try decoder.decode(APIErrorResponseModel.self, from: data)
            throw NetworkError.serverError(error)
        }
        
        return try decoder.decode(T.self, from: data)
    }
}

struct FakeAPIManager: RealAPIManager {
    var session: URLSession = URLSession.shared
    
    func run<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let bundlePath = Bundle.main.path(forResource: endpoint.fakeJSONPath, ofType: "json"),
              let data = try? String(contentsOfFile: bundlePath).data(using: .utf8) else {
            throw  NetworkError.noData
              }
        
        return try! decoder.decode(T.self, from: data)
    }
     
    func runMultipart<T>(_ endpoint: Endpoint) async throws -> T {
        fatalError("Not implemented yet")
    }
}

enum NetworkError: Error {
    case serverError(LocalizedError)
    case statusCode
    case noData
    case decode
}

//MARK: - Extensions

extension Task where Failure == Error {
    @discardableResult
    static func retrying(
        priority: TaskPriority? = nil,
        maxRetryCount: Int = 3,
        retryDelay: TimeInterval = 1,
        operation: @Sendable @escaping () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            for _ in 0..<maxRetryCount {
                do {
                    return try await operation()
                } catch {
                    let oneSecond = TimeInterval(1_000_000_000)
                    let delay = UInt64(oneSecond * retryDelay)
                    try await Task<Never, Never>.sleep(nanoseconds: delay)
                    
                    continue
                }
            }
            
            try Task<Never, Never>.checkCancellation()
            return try await operation()
        }
    }
}

struct APIErrorResponseModel: Decodable, LocalizedError {
    var message: String
    var errorDescription: String?{ message }
}

@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
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
}
