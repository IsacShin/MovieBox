//
//  HomeView.swift
//  MovieBox
//
//  Created by shinisac on 8/7/25.
//

import SwiftUI

struct HomeView: View {
    @State var isLoading: Bool = true
    @Environment(\.navigationManager) private var navigationManager
    var body: some View {
        ZStack {
            Color.ccBlack
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 헤더 영역
                header
                ScrollView {
                    VStack(spacing: 8) {
                        detailBox(isLoading: $isLoading)
                        movieList(isLoading: $isLoading)
                        movieList(isLoading: $isLoading)
                        movieList(isLoading: $isLoading)
                    }
                }
            }
        }
    }
    
    var header: some View {
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
                    print("MyListView 이동")
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
    
    private func detailBox(isLoading: Binding<Bool>) -> some View {
        return ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/8UlWHdLMpgZm9bx6QYh0NFoq67TZ.jpg"))
                .frame(height: 350)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                .skeleton(isActive: isLoading)
                .overlay {
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .black.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                }
            
            VStack {
                Text("타이틀")
                    .foregroundStyle(.ccWhite)
                    .font(.title)
                
                Button {
                    navigationManager?.push(Route.movieDetail)
                } label: {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .tint(.ccWhite)
                        Text("상세정보")
                            .foregroundStyle(.ccWhite)
                    }
                    .frame(maxWidth: .infinity) // 가로 꽉 채우기
                    .frame(height: 35) // 높이 지정
                    .background(Color.ccDarkRed)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(35)
        }
    }
    
    private func movieList(isLoading: Binding<Bool>) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Movie List")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.ccWhite)
                    .padding(.bottom, 10)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem()], spacing: 10) {
                    ForEach(0..<45, id: \.self) { index in
                        ZStack(alignment: .bottom) {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/8UlWHdLMpgZm9bx6QYh0NFoq67TZ.jpg"))
                                .frame(width: 100, height: 150)
                                .background(Color.gray)
                                .skeleton(isActive: isLoading)
                                .overlay {
                                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .black.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                                }
                            
                            Text("타이틀")
                                .foregroundStyle(.ccWhite)
                                .font(.title3)
                                .lineLimit(1)
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
