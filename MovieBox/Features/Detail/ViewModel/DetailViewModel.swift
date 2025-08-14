//
//  DetailViewModel.swift
//  MovieBox
//
//  Created by shinisac on 8/14/25.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    @Published var isShowPopupMessage: Bool = false // 팝업 여부
    private var coreDataManager = CoreDataManager.shared
    var popupMessage: String = "" // 팝업 메시지
    let movie: Movie
    var isProcessingFavorite: Bool = false
    var detailOpenUrl: URL? {
        URL(string: "https://www.themoviedb.org/movie/\(movie.id)")
    }
    init(movie: Movie) {
        self.movie = movie
    }

    func actionFavoriteButtonTapped() {
        Task { @MainActor [weak self] in
            guard let self = self, !isProcessingFavorite else { return } // 이미 처리 중이면 무시
            isProcessingFavorite = true
            
            isFavorite.toggle()
            
            if isFavorite {
                coreDataManager.addMovie(self.movie)
                popupMessage = "즐겨찾기에 추가되었습니다."
            } else {
                let filteredMovieData = coreDataManager.fetchMovies().filter { $0.id == self.movie.id }.first
                if let movieData = filteredMovieData {
                    coreDataManager.deleteMovie(movieData)
                    popupMessage = "즐겨찾기에서 삭제되었습니다."
                }
            }
            
            isShowPopupMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.isShowPopupMessage = false
                self?.isProcessingFavorite = false
            }
        }
        
    }
}
