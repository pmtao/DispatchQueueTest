//
//  DispatchSemaphore.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-4-3.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

extension QueueTestListTableViewController {
    // MARK: ---------控件动作响应
    
    /// 信号量测试
    @IBAction func semaphoreTestButtonTapped(_ sender: Any) {
        DispatchSemaphoreTest.limitTaskNumber()
    }
    
}

/// 信号量测试类
class DispatchSemaphoreTest {
    
    /// 限制同时运行的任务数
    static func limitTaskNumber() {
        let queue = DispatchQueue(
            label: "com.sinkingsoul.DispatchQueueTest.concurrentQueue",
            attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 2) // 设置数量为 2 的信号量
        
        semaphore.wait()
        queue.async {
            task(index: 1)
            semaphore.signal()
        }
        
        semaphore.wait()
        queue.async {
            task(index: 2)
            semaphore.signal()
        }
        
        semaphore.wait()
        queue.async {
            task(index: 3)
            semaphore.signal()
        }
    }
    
    /// 任务
    static func task(index: Int) {
        print("Begin task \(index) --->")
        Thread.sleep(forTimeInterval: 2)
        print("Sleep for 2 seconds in task \(index).")
        print("--->End task \(index).")
    }

}
