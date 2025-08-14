//
//  APIConfig.swift
//  MovieBox
//
//  Created by shinisac on 8/7/25.
//

import Foundation

enum APIConfig {
    // MARK: - TMDB API Configuration
    static let apiKey = "cb133eb742399a744ce5d0469f5b24ea"
    static let baseURL = "https://api.themoviedb.org/3"
    static let commonHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    static let language = "ko-KR"
}
