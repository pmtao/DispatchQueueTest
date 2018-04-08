//
//  QueueTestListTableViewController+DispatchSource.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-12.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

extension QueueTestListTableViewController {
    
    // MARK: ---------控件动作响应
    
    /// 文件监听
    @IBAction func changeFileButtonTapped(_ sender: Any) {
        dispatchSourceTest.changeFile()
    }
}
