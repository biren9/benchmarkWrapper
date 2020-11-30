//
//  BenchmarkServiceConfiguration.swift
//  Benchmark
//
//  Created by Gil Biren on 27.11.20.
//

import Foundation

public struct BenchmarkConfiguration: BenchmarkServiceConfigurationProtocol {
    public let qualityOfService: QualityOfService
    public let algorithm: Algortihm
    public let description: String?
    public let cpuCoreRunType: CpuCoreRunType
    public let duration: TimeInterval
    
    public init(qualityOfService: QualityOfService, algorithm: Algortihm, description: String? = nil, cpuCoreRunType: CpuCoreRunType, duration: TimeInterval) {
        self.qualityOfService = qualityOfService
        self.algorithm = algorithm
        self.description = description
        self.cpuCoreRunType = cpuCoreRunType
        self.duration = duration
    }
}
