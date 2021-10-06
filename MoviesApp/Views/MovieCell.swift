//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Олег Еременко on 06.03.2021.
//

import SwiftUI

struct MovieCell: View {
    var movie: Movie

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            moviePoster
            VStack(alignment: .leading, spacing: .zero) {
                movieTitle
                HStack {
                    movieVotes
                    movieReleaseDate
                }
                movieOverview
            }
        }
    }
}

private extension MovieCell {
    var moviePoster: some View {
        AsyncImage(url: URL(string: movie.posterPath)!) {
            Rectangle().foregroundColor(Color.gray.opacity(0.4))
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
    }

    var movieTitle: some View {
        Text(movie.titleWithLanguage)
            .font(.system(size: 15))
            .bold()
            .foregroundColor(.blue)
    }

    var movieVotes: some View {
        ZStack {
            Circle() // Main circle
                .trim(from: .zero, to: CGFloat(movie.voteAverage))
                .stroke(Color.orange, lineWidth: 4)
                .frame(width: 50)
                .rotationEffect(.degrees(-90))
            Circle() // Secondary circle
                .trim(from: .zero, to: 1)
                .stroke(Color.orange.opacity(0.2), lineWidth: 4)
                .frame(width: 50)
                .rotationEffect(.degrees(-90))
            Text(String.init(format: "%0.2f", movie.vote_average ?? .zero))
                .foregroundColor(.orange)
                .font(.subheadline)
        }
        .frame(height: 80)
    }

    var movieReleaseDate: some View {
        Text(movie.release_date ?? "")
            .foregroundColor(.black)
            .font(.subheadline)
    }

    var movieOverview: some View {
        Text(movie.overview ?? "")
            .font(.body)
            .foregroundColor(.gray)
    }
}
