//
//  DispatchIO.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-28.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

/// 注意：本类的所有测试方法建议使用模拟器，更方便读写 Mac 本地文件。
class DispatchIOTest {
    
    /// 利用很小的内存空间及同一队列读写方式合并文件。
    /// 代码改编自：https://stackoverflow.com/a/24216699
    static func combineFileWithOneQueue() {
        let files: NSArray = ["/Users/xxx/Downloads/gcd.mp4.zip.001",
                              "/Users/xxx/Downloads/gcd.mp4.zip.002"]
        let outFile: NSString = "/Users/xxx/Downloads/gcd.mp4.zip"
        let ioQueue = DispatchQueue(
            label: "com.sinkingsoul.DispatchQueueTest.serialQueue")
        let queueGroup = DispatchGroup()
        
        let ioWriteCleanupHandler: (Int32) -> Void = { errorNumber in
            print("写入文件完成 @\(Date())。")
        }
        
        let ioReadCleanupHandler: (Int32) -> Void = { errorNumber in
            print("读取文件完成。")
        }
        
        print("开始操作 @\(Date()).")
        
        let ioWrite = DispatchIO(type: .stream,
                                 path: outFile.utf8String!,
                                 oflag: (O_RDWR | O_CREAT | O_APPEND),
                                 mode: (S_IRWXU | S_IRWXG),
                                 queue: ioQueue,
                                 cleanupHandler: ioWriteCleanupHandler)
        ioWrite?.setLimit(highWater: 1024*1024)
        
        files.enumerateObjects { fileName, index, stop in
            if stop.pointee.boolValue {
                return
            }
            queueGroup.enter()
            
            let ioRead = DispatchIO(type: .stream,
                                    path: (fileName as! NSString).utf8String!,
                                    oflag: O_RDONLY,
                                    mode: 0,
                                    queue: ioQueue,
                                    cleanupHandler: ioReadCleanupHandler)
            ioRead?.setLimit(highWater: 1024*1024)
            
            print("开始读取文件: \(fileName) 的数据")
            
            ioRead?.read(offset: 0, length: Int.max, queue: ioQueue) { doneReading, data, error in
//                print("当前读线程：\(Thread.current)--->")
                if (error > 0 || stop.pointee.boolValue) {
                    print("读取发生错误了，错误码：\(error)")
                    ioWrite?.close()
                    stop.pointee = true
                    return
                }
                
                if (data != nil) {
                    let bytesRead: size_t = data!.count
                    if (bytesRead > 0) {
                        queueGroup.enter()
                        ioWrite?.write(offset: 0, data: data!, queue: ioQueue) {
                            doneWriting, data, error in
//                            print("当前写线程：\(Thread.current)--->")
                            if (error > 0 || stop.pointee.boolValue) {
                                print("写入发生错误了，错误码：\(error)")
                                ioRead?.close()
                                stop.pointee = true
                                queueGroup.leave()
                                return
                            }
                            if doneWriting {
                                queueGroup.leave()
                            }
//                            print("--->当前写线程：\(Thread.current)")
                        }
                    }
                }
                
                if (doneReading) {
                    ioRead?.close()
                    if (files.count == (index+1)) {
                        ioWrite?.close()
                    }
                    queueGroup.leave()
                }
//                print("--->当前读线程：\(Thread.current)")
            }
            _ = queueGroup.wait(timeout: .distantFuture)
        }
    }
    
    /// 利用很小的内存空间及双队列读写方式合并文件
    static func combineFileWithMoreQueues() {
        let files: NSArray = ["/Users/xxx/Downloads/gcd.mp4.zip.001",
                              "/Users/xxx/Downloads/gcd.mp4.zip.002"]
//        真机运行时可使用以下地址（需手动将文件放入工程中）
//        let files: NSArray = [Bundle.main.path(forResource: "gcd.mp4.zip", ofType: "001")!,
//                              Bundle.main.path(forResource: "gcd.mp4.zip", ofType: "002")!]
        var filesSize = files.map {
            return (try! FileManager.default.attributesOfItem(atPath: $0 as! String)[FileAttributeKey.size] as! NSNumber).int64Value
        }
        let outFile: NSString = "/Users/xxx/Downloads/gcd.mp4.zip"
//        真机运行时可使用以下地址（需手动将文件放入工程中）
//        let outFile: NSString = "\(NSTemporaryDirectory())/gcd.mp4.zip" as NSString
        
        // 每个分块文件各一个读、写队列
        let ioReadQueue1 = DispatchQueue(
            label: "com.sinkingsoul.DispatchQueueTest.serialQueue1")
        let ioReadQueue2 = DispatchQueue(
            label: "com.sinkingsoul.DispatchQueueTest.serialQueue2")
        let ioWriteQueue1 = DispatchQueue(
            label: "com.sinkingsoul.DispatchQueueTest.serialQueue3")
        let ioWriteQueue2 = DispatchQueue(
            label: "com.sinkingsoul.DispatchQueueTest.serialQueue4")
        
        let ioReadQueueArray = [ioReadQueue1, ioReadQueue2]
        let ioWriteQueueArray = [ioWriteQueue1, ioWriteQueue2]
        let ioWriteCleanupHandler: (Int32) -> Void = { errorNumber in
            print("写入文件完成 @\(Date())。")
        }
        let ioReadCleanupHandler: (Int32) -> Void = { errorNumber in
            print("读取文件完成 @\(Date())。")
        }
        
        let queueGroup = DispatchGroup()
        
        print("开始操作 @\(Date()).")
        
        let ioWrite = DispatchIO(type: .random, path: outFile.utf8String!, oflag: (O_RDWR | O_CREAT | O_APPEND), mode: (S_IRWXU | S_IRWXG), queue: ioWriteQueue1, cleanupHandler: ioWriteCleanupHandler)
        ioWrite?.setLimit(highWater: 1024 * 1024)
        ioWrite?.setLimit(lowWater: 1024 * 1024)
        
        filesSize.insert(0, at: 0)
        filesSize.removeLast()
        
        for (index, file) in files.enumerated() {
            DispatchQueue.global().sync {
                queueGroup.enter()
                
                let ioRead = DispatchIO(type: .stream, path: (file as! NSString).utf8String!, oflag: O_RDONLY, mode: 0, queue: ioReadQueue1, cleanupHandler: ioReadCleanupHandler)
                ioRead?.setLimit(highWater: 1024 * 1024)
                ioRead?.setLimit(lowWater: 1024 * 1024)
                
                var writeOffsetTemp = filesSize[0...index].reduce(0) { offset, size in
                    return offset + size
                }
                
                ioRead?.read(offset: 0, length: Int.max, queue: ioReadQueueArray[index]) {
                    doneReading, data, error in
//                    print("读取文件: \(file)，线程：\(Thread.current)--->")
                    if (error > 0) {
                        print("读取文件: \(file) 发生错误了，错误码：\(error)")
                        return
                    }
                    
                    if (doneReading) {
                        ioRead?.close()
                        queueGroup.leave()
                    }
                    
                    if (data != nil) {
                        let bytesRead: size_t = data!.count
                        if (bytesRead > 0) {
                            queueGroup.enter()
                            ioWrite?.write(offset: writeOffsetTemp, data: data!, queue: ioWriteQueueArray[index]) {
                                doneWriting, writeData, error in
//                                print("写入文件: \(file), 线程：\(Thread.current)--->")
                                if (error > 0) {
                                    print("写入文件: \(file) 发生错误了，错误码：\(error)")
                                    ioRead?.close()
                                    return
                                }
                                if doneWriting {
                                    queueGroup.leave()
                                }
//                                print("--->写入文件: \(file), 线程：\(Thread.current)")
                            }
                            writeOffsetTemp = writeOffsetTemp + Int64(data!.count)
                        }
                    }
//                    print("--->读取文件: \(file) ，线程：\(Thread.current)")
                }
            }
        }
        _ = queueGroup.wait(timeout: .distantFuture)
        ioWrite?.close()
        
    }
    
