//
//  DispatchWorkItem.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-4-8.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

extension QueueTestListTableViewController {
    // MARK: ---------控件动作响应
    
    /// 任务对象测试
    @IBAction func dispatchWorkItemTestButtonTapped(_ sender: Any) {
        DispatchWorkItemTest.workItemTest()
    }
    
}

/// 任务对象测试类
class DispatchWorkItemTest {
    static func workItemTest() {
        var value = 10
        let workItem = DispatchWorkItem {
            print("workItem running start.--->")
            value += 5
            print("value = ", value)
            print("--->workItem running end.")
        }
        let queue = DispatchQueue.global()
        
        queue.async(execute: workItem)
        
        queue.async {
            print("异步执行 workItem")
            workItem.perform()
            print("任务2取消了吗：\(workItem.isCancelled)")
            workItem.cancel()
            print("异步执行 workItem end")
        }
        
        workItem.notify(queue: queue) {
            print("notify 1: value = ", value)
        }
    
        workItem.notify(queue: queue) {
            print("notify 2: value = ", value)
        }
        
        workItem.notify(queue: queue) {
            print("notify 3: value = ", value)
        }
        
        queue.async {
            print("异步执行2 workItem")
            Thread.sleep(forTimeInterval: 2)
            print("任务3取消了吗：\(workItem.isCancelled)")
            workItem.perform()
            print("异步执行2 workItem end")
        }
    }

}
