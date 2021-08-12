// //解析扫码结果

// import 'package:flutter_coinid/public.dart';

// class ScanResulObjects {
//   int chainType; //链的类型
//   int status; //错误状态

//   //交易的时候赋值
//   String token;
//   String to;
//   String contract;
//   int decimals;

//   //EOS注册的时候赋值
//   String name;
//   String activePublic;
//   String ownerPublic;

//   ScanResulObjects(
//       {this.chainType,
//       this.status,
//       this.token,
//       this.to,
//       this.contract,
//       this.decimals,
//       this.name,
//       this.activePublic,
//       this.ownerPublic});
// }

// class ScanResultUtils {
//   static ScanResulObjects disposeQRCode(String codeResult, int chainType) {
//     LogUtil.v("解析二维码字符串为：$codeResult");
//     if (_disposeChainType(codeResult) == 99) {
//       //没有头部的内容，直接返回
//       ScanResulObjects scanResulObjects = new ScanResulObjects(
//           chainType: chainType,
//           status: MQRStatusCode.MQRStatusCode_Dispose_Err.index);
//       return scanResulObjects;
//     } else if (_disposeChainType(codeResult) != chainType) {
//       //头部的内容类型和当前链不匹配的，直接返回
//       ScanResulObjects scanResulObjects = new ScanResulObjects(
//           chainType: chainType,
//           status: MQRStatusCode.MQRStatusCode_Type_Err.index);
//       return scanResulObjects;
//     } else if (MCoinType.MCoinType_ETH.index == chainType) {
//       return _disposeEth(codeResult, chainType);
//     }
//   }

//   static ScanResulObjects _disposeEos(String result, int chainType) {
//     ScanResulObjects scanResulObjects = new ScanResulObjects(
//         chainType: chainType,
//         status: MQRStatusCode.MQRStatusCode_Dispose_Err.index);
//     if (result.startsWith("eos:new_eos_account-?")) {
//       //eos:new_eos_account-?ownerKey=EOS66Z6TJtX1e2X8fkjhE6UVmbH3PqMtneggtUQwn4wk7tBqr5JHA&accountName=dmjadmjtwmja&activeKey=EOS52nEhNMfSbSGUcFrtoHs5YqE29zmGNVRoggAYihgonRzez1mDS
//       String account = "", activePublic = "", ownerPublic = "";
//       List<String> strings = result.split("\\?");
//       if (strings != null) {
//         for (String string in strings) {
//           List<String> params = string.split("&");
//           if (params != null) {
//             for (String param in params) {
//               if (param.contains("ownerKey")) {
//                 ownerPublic = param.split("=")[1];
//               }
//               if (param.contains("accountName")) {
//                 account = param.split("=")[1];
//               }
//               if (param.contains("activeKey")) {
//                 activePublic = param.split("=")[1];
//               }
//             }
//           }
//         }

//         if (account != null &&
//             account.length > 0 &&
//             activePublic != null &&
//             activePublic.length > 0 &&
//             ownerPublic != null &&
//             ownerPublic.length > 0) {
//           scanResulObjects = new ScanResulObjects(
//               chainType: chainType,
//               status: MQRStatusCode.MQRStatusCode_Success.index,
//               name: account,
//               activePublic: activePublic,
//               ownerPublic: ownerPublic);
//         }
//       }
//     } else if (result.startsWith("eos")) {
//       //eos:txwknzm3hz4b?contractAddress=EOS%40eosio.token&decimal=0&value=0
//       List<String> strings = result.split("\\?");
//       if (strings != null && strings.length == 2) {
//         List<String> accounts = strings[0].split(":");
//         List<String> params = strings[1].split("&");

//         String account = accounts[1], contractAddress = "", token = "";
//         for (int i = 0; i < 3; i++) {
//           if (params[i].contains("contractAddress")) {
//             String temp = params[i].split("=")[1];
//             //EOS%40eosio.token
//             token = temp.split("%")[0];
//             contractAddress = temp.split("%")[1].substring(2);
//           }
//         }

