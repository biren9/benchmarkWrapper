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

public struct Algortihm {
    public let name: String
    public let type: BenchmarkServiceProtocol.Type
    
    public init(name: String, type: BenchmarkServiceProtocol.Type) {
        self.name = name
        self.type = type
    }
}

public protocol BenchmarkServiceProtocol: class {
    init(deadline: DispatchTime)
    
    func isCancelled() -> Bool
    func cancel()
    func calculate()
    func generateScore() -> Int
}

public protocol BenchmarkServiceConfigurationProtocol {
    var cpuCoreRunType: CpuCoreRunType { get }
    var qualityOfService: QualityOfService { get }
    var description: String? { get }
    var duration: TimeInterval { get }
    var algorithm: Algortihm { get }
}
