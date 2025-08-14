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
    
    /// Combine Request 함수
    func request<T: Decodable>(_ router: APIRouter) -> AnyPublisher<T, APIError> {
        let request: URLRequest
        do {
            request = try makeURLRequest(from: router)
        } catch {
            return Fail(error: error as? APIError ?? APIError.custom(message: error.localizedDescription)).eraseToAnyPublisher()
        }
        
        // URLSession dataTaskPublisher 사용
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw APIError.serverError(statusCode: httpResponse.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                // 에러를 APIError로 변환
                if let apiError = error as? APIError {
                    return apiError
                } else if error is DecodingError {
                    return APIError.decodingFailed
                } else {
                    return APIError.custom(message: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// Async Request 함수
    func request<T: Decodable>(_ router: APIRouter) async throws -> T {
        let request = try makeURLRequest(from: router)
        
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
    
    /// Common URLRequest 생성 함수
    private func makeURLRequest(from router: APIRouter) throws -> URLRequest {
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
        
        return request
    }
}
