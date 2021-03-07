//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Олег Еременко on 06.03.2021.
//

import SwiftUI

struct MovieCell: View {

    @AppStorage("RecentlyOpenedMovie", store: UserDefaults(suiteName: "group.com.oleg991.MoviesApp"))
    var recentlyOpenedMovie = Data()

    // MARK: - Public properties

    var movie: Movie

    // MARK: - View

    var body: some View {
        HStack(alignment: .top, spacing: 20, content: {
            moviePoster
            VStack(alignment: .leading, spacing: 0) {
                movieTitle
                HStack {
                    movieVotes
                    movieReleaseDate
                }
                movieOverview
            }
        })
    }

    private var moviePoster: some View {
        AsyncImage(url: URL(string: movie.posterPath)!) {
            Rectangle().foregroundColor(Color.gray.opacity(0.4))
        } image: { image -> Image in
            Image(uiImage: image)
                .resizable()
        }
        .frame(width: 100, height: 160)
        .animation(.easeInOut(duration: 0.5))
        .transition(.opacity)
        .scaledToFill()
        .cornerRadius(15)
        .shadow(radius: 15)
        .onTapGesture {
            save(movie)
        }
    }

    private var movieTitle: some View {
        Text(movie.titleWithLanguage)
            .font(.system(size: 15))
            .bold()
            .foregroundColor(.blue)
    }

    private var movieVotes: some View {
        ZStack {
            Circle() // Main circle
                .trim(from: 0, to: CGFloat(movie.voteAverage))
                .stroke(Color.orange, lineWidth: 4)
                .frame(width: 50)
                .rotationEffect(.degrees(-90))
            Circle()// Secondary circle
                .trim(from: 0, to: 1)
                .stroke(Color.orange.opacity(0.2), lineWidth: 4)
                .frame(width: 50)
                .rotationEffect(.degrees(-90))
            Text(String.init(format: "%0.2f", movie.vote_average ?? 0.0))
                .foregroundColor(.orange)
                .font(.subheadline)
        }
        .frame(height: 80)
    }

    private var movieReleaseDate: some View {
        Text(movie.release_date ?? "")
            .foregroundColor(.black)
            .font(.subheadline)
    }

    private var movieOverview: some View {
        Text(movie.overview ?? "")
            .font(.body)
            .foregroundColor(.gray)
    }

    private func save(_ movie: Movie) {
        guard let movieData = try? JSONEncoder().encode(movie) else { return }
        recentlyOpenedMovie = movieData
        print("save \(movie)")
    }

}

