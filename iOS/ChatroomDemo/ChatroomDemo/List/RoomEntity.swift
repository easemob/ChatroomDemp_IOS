//
//  RoomEntityNSObject.swift
//
//  Created by 朱继超 on 2023/11/2
//  Copyright (c) . All rights reserved.
//

import Foundation
import KakaJSON

class RoomList: Convertible {
    var entities: [RoomEntity]?
    var count: Int?
    
    required init() {
        
    }
}

class RoomEntity: Convertible {
    
    var affiliations_count: Int?
    var iconKey: String?
    var nickname: String?
    var created: Int?
    var showid: Int?
    var id: String?
    var status: String?
    var persistent: Bool?
    var owner: String?
    var name: String?
    var description: String?
    
    required init() {
        
    }
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        property.name
    }
    
}
