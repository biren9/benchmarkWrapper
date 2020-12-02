//
//  DispatchTimeInterval+Extensions.swift
//  
//
//  Created by Gil Biren on 02.12.20.
//

import Foundation

extension DispatchTimeInterval {
    var nanoseconds: Int {
        switch self {
        case .seconds(let s): return s * 1_000_000_000
        case .milliseconds(let ms): return ms * 1_000_000
        case .microseconds(let us): return us * 1_000
        case .nanoseconds(let ns): return ns
        case .never:
            return .max
        @unknown default:
            fatalError("@unknown default DispatchTimeInterval")
        }
    }
}
