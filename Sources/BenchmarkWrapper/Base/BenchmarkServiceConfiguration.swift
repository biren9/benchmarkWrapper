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
    public let description: String?
    public let cpuCoreRunType: CpuCoreRunType
    public let duration: TimeInterval
}
