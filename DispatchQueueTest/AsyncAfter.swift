//
//  AsyncAfter.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-13.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

/// 延迟将任务加入队列
class AsyncAfter {
    
    typealias ExchangableTask = (_ newDelayTime: TimeInterval?,
        _ anotherTask:@escaping (() -> ())
        ) -> Void
    
    /// 延迟执行闭包
    static func dispatch_later(_ time: TimeInterval, block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    /// 延迟执行一个任务，并支持在实际执行前替换为新的任务，并设定新的延迟时间。
    /// 代码改编自：[Swifter - Swift 开发者必备 Tips - GCD 和延时调用](https://store.objccn.io/products/swifter-tips)
    ///
    /// - Parameters:
    ///   - time: 延迟时间
    ///   - yourTask: 要执行的任务
    /// - Returns: 可替换原任务的闭包
    static func delay(_ time: TimeInterval, yourTask: @escaping ()->()) -> ExchangableTask {
        var exchangingTask: (() -> ())? // 备用替代任务
        var newDelayTime: TimeInterval? // 新的延迟时间
        
        let finalClosure = { () -> Void in
            if exchangingTask == nil {
                DispatchQueue.main.async(execute: yourTask)
            } else {
                if newDelayTime == nil {
                    DispatchQueue.main.async {
                        print("任务已更改，现在是：\(Date())")
                        exchangingTask!()
                    }
                }
                print("原任务取消了，现在是：\(Date())")
            }
        }
        
        dispatch_later(time) { finalClosure() }
        
        let exchangableTask: ExchangableTask =
        { delayTime, anotherTask in
            exchangingTask = anotherTask
            newDelayTime = delayTime
            
            if delayTime != nil {
                self.dispatch_later(delayTime!) {
                    anotherTask()
                    print("任务已更改，现在是：\(Date())")
                }
            }
        }
        
        return exchangableTask
    }
}
