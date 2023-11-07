//
//  UserInfoConfig.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/11/2.
//

import Foundation

let userNames = ["左冷禅",
                 "朱聪",
                 "拜月",
                 "周伯通",
                 "钟阿四",
                 "郑长老",
                 "张五侠",
                 "张三丰",
                 "掌灯",
                 "张翠山",
                 "岳不群",
                 "月白",
                 "袁冠南",
                 "袁承志",
                 "预姚春",
                 "余沧海",
                 "殷天正",
                 "尹克西",
                 "仪琳",
                 "耶律楚材",
                 "杨铁心",
                 "杨过",
                 "杨成协",
                 "玄慈大师",
                 "虚竹",
                 "许仕枫",
                 "心如止水",
                 "谢逊",
                 "逍遥子",
                 "小龙女",
                 "笑蓝春",
                 "夏雪宜",
                 "夏冰",
                 "无崖子",
                 "文泰来",
                 "韦小宝",
                 "魏无极",
                 "王处一",
                 "铁心兰",
                 "田归农",
                 "田伯光",
                 "宋青书",
                 "双儿"]

let avatars = ["fc14ab00-79f7-11ee-93f4-618a64affe88","7345d230-79f8-11ee-a0d1-5f74d88fa308","7d239bc0-79f8-11ee-92b9-770b4e48f8fc","8e208410-79f8-11ee-b8e3-232a619cf52c","99296020-79f8-11ee-8475-c7a7b59db79f","a27bd9a0-79f8-11ee-8f83-551faec94303","ae308610-79f8-11ee-a6c9-5379b9a705a1","b837f7b0-79f8-11ee-b817-23850e48ca47","c0d52af0-79f8-11ee-a6ed-6fc3a8bc6581","c8354a50-79f8-11ee-97b9-0d7ccd9e7127","d2b176c0-79f8-11ee-a291-ed6692473990","de41f960-79f8-11ee-83cd-db9df9bad9bf","e7517670-79f8-11ee-a783-c1d7a432abb7","ef5724a0-79f8-11ee-8290-eb9f9e9c2195","f78da6d0-79f8-11ee-b3b8-3b446ebd1fbb","ffb9efd0-79f8-11ee-9356-ef4cfe1f2af8","07d98ea0-79f9-11ee-8047-d35f49238254","0fa12260-79f9-11ee-890f-67aacef20d88","16bc4980-79f9-11ee-b272-3568dd301252","208dde10-79f9-11ee-b9ea-5bff48db7458","298c9240-79f9-11ee-b8b6-f16f0b5f700a"]

func generateRandomString(length: Int) -> String {
    let characters = "abcdefghijklmnopqrstuvwxyz0123456789"
    var randomString = ""
    
    for _ in 0..<length {
        let randomIndex = Int.random(in: 0..<characters.count)
        let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
        randomString.append(randomCharacter)
    }
    
    return randomString.lowercased()
}

