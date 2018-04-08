//
//  DispatchGroup.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-12.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

/// 任务组测试类，验证任务组相关的特性。
class DispatchGroupTest {
    // MARK: ---------任务组操作方法
    
    /// 创建一个新任务组
    func creatAGroup() -> DispatchGroup{
        return DispatchGroup()
    }
    
    /// 通知主线程任务组中的任务都完成
    func notifyMainQueue(from group: DispatchGroup, block: (() -> ())? = nil) {
        group.notify(queue: DispatchQueue.main) {
            print("任务组通知：任务都完成了。\n")
            if block != nil {
                block!()
            }
        }
    }
    
    /// 最多等待任务组中的任务执行 n 秒钟
    func wait(group: DispatchGroup, after time: TimeInterval) {
        let delayWalltime = DispatchWallTime.now() + time
        _ = group.wait(wallTimeout: delayWalltime)
    }
    
    // MARK: ---------添加至任务组的测试任务
    
    /// 创建常规的异步任务，并加入任务组中。
    func addTaskNormally(to group: DispatchGroup, in queue: DispatchQueue) {
        queue.async(group: group) {
            print("任务：喝一杯牛奶\n")
        }
        
        queue.async(group: group) {
            print("任务：吃一个苹果\n")
        }
    }
    
    /// 根据书籍 ID 下载一本豆瓣书籍的标签集，并返回一个打印前 5 个标签的任务闭包。此任务将加入指定的任务组中执行。
    func getBookTag(_ bookID: String, in taskGroup: DispatchGroup) -> (String)->() {
        let url = "https://api.douban.com/v2/book/\(bookID)/tags"
        var printBookTagBlock: (_ bookName: String)->() = {_ in print("还未收到返回的书籍信息") }
        
        // 创建网络信息获取成功后的任务
        let completion = {(data: Data?, response: URLResponse?, error: Error?) in
            printBookTagBlock = { bookName in
                if error != nil{
                    print(error.debugDescription)
                } else {
                    guard let data = data else { return }
                    print("书籍 《\(bookName)》的标签信息如下：")
                    BookTags.printBookPreviousFiveTags(data)
                }
            }
        }
        
        print("任务：下载书籍 \(bookID) 的信息 \(Date())")
        // 获取网络信息
        httpGet(url: url, in: taskGroup, completion: completion)
        
        let returnBlock: (String)->() = { bookName in
            printBookTagBlock(bookName)
        }
        return returnBlock
    }
    
}
