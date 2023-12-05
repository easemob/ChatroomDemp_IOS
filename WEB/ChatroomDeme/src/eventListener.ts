import { rootStore } from "chatuim2";
// import { ToastContainer, toast } from "react-toastify";
import toast, { Toaster } from "react-hot-toast";

const addEventHandler = () => {
  rootStore.client.addEventHandler("chatroom", {
    onError: handleError,
  });
};

const handleError = (error: any) => {
  console.log("error *****", error);

  if (error.type === 705 && error.message === "The chat room dose not exist.") {
    toast("聊天室不存在");
  }
};

export { addEventHandler, handleError };
