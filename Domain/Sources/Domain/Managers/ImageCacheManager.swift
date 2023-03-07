//
//  ImageCacheManager.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-07.
//

import Foundation
import SwiftUI

public class ImageCacheManager {

    static let instance = ImageCacheManager()

    private init() { }

    func saveImage(_ image: UIImage, imageName: String, folderName: String) {

        createFolderIfNeeded(folderName: folderName)

        guard let data = image.pngData(),
              let url = getURLForImage(with: imageName, from: folderName)
        else { return }

        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. \(error)")
        }
    }

    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(with: imageName, from: folderName), FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }

    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else {
            return
        }

        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. Folder name: \(folderName), error: \(error)")
            }
        }
    }

    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }

    private func getURLForImage(with imageName: String, from folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }

        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
