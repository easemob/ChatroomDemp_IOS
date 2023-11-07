//
//  SwitchMenu.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/23.
//

import UIKit
import ChatroomUIKit

final class SwitchMenu: UIView {
    
    var selectedIndex: ((UInt) -> Void)?
    
    lazy var leftItem: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: 0, y: 0, width: self.frame.width/2.0, height: self.frame.height)).image(UIImage(named: "sun"), .selected).image(UIImage(named: "sun_gray"), .normal).tag(10).addTargetFor(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
    }()
    
    lazy var rightItem: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: self.frame.width/2.0, y: 0, width: self.frame.width/2.0, height: self.frame.height)).image(UIImage(named: "moon"), .selected).image(UIImage(named: "moon_gray"), .normal).tag(11).addTargetFor(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([self.leftItem,self.rightItem])
        self.leftItem.isSelected = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchAction(sender: UIButton) {
        if sender.tag == 10 {
            self.leftItem.isSelected = true
            self.rightItem.isSelected = false
        } else {
            self.leftItem.isSelected = false
            self.rightItem.isSelected = true
        }
        self.selectedIndex?(UInt(sender.tag-10))
    }
}
