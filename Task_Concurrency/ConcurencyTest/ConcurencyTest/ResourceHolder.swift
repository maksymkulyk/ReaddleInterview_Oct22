//
//  ResourceHolder.swift
//  ConcurencyTest
//
//  Created by Sviatoslav Yakymiv on 22.10.2020.
//

import Foundation

class ResourceHolder {
    private let accessQueue = DispatchQueue.init(label: "com.test.ResourceHolder.AccessQueue",
                                                 attributes: .concurrent)
    private var resource = ""
    func append(char: Character, fromTask taskName: String) {
        accessQueue.sync(flags: .barrier) {
            self.resource.append(char)
            print("\(taskName) added symbol: \(char)")
        }
    }
    func first(fromTask taskName: String) -> Character? {
        return accessQueue.sync {
            let char = self.resource.first
            if let char = char {
                print("\(taskName) read symbol: \(char)")
            } else {
                print("\(taskName) could not read symbol")
            }
            return char
        }
    }
    func dropFirst(fromTask taskName: String) -> Character? {
        return accessQueue.sync(flags: .barrier) {
            if self.resource.isEmpty {
                print("\(taskName) could not remove symbol")
                return nil
            } else {
                let char = self.resource.removeFirst()
                print("\(taskName) removed symbol: \(char)")
                return char
            }
        }
    }
}
