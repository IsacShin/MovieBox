//
//  HomeView.swift
//  MovieBox
//
//  Created by shinisac on 8/7/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.navigationManager) private var navigationManager
    @StateObject private var viewModel = HomeViewModel(repository: HomeRepository())
    @State private var showDetailView: Bool = false
    var body: some View {
        ZStack {
            Color.ccBlack
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 헤더 영역
                headerView
                ScrollView {
                    VStack(spacing: 8) {
                        detailBoxView()
                        Spacer().frame(height: 10)
                        movieListView(moviesTitle: "현재 상영중",
                                      moives: viewModel.nowPlayingMovies,
                                      onScrollAtEnd: {
                            Task {
                                await viewModel.fetchNowPlayingMovies(page: viewModel.nowPlayingMoviesPage)
                            }
                        })
                        movieListView(moviesTitle: "인기작",
                                      moives: viewModel.popularMovies,
                                      onScrollAtEnd: {
                            Task {
                                await viewModel.fetchPopularMovies(page: viewModel.popularMoviesPage)
                            }
                        })
                        movieListView(moviesTitle: "별점 순위",
                                      moives: viewModel.topRatedMovies,
                                      onScrollAtEnd: {
                            Task {
                                await viewModel.fetchTopRatedMovies(page: viewModel.topRatedMoviesPage)
                            }
                        })
                        movieListView(moviesTitle: "개봉 예정",
                                      moives: viewModel.upcomingMovies,
                                      onScrollAtEnd: {
                            Task {
                                await viewModel.fetchUpcomingMovies(page: viewModel.upcomingMoviesPage)
                            }
                        })
                    }
                }
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
    }
    
    var headerView: some View {
        HStack(spacing: 20) {
            HStack(spacing: 8) {
                Spacer()
                    .frame(width: 10)
                Text("MOVIE")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.ccDarkRed)
                Text("BOX")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.ccWhite)
                Spacer()
                Button {
                    navigationManager?.push(Route.myList)
                } label: {
                    Image(systemName: "list.star")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.ccWhite)
                }
                Spacer()
                    .frame(width: 10)
            }
        }
    }
    
    private func detailBoxView() -> some View {
        return ZStack(alignment: .bottom) {
            AsyncImage(url: viewModel.detailBoxMovie?.posterURL) { phase in
                switch phase {
                case .empty:
                    Color.gray
                        .skeleton(isActive: .constant(true))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
              
                default: EmptyView()
                }
            }
            .frame(height: 350)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
            .overlay {
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
            }
                            
            VStack(spacing: 0) {
                Text(viewModel.detailBoxMovie?.title ?? "")
                    .foregroundStyle(.ccWhite)
                    .font(.title)
                    .bold()
                
                Button {
                    guard let movie = viewModel.detailBoxMovie else { return }
                    viewModel.updateSelectedMovie(movie)
                    showDetailView.toggle()
                } label: {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .tint(.ccWhite)
                        Text("상세정보")
                            .font(.headline)
                            .foregroundStyle(.ccWhite)
                    }
                    .frame(maxWidth: .infinity) // 가로 꽉 채우기
                    .frame(height: 45) // 높이 지정
                    .background(Color.ccDarkRed)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(10)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        
    }
    
    private func movieListView(moviesTitle: String,
                               moives: [Movie],
                               onScrollAtEnd: @escaping (()->Void)) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(moviesTitle)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.ccWhite)
                    .padding(.bottom, 10)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(moives) { movie in
                        ZStack(alignment: .bottom) {
                            AsyncImage(url: movie.posterURL) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray
                                        .skeleton(isActive: .constant(true))
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)

                                default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 100, height: 150)
                            Text(movie.title)
                                .foregroundStyle(.ccWhite)
                                .font(.title3)
                                .lineLimit(1)
                        }
                        .frame(width: 100, height: 150)
                        .onAppear {
                            if movie.id == moives.last?.id {
                                onScrollAtEnd()
                            }
                        }
                        .onTapGesture {
                            viewModel.updateSelectedMovie(movie)
                            showDetailView.toggle()
                        }
                        .sheet(isPresented: $showDetailView) {
                            if let movie = viewModel.selectedMovie {
                                DetailView(viewModel: DetailViewModel(movie: movie))
                            }
                        }
                        
                    }
                }
            }
            
        }
    }

}

#Preview {
    HomeView()
}
