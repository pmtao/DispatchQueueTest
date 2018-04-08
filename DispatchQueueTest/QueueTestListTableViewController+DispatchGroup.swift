//
//  QueueTestListTableViewController+DispatchGroup.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-12.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

extension QueueTestListTableViewController {
    
    // MARK: ---------控件动作响应
    
    /// 创建任务组，并以常规方式添加任务。
    @IBAction func creatTaskGroupButtonTapped(_ sender: Any) {
        let groupTest = DispatchGroupTest()
        let group = groupTest.creatAGroup()
        let queue = DispatchQueue.global()
        
        groupTest.addTaskNormally(to: group, in: queue)
        groupTest.notifyMainQueue(from: group)
    }
    
    /// 添加系统任务至任务组
    @IBAction func addSystemTaskToGroupButtonTapped(_ sender: Any) {
        let groupTest = DispatchGroupTest()
        let group = groupTest.creatAGroup()
        
        let book1ID = "5416832" // https://book.douban.com/subject/5416832/
        let book2ID = "1046265" // https://book.douban.com/subject/1046265/
        
        // 根据书籍 ID 下载一本豆瓣书籍的标签集，并返回一个打印前 5 个标签的任务闭包。
        let printBookTagBlock1 = groupTest.getBookTag(book1ID, in: group)
        let printBookTagBlock2 = groupTest.getBookTag(book2ID, in: group)
        
        // 下载任务完成后，通知主线程完成打印任务。
        groupTest.notifyMainQueue(from: group) {
            printBookTagBlock1("辛亥：摇晃的中国")
            printBookTagBlock2("挪威的森林")
        }
    }
    
    /// 添加系统及自定义任务至任务组
    @IBAction func addSystemAndCustomTaskToGroupButtonTapped(_ sender: Any) {
        let groupTest = DispatchGroupTest()
        let group = groupTest.creatAGroup()
        let queue = DispatchQueue.global()
        
        let book1ID = "5416832" // https://book.douban.com/subject/5416832/
        let book2ID = "1046265" // https://book.douban.com/subject/1046265/
        
        // 根据书籍 ID 下载一本豆瓣书籍的标签集，并返回一个打印前 5 个标签的任务闭包。
        let printBookTagBlock1 = groupTest.getBookTag(book1ID, in: group)
        groupTest.wait(group: group, after: 0.01) // 等待前面的任务执行不超过 0.01 秒
        printBookTagBlock1("辛亥：摇晃的中国") // 等待后进行打印
        
        // 创建常规的异步任务，并加入任务组中。
        groupTest.addTaskNormally(to: group, in: queue)
        // 再次进行下载任务
        let printBookTagBlock2 = groupTest.getBookTag(book2ID, in: group)
        
        // 全部任务完成后，通知主线程完成打印任务。
        groupTest.notifyMainQueue(from: group) {
            printBookTagBlock2("挪威的森林")
        }
    }
}
