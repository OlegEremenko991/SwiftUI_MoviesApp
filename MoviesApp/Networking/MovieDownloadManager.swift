//
//  MovieDownloadManager.swift
//  MoviesApp
//
//  Created by Олег Еременко on 03.03.2021.
//

import SwiftUI

final class MovieDownloadManager: ObservableObject {

    // MARK: - Public properties

    @Published var movies = [Movie]()
    @Published var cast   = [Cast]()

    // MARK: - Public methods

    func getNowPlaying() {
        getMovies(movieURL: .nowPlaying)
    }

    func getUpcoming() {
        getMovies(movieURL: .upcoming)
    }

    func getPopular() {
        getMovies(movieURL: .popular)
    }

    func getCast(for movie: Movie) {
        let urlString = "\(Constant.baseURL)\(movie.id ?? 100)/\(Constant.castPath)?api_key=\(API.key)&language=\(Constant.language)"
        NetworkManager<CastResponse>.fetch(from: urlString) { result in
            switch result {
            case .success(let response):
                self.cast = response.cast
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Private methods

    private func getMovies(movieURL: MovieURL) {
        NetworkManager<MovieResponse>.fetch(from: movieURL.urlString) { result in
            switch result {
            case .success(let movieResponse):
                self.movies = movieResponse.results
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

