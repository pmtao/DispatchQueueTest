//
//  QueueTestListTableViewController+DispatchIO.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-4-3.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

extension QueueTestListTableViewController {
    
    // MARK: ---------控件动作响应
    
    /// 单队列合并文件
    @IBAction func combineFileWithOneQueueButtonTapped(_ sender: Any) {
        DispatchIOTest.combineFileWithOneQueue()
    }
    
    /// 双队列合并文件
    @IBAction func combineFileWithMoreQueuesButtonTapped(_ sender: Any) {
        DispatchIOTest.combineFileWithMoreQueues()
    }
    
    /// 通过 Data 合并文件
    @IBAction func combineFileUsingDataButtonTapped(_ sender: Any) {
        DispatchIOTest.combineFileUsingData()
    }
    
    /// 通过 DispatchData 合并文件
    @IBAction func combineFileWithDispatchDataButtonTapped(_ sender: Any) {
        DispatchIOTest.combineFileWithDispatchData()
    }
}
