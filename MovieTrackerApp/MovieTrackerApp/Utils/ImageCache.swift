//
//  ImageCache.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

//import SwiftUI
//
//class ImageCache {
//    static let shared = ImageCache()
//    private var cache = NSCache<NSString, UIImage>()
//    
//    private init() {
//        // Set up cache limits
//        cache.countLimit = 100
//        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
//    }
//    
//    func set(_ image: UIImage, forKey key: String) {
//        cache.setObject(image, forKey: key as NSString)
//    }
//    
//    func get(forKey key: String) -> UIImage? {
//        return cache.object(forKey: key as NSString)
//    }
//    
//    func remove(forKey key: String) {
//        cache.removeObject(forKey: key as NSString)
//    }
//    
//    func clearCache() {
//        cache.removeAllObjects()
//    }
//}
//
//struct CachedAsyncImage<Content: View>: View {
//    private let url: URL?
//    private let scale: CGFloat
//    private let transaction: Transaction
//    private let content: (AsyncImagePhase) -> Content
//    
//    init(url: URL?, scale: CGFloat = 1.0, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
//        self.url = url
//        self.scale = scale
//        self.transaction = transaction
//        self.content = content
//    }
//    
//    var body: some View {
//        if let url = url, let cachedImage = ImageCache.shared.get(forKey: url.absoluteString) {
//            content(.success(Image(uiImage: cachedImage)))
//        } else {
//            AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
//                if case .success(let image) = phase, let url = url {
//                    let _ = cacheImage(image, url: url)
//                }
//                content(phase)
//            }
//        }
//    }
//    
//    private func cacheImage(_ image: Image, url: URL) -> Image {
//        if let uiImage = imageToUIImage(image) {
//            ImageCache.shared.set(uiImage, forKey: url.absoluteString)
//        }
//        return image
//    }
//    
//    private func imageToUIImage(_ image: Image) -> UIImage? {
//        let controller = UIHostingController(rootView: image.padding(0))
//        controller.view.backgroundColor = .clear
//        
//        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
//        controller.view.bounds = CGRect(origin: .zero, size: size)
//        controller.view.sizeToFit()
//        
//        let renderer = UIGraphicsImageRenderer(size: controller.view.bounds.size)
//        return renderer.image { _ in
//            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}
