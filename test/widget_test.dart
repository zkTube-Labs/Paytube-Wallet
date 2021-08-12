// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/pages/app.dart';
import 'package:flutter_coinid/utils/instruction_data_format.dart';
import 'package:flutter_coinid/utils/json_util.dart';
import 'package:flutter_coinid/utils/log_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_coinid/main.dart';
import '../lib/utils/string_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  test("模型转换", () {
    // CurrencyMarketModel model = CurrencyMarketModel.fromJson(markJson);
    // print(model);
    // Map json = model.toJson();
    // print(json);
    // print("map to string" + json.toString());
    // print("instance to string " + model.toString());
    String str = "172.193.179.9222:80";
    if (StringUtil.isValidIp(str.replaceAll("https://", ""))) {
      print("==true1==");
    }

    if (StringUtil.isValidIpAndPort(str.replaceAll("https://", ""))) {
      print("==true2==");
    }

    if (StringUtil.isValidUrl(str)) {
      print("==true3==");
    }
  });

  test("数据测试", () async {
    // Map jsonMap = {"a": "ccc"};

    // String json = jsonEncode(jsonMap);
    // print(json);

    // json =
    //     "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    // print(json.codeUnits); //68 65 6c 6c 6f
    // [123, 34, 97, 34, 58, 34, 99, 99, 99, 34, 125]
    // 7b    22  61 223a22636363227d
    // List<String> hexString = InstructionDataFormat.intParseHex("427000000");
    // List hexData = List.filled(32, "00", growable: true);
    // hexData.replaceRange(hexData.length - hexString.length, hexData.length, hexString);
    // print(hexData.join(""));

    // ETHAbiModel model1 = ETHAbiModel(
    //     addrType: true, value: "da0bfae3e3ccfd8238fba9d18120ab6ca70fb0b1");
    // ETHAbiModel model2 = ETHAbiModel(numberType: true, value: "427000000");

    // print("object  " + ETHAbiModel.abiDataWithAbiModel([model1, model2]));

    String balance = "14.000000 VNS";

    String a = "1";
    balance = balance.replaceAll(" ", "").replaceAll("VNS", "");
    int decimal = balance.length - balance.lastIndexOf(".") - 1;
    print("decimal " + decimal.toString());
    String newA = double.tryParse(a)!.toStringAsFixed(decimal);
    print("newA $newA  decimal $decimal balance $balance");
  });

//   test('数据库测试', () async {
//     final database = await $FloorFlutterDatabase
//         .databaseBuilder('flutter_database.db')
// //        .addCallback(callback)
// //        .addMigrations([migration1to2])
//         .build();
//     NodeDao nodeData = database.nodeDao;

//     NodeModel model = NodeModel("0",
//         content: "http://www.baidu.com",
//         chainType: 3,
//         isChoose: true,
//         isOrigin: true,
//         netType: 1);

