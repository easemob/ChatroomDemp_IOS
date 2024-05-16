//
//  BottomBar.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/24.
//

import UIKit
import ChatroomUIKit

final class BottomBar: UIView {
    
    var createClosure: (() -> ())?
    
    lazy var avatar: RoomInfoHeader = {
        RoomInfoHeader(frame: CGRect(x: 16, y: 15, width: 36, height: 36)).cornerRadius(.large)
    }()
    
    lazy var userName: UILabel = {
        UILabel(frame: CGRect(x: self.avatar.frame.maxX+12, y: 15, width: self.frame.width-self.avatar.frame.maxX-12-128, height: 40)).font(UIFont.theme.labelLarge).textColor(UIColor.theme.neutralColor1).numberOfLines(2).text(YourAppUser.current.nickname)
    }()
    
    lazy var create: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: self.frame.width-118, y: 14, width: 102, height: 38)).cornerRadius(.large).image(UIImage(named: "video"), .normal).backgroundColor(UIColor.theme.primaryColor5).textColor(UIColor.theme.neutralColor98, .normal).title("  创建", .normal).font(UIFont.theme.labelMedium).addTargetFor(self, action: #selector(createAction), for: .touchUpInside)
    }()
    
    lazy var container: UIView = {
        UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)).backgroundColor(UIColor.theme.neutralColor98)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.container.layer.shadowRadius = 36
        self.container.layer.shadowOffset = CGSize(width: 0, height: 24)
        self.container.layer.shadowColor = UIColor(red: 0.275, green: 0.306, blue: 0.325, alpha: 0.15).cgColor
        self.container.layer.shadowOpacity = 1
        self.addSubViews([self.container,self.avatar,self.userName,self.create])
        self.avatar.avatar.image(with: YourAppUser.current.avatarURL, placeHolder: Appearance.avatarPlaceHolder)
        Theme.registerSwitchThemeViews(view: self)
        self.switchTheme(style: Theme.style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func createAction() {
        self.createClosure?()
    }
    
}

extension BottomBar: ThemeSwitchProtocol {
    
    func switchTheme(style: ChatroomUIKit.ThemeStyle) {
        self.backgroundColor(style == .dark ? UIColor.theme.neutralColor1:UIColor.theme.neutralColor98)
        self.container.backgroundColor(style == .dark ? UIColor.theme.neutralColor1:UIColor.theme.neutralColor98)
        self.backgroundColor(style == .dark ? UIColor.theme.neutralColor1:UIColor.theme.neutralColor98)
        self.userName.textColor = style == .light ? UIColor.theme.neutralColor1:UIColor.theme.neutralColor98
        self.create.backgroundColor = style == .dark ? UIColor.theme.primaryColor6:UIColor.theme.primaryColor5
        self.container.layer.shadowColor = UIColor(red: 0.275, green: 0.306, blue: 0.325, alpha: style == .dark ? 0.3:0.15).cgColor
    }
    
    func switchHues() {
        self.switchTheme(style: .light)
    }
    
    
}
