import 'package:flutter_coinid/channel/channel_memo.dart';
import 'package:flutter_coinid/channel/channel_native.dart';
import 'package:flutter_coinid/channel/channel_wallet.dart';

import '../../public.dart';

class TestNativePage extends StatefulWidget {
  @override
  _TestNativePageState createState() => _TestNativePageState();
}

class _TestNativePageState extends State<TestNativePage> {
  encKeyByAES128CBC() async {
    String? result = await ChannelNative.encKeyByAES128CBC(
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278",
        "123456");
    print("加密结果：$result");
  }

  decKeyByAES128CBC() async {
    String? result = await ChannelNative.decByAES128CBC(
        "40e5bf13ba5b4c5e2221a84ef0b0146f432296517464856d3bc70c5028a3398032a2e6bb2811d2aedb7b6e70e22979653b0a6a8155812874d36f400a1565156a8aa9c340eed3cb29c86c509799fa6479d1fa2544eb2b210af38327810c33cca9783129221c51a823f1f7bc8bfda2d291707ab1dac2a3a898369163b0b0f77332f59a2eeb67d005e1b0a4ae19a9d14eb5da4a0e12b3b801003bd2243dfb66ab2d",
        "123456");
    print("解密结果：$result");
  }

  serializeTranJSON() async {
    String jsonTran =
        "{\"type\":\"spend\",\"asset_id\":\"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\"amount\":41252398000,\"control_program\":\"001485b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"address\":\"bm1qsk6dj6pym7yng0ev7wne7tm3d54ea2sjz5tyxk\",\"spent_output_id\":\"5c4ea4095e62b237941a0c1abd1b83752479756f2e29e3ca1b2de019f8d60e2f\",\"input_id\":\"4f251513b5284a3181e3a231ebc94e6776b3e6b76a2f11344b089c7938210c9d\",\"witness_arguments\":[\"7d1fdd3277855b8aa6679cfb3ad841199725ccd256d932979981b52cc1c7b1bc31adf480449cc15e97aff9c02797d256f9b6b5511c15c47898c54838071a6607\",\"b6fe635369d1d1684bd816826acda171ff96e220d5d1c0c104c244959ff89d94\"],\"transaction_id\":\"6b0af0d7b0f4b58ca4d2f8f8b3020017d60fb7ddfde946ff1c39b2262d683ad8\",\"status_fail\":false,\"io\":0,\"decode_program\":[\"DUP\",\"HASH160\",\"DATA_2085b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"EQUALVERIFY\",\"TXSIGHASH\",\"SWAP\",\"CHECKSIG\"],\"asset_name\":\"BTM\",\"asset_decimals\":\"8\"}";
    Map? map = await ChannelNative.serializeEosTranJSON(jsonTran);
    print(map);
  }

  serializeTranJSONOnly() async {
    String jsonTran =
        "{\"type\":\"spend\",\"asset_id\":\"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\"amount\":41252398000,\"control_program\":\"001485b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"address\":\"bm1qsk6dj6pym7yng0ev7wne7tm3d54ea2sjz5tyxk\",\"spent_output_id\":\"5c4ea4095e62b237941a0c1abd1b83752479756f2e29e3ca1b2de019f8d60e2f\",\"input_id\":\"4f251513b5284a3181e3a231ebc94e6776b3e6b76a2f11344b089c7938210c9d\",\"witness_arguments\":[\"7d1fdd3277855b8aa6679cfb3ad841199725ccd256d932979981b52cc1c7b1bc31adf480449cc15e97aff9c02797d256f9b6b5511c15c47898c54838071a6607\",\"b6fe635369d1d1684bd816826acda171ff96e220d5d1c0c104c244959ff89d94\"],\"transaction_id\":\"6b0af0d7b0f4b58ca4d2f8f8b3020017d60fb7ddfde946ff1c39b2262d683ad8\",\"status_fail\":false,\"io\":0,\"decode_program\":[\"DUP\",\"HASH160\",\"DATA_2085b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"EQUALVERIFY\",\"TXSIGHASH\",\"SWAP\",\"CHECKSIG\"],\"asset_name\":\"BTM\",\"asset_decimals\":\"8\"}";
    Map? map = await ChannelNative.serializeTranJSONOnly(jsonTran);
    print(map);
  }

