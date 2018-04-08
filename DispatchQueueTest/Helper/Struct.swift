//
//  Struct.swift
//  DispatchQueueTest
//
//  Created by 阿涛 on 18-3-12.
//  Copyright © 2018年 SinkingSoul. All rights reserved.
//

import Foundation


/// 豆瓣书籍标签 Json 结构体
struct BookTags: Codable {
    var tags: [Tag]
    
    struct Tag: Codable {
        var name: String
        var title: String
    }
    
    /// 根据豆瓣 API 返回的数据，解析并打印书籍的前 5 个标签。
    static func printBookPreviousFiveTags(_ data: Data) {
        if let bookTags = try? JSONDecoder().decode(BookTags.self, from: data) {
            let tags = bookTags.tags.prefix(5).reduce("") {"\($0)\($1.name)\n" }
            print(tags)
        } else {
            print("JSON parse failed")
        }
    }
    
}
