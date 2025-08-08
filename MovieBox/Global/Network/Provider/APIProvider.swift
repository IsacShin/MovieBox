//
//  APIProvider.swift
//  MovieBox
//
//  Created by shinisac on 8/8/25.
//

import Foundation
import Combine

final class APIProvider {
    static let shared = APIProvider()
    
    private init() {}
    
    func request<T: Decodable>(_ router: APIRouter) async throws -> T {
        guard var components = URLComponents(url: URL(string: APIConfig.baseURL)!.appendingPathComponent(router.path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        components.queryItems = router.queryParameters
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        
        APIConfig.commonHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = router.body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw APIError.decodingFailed
        }
    }
}