//     nodeData.insertNodeData(model);
//   });

  test("description", () {
    Map json = {
      "data": [
        {
          "type": "devices",
          "id": "NKMFUXRZ28",
          "attributes": {
            "addedDate": "2019-06-25T02:41:18.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "iphone",
            "deviceClass": "IPHONE",
            "model": "iPhone 5 (Model A1428)",
            "udid": "632c7c6ab4004f1bbb2602326086c6c53f7ab553",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/NKMFUXRZ28"
          }
        },
        {
          "type": "devices",
          "id": "H4GZ8WF865",
          "attributes": {
            "addedDate": "2019-06-25T02:41:35.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "iphone",
            "deviceClass": "IPHONE",
            "model": "iPhone 5 (Model A1429)",
            "udid": "ece7553de7cd7d0129db8d9cb44746076040bdf7",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/H4GZ8WF865"
          }
        },
        {
          "type": "devices",
          "id": "4Y4JP5ZRA6",
          "attributes": {
            "addedDate": "2019-10-10T11:00:06.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "iPhone",
            "deviceClass": "IPHONE",
            "model": "iPhone 6s",
            "udid": "02d593e20aada5c441220bfb9b1b614a929d312d",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/4Y4JP5ZRA6"
          }
        },
        {
          "type": "devices",
          "id": "35H9N9K73R",
          "attributes": {
            "addedDate": "2019-06-25T02:42:08.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "lhf01",
            "deviceClass": "IPHONE",
            "model": "iPhone 7 Plus",
            "udid": "b2079e1629194a62ad2684fc8ebee2cdc74edf82",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/35H9N9K73R"
          }
        },
        {
          "type": "devices",
          "id": "QN8M6D4QGD",
          "attributes": {
            "addedDate": "2020-06-19T06:42:29.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "liningning",
            "deviceClass": "IPHONE",
            "model": null,
            "udid": "00008030-000E59960C85802E",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/QN8M6D4QGD"
          }
        },
        {
          "type": "devices",
          "id": "F73ULYP26P",
          "attributes": {
            "addedDate": "2019-06-25T02:45:53.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "LIU CEO",
            "deviceClass": "IPHONE",
            "model": "iPhone 7",
            "udid": "63e2fe630b84c332fe91200099fd30f222600dfa",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/F73ULYP26P"
          }
        },
        {
          "type": "devices",
          "id": "GSV6B767XN",
          "attributes": {
            "addedDate": "2019-06-25T02:38:35.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "oufang",
            "deviceClass": "IPHONE",
            "model": "iPhone 7 Plus",
            "udid": "022d3ea051226ccbe08f5d992077d2b1f9fee419",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/GSV6B767XN"
          }
        },
        {
          "type": "devices",
          "id": "TJ6U646DMB",
          "attributes": {
            "addedDate": "2020-06-17T09:19:01.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "peng",
            "deviceClass": "IPHONE",
            "model": "iPhone 7 Plus",
            "udid": "a8430a51141478803313eee29bb1578c82d86c09",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/TJ6U646DMB"
          }
        },
        {
          "type": "devices",
          "id": "76NTT5HF4H",
          "attributes": {
            "addedDate": "2020-04-01T02:31:14.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "pm-wmp",
            "deviceClass": "IPAD",
            "model": "iPad mini (5th generation)",
            "udid": "00008020-000A25DC2EF9002E",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPad"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/76NTT5HF4H"
          }
        },
        {
          "type": "devices",
          "id": "6Z9Q2RXQFS",
          "attributes": {
            "addedDate": "2019-06-25T02:44:46.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "pm-x",
            "deviceClass": "IPHONE",
            "model": "iPhone XR",
            "udid": "00008020-00032D2A22FA002E",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/6Z9Q2RXQFS"
          }
        },
        {
          "type": "devices",
          "id": "3AF83QYLQD",
          "attributes": {
            "addedDate": "2019-06-25T02:45:05.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "test",
            "deviceClass": "IPHONE",
            "model": "iPhone 6",
            "udid": "ef74cfb8c0bf846ec54341930c0825eacd7b5b3b",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/3AF83QYLQD"
          }
        },
        {
          "type": "devices",
          "id": "6W4376KMGK",
          "attributes": {
            "addedDate": "2019-06-25T02:45:20.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "test",
            "deviceClass": "IPHONE",
            "model": "iPhone X",
            "udid": "72edceaa42c2daed604527145c11438e196cf7b5",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/6W4376KMGK"
          }
        },
        {
          "type": "devices",
          "id": "YQSPHH77ND",
          "attributes": {
            "addedDate": "2020-01-06T02:28:59.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "test",
            "deviceClass": "IPHONE",
            "model": "iPhone XS",
            "udid": "00008020-000829E80AD1002E",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/YQSPHH77ND"
          }
        },
        {
          "type": "devices",
          "id": "M537PM4M7L",
          "attributes": {
            "addedDate": "2019-06-25T02:46:12.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "UI",
            "deviceClass": "IPHONE",
            "model": "iPhone 6s Plus",
            "udid": "3b64e6c32a55ba8b5d2a296fc1eec638affe81f9",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/M537PM4M7L"
          }
        },
        {
          "type": "devices",
          "id": "JBV5YXZ4V6",
          "attributes": {
            "addedDate": "2019-12-12T02:06:26.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "wangyangping",
            "deviceClass": "IPHONE",
            "model": "iPhone XS",
            "udid": "00008020-001531EE3A90003A",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/JBV5YXZ4V6"
          }
        },
        {
          "type": "devices",
          "id": "GZV2S55FS8",
          "attributes": {
            "addedDate": "2020-07-22T08:33:55.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "Wind iPhone",
            "deviceClass": "IPHONE",
            "model": "iPhone 11",
            "udid": "00008030-000238300AD3802E",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/GZV2S55FS8"
          }
        },
        {
          "type": "devices",
          "id": "L8YLCF6JGB",
          "attributes": {
            "addedDate": "2019-06-27T03:38:16.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "Wind's iPhone",
            "deviceClass": "IPHONE",
            "model": "iPhone 7",
            "udid": "5a68a0ce755cbcb65ee9e47c0653e3ae5c8b7d0a",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/L8YLCF6JGB"
          }
        },
        {
          "type": "devices",
          "id": "K9LBD28HGS",
          "attributes": {
            "addedDate": "2019-06-25T02:40:18.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "xinye",
            "deviceClass": "IPHONE",
            "model": "iPhone 6s Plus",
            "udid": "0bee9b162771e39232540ee14ba8b12c958ae6e2",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/K9LBD28HGS"
          }
        },
        {
          "type": "devices",
          "id": "5R54K9L76A",
          "attributes": {
            "addedDate": "2020-06-23T07:58:12.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "zahng",
            "deviceClass": "IPHONE",
            "model": "iPhone 6s Plus",
            "udid": "27180dd12dee3859c9f3b288e2b6aadf0d390b7e",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/5R54K9L76A"
          }
        },
        {
          "type": "devices",
          "id": "2D229736YK",
          "attributes": {
            "addedDate": "2019-06-24T02:51:12.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "何海月的 iPhone",
            "deviceClass": "IPHONE",
            "model": "iPhone 6",
            "udid": "04517d058321b5c7cc14aac8f842d177d7614317",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/2D229736YK"
          }
        },
        {
          "type": "devices",
          "id": "TXSDTW4W5Z",
          "attributes": {
            "addedDate": "2020-03-09T02:43:21.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "家庆",
            "deviceClass": "IPHONE",
            "model": "iPhone XR",
            "udid": "00008020-00167021018A002E",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/TXSDTW4W5Z"
          }
        },
        {
          "type": "devices",
          "id": "ZS44CVMTK5",
          "attributes": {
            "addedDate": "2019-06-27T02:41:42.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "敏锐的高颜值人事",
            "deviceClass": "IPHONE",
            "model": "iPhone 7",
            "udid": "ecb1a3c5922e0d7232c3fc3bfe6656bdf963dec5",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/ZS44CVMTK5"
          }
        },
        {
          "type": "devices",
          "id": "7WC65XT87H",
          "attributes": {
            "addedDate": "2020-02-19T02:32:05.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "李少聪",
            "deviceClass": "IPHONE",
            "model": "iPhone 7",
            "udid": "20077142139b633b1a064c9f72f05eec85e3afe5",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/7WC65XT87H"
          }
        },
        {
          "type": "devices",
          "id": "79F4XL2MNS",
          "attributes": {
            "addedDate": "2019-06-24T07:11:39.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "林牧的 iPhone",
            "deviceClass": "IPHONE",
            "model": "iPhone X",
            "udid": "eb26479d74109463cd5d855a92e1aff086f1cd0b",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/79F4XL2MNS"
          }
        },
        {
          "type": "devices",
          "id": "8Q35LF779Q",
          "attributes": {
            "addedDate": "2019-06-24T02:31:24.000+0000",
            "serialNumber": null,
            "description": null,
            "platform": "IOS",
            "name": "粟立嘉的 iPhone",
            "deviceClass": "IPHONE",
            "model": "iPhone 6",
            "udid": "f9b1086cef7f8a3ac15bbea269d16cc2fb4f7ce6",
            "platformName": "iOS",
            "responseId": "ceb30710-3bde-440c-be36-3739b734b403",
            "status": "ENABLED",
            "devicePlatformLabel": "iPhone"
          },
          "links": {
            "self":
                "https://developer.apple.com:443/services-account/v1/devices/8Q35LF779Q"
          }
        }
      ],
      "links": {
        "self":
            "https://developer.apple.com:443/services-account/v1/devices?sort=name&limit=1000"
      },
      "meta": {
        "paging": {"total": 25, "limit": 1000}
      }
    };

    List list = json["data"];
    list.forEach((element) {
      Map attributes = element["attributes"];
      String? udid = attributes["udid"];
      String name = attributes["name"];
      name = name.replaceAll(" ", "");
      String platform = attributes["platform"];
      platform = platform.toLowerCase();

      print("<dict><key>devicePlatform</key>" +
          "<string>$platform</string>" +
          "<key>deviceIdentifier</key><string>$udid</string>" +
          "<key>deviceName</key><string>$name</string></dict>");
    });
  });

  test("code", () async {
    // String pwd = "1234qwer";
    // pwd = ",,,,,,1,";
    // LogUtil.v("object " + pwd.checkPassword().toString());
    // data = await assetLoader.load(path, Locale(locale.languageCode))

    // String a = await rootBundle.loadString("resources/langs/en-US.json");

    // String b = await rootBundle.loadString("resources/langs/zh-CN.json");

    // Map en = JsonUtil.getObj(a.toString());
    // Map cn = JsonUtil.getObj(b.toString());

    // Map newmap = Map();
    // cn.forEach((key, value) {
    //   if (!en.containsKey(key)) {
    //     newmap[key] = "";
    //   }
    // });
    // LogUtil.v(newmap);

    Map json = {
      "receipt-data":
          "MIITrQYJKoZIhvcNAQcCoIITnjCCE5oCAQExCzAJBgUrDgMCGgUAMIIDTgYJKoZIhvcNAQcBoIIDPwSCAzsxggM3MAoCAQgCAQEEAhYAMAoCARQCAQEEAgwAMAsCAQECAQEEAwIBADALAgELAgEBBAMCAQAwCwIBDwIBAQQDAgEAMAsCARACAQEEAwIBADALAgEZAgEBBAMCAQMwDAIBCgIBAQQEFgI0KzAMAgEOAgEBBAQCAgDlMA0CAQ0CAQEEBQIDAiRwMA0CARMCAQEEBQwDMS4wMA4CAQMCAQEEBgwEMTI0NDAOAgEJAgEBBAYCBFAyNTYwGAIBAgIBAQQQDA5jb20ubGVrYWkuZHN3dzAYAgEEAgECBBAX5LI42L+7QINRlHsVLSLsMBsCAQACAQEEEwwRUHJvZHVjdGlvblNhbmRib3gwHAIBBQIBAQQU+pgwS6EjKuOYhQR2DPbTywluDVQwHgIBDAIBAQQWFhQyMDIxLTAzLTA4VDA1OjMwOjAyWjAeAgESAgEBBBYWFDIwMTMtMDgtMDFUMDc6MDA6MDBaMDMCAQcCAQEEKxvMGbdcWYNvE/ygTIVyrE/9I5sF4L1sl4pF/KQyrZb2ejM9CaYJhNgYgQ0wQAIBBgIBAQQ4d9Dl8YfLkLh2c9H7K1NyydB1m2MchBHU+PB0Ds9clRjrgrKhsjmgdRH3WaHWRDJtRV+ZqCTjkN0wggFaAgERAgEBBIIBUDGCAUwwCwICBqwCAQEEAhYAMAsCAgatAgEBBAIMADALAgIGsAIBAQQCFgAwCwICBrICAQEEAgwAMAsCAgazAgEBBAIMADALAgIGtAIBAQQCDAAwCwICBrUCAQEEAgwAMAsCAga2AgEBBAIMADAMAgIGpQIBAQQDAgEBMAwCAgarAgEBBAMCAQEwDAICBq4CAQEEAwIBADAMAgIGrwIBAQQDAgEAMAwCAgaxAgEBBAMCAQAwGwICBqcCAQEEEgwQMTAwMDAwMDc4NTY"
    };

    String aaa =
        "MIIT0wYJKoZIhvcNAQcCoIITxDCCE8ACAQExCzAJBgUrDgMCGgUAMIIDdAYJKoZIhvcNAQcBoIIDZQSCA2ExggNdMAoCAQgCAQEEAhYAMAoCARQCAQEEAgwAMAsCAQECAQEEAwIBADALAgELAgEBBAMCAQAwCwIBDwIBAQQDAgEAMAsCARACAQEEAwIBADALAgEZAgEBBAMCAQMwDAIBCgIBAQQEFgI0KzAMAgEOAgEBBAQCAgDlMA0CAQ0CAQEEBQIDAiRwMA0CARMCAQEEBQwDMS4wMA4CAQMCAQEEBgwEMTI0NDAOAgEJAgEBBAYCBFAyNTYwGAIBAgIBAQQQDA5jb20ubGVrYWkuZHN3dzAYAgEEAgECBBAZgJA2Uz9Px6sZeSRRwFfHMBsCAQACAQEEEwwRUHJvZHVjdGlvblNhbmRib3gwHAIBBQIBAQQUnqgcDa+Ass9HIvAMjIhC+rLxh1owHgIBDAIBAQQWFhQyMDIxLTAzLTA4VDA1OjU3OjI2WjAeAgESAgEBBBYWFDIwMTMtMDgtMDFUMDc6MDA6MDBaMEMCAQcCAQEEOwKYoGRLg3tnd3lvrPfKLAbMf1gaVopVqhbEn1tpIGHX+TvAAYX2FEmL/t7yfgb4ozRFT0HTlEjc8aOmMFYCAQYCAQEETiTf3HTBHYJn0wNyZPpchFI10plM4RnTRGFzk4bQ5WNvvBwIQRuiAB/eUo8fQnhw4USnGHQiX/R3DLkKd/SDkY7Iw8VU7o+vGmbSsdwE3DCCAVoCARECAQEEggFQMYIBTDALAgIGrAIBAQQCFgAwCwICBq0CAQEEAgwAMAsCAgawAgEBBAIWADALAgIGsgIBAQQCDAAwCwICBrMCAQEEAgwAMAsCAga0AgEBBAIMADALAgIGtQIBAQQCDAAwCwICBrYCAQEEAgwAMAwCAgalAgEBBAMCAQEwDAICBqsCAQEEAwIBATAMAgIGrgIBAQQDAgEAMAwCAgavAgEBBAMCAQA";
    List datas = utf8.encode(aaa);

    print(datas);
  });
}
