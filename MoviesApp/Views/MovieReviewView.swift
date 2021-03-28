//
//  MovieReviewView.swift
//  MoviesApp
//
//  Created by Олег Еременко on 06.03.2021.
//

import SwiftUI

struct MovieReviewView: View {

    // MARK: Public properties

    var movie                                      : Movie

    // MARK: - Private properties

    @ObservedObject private var movieReviewManager : MovieReviewManager

    // MARK: - Init

    init(movie: Movie) {
        self.movie = movie
        self.movieReviewManager = MovieReviewManager(movie: movie)
        setupTableViewAppearance()
    }

    // MARK: - View

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.7)
            List {
                ForEach(movieReviewManager.reviews) { review in
                    VStack {
                        Text(review.author ?? "")
                            .font(.title)
                            .bold()
                        Text(review.content ?? "")
                            .font(.body)
                            .lineLimit(nil)
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color.clear)
                }
            }
            .onAppear { movieReviewManager.getMovieReviews() }
            .padding(.horizontal, 32)
        }
        .edgesIgnoringSafeArea(.all)
    }

    // MARK: - Private methods

    private func setupTableViewAppearance() {
        UITableView.appearance().separatorStyle      = .none
        UITableView.appearance().backgroundColor     = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }

}
