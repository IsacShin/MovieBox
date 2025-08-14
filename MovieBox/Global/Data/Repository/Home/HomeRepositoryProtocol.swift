//
//  HomeRepositoryProtocol.swift
//  MovieBox
//
//  Created by shinisac on 8/13/25.
//

import Foundation

protocol HomeRepositoryProtocol {
    func fetchNowPlayingMovies(page: Int) async throws -> [Movie]?
    func fetchPopularMovies(page: Int) async throws -> [Movie]?
    func fetchTopRatedMovies(page: Int) async throws -> [Movie]?
    func fetchUpcomingMovies(page: Int) async throws -> [Movie]?
    func fetchAllMovies() async throws -> (nowPlaying: [Movie]?,
                                           popular: [Movie]?,
                                           topRated: [Movie]?,
                                           upcoming: [Movie]?)
}
