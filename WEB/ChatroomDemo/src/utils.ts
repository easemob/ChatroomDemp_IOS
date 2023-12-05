import cover1 from "./assets/cover1.png";
import cover2 from "./assets/cover2.png";
import cover3 from "./assets/cover3.png";
import cover4 from "./assets/cover4.png";
import cover5 from "./assets/cover5.png";
import cover6 from "./assets/cover6.png";
import cover7 from "./assets/cover7.png";
import cover8 from "./assets/cover8.png";
import cover9 from "./assets/cover9.png";
import cover10 from "./assets/cover10.png";

export function generateRandomId(): string {
  const characters: string = "abcdefghijklmnopqrstuvwxyz0123456789";
  let randomId: string = "";

  for (let i = 0; i < 16; i++) {
    const randomIndex: number = Math.floor(Math.random() * characters.length);
    randomId += characters.charAt(randomIndex);
  }

  return randomId;
}

const avatarIds = [
  "fc14ab00-79f7-11ee-93f4-618a64affe88",
  "7345d230-79f8-11ee-a0d1-5f74d88fa308",
  "7d239bc0-79f8-11ee-92b9-770b4e48f8fc",
  "8e208410-79f8-11ee-b8e3-232a619cf52c",
  "99296020-79f8-11ee-8475-c7a7b59db79f",
  "a27bd9a0-79f8-11ee-8f83-551faec94303",
  "ae308610-79f8-11ee-a6c9-5379b9a705a1",
  "b837f7b0-79f8-11ee-b817-23850e48ca47",
  "c0d52af0-79f8-11ee-a6ed-6fc3a8bc6581",
  "c8354a50-79f8-11ee-97b9-0d7ccd9e7127",
  "d2b176c0-79f8-11ee-a291-ed6692473990",
  "de41f960-79f8-11ee-83cd-db9df9bad9bf",
  "e7517670-79f8-11ee-a783-c1d7a432abb7",
  "ef5724a0-79f8-11ee-8290-eb9f9e9c2195",
  "f78da6d0-79f8-11ee-b3b8-3b446ebd1fbb",
  "ffb9efd0-79f8-11ee-9356-ef4cfe1f2af8",
  "07d98ea0-79f9-11ee-8047-d35f49238254",
  "0fa12260-79f9-11ee-890f-67aacef20d88",
  "16bc4980-79f9-11ee-b272-3568dd301252",
  "208dde10-79f9-11ee-b9ea-5bff48db7458",
  "298c9240-79f9-11ee-b8b6-f16f0b5f700a",
];

export function generateAvatarKey(): string {
  const index = Math.floor(Math.random() * 20) + 1;
  return `https://a1.easemob.com/easemob/chatroom-uikit/chatfiles/${avatarIds[index]}`;
}

const nicknames = [
  "左冷禅",
  "朱聪",
  "拜月",
  "周伯通",
  "钟阿四",
  "郑长老",
  "张五侠",
  "张三丰",
  "掌灯",
  "张翠山",
  "岳不群",
  "月白",
  "袁冠南",
  "袁承志",
  "预姚春",
  "余观主",
  "殷天正",
  "尹克西",
  "仪琳",
  "耶律楚材",
  "杨铁心",
  "杨过",
  "杨成协",
  "玄慈大师",
  "虚竹",
  "许仕枫",
  "心如止水",
  "谢逊",
  "逍遥子",
  "小龙女",
  "笑蓝春",
  "笑傲江湖",
  "香香公主",
  "侠义",
  "夏雪宜",
  "夏冰",
  "无崖子",
  "五绝",
  "文泰来",
  "韦小宝",
  "魏无极",
  "王处一",
  "铁心兰",
  "田归农",
  "田伯光",
  "宋青书",
  "双儿",
  "神雕",
  "少庄主",
  "伤心",
  "伤人",
  "扫地僧",
  "蓉儿",
  "任盈盈",
  "任我行",
  "裘千仞",
  "丘处机",
  "欧阳克",
  "欧阳峰",
  "女儿村",
  "聂夫人",
  "南师翁",
  "木婉清",
  "慕容复",
  "慕容博",
  "穆念慈",
  "苗人凤",
  "迷途",
  "梦醉",
  "孟铮",
  "孟英霆",
  "孟星魂",
  "孟天明",
  "孟天白",
  "孟清泉",
  "孟缦",
  "梦郎",
  "梦姑",
  "孟方",
  "孟川",
  "孟陈露",
  "梅超风",
  "乱世",
  "陆无双",
  "鹿清笃",
  "陆乘风",
  "龙儿",
  "龙岛主",
  "柳无眉",
  "柳绘心",
  "令狐冲",
  "林平之",
  "梁子翁",
  "练霓裳",
  "李逍遥",
  "李文秀",
  "李萍",
  "老毒物",
  "蓝凤凰",
  "看昨夜东风",
  "金轮法王",
  "霍都",
  "黄药师",
  "黄头陀",
  "黄裳",
  "黄衫女子",
  "黄蓉",
  "黄梅",
  "黄老邪",
  "画眉",
  "胡青牛",
  "忽伦大虎",
  "红袖",
  "洪七公",
  "洪凌波",
  "郭破虏",
  "郭靖",
  "郭芙",
  "归辛树",
  "格老子",
  "葛光佩",
  "高则全",
  "风清扬",
  "风良",
  "风波恶",
  "范遥",
  "法轮",
  "二乔",
  "阿紫",
  "阿朱",
  "阿柯",
  "阿碧",
  "段正淳",
  "段誉",
  "段延庆",
  "毒手草",
  "独孤求败",
  "独孤剑",
  "东方不败",
  "狄云",
  "刀白凤",
  "褚轰",
  "程英",
  "程瑶迦",
  "程功",
  "避邪",
  "白展堂",
  "白面",
  "白长老",
  "巴圆",
  "花无缺",
];

export function generateNickname(): string {
  const index = Math.floor(Math.random() * 150);
  return nicknames[index];
}
const coverMap: {
  [key: string]: string;
} = {};
export function generateCover(id: string): string {
  if (coverMap[id]) return coverMap[id];
  const covers = [
    cover1,
    cover2,
    cover3,
    cover4,
    cover5,
    cover6,
    cover7,
    cover8,
    cover9,
    cover10,
  ];
  const index = Math.floor(Math.random() * 10);
  coverMap[id] = covers[index];
  return covers[index];
}

export function isMobileDevice() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
    navigator.userAgent
  );
}
