//
//  QueueTestListTableViewController.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-12.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import UIKit

class QueueTestListTableViewController: UITableViewController {
    
    // MARK: ---------控件实例属性
    
    // 同步任务按钮
    @IBOutlet weak var syncTaskButton1: UIButton!
    @IBOutlet weak var syncTaskButton2: UIButton!
    @IBOutlet weak var syncTaskButton3: UIButton!
    @IBOutlet weak var syncTaskButton4: UIButton!
    
    // 异步任务按钮
    @IBOutlet weak var asyncTaskButton1: UIButton!
    @IBOutlet weak var asyncTaskButton2: UIButton!
    @IBOutlet weak var asyncTaskButton3: UIButton!
    
    // 特殊任务
    @IBOutlet weak var specialTaskButton1: UIButton!
    @IBOutlet weak var specialTaskButton2: UIButton!
    
    // 延迟加入队列按钮
    @IBOutlet weak var ayncAfterButton: UIButton!
    @IBOutlet weak var ayncAfterCancelButton: UIButton!
    @IBOutlet weak var ayncAfterNewTaskButton: UIButton!
    
    // 挂起
    @IBOutlet weak var suspendButton: UIButton!
    // 唤醒
    @IBOutlet weak var resumeButton: UIButton!
    
    // 任务组按钮
    @IBOutlet weak var creatTaskGroupButton: UIButton!
    @IBOutlet weak var addSystemTaskToGroupButton: UIButton!
    @IBOutlet weak var addSystemAndCustomTaskToGroup: UIButton!
    
    
    // 资源监听
    @IBOutlet weak var changeFileButton: UIButton! // 文件监听
    
    // MARK: ---------table 属性
    let cellCount = [4, 3, 2, 3, 2, 3, 4, 3] // cell 数量数组
    
    
    // MARK: ---------测试类
    
    let createQueueWithTask = CreateQueueWithTask()
    let suspendAndResum = SuspendAndResum()
    let dispatchSourceTest = DispatchSourceTest()
    
    // MARK: ---------实例方法
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellCount.count
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return cellCount[section]
    }

}