  getEosTranSigJson() async {
    String jsonTran =
        "{\"type\":\"spend\",\"asset_id\":\"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\"amount\":41252398000,\"control_program\":\"001485b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"address\":\"bm1qsk6dj6pym7yng0ev7wne7tm3d54ea2sjz5tyxk\",\"spent_output_id\":\"5c4ea4095e62b237941a0c1abd1b83752479756f2e29e3ca1b2de019f8d60e2f\",\"input_id\":\"4f251513b5284a3181e3a231ebc94e6776b3e6b76a2f11344b089c7938210c9d\",\"witness_arguments\":[\"7d1fdd3277855b8aa6679cfb3ad841199725ccd256d932979981b52cc1c7b1bc31adf480449cc15e97aff9c02797d256f9b6b5511c15c47898c54838071a6607\",\"b6fe635369d1d1684bd816826acda171ff96e220d5d1c0c104c244959ff89d94\"],\"transaction_id\":\"6b0af0d7b0f4b58ca4d2f8f8b3020017d60fb7ddfde946ff1c39b2262d683ad8\",\"status_fail\":false,\"io\":0,\"decode_program\":[\"DUP\",\"HASH160\",\"DATA_2085b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"EQUALVERIFY\",\"TXSIGHASH\",\"SWAP\",\"CHECKSIG\"],\"asset_name\":\"BTM\",\"asset_decimals\":\"8\"}";
    String? result = await ChannelNative.getEosTranSigJson(
        jsonTran, "5JzeuzaADHKAUmQRUVjF26Bi4w3gSfei1xdGLtm8hEkb6bveqGi");
    print("EOS签名结果：$result");
  }

  packEosTranJson() async {
    String sigData =
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    String packData =
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    String? result =
        await ChannelNative.packEosTranJson(sigData, packData, 9, 60);
    print("EOS签名打包结果：$result");
  }

  packEosTranJsonOnly() async {
    String sigData =
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    String? result = await ChannelNative.packEosTranJsonOnly(sigData, 9);
    print("EOS签名打包结果：$result");
  }

  serETHTranByStr() async {
    Map? map = await ChannelNative.serETHTranByStr(
        "1",
        "23788",
        "23788",
        "b9af7A63b5FCef11C35891EF033dEC6DB7a4562B",
        "1000000000000000000",
        "xxx",
        "2");
    print(map);
  }

  // sigETHTranByStr() async {
  //   String result = await ChannelNative.sigETHTranByStr(
  //       "1",
  //       "23788",
  //       "23788",
  //       "b9af7A63b5FCef11C35891EF033dEC6DB7a4562B",
  //       "1000000000000000000",
  //       "xxx",
  //       "2",
  //       "dc0efb0bdb4947d865209f1b3d5ef88863276f7814d44c71116072bc24a15466");
  //   print("ETH签名结果：$result");
  // }

  packETHTranByStr() async {
    String sigOut =
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    String sigData =
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    String? result =
        await ChannelNative.packETHTranByStr(sigOut, sigData, 1, "2");
    print("ETH签名打包结果：$result");
  }

