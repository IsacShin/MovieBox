//
//  MovieRouter.swift
//  MovieBox
//
//  Created by shinisac on 8/8/25.
//

import Foundation

enum MovieRouter: APIRouter {
    case popularMovies(page: Int)       // 인기작
    case nowPlayingMovies(page: Int)    // 현재 상영작
    case topRatedMovies(page: Int)      // 최고 평점작
    case upcomingMovies(page: Int)      // 개봉 예정작
    
    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .nowPlayingMovies:
            return "/movie/now_playing"
        case .topRatedMovies:
            return "/movie/top_rated"
        case .upcomingMovies:
            return "/movie/upcoming"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popularMovies, .nowPlayingMovies, .topRatedMovies, .upcomingMovies:
            return .get
        }
    }
    
    var queryParameters: [URLQueryItem]? {
        var params: [URLQueryItem] = []
        params.append(URLQueryItem(name: "api_key", value: APIConfig.apiKey))
        params.append(URLQueryItem(name: "language", value: APIConfig.language))
        switch self {
        case .popularMovies(let page),
                .nowPlayingMovies(let page),
                .topRatedMovies(page: let page),
                .upcomingMovies(page: let page):
            params.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        return params
    }
    
    var body: Data? {
        return nil
    }
}
