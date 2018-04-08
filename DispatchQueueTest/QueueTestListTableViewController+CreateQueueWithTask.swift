//
//  QueueTestListTableViewController+createQueueWithTask.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-15.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

extension QueueTestListTableViewController {
    // 同步任务
    @IBAction func syncTaskButton1Tapped(_ sender: Any) {
        createQueueWithTask.testSyncTaskInSerialQueue()
    }
    
    @IBAction func syncTaskButton2Tapped(_ sender: Any) {
        createQueueWithTask.testSyncTaskNestedInSameSerialQueue()
    }
    
    @IBAction func syncTaskButton3Tapped(_ sender: Any) {
        createQueueWithTask.testSyncTaskNestedInSameConcurrentQueue()
    }
    
    @IBAction func syncTaskButton4Tapped(_ sender: Any) {
        createQueueWithTask.testSyncTaskNestedInOtherSerialQueue()
    }
    
    // 异步任务
    @IBAction func asyncTaskButton1Tapped(_ sender: Any) {
        createQueueWithTask.testAsyncTaskInConcurrentQueue()
    }
    
    @IBAction func asyncTaskButton2Tapped(_ sender: Any) {
        createQueueWithTask.testAsyncTaskInSerialQueue()
    }
    
    @IBAction func asyncTaskButton3Tapped(_ sender: Any) {
        createQueueWithTask.testAsyncTaskNestedInSameSerialQueue()
    }
    
    // 特殊任务
    @IBAction func specialTaskButton1Tapped(_ sender: Any) {
        createQueueWithTask.barrierTask()
    }
    
    @IBAction func specialTaskButton2Tapped(_ sender: Any) {
        createQueueWithTask.concurrentPerformTask()
    }
}
