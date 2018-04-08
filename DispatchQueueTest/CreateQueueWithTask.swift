//
//  CreateQueueWithTask.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-15.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

class CreateQueueWithTask {
    
    // MARK: ---------队列属性------------
    
    let serialQueue = DispatchQueue(
        label: "com.sinkingsoul.DispatchQueueTest.serialQueue")
    let concurrentQueue = DispatchQueue(
        label: "com.sinkingsoul.DispatchQueueTest.concurrentQueue",
        attributes: .concurrent)
    let mainQueue = DispatchQueue.main
    let globalQueue = DispatchQueue.global()
    
    let serialQueueKey = DispatchSpecificKey<String>()
    let concurrentQueueKey = DispatchSpecificKey<String>()
    let mainQueueKey = DispatchSpecificKey<String>()
    let globalQueueKey = DispatchSpecificKey<String>()
    
    // MARK: ---------队列方法------------
    
    init() {
        serialQueue.setSpecific(key: serialQueueKey, value: DispatchQueueType.serial.rawValue)
        concurrentQueue.setSpecific(key: concurrentQueueKey, value: DispatchQueueType.concurrent.rawValue)
        mainQueue.setSpecific(key: mainQueueKey, value: DispatchQueueType.main.rawValue)
        globalQueue.setSpecific(key: globalQueueKey, value: DispatchQueueType.global.rawValue)
    }
    
    /// 向队列中提交任务
    ///
    /// - Parameters:
    ///   - queueType: 队列类型
    ///   - taskType: 任务类型
    func submitToQueue(_ queueType: DispatchQueueType, with taskType: DispatchTaskType) {
        print("\nCurrent thread: \(Thread.current)\n")

        switch queueType {
        case .serial:
            switch taskType {
            case .sync:
                submitSyncTask(to: serialQueue)
            case .async:
                submitAsyncTask(to: serialQueue)
            }
        case .concurrent:
            switch taskType {
            case .sync:
                submitSyncTask(to: concurrentQueue)
            case .async:
                submitAsyncTask(to: concurrentQueue)
            }
        case .main:
            switch taskType {
            case .sync:
                submitSyncTask(to: mainQueue)
            case .async:
                submitAsyncTask(to: mainQueue)
            }
        case .global:
            return
        }
    }

    /// 提交同步任务
    func submitSyncTask(to queue: DispatchQueue) {
        print("\nStart queue - \(queue) at thread: \(Thread.current)\n")

        queue.sync {
            task(type: .sync, of: 1)
        }

        print("\ngoto task 2.\n")
        queue.sync {
            task(type: .sync, of: 2)
        }

        print("\ngoto task 3.\n")
        queue.sync {
            task(type: .sync, of: 3)
        }

        print("End queue.")
    }

