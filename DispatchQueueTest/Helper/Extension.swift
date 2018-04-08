//
//  Extension.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-12.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation

extension URLSession {
    /// 将数据获取的任务加入任务组中
    func addDataTask(to group: DispatchGroup,
                     with request: URLRequest,
                     completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        -> URLSessionDataTask {
            group.enter()
            return dataTask(with: request) { (data, response, error) in
                print("下载结束：\(Date())")
                completionHandler(data, response, error)
                group.leave()
            }
    }
}
