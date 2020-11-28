//
//  BenchmarkScore.swift
//  Benchmark
//
//  Created by Gil Biren on 27.11.20.
//

import Foundation

public struct BenchmarkScore: Identifiable {
    public var id: String { UUID().uuidString }
    public let name: String
    public let score: Int
}
