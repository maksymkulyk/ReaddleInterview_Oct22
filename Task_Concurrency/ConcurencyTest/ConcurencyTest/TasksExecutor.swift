//
//  TasksExecutor.swift
//  ConcurencyTest
//
//  Created by Sviatoslav Yakymiv on 22.10.2020.
//

import Foundation

class TasksExecutor {
    let resourceHolder = ResourceHolder()
    private let queue1 = TasksExecutor.queue(forTaskName: "Task 1")
    private let queue2 = TasksExecutor.queue(forTaskName: "Task 2")
    private let queue3 = TasksExecutor.queue(forTaskName: "Task 3")
    private let queue4 = TasksExecutor.queue(forTaskName: "Task 4")
    
    private let chars: [Character] = ["A", "B", "C"]
    
    func start(with index: Int = 0) {
        queue1.async {
            self.resourceHolder.append(char: self.chars[index], fromTask: "Task 1")
            let group = DispatchGroup()
            self.read(on: self.queue2, in: group, taskName: "Task 2")
            self.read(on: self.queue3, in: group, taskName: "Task 3")
            group.notify(queue: self.queue4) {
                _ = self.resourceHolder.dropFirst(fromTask: "Task 4")
                self.start(with: (index + 1) % self.chars.count)
            }
        }
    }
    
    private func read(on queue: DispatchQueue, in group: DispatchGroup, taskName: String) {
        group.enter()
        queue.async {
            _ = self.resourceHolder.first(fromTask: taskName)
            group.leave()
        }
    }
    
    private static func queue(forTaskName name: String) -> DispatchQueue {
        return DispatchQueue(label: "com.test.TasksExecutor.\(name)")
    }
}
