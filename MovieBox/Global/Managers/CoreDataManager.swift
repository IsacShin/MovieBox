//
//  CoreDataManager.swift
//  MovieBox
//
//  Created by shinisac on 8/14/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer:NSPersistentContainer
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieData")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData Load Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch  {
                print("Context 저장 실패: \(error.localizedDescription)")
            }
        }
    }
    
    /// 영화 데이터를 Core Data 에 추가
    func addMovie(_ movie: Movie) {
        let myMovie = MovieData(context: context)
        myMovie.id = Int64(movie.id)
        myMovie.title = movie.title
        myMovie.posterPath = movie.posterPath
        myMovie.releaseDate = movie.releaseDate
        myMovie.overview = movie.overview
        myMovie.voteAverage = movie.voteAverage
        saveContext()
    }
    
    /// CoreData 에서 모든 영화 데이터를 로드
    func fetchMovies() -> [MovieData] {
        let fetchRequest: NSFetchRequest<MovieData> = MovieData.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch  {
            print("데이터 로드 실패: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Core Data 에서 영화 데이터를 삭제
    func deleteMovie(_ movie: MovieData) {
        context.delete(movie)
        saveContext()
    }
}

// MARK: - EXTENSION
/// CoreData 엔티티 에 대한 확장 변수 생성
extension MovieData {
    
    ///  TMDB 포스터 URL 생성
    var posterURL: URL? {
        if let posterPath = self.posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        return nil
    }
}

