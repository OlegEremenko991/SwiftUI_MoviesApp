//
//  MovieURL.swift
//  MoviesApp
//
//  Created by Олег Еременко on 03.03.2021.
//

import Foundation

enum MovieURL: String {
    case nowPlaying = "now_playing"
    case upcoming   = "upcoming"
    case popular    = "popular"

    var urlString: String {
        "\(Constant.baseURL)\(self.rawValue)?api_key=\(API.key)&language=en-US&page=1"
    }
}
