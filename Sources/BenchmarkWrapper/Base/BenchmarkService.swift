//
//  BenchmarkService.swift
//  Benchmark
//
//  Created by Gil Biren on 27.11.20.
//

import Foundation

open class BenchmarkService: BenchmarkServiceProtocol {
    private let deadline: DispatchTime
    private let semaphore = DispatchSemaphore(value: 1)
    private var localScore = 0
    
    public required init(deadline: DispatchTime) {
        self.deadline = deadline
    }
    
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
    
    open func cancel() {
        Thread.current.cancel()
    }
    
    open func calculate() {
        if isTimeOver() {
            Thread.current.cancel()
        }
    }
    
    public func isCancelled() -> Bool {
        if isTimeOver() || Thread.current.isCancelled {
            return true
        }
        return false
    }
    
    private func isTimeOver() -> Bool {
        DispatchTime.now() > deadline
    }
}
