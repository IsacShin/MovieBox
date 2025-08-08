//
//  MovieRouter.swift
//  MovieBox
//
//  Created by shinisac on 8/8/25.
//

import Foundation

enum MovieAPI: APIRouter {
    case popularMovies(page: Int)
    case movieDetail(id: Int)
    case searchMovies(query: String)
    
    var path: String {
        switch self {
        case .popularMovies:
            return "/movies/popular"
        case .movieDetail(let id):
            return "/movies/\(id)"
        case .searchMovies:
            return "/movies/search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popularMovies, .movieDetail, .searchMovies:
            return .get
        }
    }
    
    var queryParameters: [URLQueryItem]? {
        switch self {
        case .popularMovies(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .searchMovies(let query):
            return [URLQueryItem(name: "query", value: query)]
        default:
            return nil
        }
    }
    
    var body: Data? {
        return nil
    }
}
