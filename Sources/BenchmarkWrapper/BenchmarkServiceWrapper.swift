//
//  BenchmarkServiceWrapper.swift
//  Benchmark
//
//  Created by Gil Biren on 25.11.20.
//

import Foundation

public enum BenchmarkRunningState {
    case needConfiguration
    case readyToRun
    case running
}

public final class BenchmarkServiceWrapper: ObservableObject {
    @Published public private(set) var progress: Double = 0
    @Published public private(set) var runningState: BenchmarkRunningState = .needConfiguration
    @Published public private(set) var score: BenchmarkScore?
    
    private var benchmarkServiceConfiguration: BenchmarkServiceConfigurationProtocol!
    private var benchmarkStartDate: Date?
    private var timer: Timer?
    
    private var threads: [Thread: BenchmarkServiceProtocol] = [:]
    
    public init() { }
    
    public func setConfiguration(_ configuration: BenchmarkServiceConfigurationProtocol) {
        cancelThreads()
        benchmarkServiceConfiguration = configuration
        if configuration.duration > 0 {
            runningState = .readyToRun
        } else {
            runningState = .needConfiguration
        }
    }
    
    public func run() {
        guard runningState != .needConfiguration else { return }
        score = nil
        runningState = .running
        progress = 0
        benchmarkStartDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            guard let benchmarkStartDate = self.benchmarkStartDate else { return }
            self.updateTimer(benchmarkStartDate: benchmarkStartDate)
        })
        generateOperations()
    }
    
    public func stop() {
        stopOperations(progress: 0)
        cancelThreads()
        score = nil
    }
    
    private func updateTimer(benchmarkStartDate: Date) {
        let elapsedBenchmarkTimeInterval = abs(benchmarkStartDate.timeIntervalSinceNow)
        self.progress = min(elapsedBenchmarkTimeInterval / benchmarkServiceConfiguration.duration, 1)
        
        let runningServices = threads.filter { !$0.value.isCancelled() }
        if runningServices.count == 0 {
            self.score = BenchmarkScore(
                score: fetchScoresFromActiveServices(),
                configuration: benchmarkServiceConfiguration
            )
            cancelThreads()
            self.stopOperations(progress: 1)
        }
    }
    
    private func calculation(service: BenchmarkServiceProtocol) {
        while !service.isCancelled() {
            service.calculate()
        }
    }
    
    private func generateOperations() {
        let processorCount: Int
        switch benchmarkServiceConfiguration.cpuCoreRunType {
        case .singleCore:
            processorCount = 1
        case .multiCore:
            processorCount = ProcessInfo.processInfo.processorCount
        }
        
        let deadline: DispatchTime = .now() + .milliseconds(Int(benchmarkServiceConfiguration.duration*1000))
        for _ in 1...processorCount {
            let service = benchmarkServiceConfiguration.algorithm.type.init(deadline: deadline)
            createThread(service: service, qos: benchmarkServiceConfiguration.qualityOfService)
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
