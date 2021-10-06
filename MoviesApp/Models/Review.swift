//
//  Review.swift
//  MoviesApp
//
//  Created by Олег Еременко on 03.03.2021.
//

import Foundation

struct ReviewResponse: Codable {
    var results: [Review]
}

struct Review: Codable, Identifiable {
    var id, author, content: String?
}
