//
//  ConcurrentOperation.swift
//  PhotoDownload
//
//  Created by Eric Chen on 2020/4/1.
//  Copyright © 2020 Eric Chen. All rights reserved.
//

import Foundation

class ConcurrentOperation<T>: Operation {
    
    typealias OperationCompletionHandler = (_ result: Result<T, Error>) -> Void
    var completionHandler: OperationCompletionHandler?
    
    enum State: String {
        case Ready
        case Executing
        case Finished
        
        var keyPath: String {
            return "is" + rawValue
        }
    }
    
    var state = State.Ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool{
        return super.isReady && state == .Ready
    }
    
    override var isExecuting: Bool{
        return state == .Executing
    }
    
    override var isFinished: Bool{
        return state == .Finished
    }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        if !isExecuting {
            state = .Executing
        }
        main()
    }
    
    override func cancel() {
        super.cancel()
        finish()
    }
    
    func finish(){
        if isExecuting {
            state = .Finished
        }
    }
    
    func complete(result: Result<T, Error>){
        finish()
        if !isCancelled {
            completionHandler?(result)
        }
    }
}
