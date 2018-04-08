//
//  Network.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-13.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation


/// 执行 http get 方法
func httpGet(url: String,
             getString: String? = nil,
             session: URLSession = URLSession.shared,
             completion: @escaping (Data?, URLResponse?, Error?) -> Void)
{
    let httpMethod = "GET"
    let urlStruct = URL(string: url) //创建URL对象
    var request = URLRequest(url: urlStruct!) //创建请求对象
    var dataTask: URLSessionTask
    
    request.httpMethod = httpMethod
    request.httpBody = getString?.data(using: .utf8)
    
    dataTask = session.dataTask(with: request, completionHandler: completion)
    dataTask.resume() // 启动任务
}

/// 执行 http get 方法，并加入指定的任务组。
func httpGet(url: String,
             getString: String? = nil,
             session: URLSession = URLSession.shared,
             in taskGroup: DispatchGroup,
             completion: @escaping (Data?, URLResponse?, Error?) -> Void)
{
    let httpMethod = "GET"
    let urlStruct = URL(string: url) //创建URL对象
    var request = URLRequest(url: urlStruct!) //创建请求对象
    var dataTask: URLSessionTask
    
    request.httpMethod = httpMethod
    request.httpBody = getString?.data(using: .utf8)
    
    dataTask = session.addDataTask(to: taskGroup,
                                   with: request,
                                   completionHandler: completion)
    dataTask.resume() // 启动任务
}

