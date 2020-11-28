//
//  BenchmarkServiceProtocol.swift
//  Benchmark
//
//  Created by Gil Biren on 25.11.20.
//

import Foundation

public enum CpuCoreRunType {
    case singleCore
    case multiCore
}

public protocol BenchmarkServiceProtocol: class {
    init()
    
    func cancel()
    func calculate()
    func generateScore() -> Int
}

public protocol BenchmarkServiceConfigurationProtocol {
    var cpuCoreRunType: CpuCoreRunType { get }
    var qualityOfService: QualityOfService { get }
    var description: String { get }
    var duration: TimeInterval { get }
    var serviceType: BenchmarkServiceProtocol.Type { get }
}
