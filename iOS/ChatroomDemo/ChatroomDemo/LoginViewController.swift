//
//  LoginViewController.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/23.
//

import UIKit
import ChatroomUIKit

final class LoginViewController: UIViewController {


    @UserDefault("ChatroomDemoUserToken", defaultValue: "") var chatToken
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fetchUserInfo()
    }
    
    func fetchUserInfo() {
        YourAppUser.current.userId = YourAppUser.current.userId
        YourAppUser.current.avatarURL = YourAppUser.current.avatarURL
        YourAppUser.current.nickName = YourAppUser.current.nickName
        ChatroomBusinessRequest.shared.sendPOSTRequest(api: .login(()), params: ["username":YourAppUser.current.userId,"nickname":YourAppUser.current.nickName,"icon_key":YourAppUser.current.avatarURL]) { [weak self] result, error in
            if error == nil,let access_token = result?["access_token"] as? String,let userName = result?["userName"] as? String {
                self?.chatToken = access_token
                if userName == "easemob" {
                    YourAppUser.current.avatarURL = "https://a1.easemob.com/easemob/chatroom-uikit/chatfiles/fc14ab00-79f7-11ee-93f4-618a64affe88"
                }
                self?.login(user: YourAppUser.current, token: access_token)
            } else {
                DialogManager.shared.showAlert(content: "获取登录信息失败，点击确定重新获取", showCancel: false, showConfirm: true) {
                    self?.fetchUserInfo()
                }
            }
        }
    }
    
    func login(user: YourAppUser,token: String) {
        ChatroomUIKitClient.shared.login(user: user, token: token) { [weak self] error in
            DispatchQueue.main.async {
                if error == nil {
                    self?.navigationController?.pushViewController(RoomListViewController(), animated: true)
                } else {
                    DialogManager.shared.showAlert(content: "登录失败，点击确定重新登录", showCancel: false, showConfirm: true) {
                        self?.login(user: user, token: token)
                    }
                }
            }
        }
        
    }

}


@objcMembers public final class YourAppUser: NSObject,UserInfoProtocol {
    
    static let current = YourAppUser()
    
    public func toJsonObject() -> Dictionary<String, Any>? {
        ["userId":self.userId,"nickName":self.nickName,"avatarURL":self.avatarURL,"identity":self.identity,"gender":self.gender]
    }
    
    @UserDefault("ChatroomUserName", defaultValue: userNames.randomElement() ?? "") public var nickName
    
    @UserDefault("ChatroomUserAvatar", defaultValue: "https://a1.easemob.com/easemob/chatroom-uikit/chatfiles/"+"\(avatars.randomElement() ?? "")") public var avatarURL
    
    @UserDefault("ChatRoomUserID",defaultValue: generateRandomString(length: 16)) public var userId
        
    public var gender: Int = 1
    
    public var identity: String = "https://accktvpic.oss-cn-beijing.aliyuncs.com/pic/sample_avatar/sample_avatar_6.png"//user level picture url
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
    
}
