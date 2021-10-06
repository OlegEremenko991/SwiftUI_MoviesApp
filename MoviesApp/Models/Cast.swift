//
//  Cast.swift
//  MoviesApp
//
//  Created by Олег Еременко on 03.03.2021.
//

import Foundation

struct CastResponse: Codable {
    var cast: [Cast]
}

struct Cast: Codable, Identifiable {
    var id: Int?
    var name, character, profile_path: String?
    var profilePhoto: String {
        if let path = profile_path {
            return "https://image.tmdb.org/t/p/original/\(path)"
        } else {
            return "https://picsum.photos/200/300"
        }
    }
}