//         if (account != null &&
//             account.length > 0 &&
//             contractAddress != null &&
//             contractAddress.length > 0 &&
//             token != null &&
//             token.length > 0) {
//           scanResulObjects = new ScanResulObjects(
//               chainType: chainType,
//               status: MQRStatusCode.MQRStatusCode_Success.index,
//               contract: contractAddress,
//               token: token,
//               to: account);
//         }
//       }
//     }
//     return scanResulObjects;
//   }

//   static ScanResulObjects _disposeEth(String result, int chainType) {
//     ScanResulObjects scanResulObjects = new ScanResulObjects(
//         chainType: chainType,
//         status: MQRStatusCode.MQRStatusCode_Dispose_Err.index);
//     if (result.startsWith("ethereum") || result.startsWith("vns")) {
//       //主币，decimal不需要传值
//       if (!result.contains("contractAddress")) {
//         // ethereum:0x7Fe03b447b29E5dE274f14F36097C29699bd236e?decimal=18&value=0
//         // vns:0x7Fe03b447b29E5dE274f14F36097C29699bd236e?decimal=18&value=0
//         // ethereum:0xb9af7a63b5fcef11c35891ef033dec6db7a4562b&decimal=18&value=0
//         // vns:0xb9af7a63b5fcef11c35891ef033dec6db7a4562b&decimal=18&value=0
//         if (result.contains("?decimal") || result.contains("&decimal")) {
//           List<String> split = result.split("\\?decimal");
//           if (split == null) {
//             split = result.split("&decimal");
//           }
//           if (split != null) {
//             String account = "";
//             for (int i = 0; i < split.length; i++) {
//               if (split[i].contains("ethereum") || split[i].contains("vns")) {
//                 if (split[i].split(":") != null &&
//                     split[i].split(":").length > 0) {
//                   account = split[i].split(":")[1];
//                 }
//               }
//             }
//             if (account != null && account.length > 0) {
//               scanResulObjects = new ScanResulObjects(
//                   chainType: chainType,
//                   status: MQRStatusCode.MQRStatusCode_Success.index,
//                   contract: "",
//                   decimals: 0,
//                   token: MCoinType.MCoinType_ETH.index == chainType
//                       ? "ETH"
//                       : "VNS",
//                   to: account);
//             }
//           }
//         }
//       } else {
//         //代币，decimal需要传值
//         //例 ethereum:0xb9af7a63b5fcef11c35891ef033dec6db7a4562b?contractAddress=0x0f8c45b896784a1e408526b9300519ef8660209c&decimal=8&value=0&token=XMX
//         //例 vns:0xb9af7a63b5fcef11c35891ef033dec6db7a4562b?contractAddress=0x0f8c45b896784a1e408526b9300519ef8660209c&decimal=8&value=0&token=XMX
//         List<String> params = result.split("&");
//         if (params != null && params.length == 4) {
//           String account = "", decimal = "", contractAddress = "", token = "";
//           for (int i = 0; i < 4; i++) {
//             if (params[i].contains("decimal")) {
//               decimal = params[i].split("=")[1];
//             } else if (params[i].contains("ethereum") ||
//                 params[i].contains("vns")) {
//               String temp = params[i].split(":")[1];
//               account = temp.split("\\?")[0];
//               contractAddress = temp.split("\\?")[1].split("=")[1];
//             } else if (params[i].contains("token")) {
//               token = params[i].split("=")[1];
//             }
//           }

//           if (account != null &&
//               account.length > 0 &&
//               decimal != null &&
//               decimal.length > 0 &&
//               contractAddress != null &&
//               contractAddress.length > 0 &&
//               token != null &&
//               token.length > 0) {
//             scanResulObjects = new ScanResulObjects(
//                 chainType: chainType,
//                 status: MQRStatusCode.MQRStatusCode_Success.index,
//                 contract: contractAddress,
//                 decimals: int.parse(decimal),
//                 token: token,
//                 to: account);
//           }
//         }
//       }
//     }
//     return scanResulObjects;
//   }

