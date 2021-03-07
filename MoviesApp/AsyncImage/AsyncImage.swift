//
//  AsyncImage.swift
//  MoviesApp
//
//  Created by Олег Еременко on 06.03.2021.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {

    // MARK: - Private properties

    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image

    // MARK: - Init

    init(url: URL,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }

    // MARK: - View

    var body: some View {
        content.onAppear(perform: loader.load)
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                self.image(image)
            } else {
                placeholder
            }
        }
    }
}
