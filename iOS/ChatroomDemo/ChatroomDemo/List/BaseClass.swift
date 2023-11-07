//
//  BaseClass.swift
//
//  Created by 朱继超 on 2023/11/2
//  Copyright (c) . All rights reserved.
//

import Foundation

struct BaseClass: Codable {

  enum CodingKeys: String, CodingKey {
    case persistent
    case id
    case name
    case ext
    case status
    case descriptionValue = "description"
    case affiliationsCount = "affiliations_count"
    case owner
    case showid
    case iconKey
    case videoType = "video_type"
    case created
  }

  var persistent: Bool?
  var id: String?
  var name: String?
  var ext: Ext?
  var status: String?
  var descriptionValue: String?
  var affiliationsCount: Int?
  var owner: String?
  var showid: Int?
  var iconKey: String?
  var videoType: String?
  var created: Int?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    persistent = try container.decodeIfPresent(Bool.self, forKey: .persistent)
    id = try container.decodeIfPresent(String.self, forKey: .id)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    ext = try container.decodeIfPresent(Ext.self, forKey: .ext)
    status = try container.decodeIfPresent(String.self, forKey: .status)
    descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue)
    affiliationsCount = try container.decodeIfPresent(Int.self, forKey: .affiliationsCount)
    owner = try container.decodeIfPresent(String.self, forKey: .owner)
    showid = try container.decodeIfPresent(Int.self, forKey: .showid)
    iconKey = try container.decodeIfPresent(String.self, forKey: .iconKey)
    videoType = try container.decodeIfPresent(String.self, forKey: .videoType)
    created = try container.decodeIfPresent(Int.self, forKey: .created)
  }

}
