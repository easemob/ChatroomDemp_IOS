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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let background = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        background.image = UIImage(named: "launch")
        self.view.addSubview(background)
        if !chatToken.isEmpty {
            self.fetchUserInfo()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.fetchUserInfo()
    }
    
    @objc func fetchUserInfo() {
        YourAppUser.current.userId = YourAppUser.current.userId
        YourAppUser.current.avatarURL = YourAppUser.current.avatarURL
        YourAppUser.current.nickname = YourAppUser.current.nickname
        ChatroomBusinessRequest.shared.sendPOSTRequest(api: .login(()), params: ["username":YourAppUser.current.userId,"nickname":YourAppUser.current.nickname,"icon_key":YourAppUser.current.avatarURL]) { [weak self] result, error in
            if error == nil,let access_token = result?["access_token"] as? String,let userName = result?["userName"] as? String {
                self?.chatToken = access_token
//                if userName == "easemob" {
//                    YourAppUser.current.avatarURL = ChatroomRequest.shared.host+"/\(appkeyInfos.first ?? "")/\(appkeyInfos.last ?? "")/chatfiles/"+"fc14ab00-79f7-11ee-93f4-618a64affe88"
//                }
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


fileprivate let appkeyInfos = ChatClient.shared().options.appkey.components(separatedBy: "#")

@objcMembers public final class YourAppUser: NSObject,UserInfoProtocol {
    
    static let current = YourAppUser()
    
    public func toJsonObject() -> Dictionary<String, Any>? {
        ["userId":self.userId,"nickname":self.nickname,"avatarURL":self.avatarURL,"identity":self.identity,"gender":self.gender]
    }
    
    @UserDefault("ChatroomUserName", defaultValue: userNames.randomElement() ?? "") public var nickname
    
    @UserDefault("ChatroomUserAvatar", defaultValue: ChatroomRequest.shared.host+"/\(appkeyInfos.first ?? "")/\(appkeyInfos.last ?? "")/chatfiles/"+"\(avatars.randomElement() ?? "")") public var avatarURL
    
    @UserDefault("ChatRoomUserID",defaultValue: generateRandomString(length: 16)) public var userId
        
    public var gender: Int = 1
    
    public var identity: String = "https://accktvpic.oss-cn-beijing.aliyuncs.com/pic/sample_avatar/sample_avatar_6.png"//user level picture url
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
    
}


//class NetworkHelper {
//
//    class func isNetworkAvailable() -> Bool {
//
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
//                SCNetworkReachabilityCreateWithAddress(nil, $0)
//            }
//        }) else {
//            return false
//        }
//
//        var flags: SCNetworkReachabilityFlags = []
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
//            return false
//        }
//
//        let isReachable = flags.contains(.reachable)
//        let connectionRequired = flags.contains(.connectionRequired)
//
//        return isReachable && !connectionRequired
//    }
//}