    /// 提交异步任务
    func submitAsyncTask(to queue: DispatchQueue) {
        print("\nStart \(queue) queue at thread: \(Thread.current)\n")

        queue.async {
            self.task(type: .async, of: 1)
        }
        print("\ngoto task 2.\n")

        queue.async(execute: {
            self.task(type: .async, of: 2)
        })
        print("\ngoto task 3.\n")

        queue.async {
            self.task(type: .async, of: 3)
        }
        print("\nEnd queue.\n")
    }
    
//    /// 测试指定队列类型中嵌套的同步任务
//    func testNestedSyncTaskInQueueType(_ queueType: DispatchQueueType, key: DispatchSpecificKey<String>) {
//        let queue: DispatchQueue
//        switch queueType {
//        case .serial:
//            queue = serialQueue
//        case .concurrent:
//            queue = concurrentQueue
//        case .global:
//            queue = globalQueue
//        case .main:
//            queue = mainQueue
//        }
//
//        self.printCurrentThread(with: "testHybridTaskInQueueType: \(queueType.rawValue)")
//        queue.sync {
//            queue.async {
//                print("\n\(queueType.rawValue) nest async task--->")
//                self.printCurrentThread(with: "\(queueType.rawValue) nest async task")
//                self.testIsTaskInQueue(queueType, key: key)
//
////                    queue.sync {
////                        print("\n\(queueType.rawValue) nest nest sync task--->")
////                        self.printCurrentThread(with: "\(queueType.rawValue) nest nest sync task")
////                        self.testIsSameQueue(queueType: queueType, key: key)
////                        print("--->\(queueType.rawValue) nest nest sync task\n")
////                    }
//                queue.async {
//                    print("\n\(queueType.rawValue) nest async task2--->")
//                    self.printCurrentThread(with: "\(queueType.rawValue) nest async task2")
//                    self.testIsTaskInQueue(queueType, key: key)
//                    print("--->\(queueType.rawValue) nest async task2\n")
//                }
//
//                print("--->\(queueType.rawValue) nest async task\n")
//            }
//
//            print("\n\(queueType.rawValue) sync task--->")
//            self.printCurrentThread(with: "\(queueType.rawValue) sync task")
//            self.testIsTaskInQueue(queueType, key: key)
//            print("--->\(queueType.rawValue) sync task\n")
//        }
//
//
//    }
//
//    /// 测试指定队列类型中嵌套的同步任务
//    func v2testNestedSyncTaskInQueueType(_ queueType: DispatchQueueType, key: DispatchSpecificKey<String>) {
//        let queue: DispatchQueue
//        switch queueType {
//        case .serial:
//            queue = serialQueue
//        case .concurrent:
//            queue = concurrentQueue
//        case .global:
//            queue = globalQueue
//        case .main:
//            queue = mainQueue
//        }
//
//        let serialQueue2 = DispatchQueue(
//            label: "com.sinkingsoul.DispatchQueueTest.serialQueue2")
//
//        self.printCurrentThread(with: "testHybridTaskInQueueType: \(queueType.rawValue)")
//
//        serialQueue2.sync {
//            print("\nserialQueue2 sync task1--->")
//            self.printCurrentThread(with: "serialQueue2 sync task1")
//            print("--->serialQueue2 sync task1\n")
//        }
//
//        queue.async {
//            print("\n\(queueType.rawValue) async task--->")
//            self.printCurrentThread(with: "\(queueType.rawValue) async task")
//
//            serialQueue2.sync {
//                print("\nserialQueue2 sync task--->")
//                self.printCurrentThread(with: "serialQueue2 sync task")
//                self.testIsTaskInQueue(queueType, key: key)
//                print("--->serialQueue2 sync task\n")
//            }
//
//            self.testIsTaskInQueue(queueType, key: key)
//            print("--->\(queueType.rawValue) async task\n")
//        }
//    }
//
//    /// 测试串行队列和主队列的关系
//    func testSerialAndMainQueue() {
//        self.printCurrentThread(with: "start test")
//        testIsTaskInQueue(.main, key: self.mainQueueKey)
//        self.mainQueue.async {
//            self.printCurrentThread(with: "main queue async task")
//            print("main queue async task--->")
//
//            self.mainQueue.async {
//                self.printCurrentThread(with: "main queue async task2")
//            }
//
//            print("<---main queue async task")
//        }
//
//        serialQueue.sync {
//            print("serial queue sync task--->")
//            self.printCurrentThread(with: "serial queue sync task")
//            testIsTaskInQueue(.main, key: self.mainQueueKey)
//            self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
//            print("<---serial queue sync task")
//        }
//
//        globalQueue.async {
//            print("globalQueue async task--->")
//            self.testIsTaskInQueue(.global, key: self.globalQueueKey)
//            self.serialQueue.sync {
//                print("serial queue sync task--->")
//                self.printCurrentThread(with: "serial queue sync task")
//                self.testIsTaskInQueue(.main, key: self.mainQueueKey)
//                self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
//                self.testIsTaskInQueue(.global, key: self.globalQueueKey)
//                print("<---serial queue sync task")
//            }
//            print("<---globalQueue async task")
//        }
//    }
    
    // MARK: ---------同步任务测试------------
    
    /// 串行队列中新增同步任务
    func testSyncTaskInSerialQueue() {
        printCurrentThread(with: "start test")
        serialQueue.sync {
            print("\nserialQueue sync task--->")
            self.printCurrentThread(with: "serialQueue sync task")
            self.testIsTaskInQueue(.serial, key: serialQueueKey)
            print("--->serialQueue sync task\n")
        }
        printCurrentThread(with: "end test")
    }
    
