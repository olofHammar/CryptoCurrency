//
//  Navigator.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import SwiftUI

/// Protocol conforming to Codable and Hashable
/// To use generic type as a path on the NavigationStack
public protocol NavigationStackable: Codable, Hashable {}

open class DestinationViewer<T: NavigationStackable> {
    public init() { }

    @ViewBuilder
    open func view(for destination: T) -> any View {
        EmptyView()
    }
}

public class Navigator<T: NavigationStackable>: ObservableObject {
    @Published private var root: T
    @Published private var path: [T] = []

    private let viewer: DestinationViewer<T>

    private var pathBinding: Binding<[T]> {
        Binding {
            self.path
        } set: { newValue, _ in
            self.path = newValue
        }
    }

    public var rootView: some View {
        NavigationStack(path: pathBinding) {
            AnyView(viewer.view(for: root))
                .navigationDestination(for: T.self) { destination in
                    AnyView(self.viewer.view(for: destination))
                }
        }
    }

    public required init(root: T, viewer: DestinationViewer<T>) {
        self.root = root
        self.viewer = viewer
    }

    public func setRoot(_ newRoot: T) {
        path.removeAll()
        root = newRoot
    }

    public func push(_ destination: T) {
        path.append(destination)
    }

    public func pop() {
        path.removeLast()
    }

    public func popToRoot() {
        path.removeAll()
    }
}
