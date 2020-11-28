# BenchmarkWrapper

This package provides a wrapper for individual benchmarking tasks.
Currently at an early stage and should act as a prove of concept.

## Custom benchmark service

To create a custom benchmark task, create a class and inherit from `BenchmarkService` as follows:

```
class BenchmarkCalculationPrime: BenchmarkService {
    
    /* This gets called in a loop as long as the running thread isn't cancelle. */
    override func calculate() {
        calculatePrime()
        
        /* increaseScore() will increase the calculated score by 1.
        If you need to set a custom score use setScore(x).
        The implementation of the score is thread safe.
        */
        increaseScore()
    }
    
    /* This gets called after the thread got cancelled. Use this to cleanup stuff if needed. */
    override func cancel() {
    
    }
    
    /* Custom implementation for a Benchmark */
    private func calculatePrime() {
        let to = Int(pow(2.0, 12.0))
        for number in 0...to {
            guard !isCancelled() else { return }
            isPrime(number)
        }
    }
    
    @discardableResult
    private func isPrime(_ n: Int) -> Bool {
        if n <= 1 {
            return false
        }
     
        for divider in 2..<n where n%divider == 0 {
            return false
        }
        return true;
    }
}
```

## Usage

`import BenchmarkServiceWrapper`

Create a `BenchmarkServiceWrapper` and pass in a bunch of `BenchmarkServiceConfigurationProtocol`.

```
struct BenchmarkConfiguration: BenchmarkServiceConfigurationProtocol {
    /* Defines the QualityOfService of the thread. */
    public let qualityOfService: QualityOfService
    
    /* Defines the type of benchmark service to be allocated on demand for each thread. */
    public let serviceType: BenchmarkServiceProtocol.Type
    
    /* Defines a string that should describe what the benchmark service does. */
    public let description: String
    
    /* Defines if the task should run on a single or on every core. */
    public let cpuCoreRunType: CpuCoreRunType
    
    /* Defines the duration for how long the task should run. */
    public let duration: TimeInterval
}
```

## Example

```

@ObservedObject var benchmarkService = BenchmarkServiceWrapper(
        benchmarkServiceConfigurations: [
            BenchmarkConfiguration(
                cpuCoreRunType: .singleCore,
                duration: 20,
                description: "Prime numbers singleCore",
                serviceType: BenchmarkCalculationPrime.self,
                qualityOfService: .userInitiated
            )
        ]
    )

```
