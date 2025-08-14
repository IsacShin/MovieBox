//
//  DetailView.swift
//  MovieBox
//
//  Created by shinisac on 8/13/25.
//

import SwiftUI

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State var isShowPopupAnimated: Bool = false // 팝업 애니메이션 여부
    @State var isFavoriteAnimated: Bool = false // 즐겨찾기 애니메이션 여부
    var body: some View {
        ZStack {
            Color.ccBlack
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading ,spacing: 8) {
                    ZStack {
                        AsyncImage(url: viewModel.movie.posterURL) { phase in
                            switch phase {
                            case .empty:
                                Color.gray
                                    .skeleton(isActive: .constant(true))
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            default: EmptyView()
                            }
                        }
                        .frame(height: 350)
                        .clipped()

                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(.ccWhite)
                                .padding()
                                .clipShape(Circle())
                        }
                        .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .topTrailing)
                    }
                    
                    HStack {
                        Text(viewModel.movie.title)
                            .font(.title)
                            .foregroundStyle(.ccWhite)
                            .bold()
                            .lineLimit(0)
                        Spacer()
                        Button {
                            viewModel.actionFavoriteButtonTapped()
                        } label: {
                            VStack {
                                Image(systemName: isFavoriteAnimated ? "checkmark" : "plus")
                                    .font(.title2)
                                    .foregroundStyle(.ccWhite)
                                    .rotationEffect(isFavoriteAnimated ? .degrees(0) : .degrees(90))
                                    .bold()
                                Text("즐겨찾기")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.ccWhite)
                            }
                        }
                        .onChange(of: viewModel.isShowPopupMessage) { _, newValue in
                            withAnimation {
                                isShowPopupAnimated = newValue
                            }
                        }
                        .onChange(of: viewModel.isFavorite) { _, newValue in
                            withAnimation {
                                isFavoriteAnimated = newValue
                            }
                        }
                    }
                    .padding()
                    
                    HStack {
                        HStack {
                            Group {
                                Text("개봉일:")
                                    .foregroundStyle(.ccWhite)
                                Text(viewModel.movie.releaseDate)
                                    .foregroundStyle(.ccWhite)
                            }
                            .font(.system(size: 14))
                            Spacer()
                            Text("⭐️ \(viewModel.movie.voteAverage, specifier: "%.1f")")
                                .foregroundStyle(.ccWhite)
                                .font(.system(size: 14))
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("줄거리")
                        .font(.system(size: 20))
                        .foregroundStyle(.ccWhite)
                        .bold()
                        .padding()
                    
                    Text(viewModel.movie.overview)
                        .font(.system(size: 18))
                        .foregroundStyle(.ccWhite)
                        .lineLimit(nil)
                        .padding(.horizontal)
                    
                    Button {
                        if let url = viewModel.detailOpenUrl {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("자세히 보기")
                            .foregroundStyle(.ccWhite)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ccDarkRed)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            
            if isShowPopupAnimated {
                Text(viewModel.popupMessage)
                    .font(.title2)
                    .padding()
                    .background(Color.ccWhite.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    DetailView(viewModel: DetailViewModel(movie: Movie.mock))
}