    /// 并行队列中新增同步任务
    func testSyncTaskInConcurrentQueue() {
        printCurrentThread(with: "start test")
        concurrentQueue.sync {
            print("\nconcurrentQueue sync task--->")
            self.printCurrentThread(with: "concurrentQueue sync task")
            self.testIsTaskInQueue(.concurrent, key: concurrentQueueKey)
            print("--->concurrentQueue sync task\n")
        }
        printCurrentThread(with: "end test")
    }
    
    /// 串行队列任务中嵌套本队列的同步任务
    func testSyncTaskNestedInSameSerialQueue() {
        printCurrentThread(with: "start test")
        serialQueue.async {
            print("\nserialQueue async task--->")
            self.printCurrentThread(with: "serialQueue async task")
            self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
            
            self.serialQueue.sync {
                print("\nserialQueue sync task--->")
                self.printCurrentThread(with: "serialQueue sync task")
                self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
                print("--->serialQueue sync task\n")
            }
            
            print("--->serialQueue async task\n")
        }
        printCurrentThread(with: "end test")
    }
    
    /// 并行队列任务中嵌套本队列的同步任务
    func testSyncTaskNestedInSameConcurrentQueue() {
        printCurrentThread(with: "start test")
        concurrentQueue.async {
            print("\nconcurrentQueue async task--->")
            self.printCurrentThread(with: "concurrentQueue async task")
            self.testIsTaskInQueue(.concurrent, key: self.concurrentQueueKey)
            
            self.concurrentQueue.sync {
                print("\nconcurrentQueue sync task--->")
                self.printCurrentThread(with: "concurrentQueue sync task")
                self.testIsTaskInQueue(.concurrent, key: self.concurrentQueueKey)
                print("--->concurrentQueue sync task\n")
            }
            
            print("--->concurrentQueue async task\n")
        }
        printCurrentThread(with: "end test")
    }
    
    /// 串行队列中嵌套其他队列的同步任务
    func testSyncTaskNestedInOtherSerialQueue() {
        // 创新另一个串行队列
        let serialQueue2 = DispatchQueue(
            label: "com.sinkingsoul.DispatchQueueTest.serialQueue2")
        let serialQueueKey2 = DispatchSpecificKey<String>()
        serialQueue2.setSpecific(key: serialQueueKey2, value: "serial2")
        
        self.printCurrentThread(with: "start test")
        serialQueue.sync {
            print("\nserialQueue sync task--->")
            self.printCurrentThread(with: "nserialQueue sync task")
            self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
            
            serialQueue2.sync {
                print("\nserialQueue2 sync task--->")
                self.printCurrentThread(with: "serialQueue2 sync task")
                self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
                
                let value = DispatchQueue.getSpecific(key: serialQueueKey2)
                let opnValue: String? = "serial2"
                print("Is task in serialQueue2: \(value == opnValue)")
                print("--->serialQueue2 sync task\n")
            }
            
            print("--->serialQueue sync task\n")
        }
    }
    
    // MARK: ---------异步任务测试------------
    
    /// 并行队列中新增异步任务
    func testAsyncTaskInConcurrentQueue() {
        printCurrentThread(with: "start test")
        concurrentQueue.async {
            print("\nconcurrentQueue async task--->")
            self.printCurrentThread(with: "concurrentQueue async task")
            self.testIsTaskInQueue(.concurrent, key: self.concurrentQueueKey)
            print("--->concurrentQueue async task\n")
        }
        printCurrentThread(with: "end test")
    }
    
    /// 串行队列中新增异步任务
    func testAsyncTaskInSerialQueue() {
        printCurrentThread(with: "start test")
        serialQueue.async {
            print("\nserialQueue async task--->")
            self.printCurrentThread(with: "serialQueue async task")
            self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
            print("--->serialQueue async task\n")
        }
        printCurrentThread(with: "end test")
    }
    
    /// 串行队列任务中嵌套本队列的异步任务
    func testAsyncTaskNestedInSameSerialQueue() {
        printCurrentThread(with: "start test")
        serialQueue.sync {
            print("\nserialQueue sync task--->")
            self.printCurrentThread(with: "serialQueue sync task")
            self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
            
            self.serialQueue.async {
                print("\nserialQueue async task--->")
                self.printCurrentThread(with: "serialQueue async task")
                self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
                print("--->serialQueue async task\n")
            }
            
            print("--->serialQueue sync task\n")
        }
        printCurrentThread(with: "end test")
    }
    
