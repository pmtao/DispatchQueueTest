//
//  QueueTestListTableViewController+AsyncAfter.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-13.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

extension QueueTestListTableViewController {
    // MARK: ---------控件动作响应
    
    /// 简单延迟任务
    @IBAction func ayncAfterButtonTapped(_ sender: Any) {
        print("现在是：\(Date())")
        AsyncAfter.dispatch_later(2) {
            print("打个电话 at: \(Date())") // 将在 2 秒后执行
        }
    }
    
    /// 延迟任务，在执行前临时取消任务。
    @IBAction func ayncAfterCancelButtonTapped(_ sender: Any) {
        print("现在是：\(Date())")
        let task = AsyncAfter.delay(2) {
            print("打个电话 at: \(Date())")
        }
        
        // 立即取消任务
        task(0) {}
    }
    
    /// 延迟任务，在执行前临时替换为新的任务。
    @IBAction func ayncAfterNewTaskButtonTapped(_ sender: Any) {
        print("现在是：\(Date())")
        let task = AsyncAfter.delay(2) {
            print("打个电话 at: \(Date())")
        }
        
        // 3 秒后改为执行一个新任务
        task(3) {
            print("吃了个披萨，现在是：\(Date())")
        }
    }
}
