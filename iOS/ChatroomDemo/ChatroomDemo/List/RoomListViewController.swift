//
//  RoomListViewController.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/23.
//

import UIKit
import ChatroomUIKit

final class RoomListViewController: UIViewController {
    
    private var rooms = [RoomEntity]() {
        didSet {
            DispatchQueue.main.async {
                if self.rooms.count <= 0 {
                    self.channelList.backgroundView = self.empty
                } else {
                    self.channelList.backgroundView = nil
                }
            }
        }
    }
    
    lazy var headTitle: UILabel = {
        UILabel(frame: CGRect(x: 16, y: StatusBarHeight+14, width: 70, height: 28)).font(UIFont.theme.headlineLarge).textColor(UIColor.theme.neutralColor1).text("聊天室")
    }()
    
    lazy var refresh: UIButton = {
        UIButton(type: .custom).frame(CGRect(x: self.headTitle.frame.maxX+8, y: StatusBarHeight+18, width: 20, height: 20)).image(UIImage(named: "refresh")?.withTintColor(UIColor.theme.neutralColor3), .normal).addTargetFor(self, action: #selector(refreshChannel), for: .touchUpInside)
    }()
    
    /// Switch theme
    private lazy var modeSegment: SwitchMenu = {
        SwitchMenu(frame: CGRect(x: ScreenWidth-70, y: StatusBarHeight+10, width: 64, height: 30)).cornerRadius(.large).backgroundColor(UIColor.theme.neutralColor9)
    }()
    
    lazy var channelList: UITableView = {
        UITableView(frame: CGRect(x: 0, y: NavigationHeight, width: ScreenWidth, height: ScreenHeight-NavigationHeight-self.bottomBar.frame.height), style: .plain).delegate(self).dataSource(self).tableFooterView(UIView()).separatorStyle(.none).registerCell(RoomListCell.self, forCellReuseIdentifier: "RoomListCell").rowHeight(140).backgroundColor(.clear)
    }()
    
    lazy var empty: EmptyStateView = {
        EmptyStateView(frame: CGRect(x: self.channelList.frame.minX, y: self.channelList.frame.minY, width: self.channelList.frame.width, height: self.channelList.frame.height),emptyImage: UIImage(named: "empty",in: .chatroomBundle, with: nil))
    }()
    
    lazy var bottomBar: BottomBar = {
        BottomBar(frame: CGRect(x: 0, y: ScreenHeight-BottomBarHeight-66, width: ScreenWidth, height: BottomBarHeight+66)).backgroundColor(UIColor.theme.neutralColor98)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.perform(#selector(fetchChatrooms), with: nil, afterDelay: 0.5)
        self.headTitle.frame = CGRect(x: 16, y: StatusBarHeight+14, width: 70, height: 28)
        self.refresh.frame = CGRect(x: self.headTitle.frame.maxX+8, y: StatusBarHeight+18, width: 20, height: 20)
        self.modeSegment.frame = CGRect(x: ScreenWidth-70, y: StatusBarHeight+10, width: 64, height: 30)
        self.channelList.frame = CGRect(x: 0, y: NavigationHeight, width: ScreenWidth, height: ScreenHeight-NavigationHeight-self.bottomBar.frame.height)
        self.bottomBar.frame = CGRect(x: 0, y: ScreenHeight-BottomBarHeight-66, width: ScreenWidth, height: BottomBarHeight+66)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = UIColor.theme.neutralColor98
        // Do any additional setup after loading the view.
        self.view.addSubViews([self.headTitle,self.refresh,self.modeSegment,self.channelList,self.bottomBar])
        self.modeSegment.selectedIndex = { [weak self] in
            self?.switchTheme(tag: $0)
        }
        self.bottomBar.createClosure = { [weak self] in
            self?.createRoom()
        }
        Theme.registerSwitchThemeViews(view: self)
        ChatroomUIKit.Appearance.barrageCellStyle = .hideUserIdentity
    }
    
    @objc private func fetchChatrooms() {
        ChatroomBusinessRequest.shared.sendGETRequest(api: .room(()), params: [:], classType: RoomList.self) { [weak self] list, error in
            if error == nil,list?.count ?? 0 > 0 {
                self?.endRefresh()
                if error == nil {
                    if let list = list {
                        self?.rooms.removeAll()
                        self?.rooms.append(contentsOf: list.entities ?? [])
                        self?.channelList.reloadData()
                    }
                } else {
                    self?.showToast(toast: "Fetch Chatrooms error:\(error?.localizedDescription ?? "")", duration: 2)
                }
            }
        }
    }
    
    private func createRoom() {
        ChatroomBusinessRequest.shared.sendPOSTRequest(api: .room(()), params: ["name":"\(YourAppUser.current.nickName)的直播间","owner":YourAppUser.current.userId], classType: RoomEntity.self) { [weak self] room, error in
            if error == nil,let room = room {
                self?.enterRoom(room: room)
            } else {
                self?.showToast(toast: "\(error?.localizedDescription ?? "")")
            }
        }
    }

    private func switchTheme(tag: UInt) {
        let style = ThemeStyle(rawValue: tag) ?? .light
        Theme.switchTheme(style: style)
    }
    
    @objc func refreshChannel() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2) // 360° in radians
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = .infinity
        self.refresh.imageView?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        self.fetchChatrooms()
    }

    func endRefresh() {
        self.refresh.imageView?.layer.removeAnimation(forKey: "rotationAnimation")
    }
}


extension RoomListViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RoomListCell") as? RoomListCell
        if cell == nil {
            cell = RoomListCell(style: .default, reuseIdentifier: "RoomListCell")
        }
        cell?.selectionStyle = .none
        cell?.ownerName.text = self.rooms[indexPath.row].nickname
        cell?.roomName.text = "\(self.rooms[indexPath.row].nickname ?? "")的聊天室"
        cell?.ownerAvatar.image(with: self.rooms[indexPath.row].iconKey ?? "", placeHolder: Appearance.avatarPlaceHolder)
        if indexPath.row == 0 {
            cell?.roomCover.image = UIImage(named: "easemob_cover")
        } else {
            cell?.roomCover.image = UIImage(named: "cover"+"\(indexPath.row%10)")
        }
        return cell ?? RoomListCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let room = self.rooms[safe:indexPath.row] {
            self.enterRoom(room: room)
        }
    }
    
    func enterRoom(room: RoomEntity) {
        let vc = RoomViewController(room: room)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension RoomListViewController: ThemeSwitchProtocol {
    
    func switchTheme(style: ChatroomUIKit.ThemeStyle) {
        self.modeSegment.backgroundColor(style == .dark ? UIColor.theme.neutralColor2:UIColor.theme.neutralColor9)
        self.view.backgroundColor(style == .dark ? UIColor.theme.neutralColor1:UIColor.theme.neutralColor98)
        self.refresh.setImage(UIImage(named: "refresh")?.withTintColor(style == .light ? UIColor.theme.neutralColor3:UIColor.theme.neutralColor95), for: .normal)
        self.headTitle.textColor = style == .dark ? UIColor.theme.neutralColor98:UIColor.theme.neutralColor1
    }
    
    func switchHues() {
        self.switchTheme(style: .light)
    }
    
    
}
