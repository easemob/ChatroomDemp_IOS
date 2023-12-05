import React from "react";
import ChatroomList, { ChatroomInfo } from "./pages/chatroomList";
export interface ContextProps {
  token: string;
  chatroomId?: string;
  theme: "sun" | "moon";
  userInfo: {
    userId: string;
    nickname: string;
    avatarKey: string;
  };
  chatroomInfo?: ChatroomInfo;
  chatPanelVisible?: boolean;
}

export const ChatroomContext = React.createContext<ContextProps>({
  token: "",
  chatroomId: "",
  theme: "sun",
  userInfo: {
    userId: "",
    nickname: "",
    avatarKey: "",
  },
  chatroomInfo: {} as ChatroomInfo,
  chatPanelVisible: true,
});

export const ChatroomProvider = ChatroomContext.Provider;
