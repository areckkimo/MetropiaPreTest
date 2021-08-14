//
//  PhotoDownloadOperation.swift
//  PhotoDownload
//
//  Created by Eric Chen on 2020/4/2.
//  Copyright © 2020 Eric Chen. All rights reserved.
//

import Foundation
import UIKit

class PhotoDownloadOperation: ConcurrentOperation<(UIImage, IndexPath)> {
    private let session: URLSession
    let photoURL: URL?
    private let indexPath: IndexPath
    private var task: URLSessionTask?
    
    init(session: URLSession = URLSession.shared, photoURL: URL?, indexPath: IndexPath) {
        self.session = session
        self.photoURL = photoURL
        self.indexPath = indexPath
    }
    
    override func main() {
        guard let photoURL = photoURL else {
            cancel()
            return
        }
        task = session.downloadTask(with: photoURL, completionHandler: { (localURL, response, error) in
            guard
                let localURL = localURL,
                let data = try? Data(contentsOf: localURL),
                let image = UIImage(data: data)
            else{
                DispatchQueue.main.async {
                    if let error = error{
                        self.complete(result: .failure(error))
                    }else{
                        self.complete(result: .failure(DataResponseError.missingData))
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self.complete(result: .success((image, self.indexPath)))
            }
        })
        task?.resume()
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}
