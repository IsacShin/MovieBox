//
//  MyListView.swift
//  MovieBox
//
//  Created by shinisac on 8/14/25.
//

import SwiftUI

struct MyListView: View {
    
    @StateObject private var viewModel = MyListViewModel()
    @State private var showDetailView: Bool = false

    var body: some View {
        ZStack {
            Color.ccBlack
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10),
                                    GridItem(.flexible(), spacing: 10),
                                    GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(viewModel.favoriteMovies) { movie in
                        ZStack {
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
                            .frame(height: 200)
                            .clipped()
                            .overlay {
                                LinearGradient(colors: [.black.opacity(0.1), .black.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                            }

                            VStack {
                                Spacer()
                                Text(movie.title ?? "")
                                    .font(.title3)
                                    .foregroundStyle(.ccWhite)
                                    .bold()
                            }
                            .padding()
                            
                        }
                        .onTapGesture {
                            viewModel.selectMovie(movie)
                            showDetailView.toggle()
                        }
                    }
                }
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = .ccBlack
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        .sheet(isPresented: $showDetailView) {
            if let selectedMovie = viewModel.selectedMovie {
                DetailView(viewModel: DetailViewModel(movie: selectedMovie))
            }
        }
        .navigationTitle("MyList")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    MyListView()
}
