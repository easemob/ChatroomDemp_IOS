// Learn more https://docs.expo.io/guides/customizing-metro
const path = require('path');
const { getDefaultConfig } = require('expo/metro-config');
const exclusionList = require('metro-config/src/defaults/exclusionList');

const source = '/Users/asterisk/Codes/zuoyu/react-native-chat-room';
const pak = require('/Users/asterisk/Codes/zuoyu/ChatroomDemo/rn/ChatroomDemo/node_modules/react-native-chat-room/package.json');

const defaultConfig = getDefaultConfig(__dirname);
const modules = Object.keys({
  ...pak.peerDependencies,
});

const list = [];
list.push(
  ...modules.map(
    (m) => new RegExp(`^${escape(path.join(source, 'node_modules', m))}\\/.*$`)
  )
);
list.push(
  ...modules.map(
    (m) =>
      new RegExp(
        `^${escape(path.join(source, 'example/node_modules', m))}\\/.*$`
      )
  )
);
console.log('test:zuoyu:modes', list);

module.exports = {
  ...defaultConfig,
  
  // !!! This is the part you need to add for test local npm package
  watchFolders: [source],
  resolver: {
    ...defaultConfig.resolver,
    extraNodeModules: {
      // Add your project directories here
      // 'react-native-chat-room': source,
    },
    nodeModulesPaths: [
      '/Users/asterisk/Codes/zuoyu/ChatroomDemo/rn/ChatroomDemo/node_modules',
      `${source}/node_modules`,
    ],
    blacklistRE: exclusionList(list),
  },
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
};
