//
//  NetworkTurnpike.swift
//  RayWatch
//
//  Created by Sonja Mathew on 2023-09-25.
//

import Foundation

struct NetworkTurnpike {
    var agent: RealAPIManager
    
    init(agent: RealAPIManager) {
        self.agent = agent
    }
    
    static func mock() -> NetworkTurnpike { NetworkTurnpike(agent: FakeAPIManager.init()) }
}

extension NetworkTurnpike {
    func run<T: Decodable>(_ request: Endpoint) async throws -> T {
        return try await agent.run(request)
    }

    func getUVIndex(_ request: Endpoint) async throws -> UVData {
        return try await agent.run(request)
    }
}