    /// 利用 NSMutableData 类型合并文件
    static func combineFileUsingData() {
        let filePathArray = ["/Users/xxx/Downloads/gcd.mp4.zip.001",
                             "/Users/xxx/Downloads/gcd.mp4.zip.002"]
        let outputFilePath = "/Users/xxx/Downloads/gcd.mp4.zip"
        print("开始操作 @\(Date()).")
        let data = filePathArray.reduce(NSMutableData()) { data, filePath in
            // 将文件转换为 Data
            let fileData = try! NSMutableData(contentsOfFile: filePath, options: .mappedIfSafe)
            let tempData = data
            tempData.append(fileData as Data)
            return tempData
        }
        print("准备写入文件 @\(Date()).")
        data.write(toFile: outputFilePath, atomically: false)
        print("写入文件完成 @\(Date()).")
    }
    
    /// 利用 DispatchData 类型快速合并文件
    static func combineFileWithDispatchData() {
        let filePathArray = ["/Users/xxx/Downloads/gcd.mp4.zip.001",
                             "/Users/xxx/Downloads/gcd.mp4.zip.002"]
        let outputFilePath: NSString = "/Users/xxx/Downloads/gcd.mp4.zip"
        let ioWriteQueue = DispatchQueue(
            label: "com.sinkingsoul.DispatchQueueTest.serialQueue")
        
        let ioWriteCleanupHandler: (Int32) -> Void = { errorNumber in
            print("写入文件完成 @\(Date()).")
        }
        let ioWrite = DispatchIO(type: .stream,
                                 path: outputFilePath.utf8String!,
                                 oflag: (O_RDWR | O_CREAT | O_APPEND),
                                 mode: (S_IRWXU | S_IRWXG),
                                 queue: ioWriteQueue,
                                 cleanupHandler: ioWriteCleanupHandler)
        ioWrite?.setLimit(highWater: 1024*1024*2)
        
        print("开始操作 @\(Date()).")
        
        // 将所有文件合并为一个 DispatchData 对象
        let dispatchData = filePathArray.reduce(DispatchData.empty) { data, filePath in
            // 将文件转换为 Data
            let url = URL(fileURLWithPath: filePath)
            // 将文件虚拟隐射为 Data 对象，不会占用内存空间。
            let fileData = try! Data(contentsOf: url, options: .mappedIfSafe)
            var tempData = data
            // 将 Data 转换为 DispatchData
            let dispatchData = fileData.withUnsafeBytes {
                (u8Ptr: UnsafePointer<UInt8>) -> DispatchData in
                let rawPtr = UnsafeRawPointer(u8Ptr)
                let innerData = Unmanaged.passRetained(fileData as NSData)
                return DispatchData(bytesNoCopy:
                    UnsafeRawBufferPointer(start: rawPtr, count: fileData.count),
                                    deallocator: .custom(nil, innerData.release))
            }
            // 拼接 DispatchData 对象，也不占用内存。
            tempData.append(dispatchData)
            return tempData
        }
        
        //将 DispatchData 对象写入结果文件中
        ioWrite?.write(offset: 0, data: dispatchData, queue: ioWriteQueue) {
            doneWriting, data, error in
            if (error > 0) {
                print("写入发生错误了，错误码：\(error)")
                return
            }
            
            if data != nil {
//                print("正在写入文件，剩余大小：\(data!.count) bytes.")
            }
            
            if (doneWriting) {
                ioWrite?.close()
            }
        }
    }
    
}
