//
//  BenchmarkScore.swift
//  Benchmark
//
//  Created by Gil Biren on 27.11.20.
//

import Foundation

public struct BenchmarkScore: Identifiable {
    public let id = UUID()
    public let score: Int
    public let configuration: BenchmarkServiceConfigurationProtocol
    
    public init(score: Int, configuration: BenchmarkServiceConfigurationProtocol) {
        self.score = score
        self.configuration = configuration
    }
}
