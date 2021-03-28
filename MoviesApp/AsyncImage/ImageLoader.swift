//
//  ImageLoader.swift
//  MoviesApp
//
//  Created by Олег Еременко on 06.03.2021.
//

import Combine
import UIKit

final class ImageLoader: ObservableObject {

    // MARK: - Public properties

    @Published var image                    : UIImage?

    // MARK: - Private properties

    private(set) var isLoading              = false
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    private let url                         : URL
    private var cache                       : ImageCache?
    private var cancellable                 : AnyCancellable?

    // MARK: - Lifecycle

    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }

    deinit {
        cancel()
    }

    // MARK: - Public methods

    func load() {
        guard !isLoading else { return }

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

    // MARK: - Private methods

    private func onStart()                { isLoading = true }
    private func cache(_ image: UIImage?) { image.map { cache?[url] = $0 } }
    private func onFinish()               { isLoading = false }
    private func cancel()                 { cancellable?.cancel() }

}
