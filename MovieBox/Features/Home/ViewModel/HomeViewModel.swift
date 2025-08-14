//
//  HomeViewModel.swift
//  MovieBox
//
//  Created by shinisac on 8/8/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    enum MoviesType {
        case nowPlaying
        case popular
        case topRated
        case upcoming
    }

    @Published var isLoading: Bool = true
    @Published var nowPlayingMovies: [Movie] = [] {
        didSet {
            if nowPlayingMovies.count > 0 {
                detailBoxMovie = nowPlayingMovies.first
            }
        }
    }
    @Published var popularMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    @Published var upcomingMovies: [Movie] = []
    
    var nowPlayingMoviesPage: Int = 1
    var popularMoviesPage: Int = 1
    var topRatedMoviesPage: Int = 1
    var upcomingMoviesPage: Int = 1
    var selectedMovie: Movie? = nil
    
    @Published var detailBoxMovie: Movie? = nil
    private var repository:HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
        Task {
            await fetchAllMovies()
        }
    }
    
    private func fetchAllMovies() async {
        let result = try? await repository.fetchAllMovies()
        Task { @MainActor [weak self] in
            self?.nowPlayingMovies = result?.nowPlaying ?? []
            self?.popularMovies = result?.popular ?? []
            self?.topRatedMovies = result?.topRated ?? []
            self?.upcomingMovies = result?.upcoming ?? []
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
            self?.isLoading = false
        }
    }
    
    func fetchNowPlayingMovies(page: Int = 1) async {
        let response = try? await repository.fetchNowPlayingMovies(page: page)
        await updateMovies(type: .nowPlaying, movies: response ?? [], page: page)
    }
    
    func fetchPopularMovies(page: Int = 1) async {
        let response = try? await repository.fetchPopularMovies(page: page)
        await updateMovies(type: .popular, movies: response ?? [], page: page)
    }
    
    func fetchTopRatedMovies(page: Int = 1) async {
        let response = try? await repository.fetchTopRatedMovies(page: page)
        await updateMovies(type: .topRated, movies: response ?? [], page: page)
    }
    
    func fetchUpcomingMovies(page: Int = 1) async {
        let response = try? await repository.fetchUpcomingMovies(page: page)
        await updateMovies(type: .upcoming, movies: response ?? [], page: page)
    }
    
    func updateSelectedMovie(_ movie: Movie) {
        selectedMovie = movie
    }
    
    @MainActor
    private func updateMovies(type: MoviesType, movies: [Movie], page: Int = 1) async {
        switch type {
        case .nowPlaying:
            if nowPlayingMoviesPage == 1 {
                nowPlayingMovies = movies
            } else {
                nowPlayingMovies.append(contentsOf: movies)
            }
            nowPlayingMoviesPage += 1
        case .popular:
            if popularMoviesPage == 1 {
                popularMovies = movies
            } else {
                popularMovies.append(contentsOf: movies)
            }
            popularMoviesPage += 1
        case .topRated:
            if topRatedMoviesPage == 1 {
                topRatedMovies = movies
            } else {
                topRatedMovies.append(contentsOf: movies)
            }
            topRatedMoviesPage += 1
        case .upcoming:
            if upcomingMoviesPage == 1 {
                upcomingMovies = movies
            } else {
                upcomingMovies.append(contentsOf: movies)
            }
            upcomingMoviesPage += 1
        }
        
    }
}
