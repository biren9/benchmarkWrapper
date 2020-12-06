//
//  BenchmarkServiceConfiguration.swift
//  Benchmark
//
//  Created by Gil Biren on 27.11.20.
//

import Foundation

public struct BenchmarkConfiguration: BenchmarkServiceConfigurationProtocol {
    public let qualityOfService: QualityOfService
    public let threadPriority: Double
    public let algorithm: Algortihm
    public let description: String?
    public let cpuCoreRunType: CpuCoreRunType
    public let duration: DispatchTimeInterval
    
    public init(qualityOfService: QualityOfService, threadPriority: Double, algorithm: Algortihm, description: String? = nil, cpuCoreRunType: CpuCoreRunType, duration: DispatchTimeInterval) {
        self.qualityOfService = qualityOfService
        self.threadPriority = threadPriority
        self.algorithm = algorithm
        self.description = description
        self.cpuCoreRunType = cpuCoreRunType
        self.duration = duration
    }
}
