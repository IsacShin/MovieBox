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
                
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3),
                          spacing: 10) {
                    
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
                                default:
                                    EmptyView()
                                }
                            }
                            .clipped()
                            .overlay {
                                LinearGradient(colors: [.black.opacity(0.1), .black.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                            }
                            .frame(height: 200)
                            .onTapGesture {
                                viewModel.selectMovie(movie)
                                showDetailView.toggle()
                            }
                            
                            VStack {
                                Spacer()
                                Text(movie.title ?? "")
                                    .font(.title3)
                                    .foregroundStyle(.ccWhite)
                                    .bold()
                            }
                            .padding()
                            
                            Button(action: {
                                viewModel.deleteMovie(movie)
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(.ccWhite)
                                    .padding(8)
                                    .background(Color.red.opacity(0.7))
                                    .clipShape(Circle())
                            }
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
