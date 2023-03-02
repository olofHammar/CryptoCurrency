//
//  AppConfig.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Domain
import Foundation
import Navigation
import Network
import ShortcutFoundation

struct AppConfig: Config {
    func configure(_ injector: ShortcutFoundation.Injector) {
        configureNetworkInjections(injector)
        configureDomainInjections(injector)
        configureNavigationInjections(injector)
        configureViewModelInjections(injector)
        configurePresentationInjections(injector)
    }
}

private extension AppConfig {
    func configureNetworkInjections(_ injector: Injector) {
        injector.map(ICoinDataSource.self) {
            if shouldFetchStaticData() {
                return StaticCoinDataSource()
            } else {
                return CoinDataSource()
            }
        }
    }

    func configureDomainInjections(_ injector: Injector) {
        injector.map(ICoinsRepository.self) {
            CoinsRepository()
        }
    }

    func configureNavigationInjections(_ injector: Injector) {
        injector.map(AppNavigator.self) {
            Navigator(root: .root, viewer: AppDestinationViewer())
        }
    }

    func configurePresentationInjections(_ injector: Injector) {
        injector.map(IFetchAllSupportedCoinsUseCase.self) {
            FetchAllSupportedCoinsUseCase()
        }
    }

    func configureViewModelInjections(_ injector: Injector) {
        injector.map(TabBarViewModel.self) {
            TabBarViewModel()
        }

        injector.map(RootViewModel.self) {
            RootViewModel()
        }

        injector.map(DashboardViewModel.self) {
            DashboardViewModel()
        }
    }
}

private extension AppConfig {
    var isRunningInPreview: Bool { ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" }
    var isRunningTests: Bool { ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil }

    func shouldFetchStaticData() -> Bool {
        isRunningInPreview || isRunningTests
    }
}
