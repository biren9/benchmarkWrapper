//
//  BenchmarkServiceConfiguration.swift
//  Benchmark
//
//  Created by Gil Biren on 27.11.20.
//

import Foundation

public struct BenchmarkConfiguration: BenchmarkServiceConfigurationProtocol {
    public let qualityOfService: QualityOfService
    public let serviceType: BenchmarkServiceProtocol.Type
    public let description: String
    public let cpuCoreRunType: CpuCoreRunType
    public let duration: TimeInterval
    
    public init(cpuCoreRunType: CpuCoreRunType, duration: TimeInterval, description: String, serviceType: BenchmarkServiceProtocol.Type, qualityOfService: QualityOfService) {
        self.cpuCoreRunType = cpuCoreRunType
        self.duration = duration
        self.description = description
        self.serviceType = serviceType
        self.qualityOfService = qualityOfService
    }
}
