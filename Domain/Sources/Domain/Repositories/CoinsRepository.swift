//
//  CoinsRepository.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Combine
import Foundation
import Model
import Network
import ShortcutFoundation
import UIKit

public protocol ICoinsRepository {
    func getAllSupportedCoins() -> AnyPublisher<[CoinModel], RequestError>
    func downloadImage(for coin: CoinModel) -> AnyPublisher<UIImage, RequestError>
    func getCachedImage(for coin: CoinModel) -> UIImage?
}

public class CoinsRepository: ICoinsRepository {
    @LazyInject private(set) var coinDataSource: ICoinDataSource

    private let imageCacheManager = ImageCacheManager.instance
    private let folderName = "coin_images"

    public init() { }

    public func getAllSupportedCoins() -> AnyPublisher<[CoinModel], RequestError> {
        return Future { promise in
            Task {
                let result = await self.coinDataSource.getAllSupportedCoins()

                switch result {
                case .success(let coins):
                    promise(.success(coins))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func getCachedImage(for coin: CoinModel) -> UIImage? {
        imageCacheManager.getImage(imageName: coin.id, folderName: folderName)
    }

    private func saveImageToCache(image: UIImage, imageName: String) {
        imageCacheManager.saveImage(image, imageName: imageName, folderName: folderName)
    }

    public func downloadImage(for coin: CoinModel) -> AnyPublisher<UIImage, RequestError> {
        guard let url = URL(string: coin.image) else {
            return Fail(error: RequestError.invalidURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let image = UIImage(data: data) else {
                    throw RequestError.noResponse
                }
                return image
            }
            .mapError { error in
                return RequestError.unknown
            }
            .eraseToAnyPublisher()
    }
}
