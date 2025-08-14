//
//  MovieModel.swift
//  MovieBox
//
//  Created by shinisac on 8/8/25.
//

import Foundation

// MARK: - MovieResponse
///TMDB API 에서 영화 데이터를 받아오는 응답 모델
///응답에 `results` 라는 이름으로 영화 배열 데이터를 포함함
struct MovieResponse: Decodable {
    let results: [Movie] // 영화 데이터 배열
}


// MARK: - Movie
/// TMBD API 의 개별 영화 데이터를 표현하는 모델
/// API 응답에서 개별 영화 정보를 파싱하는데 사용됨
struct Movie: Identifiable, Decodable, Equatable, Hashable {
    
    // Properties
    let id: Int  // 영화 고유 ID
    let title: String // 영화 제목
    let overview: String // 영화 줄거리
    let releaseDate: String // 개봉일
    let voteAverage: Double // 평균평점
    let posterPath: String? // 포스터 이미지 경로 (Optional)
    
    /// TMDB 이미지 URL 생성
    /// 포스트 경로를 포함해 완전 이미지 URL 구성
    /// - 포스터 경로가 없는 경우 nil 로 반환
    /// 참조 : https://developer.themoviedb.org/docs/image-basics
    var posterURL: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        } else {
            return nil
        }
    }
    
    
    // MARK: - Coding Keys
    /// JSON 응답의 키와 Swift 속성 이름이 일치하지 않는 경우 매칭을 정의
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case overview = "overview"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
    
    // MARK: - Mock Data
    /// 테스트 및 미리보기 용 Mock 데이터
    static let mock = Movie(
        id: 912649,
        title: "테스트용 무비",
        overview: "이거는 테스트용 무비 데이터 줄거리 입니다",
        releaseDate: "2024-01-01",
        voteAverage: 8.8,
        posterPath: "/3flIDcZF3tnR7m5OU2h7lLPQwmr.jpg"
    )
    
    
    // MARK: - Equatable 설정
    /// 두 Movie 객체가 같은 ID 값을 비교해서 동일여부 결정
    /// Swiftdml == 연산자를 사용자 정의 위해 사용함 ForEach 배열 데이터를 처리할때 고유성 여부 확인
    /// - Parameters:
    ///   - lhs: 비교할 첫번째 Movie 객체
    ///   - rhs: 비교할 두번째 Movie 객체
    ///  - Return: 두 객체의 id가 동일하면 ture,  아니면 false
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