  serializeBTCTranJSON() async {
    String jsonTran =
        "{\"type\":\"spend\",\"asset_id\":\"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\"amount\":41252398000,\"control_program\":\"001485b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"address\":\"bm1qsk6dj6pym7yng0ev7wne7tm3d54ea2sjz5tyxk\",\"spent_output_id\":\"5c4ea4095e62b237941a0c1abd1b83752479756f2e29e3ca1b2de019f8d60e2f\",\"input_id\":\"4f251513b5284a3181e3a231ebc94e6776b3e6b76a2f11344b089c7938210c9d\",\"witness_arguments\":[\"7d1fdd3277855b8aa6679cfb3ad841199725ccd256d932979981b52cc1c7b1bc31adf480449cc15e97aff9c02797d256f9b6b5511c15c47898c54838071a6607\",\"b6fe635369d1d1684bd816826acda171ff96e220d5d1c0c104c244959ff89d94\"],\"transaction_id\":\"6b0af0d7b0f4b58ca4d2f8f8b3020017d60fb7ddfde946ff1c39b2262d683ad8\",\"status_fail\":false,\"io\":0,\"decode_program\":[\"DUP\",\"HASH160\",\"DATA_2085b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"EQUALVERIFY\",\"TXSIGHASH\",\"SWAP\",\"CHECKSIG\"],\"asset_name\":\"BTM\",\"asset_decimals\":\"8\"}";
    Map? map = await ChannelNative.serializeBTCTranJSON(jsonTran,
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278");
    print(map);
  }

  serializeBTCTranJSONOnly() async {
    String jsonTran =
        "{\"type\":\"spend\",\"asset_id\":\"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\"amount\":41252398000,\"control_program\":\"001485b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"address\":\"bm1qsk6dj6pym7yng0ev7wne7tm3d54ea2sjz5tyxk\",\"spent_output_id\":\"5c4ea4095e62b237941a0c1abd1b83752479756f2e29e3ca1b2de019f8d60e2f\",\"input_id\":\"4f251513b5284a3181e3a231ebc94e6776b3e6b76a2f11344b089c7938210c9d\",\"witness_arguments\":[\"7d1fdd3277855b8aa6679cfb3ad841199725ccd256d932979981b52cc1c7b1bc31adf480449cc15e97aff9c02797d256f9b6b5511c15c47898c54838071a6607\",\"b6fe635369d1d1684bd816826acda171ff96e220d5d1c0c104c244959ff89d94\"],\"transaction_id\":\"6b0af0d7b0f4b58ca4d2f8f8b3020017d60fb7ddfde946ff1c39b2262d683ad8\",\"status_fail\":false,\"io\":0,\"decode_program\":[\"DUP\",\"HASH160\",\"DATA_2085b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"EQUALVERIFY\",\"TXSIGHASH\",\"SWAP\",\"CHECKSIG\"],\"asset_name\":\"BTM\",\"asset_decimals\":\"8\"}";
    Map? map = await ChannelNative.serializeBTCTranJSONOnly(jsonTran,
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278");
    print(map);
  }

  sigtBTCTransaction() async {
    String jsonTran =
        "{\"type\":\"spend\",\"asset_id\":\"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\"amount\":41252398000,\"control_program\":\"001485b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"address\":\"bm1qsk6dj6pym7yng0ev7wne7tm3d54ea2sjz5tyxk\",\"spent_output_id\":\"5c4ea4095e62b237941a0c1abd1b83752479756f2e29e3ca1b2de019f8d60e2f\",\"input_id\":\"4f251513b5284a3181e3a231ebc94e6776b3e6b76a2f11344b089c7938210c9d\",\"witness_arguments\":[\"7d1fdd3277855b8aa6679cfb3ad841199725ccd256d932979981b52cc1c7b1bc31adf480449cc15e97aff9c02797d256f9b6b5511c15c47898c54838071a6607\",\"b6fe635369d1d1684bd816826acda171ff96e220d5d1c0c104c244959ff89d94\"],\"transaction_id\":\"6b0af0d7b0f4b58ca4d2f8f8b3020017d60fb7ddfde946ff1c39b2262d683ad8\",\"status_fail\":false,\"io\":0,\"decode_program\":[\"DUP\",\"HASH160\",\"DATA_2085b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"EQUALVERIFY\",\"TXSIGHASH\",\"SWAP\",\"CHECKSIG\"],\"asset_name\":\"BTM\",\"asset_decimals\":\"8\"}";
    String? result = await ChannelNative.sigtBTCTransaction(
        jsonTran, "L218xQ3os3RZzR4GD2R91Q5QmxnXrbod2axVsdLhndjTMJZCnKPv");
    print("BTC签名结果：$result");
  }

  packBTCTranJson() async {
    String sigOut =
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    String? result = await ChannelNative.packBTCTranJson(
        1, sigOut, "L218xQ3os3RZzR4GD2R91Q5QmxnXrbod2axVsdLhndjTMJZCnKPv");
    print("BTC签名打包结果：$result");
  }

  packBTCTranJsonOnly() async {
    String sigOut =
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    String? result = await ChannelNative.packBTCTranJsonOnly(
        sigOut, "L218xQ3os3RZzR4GD2R91Q5QmxnXrbod2axVsdLhndjTMJZCnKPv");
    print("BTC签名打包结果：$result");
  }

  getBYTOMCode() async {
    String? result = await ChannelNative.getBYTOMCode(
        "bm1quuemhsmhrs0uxhwldhga9ehqfyfjmwt276p7zl");
    print("比原地址转code: $result");
  }

  serializeBYTOMTranJSON() async {
    String jsonTran =
        "{\"type\":\"spend\",\"asset_id\":\"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\"amount\":41252398000,\"control_program\":\"001485b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"address\":\"bm1qsk6dj6pym7yng0ev7wne7tm3d54ea2sjz5tyxk\",\"spent_output_id\":\"5c4ea4095e62b237941a0c1abd1b83752479756f2e29e3ca1b2de019f8d60e2f\",\"input_id\":\"4f251513b5284a3181e3a231ebc94e6776b3e6b76a2f11344b089c7938210c9d\",\"witness_arguments\":[\"7d1fdd3277855b8aa6679cfb3ad841199725ccd256d932979981b52cc1c7b1bc31adf480449cc15e97aff9c02797d256f9b6b5511c15c47898c54838071a6607\",\"b6fe635369d1d1684bd816826acda171ff96e220d5d1c0c104c244959ff89d94\"],\"transaction_id\":\"6b0af0d7b0f4b58ca4d2f8f8b3020017d60fb7ddfde946ff1c39b2262d683ad8\",\"status_fail\":false,\"io\":0,\"decode_program\":[\"DUP\",\"HASH160\",\"DATA_2085b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"EQUALVERIFY\",\"TXSIGHASH\",\"SWAP\",\"CHECKSIG\"],\"asset_name\":\"BTM\",\"asset_decimals\":\"8\"}";
    Map? map = await ChannelNative.serializeBYTOMTranJSON(jsonTran);
    print(map);
  }

  serializeBYTOMTranJSONOnly() async {
    String jsonTran =
        "{\"type\":\"spend\",\"asset_id\":\"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\"amount\":41252398000,\"control_program\":\"001485b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"address\":\"bm1qsk6dj6pym7yng0ev7wne7tm3d54ea2sjz5tyxk\",\"spent_output_id\":\"5c4ea4095e62b237941a0c1abd1b83752479756f2e29e3ca1b2de019f8d60e2f\",\"input_id\":\"4f251513b5284a3181e3a231ebc94e6776b3e6b76a2f11344b089c7938210c9d\",\"witness_arguments\":[\"7d1fdd3277855b8aa6679cfb3ad841199725ccd256d932979981b52cc1c7b1bc31adf480449cc15e97aff9c02797d256f9b6b5511c15c47898c54838071a6607\",\"b6fe635369d1d1684bd816826acda171ff96e220d5d1c0c104c244959ff89d94\"],\"transaction_id\":\"6b0af0d7b0f4b58ca4d2f8f8b3020017d60fb7ddfde946ff1c39b2262d683ad8\",\"status_fail\":false,\"io\":0,\"decode_program\":[\"DUP\",\"HASH160\",\"DATA_2085b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"EQUALVERIFY\",\"TXSIGHASH\",\"SWAP\",\"CHECKSIG\"],\"asset_name\":\"BTM\",\"asset_decimals\":\"8\"}";
    Map? map = await ChannelNative.serializeBYTOMTranJSONOnly(jsonTran);
    print(map);
  }

  sigtBYTOMTransaction() async {
    String jsonTran =
        "{\"type\":\"spend\",\"asset_id\":\"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\"amount\":41252398000,\"control_program\":\"001485b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"address\":\"bm1qsk6dj6pym7yng0ev7wne7tm3d54ea2sjz5tyxk\",\"spent_output_id\":\"5c4ea4095e62b237941a0c1abd1b83752479756f2e29e3ca1b2de019f8d60e2f\",\"input_id\":\"4f251513b5284a3181e3a231ebc94e6776b3e6b76a2f11344b089c7938210c9d\",\"witness_arguments\":[\"7d1fdd3277855b8aa6679cfb3ad841199725ccd256d932979981b52cc1c7b1bc31adf480449cc15e97aff9c02797d256f9b6b5511c15c47898c54838071a6607\",\"b6fe635369d1d1684bd816826acda171ff96e220d5d1c0c104c244959ff89d94\"],\"transaction_id\":\"6b0af0d7b0f4b58ca4d2f8f8b3020017d60fb7ddfde946ff1c39b2262d683ad8\",\"status_fail\":false,\"io\":0,\"decode_program\":[\"DUP\",\"HASH160\",\"DATA_2085b4d96824df89343f2cf3a79f2f716d2b9eaa12\",\"EQUALVERIFY\",\"TXSIGHASH\",\"SWAP\",\"CHECKSIG\"],\"asset_name\":\"BTM\",\"asset_decimals\":\"8\"}";
    String? result = await ChannelNative.sigtBYTOMTransaction(jsonTran,
        "38f54212029358ac3b0c0b1758b12d8844c5bb0ecf1929826d48a83c10acec5aa37573fda2f25adf3e34a703a0a4a1f2ae8b9848c64edbd6e3e7f5d74417ffad");
    print("比原签名结果: $result");
  }

  packBYTOMTranJson() async {
    String sigOut =
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    String? result = await ChannelNative.packBYTOMTranJson(sigOut);
    print("比原签名打包结果: $result");
  }

  packBYTOMTranJsonOnly() async {
    String sigOut =
        "e00880467b2274223a226d7367222c2261223a2270757368222c2269223a7b226374223a22627463222c2270223a2231222c226361223a302c2263223a223132333435227d7d8278";
    String? result = await ChannelNative.packBYTOMTranJsonOnly(sigOut);
    print("比原签名打包结果: $result");
  }

  checkEOSpushValid() async {
    String pushStr =
        "55efa15b7652453a0a9d0000000001609d71495577d556000000572d3ccdcd019070c2096385154e00000000a8ed3232279070c2096385154e90dc741425371d450a00000000000000044951000000000006e59183e5918300";
    bool? result = await ChannelNative.checkEOSpushValid(
        pushStr, "xinminghuafa", "10000", "eos");
    print("eos交易数据验证: $result");
  }

  checkETHpushValid() async {
    String pushStr =
        "f86901825cec825cec94b9af7a63b5fcef11c35891ef033dec6db7a4562b880de0b6b3a76400008027a0efbc2b5b9350b26d6d3ff7bc53c499ea1cc5a6ada3e475cddda15c3723f58281a0639e53524705274135f73d3fe7899e4dd7bda21fcfe547db5216562b0eb08337";
    bool? result = await ChannelNative.checkETHpushValid(
        pushStr, "b9af7A63b5FCef11C35891EF033dEC6DB7a4562B", "1", 18, "");
    print("eth交易数据验证: $result");
  }

  checkBTCpushValid() async {
    String pushStr =
        "55efa15b7652453a0a9d0000000001609d71495577d556000000572d3ccdcd019070c2096385154e00000000a8ed3232279070c2096385154e90dc741425371d450a00000000000000044951000000000006e59183e5918300";
    bool? result = await ChannelNative.checkBTCpushValid(pushStr,
        "1PX7MaEHU4e2Lrv1vSVdYzWBq6chNY6U7Z", "1", "", "", "", "btc", true);
    print("btc交易数据验证: $result");
  }

  checkBYTOMpushValid() async {
    String pushStr =
        "55efa15b7652453a0a9d0000000001609d71495577d556000000572d3ccdcd019070c2096385154e00000000a8ed3232279070c2096385154e90dc741425371d450a00000000000000044951000000000006e59183e5918300";
    bool? result = await ChannelNative.checkBYTOMpushValid(
        pushStr,
        "bm1quuemhsmhrs0uxhwldhga9ehqfyfjmwt276p7zl",
        "1",
        "bm1quuemhsmhrs0uxhwldhga9ehqfyfjmwt276p7zl",
        "1");
    print("btm交易数据验证: $result");
  }

  checkAddressValid() async {
    bool? result = await ChannelNative.checkAddressValid(
        1, "1PX7MaEHU4e2Lrv1vSVdYzWBq6chNY6U7Z");
    print("检测地址格式: $result");
  }

  cvtAddrByEIP55() async {
    String? result = await ChannelNative.cvtAddrByEIP55(
        "b9af7A63b5FCef11C35891EF033dEC6DB7a4562B");
    print("以太系地址格式转换: $result");
  }

  filterUTXO() async {
    String utxo =
        "[{\"tx_pos\":1,\"tx_hash\":\"58cecfd2d9ab95918a8f7c38911f2f87232c098a4f15face038c5e45a0d57a3c\",\"value\":399325,\"height\":541912}]";
    String? result =
        await ChannelNative.filterUTXO(utxo, "10000", "10000", 1, 1, "btc");
    print("筛选utxo结果: $result");
  }

  genKeyPair() async {
    Map? map = await ChannelNative.genKeyPair();
    print(map);
  }

  keyAgreement() async {
    String prvKey =
        "55efa15b7652453a0a9d0000000001609d71495577d556000000572d3ccdcd019070c2096385154e00000000a8ed3232279070c2096385154e90dc741425371d450a00000000000000044951000000000006e59183e5918300";
    String pubKey =
        "55efa15b7652453a0a9d0000000001609d71495577d556000000572d3ccdcd019070c2096385154e00000000a8ed3232279070c2096385154e90dc741425371d450a00000000000000044951000000000006e59183e5918300";
    String? result = await ChannelNative.keyAgreement(prvKey, pubKey);
    print("获取冷端output结果: $result");
  }

  eCDSASign() async {
    String msg =
        "55efa15b7652453a0a9d0000000001609d71495577d556000000572d3ccdcd019070c2096385154e00000000a8ed3232279070c2096385154e90dc741425371d450a00000000000000044951000000000006e59183e5918300";
    String? result = await ChannelNative.eCDSASign(msg);
    print("冷端配对数据签名的结果: $result");
  }

  eCDSAVerify() async {
    String msg =
        "55efa15b7652453a0a9d0000000001609d71495577d556000000572d3ccdcd019070c2096385154e00000000a8ed3232279070c2096385154e90dc741425371d450a00000000000000044951000000000006e59183e5918300";
    String sigData =
        "55efa15b7652453a0a9d0000000001609d71495577d556000000572d3ccdcd019070c2096385154e00000000a8ed3232279070c2096385154e90dc741425371d450a00000000000000044951000000000006e59183e5918300";
    bool? result = await ChannelNative.eCDSAVerify(msg, sigData);
    print("冷端配对数据检验的结果: $result");
  }

  genBTCAddress() async {
    String? result = await ChannelNative.genBTCAddress(
        "L218xQ3os3RZzR4GD2R91Q5QmxnXrbod2axVsdLhndjTMJZCnKPv", true);
    print("btc隔离见证转换结果: $result");
  }

  genBTCAddress2() async {
    String? result = await ChannelNative.genBTCAddress(
        "L218xQ3os3RZzR4GD2R91Q5QmxnXrbod2axVsdLhndjTMJZCnKPv", false);
    print("btc隔离见证转换结果: $result");
  }

  testWallet() async {}

  checkMemoValid() async {
    bool result = await ChannelMemos.checkMemoValid(
        "要，踏，楚，和，据，须，任，精，块，籍，撞，幕，控，界，筑，家，在，磷，思，愿，现，院，广，班");
    LogUtil.v(result);
  }

  @override
  Widget build(BuildContext context) {
    OffsetWidget.screenInit(context, 375);
    return CustomPageView(
      hiddenAppBar: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // OffsetWidget.vGap(10),
          // FlatButton(
          //     onPressed: encKeyByAES128CBC, child: Text("encKeyByAES128CBC")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: decKeyByAES128CBC, child: Text("decKeyByAES128CBC")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: serializeTranJSON, child: Text("serializeTranJSON")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: serializeTranJSONOnly,
          //     child: Text("serializeTranJSONOnly")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: getEosTranSigJson, child: Text("getEosTranSigJson")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: packEosTranJson, child: Text("packEosTranJson")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: packEosTranJsonOnly,
          //     child: Text("packEosTranJsonOnly")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: serETHTranByStr, child: Text("serETHTranByStr")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: sigETHTranByStr, child: Text("sigETHTranByStr")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: packETHTranByStr, child: Text("packETHTranByStr")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: serializeBTCTranJSON,
          //     child: Text("serializeBTCTranJSON")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: serializeBTCTranJSONOnly,
          //     child: Text("serializeBTCTranJSONOnly")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: sigtBTCTransaction, child: Text("sigtBTCTransaction")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: packBTCTranJson, child: Text("packBTCTranJson")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: packBTCTranJsonOnly,
          //     child: Text("packBTCTranJsonOnly")),
          // OffsetWidget.vGap(5),
          // FlatButton(onPressed: getBYTOMCode, child: Text("getBYTOMCode")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: serializeBYTOMTranJSON,
          //     child: Text("serializeBYTOMTranJSON")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: serializeBYTOMTranJSONOnly,
          //     child: Text("serializeBYTOMTranJSONOnly")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: sigtBYTOMTransaction,
          //     child: Text("sigtBYTOMTransaction")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: packBYTOMTranJson, child: Text("packBYTOMTranJson")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: packBYTOMTranJsonOnly,
          //     child: Text("packBYTOMTranJsonOnly")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: checkEOSpushValid, child: Text("checkEOSpushValid")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: checkETHpushValid, child: Text("checkETHpushValid")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: checkBTCpushValid, child: Text("checkBTCpushValid")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: checkBYTOMpushValid,
          //     child: Text("checkBYTOMpushValid")),
          // OffsetWidget.vGap(5),
          // FlatButton(
          //     onPressed: checkAddressValid, child: Text("checkAddressValid")),
          // OffsetWidget.vGap(5),
          // FlatButton(onPressed: cvtAddrByEIP55, child: Text("cvtAddrByEIP55")),
          // OffsetWidget.vGap(5),
          // FlatButton(onPressed: filterUTXO, child: Text("filterUTXO")),
          // OffsetWidget.vGap(5),
          // FlatButton(onPressed: genKeyPair, child: Text("genKeyPair")),
          // OffsetWidget.vGap(5),
          // FlatButton(onPressed: keyAgreement, child: Text("keyAgreement")),
          // OffsetWidget.vGap(5),
          // FlatButton(onPressed: eCDSASign, child: Text("eCDSASign")),
          // OffsetWidget.vGap(5),
          // FlatButton(onPressed: eCDSAVerify, child: Text("eCDSAVerify")),
          // OffsetWidget.vGap(5),
          // FlatButton(onPressed: genBTCAddress, child: Text("genBTCAddress")),
          // OffsetWidget.vGap(5),
          // FlatButton(onPressed: genBTCAddress2, child: Text("genBTCAddress2")),
          // OffsetWidget.vGap(5),
          FlatButton(onPressed: checkETHpushValid, child: Text("testWallet")),
          OffsetWidget.vGap(5),
        ],
      ),
    );
  }
}
