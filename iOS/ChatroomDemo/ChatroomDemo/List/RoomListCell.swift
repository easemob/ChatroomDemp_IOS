//
//  RoomCell.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/23.
//

import UIKit
import ChatroomUIKit

final class RoomListCell: UITableViewCell {
    
    var hasShadow = false
    
    lazy var shadowEffect: UIView = {
        UIView(frame: CGRect(x: 13, y: 7, width: self.contentView.frame.width-26, height: self.frame.height - 14)).cornerRadius(.medium).backgroundColor(.clear)
    }()
    
    lazy var background: UIView = {
        UIView(frame: CGRect(x: 16, y: 10, width: self.contentView.frame.width-32, height: self.frame.height - 20)).backgroundColor(UIColor.theme.neutralColor98).cornerRadius(.medium)
    }()
    
    lazy var roomCover: UIImageView = {
        UIImageView(frame: CGRect(x: 0, y: 0, width: self.background.frame.height, height: self.background.frame.height)).cornerRadius(.small, [.topLeft,.bottomLeft], .clear, 0).backgroundColor(.clear).image(UIImage(named: "roomCover"))
    }()
    
    lazy var roomName: UILabel = {
        UILabel(frame:CGRect(x: self.roomCover.frame.maxX+14, y: 11, width: self.background.frame.width/2.0 - 20, height: 40)).font(UIFont.theme.labelLarge).textColor(UIColor.theme.neutralColor1).text("User's channel~").numberOfLines(2)
    }()
    
    lazy var ownerAvatar: ImageView = {
        ImageView(frame: CGRect(x: self.roomName.frame.minX, y: self.roomName.frame.maxY+15, width: 16, height: 16)).cornerRadius(.large)
    }()
    
    lazy var ownerName: UILabel = {
        UILabel(frame: CGRect(x: self.roomName.frame.minX+20, y: self.roomName.frame.maxY+15, width: self.background.frame.width/2.0 - 20, height: 16)).isUserInteractionEnabled(false).font(UIFont.theme.bodyExtraSmall).text("用户名").textColor(UIColor.theme.neutralColor5)
    }()
    
    lazy var entryRoom: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: self.background.frame.width - 72, y: self.background.frame.height - 40, width: 56, height: 24)).font(UIFont.theme.headlineExtraSmall).backgroundColor(UIColor.theme.neutralColor9).title("进入".chatroom.localize, .normal).cornerRadius(.large).textColor(UIColor.theme.neutralColor1, .normal).isUserInteractionEnabled(false)
    }()
    
    lazy var entryBlur: UIView = {
        UIView(frame: self.entryRoom.frame).backgroundColor(UIColor(white: 1, alpha: 0.3)).cornerRadius(.large)
    }()    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(self.shadowEffect)
        self.contentView.addSubview(self.background)
        self.background.addSubViews([self.roomCover,self.roomName,self.ownerAvatar,self.ownerName,self.entryBlur,self.entryRoom])
        Theme.registerSwitchThemeViews(view: self)
        self.switchTheme(style: Theme.style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowEffect.frame = CGRect(x: 13, y: 7, width: self.contentView.frame.width-26, height: self.frame.height - 14)
        self.addEffect()
        self.background.frame = CGRect(x: 16, y: 10, width: self.contentView.frame.width-32, height: self.frame.height - 20)
        self.roomCover.frame = CGRect(x: 0, y: 0, width: self.background.frame.height, height: self.background.frame.height)
        self.roomCover.cornerRadius(.medium, [.topLeft,.bottomLeft], .clear, 0)
        self.roomName.frame = CGRect(x: self.roomCover.frame.maxX+14, y: 11, width: self.background.frame.width/2.0 - 20, height: 40)
        self.ownerAvatar.frame =  CGRect(x: self.roomName.frame.minX, y: self.roomName.frame.maxY+3, width: 16, height: 16)
        self.ownerName.frame = CGRect(x: self.roomName.frame.minX+20, y: self.roomName.frame.maxY+3, width: self.background.frame.width/2.0 - 20, height: 16)
        self.entryRoom.frame = CGRect(x: self.background.frame.width - 72, y: self.background.frame.height - 40, width: 56, height: 24)
        self.entryBlur.frame = self.entryRoom.frame
    }
    
    private func addEffect() {
        if !self.hasShadow {
            let shadowPath0 = UIBezierPath(roundedRect: self.shadowEffect.bounds, cornerRadius: 16)
            let layer0 = CALayer()
            layer0.shadowPath = shadowPath0.cgPath
            layer0.shadowColor = UIColor(red: 0.275, green: 0.306, blue: 0.325, alpha: 0.15).cgColor
            layer0.shadowOpacity = 1
            layer0.shadowRadius = 3
            layer0.shadowOffset = CGSize(width: 0, height: 1)
            self.shadowEffect.layer.addSublayer(layer0)
            self.hasShadow = true
        }
    }
}

extension RoomListCell: ThemeSwitchProtocol {
    func switchTheme(style: ChatroomUIKit.ThemeStyle) {
        self.background.backgroundColor = style == .dark ? UIColor.theme.neutralColor2:UIColor.theme.neutralColor95
        self.ownerName.textColor = style == .dark ? UIColor.theme.neutralColor7:UIColor.theme.neutralColor5
        self.roomName.textColor = style == .dark ? UIColor.theme.neutralColor98:UIColor.theme.neutralColor1
        self.entryRoom.setTitleColor(style == .dark ? UIColor.theme.neutralColor98:UIColor.theme.neutralColor1, for: .normal)
        self.entryRoom.backgroundColor = style == .dark ? UIColor.theme.neutralColor3:UIColor.theme.neutralColor9
    }
    
    func switchHues() {
        self.switchTheme(style: .light)
    }
    
    
}
