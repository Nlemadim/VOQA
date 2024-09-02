//
//  CachedImageView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import SwiftUI
import Shimmer

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}

    private var cache = [URL: Data]() // Dictionary to store cached images

    func hasImageInCache(url: URL) -> Data? {
        return cache[url]
    }

    func cacheImageData(url: URL, data: Data) {
        cache[url] = data
    }
}

struct CachedImageView: View {
    let imageUrl: String

    var body: some View {
        if let url = URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            if let imageData = ImageCacheManager.shared.hasImageInCache(url: url),
               let uiImage = UIImage(data: imageData) {
                // Use the cached image
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                // Load the image using AsyncImage
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        // Show a shimmer effect as a placeholder
                        ZStack {
                            Color.gray.opacity(0.2)
                                .shimmering()
                                .cornerRadius(10)
                        }

                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .onAppear {
                                // Cache the image data when it successfully loads
                                cacheImage(url: url, image: image)
                            }

                    case .failure:
                        // Show an error view if loading fails
                        ZStack {
                            Color.gray.opacity(0.2)
                                .cornerRadius(10)
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .imageScale(.large)
                        }

                    @unknown default:
                        EmptyView()
                    }
                }
            }
        } else {
            // Show a fallback if the URL is invalid
            ZStack {
                Color.gray.opacity(0.2)
                    .cornerRadius(10)
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .imageScale(.large)
            }
        }
    }

    private func cacheImage(url: URL, image: Image) {
        // Use AsyncImage to fetch the image's data and then cache it
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                ImageCacheManager.shared.cacheImageData(url: url, data: data)
            }
        }.resume()
    }
}

//struct CachedImageView: View {
//    let imageUrl: String
//
//    var body: some View {
//        if let url = URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
//            if let imageData = ImageCacheManager.shared.hasImageInCache(url: url),
//               let uiImage = UIImage(data: imageData) {
//                // Use the cached image
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            } else {
//                // Load the image using AsyncImage
//                AsyncImage(url: url) { phase in
//                    switch phase {
//                    case .empty:
//                        // Show a placeholder with a ProgressView overlay
//                        ZStack {
//                            Image("IconImage")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            ProgressView()
//                        }
//
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .onAppear {
//                                // Cache the image data when it successfully loads
//                                cacheImage(url: url, image: image)
//                            }
//
//                    case .failure:
//                        // Show the placeholder with an error overlay
//                        ZStack {
//                            Image("IconImage")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            Image(systemName: "exclamationmark.triangle.fill")
//                                .foregroundColor(.red)
//                                .imageScale(.large)
//                        }
//
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//            }
//        } else {
//            // Show a fallback if the URL is invalid
//            ZStack {
//                Image("IconImage")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                Image(systemName: "exclamationmark.triangle.fill")
//                    .foregroundColor(.red)
//                    .imageScale(.large)
//            }
//        }
//    }
//
//    private func cacheImage(url: URL, image: Image) {
//        // Use AsyncImage to fetch the image's data and then cache it
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            if let data = data {
//                ImageCacheManager.shared.cacheImageData(url: url, data: data)
//            }
//        }.resume()
//    }
//}
