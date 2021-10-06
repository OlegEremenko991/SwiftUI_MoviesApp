//
//  AsyncImage.swift
//  MoviesApp
//
//  Created by Олег Еременко on 06.03.2021.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image

    init(
        url: URL,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(
            wrappedValue: ImageLoader(
                url: url,
                cache: Environment(\.imageCache).wrappedValue
            )
        )
    }

    var body: some View {
        content.onAppear(perform: loader.load)
    }
}

private extension AsyncImage {
    var content: some View {
        Group {
            if let image = loader.image {
                self.image(image)
            } else {
                placeholder
            }
        }
    }
}
