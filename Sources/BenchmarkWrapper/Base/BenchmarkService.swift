//
//  BenchmarkService.swift
//  Benchmark
//
//  Created by Gil Biren on 27.11.20.
//

import Foundation

open class BenchmarkService: BenchmarkServiceProtocol {
    private let semaphore = DispatchSemaphore(value: 1)
    private var localScore = 0
    
    public required init() { }
    
    public func increaseScore() {
        semaphore.wait()
        localScore += 1
        semaphore.signal()
    }
    
    public func setScore(_ score: Int) {
        semaphore.wait()
        localScore = score
        semaphore.signal()
    }
    
    public func generateScore() -> Int {
        semaphore.wait()
        let localScore = self.localScore
        semaphore.signal()
        return localScore
    }
    
    public func cancel() { }
    
    public func calculate() { }
    
    public func isCancelled() -> Bool {
        Thread.current.isCancelled
    }
}
