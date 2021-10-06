//
//  MovieDetailView.swift
//  MoviesApp
//
//  Created by Олег Еременко on 06.03.2021.
//

import SwiftUI

struct MovieDetailView: View {
    @AppStorage("RecentlyOpenedMovie", store: UserDefaults(suiteName: "group.com.oleg991.MoviesApp"))
    var recentlyOpenedMovie = Data()

    var movie: Movie

    @StateObject private var loader: ImageLoader
    @StateObject private var movieManager = MovieDownloadManager()

    init(movie: Movie) {
        self.movie = movie
        _loader = StateObject(
            wrappedValue: ImageLoader(
                url: URL(string: movie.posterPath)!,
                cache: Environment(\.imageCache).wrappedValue
            )
        )
    }

    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            ScrollView(
                .vertical,
                showsIndicators: false
            ) {
                VStack(alignment: .leading) {
                    headerView
                    moviePosterView
                    movieOverView
                    reviewLink
                    castInfo
                    Spacer()
                }
                .padding(.top, 84)
                .padding(.horizontal, 32)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear { save(movie) }
    }
}

private extension MovieDetailView {
    var backgroundView: some View {
        imageView.onAppear { loader.load() }
        .blur(radius: 100)
    }

    var imageView: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.4))
            }
        }
    }

    var headerView: some View {
        VStack {
            Text(movie.titleWithLanguage)
                .font(.title)
            Text("Release Date: \(movie.release_date ?? "-")")
                .font(.subheadline)
        }
        .foregroundColor(.white)
    }

    var moviePosterView: some View {
        HStack(alignment: .center) {
            Spacer()
            imageView
                .frame(width: 200, height: 320)
                .cornerRadius(20)
            Spacer()
        }
    }

    var movieOverView: some View {
        Text(movie.overview ?? "-")
            .font(.body)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 16)
    }

    var reviewLink: some View {
        VStack {
            Divider()
            NavigationLink(destination: MovieReviewView(movie: movie)) {
                HStack {
                    Text("Reviews")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            Divider()
        }
    }

    var castInfo: some View {
        VStack(alignment: .leading) {
            Text("Cast")
                .foregroundColor(.white)
            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                HStack(
                    alignment: .top,
                    spacing: 20
                ) {
                    ForEach(movieManager.cast) { cast in
                        VStack {
                            AsyncImage(url: URL(string: cast.profilePhoto)!) {
                                Rectangle()
                                    .foregroundColor(Color.gray.opacity(0.4))
                            } image: {
                                Image(uiImage: $0)
                                    .resizable()
                            }
                            .frame(width: 100, height: 160)
                            .animation(.easeInOut(duration: 0.5))
                            .transition(.opacity)
                            .scaledToFill()
                            .cornerRadius(15)
                            .shadow(radius: 15)

                            Text("\(cast.name ?? "-") as \(cast.character ?? "-")")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 100)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
        .onAppear { movieManager.getCast(for: movie) }
    }

    func save(_ movie: Movie) {
        guard let movieData = try? JSONEncoder().encode(movie) else { return }
        recentlyOpenedMovie = movieData
        print("save \(movie)")
    }
}
