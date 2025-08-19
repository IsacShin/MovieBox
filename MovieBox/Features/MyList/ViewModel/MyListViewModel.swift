//
//  MyListViewModel.swift
//  MovieBox
//
//  Created by shinisac on 8/14/25.
//

import Foundation
import Combine

final class MyListViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var favoriteMovies: [MovieData] = []
    var selectedMovie: Movie? = nil

    private var coreDataManager = CoreDataManager.shared
    
    init() {
        Task {
            await fetchFavoriteMovies()
        }
    }
    
    private func fetchFavoriteMovies() async {
        let movies = coreDataManager.fetchMovies()
        Task { @MainActor [weak self] in
            self?.favoriteMovies = movies
            self?.isLoading = false
        }
    }
    
    func deleteMovie(_ movie: MovieData) {
        coreDataManager.deleteMovie(movie)
        Task {
            await fetchFavoriteMovies()
        }
    }
    
    func selectMovie(_ movie: MovieData) {
        selectedMovie = Movie(id: Int(movie.id),
                              title: movie.title ?? "",
                              overview: movie.overview ?? "",
                              releaseDate: movie.releaseDate ?? "",
                              voteAverage: movie.voteAverage,
                              posterPath: movie.posterPath)
    }
}
