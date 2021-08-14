//
//  ImageDownloadManager.swift
//  PhotoDownload
//
//  Created by Eric Chen on 2020/4/2.
//  Copyright © 2020 Eric Chen. All rights reserved.
//

import Foundation
import UIKit

class PhotoDownloadManager {
    typealias photoDownLoadHandler = (_ result: Result<(UIImage, IndexPath), Error>) -> Void
    lazy var photoDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "photoDownloadQueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    let photoCache = NSCache<NSString, UIImage>()
    static let shared = PhotoDownloadManager()
    private init() {}
    func downloadPhoto(with url: URL, indexPath: IndexPath, completionHandler: @escaping photoDownLoadHandler){
        
        let urlString = url.absoluteString
        
        if let cachedImage = photoCache.object(forKey: urlString as NSString) {
            print("return cached image for \(urlString)")
            completionHandler(.success((cachedImage, indexPath)))
        }else{
            if let operations = (photoDownloadQueue.operations as? [PhotoDownloadOperation])?.filter({ $0.photoURL?.absoluteString == urlString && $0.isFinished == false && $0.isExecuting == true}), let operation = operations.first {
                print("Increase the priority for \(urlString)")
                operation.queuePriority = .veryHigh
            }else{
                print("Create a new task for \(urlString)")
                let operation = PhotoDownloadOperation(photoURL: URL(string: urlString), indexPath: indexPath)
                operation.completionHandler = { (result) in
                    switch result{
                    case .success(let (image, _)):
                        self.photoCache.setObject(image, forKey: urlString as NSString)
                    case .failure(_): break
                    }
                    completionHandler(result)
                }
                photoDownloadQueue.addOperation(operation)
            }
        }
    }
    
    func slowDownPhotoDownloadTask(for url: URL){
        let urlString = url.absoluteString
        if let operations = (photoDownloadQueue.operations as? [PhotoDownloadOperation])?.filter({$0.photoURL?.absoluteString == urlString && $0.isFinished == false && $0.isExecuting == true}),
           let operation = operations.first {
            print("Decrease the priority for \(urlString)")
            operation.queuePriority = .veryLow
        }
    }
}
