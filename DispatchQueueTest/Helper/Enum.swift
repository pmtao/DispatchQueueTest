//
//  Enum.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-24.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

/// 队列类型
enum DispatchQueueType: String {
    case serial
    case concurrent
    case main
    case global
}

/// 任务类型
enum DispatchTaskType: String {
    case sync
    case async
}