    // MARK: ---------特殊任务------------
    
    /// 栅栏任务
    func barrierTask() {
        let queue = concurrentQueue
        let barrierTask = DispatchWorkItem(flags: .barrier) {
            print("\nbarrierTask--->")
            self.printCurrentThread(with: "barrierTask")
            print("--->barrierTask\n")
        }
        
        printCurrentThread(with: "start test")
        
        queue.async {
            print("\nasync task1--->")
            self.printCurrentThread(with: "async task1")
            print("--->async task1\n")
        }
        queue.async {
            print("\nasync task2--->")
            self.printCurrentThread(with: "async task2")
            print("--->async task2\n")
        }
        queue.async {
            print("\nasync task3--->")
            self.printCurrentThread(with: "async task3")
            print("--->async task3\n")
        }
        
        queue.async(execute: barrierTask) // 栅栏任务
        
        queue.async {
            print("\nasync task4--->")
            self.printCurrentThread(with: "async task4")
            print("--->async task4\n")
        }
        queue.async {
            print("\nasync task5--->")
            self.printCurrentThread(with: "async task5")
            print("--->async task5\n")
        }
        queue.async {
            print("\nasync task6--->")
            self.printCurrentThread(with: "async task6")
            print("--->async task6\n")
        }
        printCurrentThread(with: "end test")
    }
    
    /// 迭代任务
    func concurrentPerformTask() {
        printCurrentThread(with: "start test")
        
        /// 判断一个数是否能被另一个数整除
        func isDividedExactlyBy(_ divisor: Int, with number: Int) -> Bool {
            return number % divisor == 0
        }
        
        let array = Array(1...100)
        var result: [Int] = []
        
        globalQueue.async {
            //通过concurrentPerform，循环变量数组
            print("concurrentPerform task start--->")
            DispatchQueue.concurrentPerform(iterations: 100) {(index) -> Void in
                if isDividedExactlyBy(13, with: array[index]) {
                    self.printCurrentThread(with: "find a match: \(array[index])")
                    self.mainQueue.async {
                        result.append(array[index])
                    }
                }
            }
            print("--->concurrentPerform task over")
            //执行完毕，主线程更新结果。
            DispatchQueue.main.sync {
                print("back to main thread")
                print("result: find \(result.count) number - \(result)")
            }
        }
        printCurrentThread(with: "end test")
    }
    
    // MARK: ---------设置目标队列------------
    
    /// 设置目标队列
    func setTargetQueue() {
        // 创建一个串行队列
        let mySerialDispatchQueue = DispatchQueue(label: "mySerialDispatchQueue", attributes: .initiallyInactive)
        
        // 获取某个优先级的 global queue
        let globalDispatchQueueBackground = DispatchQueue.global(qos: .background)
        
        
        // 通过 setTarget 来改变 mySerialDispatchQueue 的优先级
        mySerialDispatchQueue.setTarget(queue: globalDispatchQueueBackground)
        submitAsyncTask(to: mySerialDispatchQueue)
        mySerialDispatchQueue.activate()
    }
    
    // MARK: ---------辅助方法------------
    
    /// 任务
    func task(type: DispatchTaskType, of index: Int) {
        print("----------->Begin \(type.rawValue) task \(index) at thread: \(Thread.current) \n")
        
        printTimeMark(of: "\nTask \(index) start")
        for i in 0..<1000 {
            _ = Array(0..<1000).map {
                $0 + i
            }
        }
        printTimeMark(of: "\nTask \(index) end  ")
        print("\n<-----------\n")
    }
    
    
    
    /// 打印时间戳
    func printTimeMark(of des: String) {
        print("\(des): \(Date())")
    }
    
    /// 打印当前线程
    func printCurrentThread(with des: String, _ terminator: String = "") {
        print("\(des) at thread: \(Thread.current), this is \(Thread.isMainThread ? "" : "not ")main thread\(terminator)")
    }
    
    /// 测试任务是否在指定队列中
    func testIsTaskInQueue(_ queueType: DispatchQueueType, key: DispatchSpecificKey<String>) {
        let value = DispatchQueue.getSpecific(key: key)
        let optOriginalValue: String? = queueType.rawValue
        print("Is task in \(queueType.rawValue) queue: \(value == optOriginalValue)")
    }
}
