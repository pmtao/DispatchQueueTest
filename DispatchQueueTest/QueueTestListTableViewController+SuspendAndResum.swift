//
//  QueueTestListTableViewController+SuspendAndResum.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-22.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

extension QueueTestListTableViewController {
    // 挂起
    @IBAction func suspendButtonTapped(_ sender: Any) {
        suspendAndResum.suspendQueue()
    }
    
    // 唤醒
    @IBAction func resumeButtonTapped(_ sender: Any) {
        suspendAndResum.resumeQueue()
    }
}
