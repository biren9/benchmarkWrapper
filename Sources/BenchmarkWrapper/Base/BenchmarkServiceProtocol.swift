//
//  BenchmarkServiceProtocol.swift
//  Benchmark
//
//  Created by Gil Biren on 25.11.20.
//

import Foundation

public enum CpuCoreRunType: Equatable, Hashable {
    case singleCore
    case multiCore
    case custom(Int)
}

public struct Algortihm {
    public let name: String
    public let type: BenchmarkServiceProtocol.Type
    
    public init(name: String, type: BenchmarkServiceProtocol.Type) {
        self.name = name
        self.type = type
    }
}

public protocol BenchmarkServiceProtocol: AnyObject {
    init(deadline: DispatchTime)
    
    func isCancelled() -> Bool
    func cancel()
    func calculate()
    func generateScore() -> Int
}

public protocol BenchmarkServiceConfigurationProtocol {
    var cpuCoreRunType: CpuCoreRunType { get }
    var qualityOfService: QualityOfService { get }
    var threadPriority: Double { get }
    var description: String? { get }
    var duration: DispatchTimeInterval { get }
    var algorithm: Algortihm { get }
}
