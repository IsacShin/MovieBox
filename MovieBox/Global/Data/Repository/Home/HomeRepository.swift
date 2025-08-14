//
//  HomeRepositoryImpl.swift
//  MovieBox
//
//  Created by shinisac on 8/13/25.
//

import Foundation

final class HomeRepository: HomeRepositoryProtocol {
    func fetchNowPlayingMovies(page: Int) async throws -> [Movie]? {
        do {
            let movieResponse: MovieResponse? = try await APIProvider.shared.request(MovieRouter.nowPlayingMovies(page: page))
            return movieResponse?.results
        } catch let apiError as APIError {
            print("API Error: \(apiError.localizedDescription)")
        } catch {
            print("Unexpected Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchPopularMovies(page: Int) async throws -> [Movie]? {
        do {
            let movieResponse: MovieResponse? = try await APIProvider.shared.request(MovieRouter.popularMovies(page: page))
            return movieResponse?.results
        } catch let apiError as APIError {
            print("API Error: \(apiError.localizedDescription)")
        } catch {
            print("Unexpected Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchTopRatedMovies(page: Int) async throws -> [Movie]? {
        do {
            let movieResponse: MovieResponse? = try await APIProvider.shared.request(MovieRouter.topRatedMovies(page: page))
            return movieResponse?.results
        } catch let apiError as APIError {
            print("API Error: \(apiError.localizedDescription)")
        } catch {
            print("Unexpected Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchUpcomingMovies(page: Int) async throws -> [Movie]? {
        do {
            let movieResponse: MovieResponse? = try await APIProvider.shared.request(MovieRouter.upcomingMovies(page: page))
            return movieResponse?.results
        } catch let apiError as APIError {
            print("API Error: \(apiError.localizedDescription)")
        } catch {
            print("Unexpected Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchAllMovies() async throws -> (nowPlaying: [Movie]?, popular: [Movie]?, topRated: [Movie]?, upcoming: [Movie]?) {
        do {
            async let nowPlaying = fetchNowPlayingMovies(page: 1)
            async let popular = fetchPopularMovies(page: 1)
            async let topRated = fetchTopRatedMovies(page: 1)
            async let upcoming = fetchUpcomingMovies(page: 1)
            return try await (nowPlaying: nowPlaying,
                              popular: popular,
                              topRated: topRated,
                              upcoming: upcoming)
        } catch let apiError as APIError {
            print("API Error: \(apiError.localizedDescription)")
        } catch {
            print("Unexpected Error: \(error.localizedDescription)")
        }
        return (nowPlaying: nil, popular: nil, topRated: nil, upcoming: nil)
    }
}
