//
//  RoomInfoHeader.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/25.
//

import UIKit
import ChatroomUIKit

final class RoomInfoHeader: UIView {
    
    lazy var avatar: ImageView = {
        ImageView(frame: CGRect(x: 2, y: 2, width: self.frame.height-4, height: self.frame.height-4)).cornerRadius(.large)
    }()
    
    lazy var roomName: UILabel = {
        UILabel(frame: CGRect(x: self.avatar.frame.maxX+8, y: 2, width: self.frame.width-self.avatar.frame.maxX-8-16, height: 22)).font(UIFont.theme.labelLarge).textColor(UIColor.theme.neutralColor98).text("User's channel~")
    }()
    
    lazy var userName: UILabel = {
        UILabel(frame: CGRect(x: self.avatar.frame.maxX+8, y: self.frame.height-2-14, width: self.frame.width-self.avatar.frame.maxX-8-16, height: 14)).font(UIFont.theme.bodyExtraSmall).textColor(UIColor(white: 1, alpha: 0.8)).text("UserName")
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([self.avatar,self.roomName,self.userName])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


final class RoomHeader: UIView {
    
    var backClosure: (() -> ())?
    
    var membersClosure: (() -> ())?
    
    lazy var back: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: 10, y: 3, width: 22, height: self.frame.height-6)).image(UIImage(named: "back"), .normal).addTargetFor(self, action: #selector(backAction), for: .touchUpInside)
    }()
    
    lazy var info: RoomInfoHeader = {
        RoomInfoHeader(frame: CGRect(x: self.back.frame.maxX+4, y: 3, width: (self.frame.width*0.4), height: self.frame.height-6)).backgroundColor(UIColor.theme.barrageLightColor2).cornerRadius(.large)
    }()
    
    lazy var members: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: self.frame.width-46, y: 6, width: 30, height: 30)).image(UIImage(named: "members"), .normal).addTargetFor(self, action: #selector(membersAction), for: .touchUpInside).cornerRadius(.large).backgroundColor(UIColor.theme.barrageDarkColor2)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([self.back,self.info,self.members])
        Theme.registerSwitchThemeViews(view: self)
        self.switchTheme(style: Theme.style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backAction() {
        self.backClosure?()
    }
    
    @objc func membersAction() {
        self.membersClosure?()
    }
    
    func update(roomName: String,userName: String,avatar: String) {
        self.info.avatar.image(with: avatar, placeHolder: Appearance.avatarPlaceHolder)
        self.info.roomName.text = roomName
        self.info.userName.text = userName
        let size = roomName.chatroom.sizeWithText(font: UIFont.systemFont(ofSize: 16, weight: .medium), size: CGSize(width: ScreenWidth-120, height: 18))
        let width = size.width+(self.info.frame.height-4)+32
        self.info.frame = CGRect(x: self.info.frame.minX, y: self.info.frame.minY, width: width, height: self.info.frame.height)
        self.info.roomName.frame = CGRect(x: self.info.avatar.frame.maxX+8, y: 2, width: self.info.frame.width-self.info.avatar.frame.maxX-8-16, height: 22)
    }
    
    deinit {
    }
}

extension RoomHeader: ThemeSwitchProtocol {
    func switchTheme(style: ChatroomUIKit.ThemeStyle) {
        self.info.backgroundColor(style == .dark ? UIColor.theme.barrageLightColor2:UIColor.theme.barrageDarkColor1)
        self.members.backgroundColor = style == .dark ? UIColor.theme.barrageLightColor2:UIColor.theme.barrageDarkColor1
    }
    
    
}
