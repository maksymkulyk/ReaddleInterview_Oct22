//
//  TasksExecutor.swift
//  ConcurencyTest
//
//  Created by Sviatoslav Yakymiv on 22.10.2020.
//

import Foundation

class TasksExecutor {
    let resourceHolder = ResourceHolder()
    func start() {
        self.startWritingTask(withName: "Task 1")
        self.startReadingTask(withName: "Task 2")
        self.startReadingTask(withName: "Task 3")
        self.startRemovingTask(withName: "Task 4")
    }
    private func startWritingTask(withName name: String) {
        queue(forTaskName: name).async {
            let chars: [Character] = ["A", "B", "C"]
            var i = 0
            while true {
                self.resourceHolder.append(char: chars[i], fromTask: name)
                i = (i + 1) % chars.count
            }
        }
    }
    private func startRemovingTask(withName name: String) {
        queue(forTaskName: name).async {
            while true {
                _ = self.resourceHolder.dropFirst(fromTask: name)
            }
        }
    }
    private func startReadingTask(withName name: String) {
        queue(forTaskName: name).async {
            while true {
                _ = self.resourceHolder.first(fromTask: name)
            }
        }
    }
    private func queue(forTaskName name: String) -> DispatchQueue {
        return DispatchQueue(label: "com.test.TasksExecutor.\(name)")
    }
}
