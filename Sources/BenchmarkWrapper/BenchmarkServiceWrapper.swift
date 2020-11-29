//
//  BenchmarkServiceWrapper.swift
//  Benchmark
//
//  Created by Gil Biren on 25.11.20.
//

import Foundation
import Combine

public enum BenchmarkRunningState {
    case needConfiguration
    case readyToRun
    case running
}

public final class BenchmarkServiceWrapper: ObservableObject {
    @Published public private(set) var progress: Double = 0
    @Published public private(set) var runningState: BenchmarkRunningState = .needConfiguration
    @Published public private(set) var scores: [BenchmarkScore] = []
    
    private var benchmarkServiceConfigurations: [BenchmarkServiceConfigurationProtocol] = []
    private var completeDuration: TimeInterval = 0
    
    private var serviceIndex = 0
    private var benchmarkStartDate: Date?
    private var serviceStartDate: Date?
    private var timer: Timer?
    
    private var threads: [Thread: BenchmarkServiceProtocol] = [:]
    
    public init() { }
    
    public func setConfigurations(_ configuration: BenchmarkServiceConfigurationProtocol) {
        setConfigurations([configuration])
    }
    
    public func setConfigurations(_ configurations: [BenchmarkServiceConfigurationProtocol]) {
        cancelThreads()
        benchmarkServiceConfigurations = configurations
        completeDuration = benchmarkServiceConfigurations.reduce(0, { $0 + $1.duration })
        if completeDuration > 0 {
            runningState = .readyToRun
        } else {
            runningState = .needConfiguration
        }
    }
    
    public func run() {
        guard runningState != .needConfiguration else { return }
        scores = []
        runningState = .running
        progress = 0
        serviceIndex = 0
        benchmarkStartDate = Date()
        serviceStartDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            guard let benchmarkStartDate = self.benchmarkStartDate else { return }
            self.updateTimer(benchmarkStartDate: benchmarkStartDate)
        })
        generateOperations()
    }
    
    public func stop() {
        stopOperations(progress: 0)
        scores = []
    }
    
    private func updateTimer(benchmarkStartDate: Date) {
        let elapsedBenchmarkTimeInterval = abs(benchmarkStartDate.timeIntervalSinceNow)
        self.progress = min(elapsedBenchmarkTimeInterval / completeDuration, 1)
        
        let elapsedServiceTimeInterval = abs(serviceStartDate!.timeIntervalSinceNow)
        if elapsedServiceTimeInterval > benchmarkServiceConfigurations[serviceIndex].duration {
            self.scores += [BenchmarkScore(
                name: benchmarkServiceConfigurations[serviceIndex].description,
                score: fetchScoresFromActiveServices()
            )]
            cancelThreads()
            if benchmarkServiceConfigurations.count > serviceIndex+1 {
                serviceIndex += 1
                serviceStartDate = Date()
                generateOperations()
            } else {
                self.stopOperations(progress: 1)
            }
        }
    }
    
    private func calculation(service: BenchmarkServiceProtocol) {
        while !Thread.current.isCancelled {
            service.calculate()
        }
    }
    
    private func generateOperations() {
        let configuration = benchmarkServiceConfigurations[serviceIndex]
        let processorCount: Int
        switch configuration.cpuCoreRunType {
        case .singleCore:
            processorCount = 1
        case .multiCore:
            processorCount = ProcessInfo.processInfo.processorCount
        }
        for _ in 1...processorCount {
            let service = configuration.serviceType.init()
            createThread(service: service, qos: configuration.qualityOfService)
        }
    }
    
    private func fetchScoresFromActiveServices() -> Int {
        var score = 0
        for (_, service) in threads {
            score += service.generateScore()
        }
        return score
    }
    
    private func cancelThreads() {
        for (thread, service) in threads {
            thread.cancel()
            service.cancel()
        }
        threads = [:]
    }
    
    private func createThread(service: BenchmarkServiceProtocol, qos: QualityOfService) {
        let thread = Thread {
            self.calculation(service: service)
        }
        thread.threadPriority = 1
        thread.qualityOfService = qos
        thread.start()
        threads[thread] = service
    }
    
    private func stopOperations(progress: Double) {
        timer?.invalidate()
        timer = nil
        runningState = .readyToRun
        self.progress = progress
    }
}
