import axios from "axios";
const host = "";
export const getToken = (userId: string, nickname: string, avatar: string) => {
  return axios.post(`${host}/liverooms/user/login`, {
    username: userId,
    icon_key: avatar,
    nickname,
  });
};

export const createChatroom = (chatroomName: string, ownerId: string) => {
  const token = sessionStorage.getItem("chatroom-token");
  return axios.post(
    `${host}/liverooms`,
    {
      name: chatroomName,
      owner: ownerId,
    },
    {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    }
  );
};

export const getChatroomList = () => {
  const token = sessionStorage.getItem("chatroom-token");
  return axios.get(`${host}/liverooms`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
};

export const deleteChatroom = (roomId: string) => {
  const token = sessionStorage.getItem("chatroom-token");
  return axios.delete(`${host}/liverooms/${roomId}`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
};
