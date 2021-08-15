//
//  AreaViewModel.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/15.
//

import Foundation
import CoreLocation

protocol AreaViewModelDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed(error: HTTPError)
}

final class AreaViewModel {
    private weak var delegate: AreaViewModelDelegate?
    private(set) var coordinates = [CLLocationCoordinate2D]()
    private let sheethubClient = SheethubClient()
    private let request: AreaRequest
    
    init(request: AreaRequest, delegate: AreaViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    func fetchAreaBound(){
        sheethubClient.fetchAreaBoundaries(with: request) { (result) in
            switch result {
            case .success(let area):
                let coordinates = area.features[0].geometry.coordinates[0]
                for coordinate in coordinates {
                    let location = CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])
                    self.coordinates.append(location)
                }
                DispatchQueue.main.async {
                    self.delegate?.onFetchCompleted()
                }
            case .failure(let error):
                self.delegate?.onFetchFailed(error: error)
            }
        }
    }
}
