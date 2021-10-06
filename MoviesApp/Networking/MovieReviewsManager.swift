//
//  MovieReviewsManager.swift
//  MoviesApp
//
//  Created by Олег Еременко on 03.03.2021.
//

import SwiftUI

final class MovieReviewManager: ObservableObject {
    @Published var reviews = [Review]()
    private var movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    func getMovieReviews() {
        getReview(for: movie)
    }
}

private extension MovieReviewManager {
    func getReview(for movie: Movie) {
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
