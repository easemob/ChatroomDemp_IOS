// chatroomList 组件
import React, { useEffect, useContext, useState } from "react";
import { Collapse, Header, Avatar, Button, Icon, Modal } from "chatuim2";
import "./index.css";
import {
  getChatroomList,
  createChatroom as createChatroomApi,
  deleteChatroom,
} from "../../apis";
import { ChatroomContext } from "../../context";
import toast from "react-hot-toast";
import { generateCover } from "../../utils";
export interface ChatroomInfo {
  affiliations_count: number;
  created: number;
  description: string;
  iconKey: string;
  id: string;
  name: string; // chatroom name
  nickname: string; // owner nickname
  owner: string; //owner userId
  persistent: boolean;
  showid: number;
  status: string;
  video_type: string;
}

export interface ChatroomListProps {
  onJoinChatroom: (roomInfo: ChatroomInfo) => void;
  leaveChatroom?: boolean;
}
const ChatroomList = (props: ChatroomListProps) => {
  const { onJoinChatroom, leaveChatroom } = props;
  const context = useContext(ChatroomContext);
  const [chatroomList, setChatroomList] = useState<ChatroomInfo[]>([]);
  const [extend, setExtend] = useState(false);
  const [activeKey, setActiveKey] = useState(0);
  const [isLiving, setIsLiving] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [livingRoomId, setLivingRoomId] = useState("");
  useEffect(() => {
    if (context.token) {
      getChatroomList().then((res) => {
        const roomList = res.data.entities;
        setChatroomList(roomList);

        if (!leaveChatroom) {
          onJoinChatroom(roomList[0]);
          setActiveKey(0);
        }
      });
    }
  }, [context.token, leaveChatroom]);

  useEffect(() => {
    if (leaveChatroom) {
      setActiveKey(-1);
      setIsLiving(false);
    }
  }, [leaveChatroom]);

  const createChatroom = () => {
    const userInfoString = localStorage.getItem("chatroom-userInfo");
    if (!userInfoString) {
      return;
    }
    const userInfo = JSON.parse(userInfoString);
    const chatroomName = `${userInfo.nickname}的聊天室`;
    createChatroomApi(chatroomName, userInfo.userId).then((res) => {
      const chatroomInfo = res.data;
      setChatroomList([chatroomInfo, ...chatroomList]);
      setActiveKey(0);
      setIsLiving(true);
      setLivingRoomId(chatroomInfo.id);
      onJoinChatroom(chatroomInfo);
    });
  };

  const handleJoin = (roomInfo: ChatroomInfo, index: number) => {
    if (isLiving) {
      toast.error("直播中，无法进入其他直播间");
      return;
      return setModalOpen(true);
    }
    setActiveKey(index);
    onJoinChatroom(roomInfo);
  };

  const endLive = () => {
    if (!livingRoomId) {
      return console.warn("no roomId");
    }
    deleteChatroom(livingRoomId).then(() => {
      setIsLiving(false);
      const chatroomListFresh = chatroomList.filter((item) => {
        return item.id !== livingRoomId;
      });
      setChatroomList(chatroomListFresh);
      setModalOpen(false);
      setLivingRoomId("");
    });
  };

  // 展开的列表
  const renderExtend = () => {
    return (
      <div
        className={`chatroom-list-container ${
          context.theme == "moon" ? "theme-dark" : ""
        } `}
      >
        <div className="chatroom-list-extend">
          {chatroomList.map((item, index) => {
            return [
              <div
                key={index}
                className={`list-contracted-item ${
                  activeKey == index ? "active" : ""
                } ${isLiving ? "not-allowed" : ""}`}
              >
                <Avatar
                  src={
                    item.name === "环信聊天室"
                      ? item.iconKey
                      : generateCover(item.name)
                  }
                  shape="square"
                  size={50}
                  style={{ margin: "0 8px" }}
                >
                  {item.name}
                </Avatar>
                <div>
                  <div>{item.name}</div>
                  <div className="item-user">
                    <Avatar src={item.iconKey} size={16}>
                      {item.nickname}
                    </Avatar>
                    <div style={{ marginLeft: "4px" }}>{item.nickname}</div>
                  </div>
                </div>
                {activeKey != index && (
                  <Button
                    type="default"
                    shape="round"
                    className="item-button-join"
                    onClick={() => {
                      handleJoin(item, index);
                    }}
                  >
                    进入
                  </Button>
                )}
              </div>,
            ];
          })}
        </div>
        <div className="chatroom-create-extend">
          <div className="create-user">
            <Avatar src={context.userInfo.avatarKey} size={38}>
              {context.userInfo.nickname}
            </Avatar>
            <div>{context.userInfo.nickname}</div>
          </div>
          {isLiving ? (
            <Button
              shape="round"
              style={{ background: "#FF002B", borderColor: "#FF002B" }}
              type="primary"
              onClick={() => {
                setModalOpen(true);
              }}
              className="create-button"
            >
              <Icon color="#fff" type="POWER"></Icon>
              停止
            </Button>
          ) : (
            <Button
              shape="round"
              type="primary"
              onClick={createChatroom}
              className="create-button"
            >
              <Icon color="#fff" type="VIDEO_CAMERA_PLUS"></Icon>
              创建
            </Button>
          )}
        </div>
      </div>
    );
  };

  // 收缩起来的列表
  const renderContracted = () => {
    return (
      <div className="chatroom-list-container">
        <div className="chatroom-list-contracted">
          {chatroomList.map((item, index) => {
            return [
              <div
                title={item.name}
                key={index}
                className={`list-contracted-item ${
                  activeKey == index ? "active" : ""
                } ${isLiving ? "not-allowed" : ""}`}
                onClick={() => {
                  handleJoin(item, index);
                }}
              >
                <Avatar
                  src={
                    item.name === "环信聊天室"
                      ? item.iconKey
                      : generateCover(item.name)
                  }
                  shape="square"
                  size={50}
                >
                  {item.name}
                </Avatar>
              </div>,
            ];
          })}
        </div>
        <div className="chatroom-create">
          {isLiving ? (
            <Button
              shape="circle"
              style={{ background: "#FF002B", borderColor: "#FF002B" }}
              type="primary"
              onClick={() => {
                setModalOpen(true);
              }}
            >
              <Icon color="#fff" type="POWER"></Icon>
            </Button>
          ) : (
            <Button shape="circle" type="primary" onClick={createChatroom}>
              <Icon color="#fff" type="VIDEO_CAMERA_PLUS"></Icon>
            </Button>
          )}
        </div>
      </div>
    );
  };
  const handleExtend = (extend: boolean) => {
    setExtend(extend);
  };

  const refreshRoomList = () => {
    getChatroomList().then((res) => {
      const roomList = res.data.entities;
      setChatroomList(roomList);
      roomList.forEach((item: any, index: number) => {
        if (item.id === livingRoomId) {
          setActiveKey(index);
        }
      });
      toast.success("列表已刷新", {
        position: "top-center",
      });
    });
  };
  return (
    <div style={{ height: "100%", position: "relative", border: "none" }}>
      {extend ? (
        <div
          className={`roomlist-title ${
            context.theme == "moon" ? "theme-dark" : ""
          }`}
        >
          直播间列表{" "}
          <Icon
            type="SPINNER"
            onClick={refreshRoomList}
            style={{
              cursor: "pointer",
              fill: context.theme == "moon" ? "#E3E6E8" : "#464E53",
            }}
          ></Icon>
        </div>
      ) : null}
      <Collapse
        // expandIcon={<div onClick={() => handleExtend(false)}>123 》 </div>}
        collapsible="icon"
        style={{ height: "100%" }}
        title={
          (extend ? renderExtend() : renderContracted()) as unknown as string
        }
        direction="right"
        onChange={handleExtend}
      />
      <Modal
        title="结束直播"
        okText="确认"
        cancelText="取消"
        open={modalOpen}
        onOk={endLive}
        onCancel={() => {
          setModalOpen(false);
        }}
      >
        <div className="roomlist-modal-content">
          <Icon type="VIDEO_CAMERA_XMARK" width={90} height={90}></Icon>
          你想要结束直播吗?
        </div>
      </Modal>
    </div>
  );
};

export default ChatroomList;
