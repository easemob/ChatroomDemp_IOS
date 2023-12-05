import React, {
  useState,
  useEffect,
  Provider,
  useContext,
  useCallback,
} from "react";
import "./App.css";
import { observer } from "mobx-react-lite";
import {
  Icon,
  Chatroom,
  Collapse,
  Header,
  useClient,
  ChatroomMember,
  rootStore,
  Modal,
  Button,
  RootContext,
  Provider as UIKitProvider,
  eventHandler,
} from "chatuim2";
import "chatuim2/style.css";
import ChatroomList, { ChatroomInfo } from "./pages/chatroomList";
import VideoPlayer from "./pages/videoPlayer";
import {
  generateRandomId,
  generateAvatarKey,
  generateNickname,
  isMobileDevice,
} from "./utils";
import { getToken } from "./apis";
// import { addEventHandler } from "./eventListener";
import { ChatroomProvider, ContextProps } from "./context";
import toast, { Toaster } from "react-hot-toast";
import { AgoraChat } from "agora-chat";

function App() {
  const context = useContext(RootContext);
  const [token, setToken] = useState("");
  const [joinedRoomId, setJoinedRoomId] = useState("");
  const [roomInfo, setRoomInfo] = useState<ContextProps["chatroomInfo"]>();
  const [memberPanelVisible, setMemberPanelVisible] = useState(false);
  const [chatPanelVisible, setChatPanelVisible] = useState(!isMobileDevice());
  const [theme, setTheme] = useState<"sun" | "moon">("sun");
  const [userInfo, setUserInfo] = useState<ContextProps["userInfo"]>({
    userId: "",
    nickname: "",
    avatarKey: "",
  });
  const [removedModalOpen, setRemovedModalOpen] = useState(false);
  const [removedModalContent, setRemovedModalContent] =
    useState("你已经被移除直播间");

  useEffect(() => {
    const documentHeight = () => {
      const doc = document.documentElement;
      doc.style.setProperty("--doc-height", `${window.innerHeight}px`);
    };
    window.addEventListener("resize", documentHeight);
    documentHeight();

    const handleError = (error: any) => {
      if (
        error.type == 206 &&
        error.message == "the user is already logged on another device"
      ) {
        toast("当前账号已在其他设备登录");
      }

      if (error.type == 602 && error.message == "not in group or chatroom") {
        toast("消息发送失败，已不在当前直播间");
      }

      if (error.type == 35 && error.message == "not login") {
        toast("没登录");
      }
    };
    eventHandler.addEventHandler("chatroom", {
      onError: handleError,
      joinChatRoom: {
        error: () => {
          toast("直播已结束");
          setJoinedRoomId("");
        },
      },
      recallMessage: {
        success: () => {
          toast.success("撤回成功");
        },
        error: (error) => {
          toast.error("撤回失败");
        },
      },
      reportMessage: {
        success: () => {
          toast.success("举报成功");
        },
        error: (error) => {
          toast.error("举报失败");
        },
      },
      sendMessage: {
        error: (error) => {
          if (error.type == 507) {
            toast.error("你已被禁言，无法发送消息");
          }
        },
      },
    });
  }, []);

  useEffect(() => {
    const doc = document.documentElement;
    doc.style.setProperty("--vh", window.innerHeight * 0.01 + "px");
  }, []);
  const client = useClient();
  useEffect(() => {
    if (Object.keys(client).length === 0) return;

    client &&
      client.addEventHandler("chatroom", {
        onChatroomEvent: (event: AgoraChat.EventData) => {
          if (
            event.operation === "removeMember" ||
            event.operation === "destroy"
          ) {
            setJoinedRoomId("");
            setRemovedModalOpen(true);
            if (event.operation === "removeMember") {
              setRemovedModalContent("你已经被移除直播间");
            } else {
              setRemovedModalContent("直播间已解散");
            }
          }
          if (event.operation === "muteMember") {
            toast.error("你已被禁言");
          }
          if (event.operation === "unmuteMember") {
            toast.success("你已解除禁言");
          }
        },
      });
    // demo 中随机创建一个用户
    const userInfoString = localStorage.getItem("chatroom-userInfo");
    let userInfo: ContextProps["userInfo"];
    if (!userInfoString) {
      userInfo = {
        userId: generateRandomId(),
        nickname: generateNickname(),
        avatarKey: generateAvatarKey(),
      };
      setUserInfo(userInfo);
      localStorage.setItem("chatroom-userInfo", JSON.stringify(userInfo));
    } else {
      userInfo = JSON.parse(userInfoString);
      setUserInfo(userInfo);
    }
    getToken(userInfo.userId, userInfo.nickname, userInfo.avatarKey)
      .then((res) => {
        const token = res.data.access_token;
        setToken(token);
        sessionStorage.setItem("chatroom-token", token);
        if (client.isOpened()) return;
        client &&
          client
            .open({
              user: userInfo.userId,
              accessToken: token,
            })
            .then(() => {
              console.log("登录成功");
              client
                .updateOwnUserInfo({
                  nickname: userInfo.nickname,
                  avatarurl: userInfo.avatarKey,
                  gender: 1,
                })
                .then(() => {
                  console.log("设置成功");
                });
            });
      })
      .catch((err) => {
        toast("登陆失败，请刷新重试");
      });

    return () => {
      client.close();
    };
  }, [client]);

  const handleJoin = (roomInfo: ChatroomInfo) => {
    setJoinedRoomId(roomInfo.id);
    setRoomInfo(roomInfo);
    setMemberPanelVisible(false);
  };
  return (
    <UIKitProvider
      initConfig={{
        appKey: "easemob#chatroom-uikit",
      }}
      local={{
        lng: "zh",
      }}
      theme={{
        mode: theme === "sun" ? "light" : "dark",
      }}
    >
      <ChatroomProvider
        value={{
          token: token,
          userInfo,
          chatroomId: joinedRoomId,
          chatroomInfo: roomInfo,
          theme: theme,
          chatPanelVisible,
        }}
      >
        <div className={`App ${theme == "moon" ? "theme-dark" : ""}`}>
          <div className="channel-list">
            <ChatroomList
              onJoinChatroom={handleJoin}
              leaveChatroom={removedModalOpen}
            />
          </div>
          <div className="video-box">
            <VideoPlayer
              onThemeChange={(type) => {
                setTheme(type);
              }}
              onChatClick={() => {
                setChatPanelVisible(true);
              }}
            />
          </div>
          <div
            className="chat-box"
            style={{
              display:
                memberPanelVisible || !chatPanelVisible ? "none" : "block",
            }}
          >
            <Chatroom
              chatroomId={joinedRoomId}
              renderHeader={() => (
                <div className="uikit-header">
                  <div>
                    <Icon
                      onClick={() => {
                        setChatPanelVisible(false);
                      }}
                      type="VERTICAL_ARROW"
                      style={{
                        transform: "rotate(180deg)",
                        fill: theme == "moon" ? "#E3E6E8" : "#464E53",
                      }}
                      width={24}
                      height={24}
                    ></Icon>
                    聊天室
                  </div>
                  <Icon
                    color={theme == "moon" ? "#E3E6E8" : "#464E53"}
                    type="PERSON_DOUBLE_FILL"
                    onClick={() => {
                      setMemberPanelVisible(true);
                    }}
                  ></Icon>
                </div>
              )}
            />
          </div>
          {memberPanelVisible && (
            <div className="chat-box">
              <ChatroomMember
                chatroomId={joinedRoomId}
                headerProps={{
                  onCloseClick: () => {
                    setMemberPanelVisible(false);
                  },
                  avatar: <></>,
                  content: "聊天室成员",
                }}
              />
            </div>
          )}
          <Toaster />
        </div>
      </ChatroomProvider>
      <Modal
        title="提示"
        open={removedModalOpen}
        onCancel={() => {
          setRemovedModalOpen(false);
        }}
        footer={
          <div>
            <Button
              onClick={() => {
                setRemovedModalOpen(false);
              }}
            >
              确认
            </Button>
          </div>
        }
      >
        <div className="removed-modal">
          <Icon type="EXCLAMATION_MARK_IN_CIRCLE" width={90} height={90}></Icon>{" "}
          {removedModalContent}
        </div>
      </Modal>
    </UIKitProvider>
  );
}

export default observer(App);
