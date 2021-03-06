//
//  MovieReviewsManager.swift
//  MoviesApp
//
//  Created by Олег Еременко on 03.03.2021.
//

import SwiftUI

final class MovieReviewManager: ObservableObject {

    // MARK: - Public properties

    @Published var reviews = [Review]()

    // MARK: - Private properties

    private var movie: Movie

    // MARK: - Lifecycle

    init(movie: Movie) {
        self.movie = movie
    }

    // MARK: - Public methods

    func getMovieReviews() {
        getReview(for: movie)
    }


    // MARK: - Private methods

    private func getReview(for movie: Movie) {
        let urlString = "\(Constant.baseURL)\(movie.id ?? 100)/\(Constant.reviewPath)?api_key=\(API.key)"
        NetworkManager<ReviewResponse>.fetch(from: urlString) { result in
            switch result {
            case .success(let response):
                self.reviews = response.results
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
