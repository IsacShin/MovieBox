//
//  APIRouter.swift
//  MovieBox
//
//  Created by shinisac on 8/8/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // 필요에 따라 추가 (PUT, DELETE 등)
}

protocol APIRouter {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [URLQueryItem]? { get }
    var body: Data? { get }
}