//   static ScanResulObjects _disposeBtc(String result, int chainType) {
//     ScanResulObjects scanResulObjects = new ScanResulObjects(
//         chainType: chainType,
//         status: MQRStatusCode.MQRStatusCode_Dispose_Err.index);
//     if (result.startsWith("bitcoin") ||
//         result.startsWith("btm") ||
//         result.startsWith("ltc") ||
//         result.startsWith("bch") ||
//         result.startsWith("dash")) {
//       if (result.contains("?amount")) {
//         List<String> split = result.split("\\?");
//         if (split != null) {
//           String account = "", token = "";
//           for (int i = 0; i < split.length; i++) {
//             if (split[i].contains("bitcoin") ||
//                 split[i].contains("btm") ||
//                 split[i].contains("ltc") ||
//                 split[i].contains("bch") ||
//                 split[i].contains("dash")) {
//               if (split[i].split(":") != null &&
//                   split[i].split(":").length > 0) {
//                 account = split[i].split(":")[1];
//               }
//             }
//           }
//           if (MCoinType.MCoinType_LTC.index == chainType) {
//             token = "LTC";
//           } else if (MCoinType.MCoinType_BTC.index == chainType) {
//             token = "BTC";
//           } else if (MCoinType.MCoinType_BTM.index == chainType) {
//             token = "BTM";
//           }
//           if (account != null && account.length > 0) {
//             scanResulObjects = new ScanResulObjects(
//                 chainType: chainType,
//                 status: MQRStatusCode.MQRStatusCode_Success.index,
//                 contract: "",
//                 decimals: 0,
//                 token: token,
//                 to: account);
//           }
//         }
//       } else {
//         //例 bitcoin:1PX7MaEHU4e2Lrv1vSVdYzWBq6chNY6U7Z&decimal=0&value=0
//         //例 btm:1PX7MaEHU4e2Lrv1vSVdYzWBq6chNY6U7Z&decimal=0&value=0
//         List<String> params = result.split("&");
//         if (params != null && params.length == 3) {
//           String account = "", token = "";
//           for (int i = 0; i < 3; i++) {
//             if (params[i].contains("bitcoin") ||
//                 params[i].contains("btm") ||
//                 params[i].contains("ltc") ||
//                 params[i].contains("bch") ||
//                 params[i].contains("dash")) {
//               account = params[i].split(":")[1];
//             }
//           }
//           if (MCoinType.MCoinType_LTC.index == chainType) {
//             token = "LTC";
//           } else if (MCoinType.MCoinType_BTC.index == chainType) {
//             token = "BTC";
//           } else if (MCoinType.MCoinType_BTM.index == chainType) {
//             token = "BTM";
//           }
//           if (account != null && account.length > 0) {
//             scanResulObjects = new ScanResulObjects(
//                 chainType: chainType,
//                 status: MQRStatusCode.MQRStatusCode_Success.index,
//                 contract: "",
//                 decimals: 0,
//                 token: token,
//                 to: account);
//           }
//         }
//       }
//     }
//     return scanResulObjects;
//   }

//   static int _disposeChainType(String result) {
//     if (result.startsWith("ethereum")) {
//       return MCoinType.MCoinType_ETH.index;
//     } else if (result.startsWith("vns")) {
//       return MCoinType.MCoinType_VNS.index;
//     } else if (result.startsWith("eos")) {
//       return MCoinType.MCoinType_EOS.index;
//     } else if (result.startsWith("btc")) {
//       return MCoinType.MCoinType_BTC.index;
//     } else if (result.startsWith("ltc")) {
//       return MCoinType.MCoinType_LTC.index;
//     } else if (result.startsWith("btm")) {
//       return MCoinType.MCoinType_BTM.index;
//     } else {
//       return 99;
//     }
//   }
// }
