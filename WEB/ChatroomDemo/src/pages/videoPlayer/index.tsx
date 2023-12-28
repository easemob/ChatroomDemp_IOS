import React, { useEffect, useRef, useContext } from "react";
import { Avatar, Collapse, Header, Icon } from "easemob-chat-uikit";
import "./index.css";
import video from "../../video/xuanchuan2.mp4";
import { ChatroomContext } from "../../context";
import ThemeSwitch from "./themeSwitch";
interface VideoPlayerProps {
  onChatClick: () => void; // 点击聊天按钮
  onThemeChange: (type: "sun" | "moon") => void; // 点击切换主题
}
const VideoPlayer = (props: VideoPlayerProps) => {
  const { onChatClick, onThemeChange } = props;
  const videoRef = useRef<HTMLVideoElement>(null);
  const context = useContext(ChatroomContext);

  useEffect(() => {
    if (!context.chatroomId) {
      return;
    }
    // videoRef?.current?.click();
    setTimeout(() => {
      videoRef.current && (videoRef.current.currentTime = 0);
      videoRef?.current?.play();
    }, 100);
  }, [context.chatroomId]);
  return (
    <div>
      <Header
        content={context.chatroomInfo?.name || ""}
        subtitle={context.chatroomInfo?.nickname}
        // avatarSrc={context.chatroomInfo?.iconKey}
        avatar={
          context.chatroomInfo?.iconKey ? (
            <Avatar
              src={context.chatroomInfo?.iconKey}
              style={{ marginRight: 12 }}
            ></Avatar>
          ) : (
            <></>
          )
        }
        suffixIcon={
          <div className="header-icon-box">
            <ThemeSwitch onChange={onThemeChange}></ThemeSwitch>
            {!context.chatPanelVisible && (
              <div title="聊天" style={{ display: "flex", cursor: "pointer" }}>
                <Icon
                  type="BUBBLE_FILL"
                  color={context.theme == "moon" ? "#E3E6E8" : "#464E53"}
                  onClick={onChatClick}
                  width={24}
                  height={24}
                ></Icon>
              </div>
            )}
          </div>
        }
      />
      <div className="video-container">
        {context.chatroomId && <video src={video} loop ref={videoRef}></video>}
      </div>
    </div>
  );
};

export default VideoPlayer;
