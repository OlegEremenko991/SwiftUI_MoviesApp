//
//  ImageLoader.swift
//  MoviesApp
//
//  Created by Олег Еременко on 06.03.2021.
//

import Combine
import UIKit

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private(set) var isLoading = false
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    private let url: URL
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?

    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }

    deinit {
        cancel()
    }

    func load() {
        if isLoading {
            return
        }

        if let image = cache?[url] {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.onStart()  },
                receiveOutput:       { [weak self]   in self?.cache($0)  },
                receiveCompletion:   { [weak self] _ in self?.onFinish() },
                receiveCancel:       { [weak self]   in self?.onFinish() }
            )
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
}

private extension ImageLoader {
    func onStart() {
        isLoading = true
    }

    func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }

    func onFinish() {
        isLoading = false
    }

    func cancel() {
        cancellable?.cancel()
    }
}
