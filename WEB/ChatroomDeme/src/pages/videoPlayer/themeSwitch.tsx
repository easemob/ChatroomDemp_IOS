import React, { useState, useContext } from "react";
import { Icon } from "chatuim2";
import { ChatroomContext } from "../../context";
interface ThemeSwitchProps {
  onChange?: (type: "sun" | "moon") => void;
}
const ThemeSwitch = (props: ThemeSwitchProps) => {
  const style = {
    background: "#009EFF",
    borderRadius: "12px",
    width: "24px",
    height: "24px",
    fill: "#F9FAFA",
  };
  const context = useContext(ChatroomContext);
  const { onChange } = props;
  const [activeType, setActiveType] = useState("sun");
  const handleClick = (type: "sun" | "moon") => {
    setActiveType(type);
    onChange?.(type);
  };
  return (
    <div
      className={`themeSwitch-box ${
        context.theme == "moon" ? "theme-dark" : ""
      }`}
    >
      <Icon
        type="SUN"
        width={24}
        height={24}
        onClick={() => {
          handleClick("sun");
        }}
        style={activeType == "sun" ? style : { width: "24px", height: "24px" }}
      ></Icon>
      <Icon
        type="MOON"
        width={24}
        height={24}
        onClick={() => {
          handleClick("moon");
        }}
        style={activeType == "moon" ? style : { width: "24px", height: "24px" }}
      ></Icon>
    </div>
  );
};

export default ThemeSwitch;
