//
//  SuspendAndResum.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-22.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

/// 挂起、唤醒测试类
class SuspendAndResum {
    let createQueueWithTask = CreateQueueWithTask()
    var concurrentQueue: DispatchQueue {
        return createQueueWithTask.concurrentQueue
    }
    var suspendCount = 0 // 队列挂起的次数
    
    // MARK: ---------队列方法------------
    
    /// 挂起测试
    func suspendQueue() {
        createQueueWithTask.printCurrentThread(with: "start test")
        concurrentQueue.async {
            self.createQueueWithTask.printCurrentThread(with: "concurrentQueue async task1")
        }
        concurrentQueue.async {
            self.createQueueWithTask.printCurrentThread(with: "concurrentQueue async task2")
        }
        
        // 通过栅栏挂起任务
        let barrierTask = DispatchWorkItem(flags: .barrier) {
            self.safeSuspend(self.concurrentQueue)
        }
        concurrentQueue.async(execute: barrierTask)
        
        concurrentQueue.async {
            self.createQueueWithTask.printCurrentThread(with: "concurrentQueue async task3")
        }
        
        concurrentQueue.async {
            self.createQueueWithTask.printCurrentThread(with: "concurrentQueue async task4")
        }
        concurrentQueue.async {
            self.createQueueWithTask.printCurrentThread(with: "concurrentQueue async task5")
        }
        createQueueWithTask.printCurrentThread(with: "end test")
    }
    
    /// 唤醒测试
    func resumeQueue() {
        self.safeResume(self.concurrentQueue)
    }
    
    /// 安全的挂失操作
    func safeSuspend(_ queue: DispatchQueue) {
        suspendCount += 1
        queue.suspend()
        print("任务挂起了")
    }
    
    /// 安全的唤醒操作
    func safeResume(_ queue: DispatchQueue) {
        if suspendCount == 1 {
            queue.resume()
            suspendCount = 0
            print("任务唤醒了")
        } else if suspendCount < 1 {
            print("唤醒的次数过多")
        } else {
            queue.resume()
            suspendCount -= 1
            print("唤醒的次数不够，还需要 \(suspendCount) 次唤醒。")
        }
    }
    
}
