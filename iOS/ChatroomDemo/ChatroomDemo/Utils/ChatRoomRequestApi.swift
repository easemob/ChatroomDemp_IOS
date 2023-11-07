//
//  ChatRoomRequestApi.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/30.
//

import Foundation

public enum ChatRoomRequestApi {
    case login(Void)
    //MARK: - room api
    case room(Void)
    case destroy(roomId: String)
}


