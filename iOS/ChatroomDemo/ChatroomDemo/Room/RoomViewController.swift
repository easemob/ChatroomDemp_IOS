//
//  RoomViewController.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/25.
//

import UIKit
import ChatroomUIKit
import AVFoundation
import AVKit
import KakaJSON

final class RoomViewController: UIViewController {
    
    var option_UI: UIOptions {
        let option = UIOptions()
        option.bottomDataSource = self.bottomBarDatas()
        return option
    }
    
    lazy var header: RoomHeader = {
        RoomHeader(frame: CGRect(x: 0, y: StatusBarHeight, width: self.view.frame.width, height: 44)).backgroundColor(.clear)
    }()
    
    lazy var player: AVPlayer = {
        guard let videoURL = Bundle.main.url(forResource: "video_easemob", withExtension: "mp4") else { return AVPlayer() }
        let play = AVPlayer(url: videoURL)
        return play
    }()
    
    lazy var playView: PlayerView = {
        PlayerView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight),player:self.player).backgroundColor(.clear)
    }()
    
    lazy var roomView: ChatroomView = {
        ChatroomUIKitClient.shared.launchRoomView(roomId: self.room.id ?? "", frame: CGRect(x: 0, y: ScreenHeight-336-BottomBarHeight, width: self.view.frame.width, height: 336+BottomBarHeight), ownerId: self.room.owner ?? "",options: self.option_UI)
    }()
        
    lazy var gift1: GiftsViewController = {
        GiftsViewController(gifts: self.gifts())
    }()
    
    private var room = RoomEntity()
    
    required convenience init(room: RoomEntity) {
        self.init()
        self.room = room
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.playView)
        self.view.addSubViews([self.roomView,self.header])
        if let roomName = self.room.name,let userName = self.room.nickname,let avatar = self.room.iconKey {
            self.header.update(roomName: roomName, userName: userName, avatar: avatar)
        }
        self.roomView.addActionHandler(self)
        ChatroomUIKitClient.shared.registerRoomEventsListener(self)
        self.playView.player = self.player
        self.player.play()
        self.header.backClosure = { [weak self] in
            self?.leaveRoom()
        }
        self.header.membersClosure = { [weak self] in
            self?.showMembers()
        }
    }
    
    deinit {
        ChatroomUIKitClient.shared.unregisterRoomEventsListener(self)
    }
    
    private func leaveRoom() {
        self.roomView.inputBar.hiddenInputBar()
        if ChatroomContext.shared?.owner ?? false {
            DialogManager.shared.showAlert(content: "离开后直播间立刻销毁，确定离开？", showCancel: true, showConfirm: true,title: "销毁聊天室") { [weak self] in
                self?.destroyRoom()
            }
        } else {
            self.exitRoom()
        }
    }
    
    @objc private func exitRoom() {
        ChatroomUIKitClient.shared.destroyRoom()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func destroyRoom() {
        if let roomId = self.room.id {
            ChatroomBusinessRequest.shared.sendDELETERequest(api: .destroy(roomId: roomId), params: [:]) { [weak self] result, error in
                if error == nil {
                    self?.exitRoom()
                } else {
                    self?.showToast(toast: "destroyRoom:\(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    private func showMembers() {
        DialogManager.shared.showParticipantsDialog { [weak self] user in
            self?.handleUserAction(user: user, muteTab: false)
        } muteMoreClosure: { [weak self] user in
            self?.handleUserAction(user: user, muteTab: true)
        }
    }
    
    private func handleUserAction(user: UserInfoProtocol,muteTab: Bool) {
        DialogManager.shared.showUserActions(actions: muteTab ? Appearance.defaultOperationMuteUserActions:Appearance.defaultOperationUserActions) { item,object  in
            switch item.tag {
            case "Mute":
                ChatroomUIKitClient.shared.roomService?.mute(userId: user.userId, completion: { [weak self] error in
                    guard let `self` = self else { return }
                    if error == nil {
//                        self.removeUser(user: user)
                    } else {
                        self.showToast(toast: "\(error?.errorDescription ?? "")",duration: 3)
                    }
                })
            case "unMute":
                ChatroomUIKitClient.shared.roomService?.unmute(userId: user.userId, completion: { [weak self] error in
                    guard let `self` = self else { return }
                    if error == nil {
//                        self.removeUser(user: user)
                    } else {
                        self.showToast(toast: "\(error?.errorDescription ?? "")", duration: 3)
                    }
                })
            case "Remove":
                DialogManager.shared.showAlert(content: "确定要移除成员 `\(user.nickname.isEmpty ? user.userId:user.nickname)`?", showCancel: true, showConfirm: true) {
                    ChatroomUIKitClient.shared.roomService?.kick(userId: user.userId) { [weak self] error in
                        guard let `self` = self else { return }
                        if error == nil {
                            self.showToast(toast: error == nil ? "删除成功":"\(error?.errorDescription ?? "")",duration: 2)
                        } else {
                            self.showToast(toast: "\(error?.errorDescription ?? "")", duration: 3)
                        }
                    }
                }
            default:
                item.action?(item, object)
            }
        }
    }
    
    
    /// Constructor of ``ChatBottomFunctionBar`` data source.
    /// - Returns: Conform ``ChatBottomItemProtocol`` class instance array.
    func bottomBarDatas() -> [ChatBottomItemProtocol] {
        var entities = [ChatBottomItemProtocol]()
        let names = ["gift"]
        for i in 0...names.count-1 {
            let entity = ChatBottomItem()
            entity.showRedDot = false
            entity.selected = false
            entity.selectedImage = UIImage(named: "sendgift", in: .chatroomBundle, with: nil)
            entity.normalImage = UIImage(named: "sendgift", in: .chatroomBundle, with: nil)
            entity.type = i
            entities.append(entity)
        }
        return entities
    }
    
    /// Simulate fetch json from server .
    /// - Returns: Conform ``GiftEntityProtocol`` class instance.
    private func gifts() -> [GiftEntityProtocol] {
        if let path = Bundle.main.url(forResource: "Gifts", withExtension: "json") {
            var data = Dictionary<String,Any>()
            do {
                data = try Data(contentsOf: path).chatroom.toDictionary() ?? [:]
            } catch {
                assert(false)
            }
            if let jsons = data["gifts"] as? [Dictionary<String,Any>] {
                return jsons.compactMap {
                    let entity = GiftEntity()
                    entity.setValuesForKeys($0)
                    return entity
                }
            }
        }
        return []
    }
    
}

//MARK: - When you called `self.roomView.addActionHandler(actionHandler: self)`.You'll receive chatroom view's click action events callback.
extension RoomViewController : ChatroomViewActionEventsDelegate {
    func onMessageClicked(message: ChatroomUIKit.ChatMessage) {
        //Statistical data
    }
    
    func onMessageLongPressed(message: ChatroomUIKit.ChatMessage) {
        //Statistical data
    }
    
    func onKeyboardRaiseClicked() {
        //Statistical data
    }
    
    func onExtensionBottomItemClicked(item: ChatroomUIKit.ChatBottomItemProtocol) {
        if item.type == 0 {
            DialogManager.shared.showGiftsDialog(titles: ["礼物列表"], gifts: [self.gift1])
        }
    }
    
    
}

//MARK: - When you called `ChatroomUIKitClient.shared.registerRoomEventsListener(listener: self)`.You'll implement these method.
extension RoomViewController: RoomEventsListener {
    func userAccountDidRemoved() {
        self.showToast(toast: "您的账户已被管理员移除", duration: 2)
        self.perform(#selector(exitRoom), with: nil, afterDelay: 1)
    }
    
    func userDidForbidden() {
        self.showToast(toast: "当前用户已被管理员封禁", duration: 2)
        self.perform(#selector(exitRoom), with: nil, afterDelay: 1)
    }
    
    func userAccountDidForcedToLogout(error: ChatroomUIKit.ChatError?) {
        self.showToast(toast: "用户账户已被强制登出:\(error?.errorDescription ?? "")", duration: 2)
        self.perform(#selector(exitRoom), with: nil, afterDelay: 1)
    }
    
    func onReceiveMessage(message: ChatroomUIKit.ChatMessage) {
        //Received new message
    }
    
    func onUserLeave(roomId: String, userId: String) {
        //Statistical data
//        self.showToast(toast: "\(ChatroomContext.shared?.usersMap?[userId]?.nickName ?? userId) was left.", duration: 3)
    }
    
    
    func onSocketConnectionStateChanged(state: ChatroomUIKit.ConnectionState) {
        self.showToast(toast: "Socket connection state change to \(state.rawValue).", duration: 3)
    }
    
    func onUserTokenDidExpired() {
        self.showToast(toast: "User chat token was expired.", duration: 3)
        //SDK will auto enter current chatroom of `ChatroomContext` on reconnect success.
//        ChatroomUIKitClient.shared.login(user: ExampleRequiredConfig.YourAppUser(), token: ExampleRequiredConfig.chatToken) { [weak self] error in
//            if error != nil {
//                self?.showToast(toast: "User chat token was expired.Login again error:\(error?.errorDescription ?? "")", duration: 3)
//            }
//        }
        //MARK: - Warning note
        //When the App is reopened, you need to go through the logic of SDK initialization and login creation, ChatroomView addition, etc. again.
    }
    
    func onUserTokenWillExpired() {
//        ChatroomUIKitClient.shared.refreshToken(token: ExampleRequiredConfig.chatToken)
    }
    
    func onUserLoginOtherDevice(device: String) {
        self.showToast(toast: "当前用户已在其它设备登录", duration: 3)
    }
    
    func onUserUnmuted(roomId: String, userId: String) {
        self.showToast(toast: "您已被解除禁言.", duration: 3)
    }
    
    func onUserMuted(roomId: String, userId: String) {
        if userId == ChatroomContext.shared?.currentUser?.userId ?? "" {
            self.showToast(toast: "您已被禁言", duration: 3)
        }
    }
    
    func onUserJoined(roomId: String, user: ChatroomUIKit.UserInfoProtocol) {
        
    }
    
    func onUserBeKicked(roomId: String, reason: ChatroomUIKit.ChatroomBeKickedReason) {
        self.showToast(toast: "你已被请出聊天室.", duration: 2)
        self.perform(#selector(exitRoom), with: nil, afterDelay: 1)
    }
    
    func onReceiveGlobalNotify(message: ChatroomUIKit.ChatMessage) {
        
    }
    
    func onAnnouncementUpdate(roomId: String, announcement: String) {
        //toast or alert notify participants.
        self.showToast(toast: "群公告已更新： \(announcement)", duration: 5)
    }
    
    func onEventResultChanged(error: ChatroomUIKit.ChatError?, type: ChatroomUIKit.RoomEventsType) {
        //you can catch error then handle.
        if error == nil {
            switch type {
            case .leave,.destroyed:
                self.exitRoom()
            case .report:
                //You can show alert.
                self.showToast(toast: "举报已提交",duration: 2)
            case .unmute:
                self.showToast(toast: "您已被解除禁言",duration: 2)
            case .mute:
                self.showToast(toast: "您已被禁言",duration: 2)
            case .kick:
                self.showToast(toast: "踢出成功",duration: 2)
            default:
                break
            }
        } else {
            switch type {
            case .sendMessage:
                if error?.code == .userMuted {
                    self.showToast(toast: "You have been muted and are unable to send messages.".chatroom.localize, duration: 2,delay: 1)
                }
            case .recall:
                if error?.code == .messageRecallTimeLimit {
                    self.showToast(toast: "此消息已经超过撤回时限，无法撤回")
                }
            default:
                self.showToast(toast: "RoomEvents \(type) error: \(error?.errorDescription ?? "")", duration: 3)
                break
            }
            
        }
    }
    
    
}



final class ChatBottomItem:NSObject, ChatBottomItemProtocol {
    
    var action: ((ChatroomUIKit.ChatBottomItemProtocol) -> Void)?
    
    var showRedDot: Bool = false
    
    var selected: Bool = false
    
    var selectedImage: UIImage?
    
    var normalImage: UIImage?
    
    var type: Int = 0
   
}

@objcMembers public class GiftEntity:NSObject,GiftEntityProtocol {
    public var giftCount: Int = 0
    
    
    public func toJsonObject() -> Dictionary<String, Any> {
        ["giftId":self.giftId,"giftName":self.giftName,"giftPrice":self.giftPrice,"giftCount":self.giftCount,"giftIcon":self.giftIcon,"giftEffect":self.giftEffect]
    }
    
    public var giftId: String = ""
    
    public var giftName: String = ""
    
    public var giftName1: String = ""
    
    public var giftPrice: String = ""
    
    
    public var giftIcon: String = ""
    
    public var giftEffect: String = ""
    
    public var selected: Bool = false
    
    public var sentThenClose: Bool = true
    
    public var sendUser: UserInfoProtocol?
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

