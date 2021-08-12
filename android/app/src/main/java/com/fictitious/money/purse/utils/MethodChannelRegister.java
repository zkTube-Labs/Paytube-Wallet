package com.fictitious.money.purse.utils;

import android.content.Intent;
import android.os.AsyncTask;
import android.provider.Settings;
import android.text.TextUtils;

import com.fictitious.money.purse.App;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.callback.PingValueCallBack;
import com.fictitious.money.purse.utils.wallet.CreateMomeUtil;
import com.fictitious.money.purse.web.shop.BanKeMarketActivity;
import com.fictitious.money.purse.web.shop.BrowserX5WebActivity;
import com.fictitious.money.purse.web.vdai.VdaiWebActivity;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import static com.fictitious.money.purse.App.getContext;

public class MethodChannelRegister implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler{
    //注册通道的方法
    public static String CHANNEL_MEMOS = "plugins.coinidwallet.memos";
    public static String CHANNEL_WALLETS = "plugins.coinidwallet.wallets";
    public static String CHANNEL_NATIVES = "plugins.coinidwallet.natives";
    public static String CHANNEL_SCANS = "plugins.coinidwallet.scans";
    public static String CHANNEL_SCANS_EVENTS = "plugins.coinidwallet.scans.events";
    public static String CHANNEL_DAPP = "plugins.coinidwallet.dapps";

    private static MethodChannel dappChannel;
    private EventChannel.EventSink sink;

    public static void registerMemo(FlutterEngine flutterEngine) {
        MethodChannelRegister instance = new MethodChannelRegister();
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_MEMOS);
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    public static void registerWallet(FlutterEngine flutterEngine) {
        MethodChannelRegister instance = new MethodChannelRegister();
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_WALLETS);
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    public static void registerNative(FlutterEngine flutterEngine) {
        MethodChannelRegister instance = new MethodChannelRegister();
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_NATIVES);
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    public static void registerDAPP(FlutterEngine flutterEngine) {
        MethodChannelRegister instance = new MethodChannelRegister();
        dappChannel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_DAPP);
        //setMethodCallHandler在此通道上接收方法调用的回调
        dappChannel.setMethodCallHandler(instance);
    }

    public static void registerScan(FlutterEngine flutterEngine) {
        MethodChannelRegister instance = new MethodChannelRegister();
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_SCANS);
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    public static void registerScanEvent(FlutterEngine flutterEngine) {
        MethodChannelRegister instance = new MethodChannelRegister();
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_SCANS_EVENTS);
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if(methodCall.arguments != null){
            Logger.e("参数：" , methodCall.arguments.toString());
        }
        if(methodCall.method.equals("createWalletMemo")){
            int count = (int)methodCall.arguments;
            result.success(CoinIDHelper.createWalletMemo(count));
        } else if(methodCall.method.equals("importWalletFrom")){
            String content = (String) methodCall.argument("content");
            String pin = (String) methodCall.argument("pin");
            int coinType = methodCall.argument("mCoinType");
            int leadType = methodCall.argument("mLeadType");
            int originType = methodCall.argument("mOriginType");
            result.success(CoinIDHelper.importWalletFrom(content, pin, coinType, leadType, originType));
        } else if(methodCall.method.equals("exportPrvFrom")){
            String content = (String) methodCall.argument("content");
            String pin = (String) methodCall.argument("pin");
            int coinType = methodCall.argument("mCoinType");
            result.success(CoinIDHelper.exportPrvFrom(content, pin, coinType));
        } else if(methodCall.method.equals("exportKeyStoreFrom")){
            String content = (String) methodCall.argument("content");
            String pin = (String) methodCall.argument("pin");
            int coinType = methodCall.argument("mCoinType");
            result.success(CoinIDHelper.exportKeyStoreFrom(content, pin, coinType));
        } else if(methodCall.method.equals("CoinID_EncKeyByAES128CBC")) {
            //内容加密
            String input = (String) methodCall.argument("input");
            String inputPIN = (String) methodCall.argument("inputPIN");
            byte[] inputByte = CommonUtil.strToByteArrayNotAddEnd(input);
            byte[] inputPINByte = CommonUtil.strToByteArrayNotAddEnd(inputPIN);
            byte[] encKey = new byte[16];
            if (inputPINByte.length < 16) {
                System.arraycopy(inputPINByte, 0, encKey, 0, inputPINByte.length);
            } else {
                System.arraycopy(inputPINByte, 0, encKey, 0, 16);
            }
            byte[] output = new byte[(inputByte.length + 16) & 0xf0];
            boolean flag = XMHCoinUtitls.CoinID_EncByAES128CBC(inputByte, (short) inputByte.length, encKey, output);
            if(flag){
                result.success(DigitalTrans.byte2hex(output));
            } else {
                result.success(null);
            }
        } else if(methodCall.method.equals("CoinID_DecByAES128CBC")) {
            //内容解密
            String input = (String) methodCall.argument("input");
            String inputPIN = (String) methodCall.argument("inputPIN");
            byte[] inputByte = DigitalTrans.hex2byte(input);
            byte[] inputPINByte = CommonUtil.strToByteArrayNotAddEnd(inputPIN);
            byte[] encKey = new byte[16];
            if (inputPINByte.length < 16) {
                System.arraycopy(inputPINByte, 0, encKey, 0, inputPINByte.length);
            } else {
                System.arraycopy(inputPINByte, 0, encKey, 0, 16);
            }
            byte[] decOutput = new byte[1000];
            short decLen = XMHCoinUtitls.CoinID_DecByAES128CBC(inputByte, (short) inputByte.length, encKey, decOutput);
            byte[] resultByte = new byte[decLen];
            System.arraycopy(decOutput, 0, resultByte, 0, decLen);
            String decResultStr = CommonUtil.byteArrayToStr(resultByte);
            if (CommonUtil.isMessyCode(decResultStr)) {
                result.success(null);
            } else {
                result.success(decResultStr);
            }
        } else if(methodCall.method.equals("CoinID_serializeTranJSON")) {
            Map map = new HashMap();
            String jsonTran = (String) methodCall.argument("jsonTran");
            byte[] sigHash = new byte[32];
            byte[] outLength = new byte[2];
            byte[] byteTran = CommonUtil.strToByteArray(jsonTran);
            byte[] result_byte = XMHCoinUtitls.CoinID_serializeTranJSON(byteTran, (short) byteTran.length, sigHash, outLength);
            map.put("hash", HexUtil.encodeHexStr(sigHash));
            map.put("outLen", HexUtil.encodeHexStr(outLength));
            map.put("result", HexUtil.encodeHexStr(result_byte));
            result.success(map);
        } else if(methodCall.method.equals("CoinID_serializeTranJSONOnly")) {
            Map map = new HashMap();
            String jsonTran = (String) methodCall.argument("jsonTran");
            byte[] outLength = new byte[2];
            byte[] byteTran = CommonUtil.strToByteArrayNotAddEnd(jsonTran);
            byte[] result_byte = XMHCoinUtitls.CoinID_serializeTranJSONOnly(byteTran, outLength);
            map.put("outLen", HexUtil.encodeHexStr(outLength));
            map.put("result", HexUtil.encodeHexStr(result_byte));
            result.success(map);
        } else if(methodCall.method.equals("CoinID_GetTranSigJson")) {
            String jsonTran = (String) methodCall.argument("jsonTran");
            String prvKey = (String) methodCall.argument("prvKey");
            byte[] jsonByte = CommonUtil.strToByteArray(jsonTran);
            byte[] prvKeyByte = CommonUtil.strToByteArray(prvKey);
            boolean check = XMHCoinUtitls.CoinID_ImportEOSPrvKeyCheck(prvKeyByte, (byte) prvKeyByte.length);
            if(check) {
                byte[] ownerByte = XMHCoinUtitls.CoinID_ImportEOSPrvKey(prvKeyByte, (byte) prvKeyByte.length);
                //私钥
                byte[] signPrvKey = new byte[32];
                System.arraycopy(ownerByte, 0, signPrvKey, 0 , signPrvKey.length);
                byte[] result_byte = XMHCoinUtitls.CoinID_GetTranSigJson(jsonByte, (short) (jsonByte.length), signPrvKey);
                result.success(HexUtil.encodeHexStr(result_byte));
            } else {
                result.success(null);
            }
        } else if(methodCall.method.equals("CoinID_packTranJson")) {
            String sigData = (String) methodCall.argument("sigData");
            String packData = (String) methodCall.argument("packData");
            int recid = methodCall.argument("recid");
            int msgLen = methodCall.argument("msgLen");
            byte[] packByte = XMHCoinUtitls.CoinID_packTranJson(HexUtil.hexStringToBytes(sigData), HexUtil.hexStringToBytes(packData), recid, (short) msgLen);
            result.success(new String(packByte));
        } else if(methodCall.method.equals("CoinID_packTranJsonOnly")) {
            String sigData = (String) methodCall.argument("sigData");
            int recid = methodCall.argument("recid");
            byte[] packByte = XMHCoinUtitls.CoinID_packTranJsonOnly(HexUtil.hexStringToBytes(sigData), recid);
            result.success(new String(packByte));
        } else if(methodCall.method.equals("CoinID_serETH_TX_by_str")) {
            Map map = new HashMap();
            String nonce = (String) methodCall.argument("nonce");
            String gasprice = (String) methodCall.argument("gasprice");
            String startgas = (String) methodCall.argument("startgas");
            String to = (String) methodCall.argument("to");
            String value = (String) methodCall.argument("value");
            String data = (String) methodCall.argument("data");
            String chainId = (String) methodCall.argument("chainId");
            byte[] sigHash = new byte[32];
            String serResult = XMHCoinUtitls.CoinID_serETH_TX_by_str(nonce, gasprice, startgas, to, value, data, chainId, sigHash);
            map.put("hash", HexUtil.encodeHexStr(sigHash));
            map.put("result", serResult);
            result.success(map);
        } else if(methodCall.method.equals("CoinID_sigETH_TX_by_str")) {
            String nonce = (String) methodCall.argument("nonce");
            String gasprice = (String) methodCall.argument("gasprice");
            String startgas = (String) methodCall.argument("startgas");
            String to = (String) methodCall.argument("to");
            String value = (String) methodCall.argument("value");
            String data = (String) methodCall.argument("data");
            String chainId = (String) methodCall.argument("chainId");
            String prvKey = (String) methodCall.argument("prvKey");
            byte[] signPrvKey = new byte[32];
            byte[] prvKeyByte = DigitalTrans.hex2byte(prvKey);
            byte[] eth_byte = XMHCoinUtitls.CoinID_ImportETHPrvKey(prvKeyByte);
            //私钥
            System.arraycopy(eth_byte, 0, signPrvKey, 0 , signPrvKey.length);
            String sigResult = XMHCoinUtitls.CoinID_sigETH_TX_by_str(nonce, gasprice, startgas, to, value, data, chainId, HexUtil.encodeHexStr(signPrvKey));
            result.success(sigResult);
        } else if(methodCall.method.equals("CoinID_packETH_TX_by_str")) {
            String sigOut = (String) methodCall.argument("sigOut");
            String sigData = (String) methodCall.argument("sigData");
            int recid = methodCall.argument("recid");
            String chainId = (String) methodCall.argument("chainId");
            String packResult = XMHCoinUtitls.CoinID_packETH_TX_by_str(sigOut, sigData, recid, chainId);
            result.success(packResult);
        } else if(methodCall.method.equals("CoinID_serializeBTCTranJSON")) {
            Map map = new HashMap();
            String jsonTran = (String) methodCall.argument("jsonTran");
            String pubKey = (String) methodCall.argument("pubKey");
            byte[] outLen = new byte[2];
            byte[] jsonByte = CommonUtil.strToByteArray(jsonTran);
            byte[] serResult = XMHCoinUtitls.CoinID_serializeBTCTranJSON(jsonByte, (short) jsonByte.length, HexUtil.hexStringToBytes(pubKey), outLen);
            map.put("outLen", HexUtil.encodeHexStr(outLen));
            map.put("result", serResult);
            result.success(map);
        } else if(methodCall.method.equals("CoinID_serializeBTCTranJSONOnly")) {
            Map map = new HashMap();
            String jsonTran = (String) methodCall.argument("jsonTran");
            String pubKey = (String) methodCall.argument("pubKey");
            byte[] outLen = new byte[2];
            byte[] jsonByte = CommonUtil.strToByteArray(jsonTran);
            byte[] serResult = XMHCoinUtitls.CoinID_serializeBTCTranJSONOnly(jsonByte, HexUtil.hexStringToBytes(pubKey), outLen);
            map.put("outLen", HexUtil.encodeHexStr(outLen));
            map.put("result", serResult);
            result.success(map);
        } else if(methodCall.method.equals("CoinID_sigtBTCTransaction")) {
            String jsonTran = (String) methodCall.argument("jsonTran");
            String prvKey = (String) methodCall.argument("prvKey");
            byte[] jsonByte = CommonUtil.strToByteArray(jsonTran);
            byte[] mSignPrvKey = new byte[32];
            byte[] prvKeyByte = CommonUtil.strToByteArray(prvKey);
            byte[] BtcByte = XMHCoinUtitls.CoinID_ImportBTCPrvKeyByWIF(prvKeyByte, (short)prvKeyByte.length);
            //私钥
            System.arraycopy(BtcByte, 0, mSignPrvKey, 0 , mSignPrvKey.length);
            byte[] resultByte = XMHCoinUtitls.CoinID_sigtBTCTransaction(jsonByte, (short) jsonByte.length, mSignPrvKey);
            String sigResult = CommonUtil.byteArrayToStr(resultByte);
            result.success(sigResult);
        } else if(methodCall.method.equals("CoinID_packBTCTranJson")) {
            int segwit = methodCall.argument("segwit");
            String sigData = (String) methodCall.argument("sigData");
            String pubKey = (String) methodCall.argument("pubKey");
            byte[] sigDataByte = HexUtil.hexStringToBytes(sigData);
            byte[] pubKeyByte = HexUtil.hexStringToBytes(pubKey);
            byte[] packByte = XMHCoinUtitls.CoinID_packBTCTranJson((byte) segwit, sigDataByte, sigDataByte.length, pubKeyByte);
            String packResult = CommonUtil.byteArrayToStr(packByte);
            result.success(packResult);
        } else if(methodCall.method.equals("CoinID_packBTCTranJsonOnly")) {
            String sigData = (String) methodCall.argument("sigData");
            String pubKey = (String) methodCall.argument("pubKey");
            byte[] sigDataByte = HexUtil.hexStringToBytes(sigData);
            byte[] pubKeyByte = HexUtil.hexStringToBytes(pubKey);
            byte[] packByte = XMHCoinUtitls.CoinID_packBTCTranJsonOnly(sigDataByte, sigDataByte.length, pubKeyByte);
            String packResult = CommonUtil.byteArrayToStr(packByte);
            result.success(packResult);
        } else if(methodCall.method.equals("CoinID_genScriptHash")) {
            String address = (String) methodCall.argument("address");
            byte[] pubKeyByte = CommonUtil.strToByteArray(address);
            byte[] hashResult = XMHCoinUtitls.CoinID_genScriptHash(pubKeyByte, (short) pubKeyByte.length);
            result.success(CommonUtil.byteArrayToStr(hashResult));
        } else if(methodCall.method.equals("CoinID_getBYTOMCode")) {
            String address = (String) methodCall.argument("address");
            result.success(CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_getBYTOMCode(CommonUtil.strToByteArray(address))));
        } else if(methodCall.method.equals("CoinID_serializeBYTOMTranJSON")) {
            Map map = new HashMap();
            String jsonTran = (String) methodCall.argument("jsonTran");
            byte[] outLen = new byte[2];
            byte[] jsonByte = CommonUtil.strToByteArray(jsonTran);
            byte[] resultByte = XMHCoinUtitls.CoinID_serializeBYTOMTranJSON(jsonByte, outLen);
            map.put("outLen", HexUtil.encodeHexStr(outLen));
            map.put("result", HexUtil.encodeHexStr(resultByte));
            result.success(map);
        } else if(methodCall.method.equals("CoinID_serializeBYTOMTranJSONOnly")) {
            Map map = new HashMap();
            String jsonTran = (String) methodCall.argument("jsonTran");
            byte[] outLen = new byte[2];
            byte[] jsonByte = CommonUtil.strToByteArray(jsonTran);
            byte[] resultByte = XMHCoinUtitls.CoinID_serializeBYTOMTranJSONOnly(jsonByte, outLen);
            map.put("outLen", HexUtil.encodeHexStr(outLen));
            map.put("result", HexUtil.encodeHexStr(resultByte));
            result.success(map);
        } else if(methodCall.method.equals("CoinID_sigtBYTOMTransaction")) {
            String jsonTran = (String) methodCall.argument("jsonTran");
            String prvKey = (String) methodCall.argument("prvKey");
            byte[] jsonByte = CommonUtil.strToByteArray(jsonTran);
            byte[] result_byte = XMHCoinUtitls.CoinID_sigtBYTOMTransaction(jsonByte, HexUtil.hexStringToBytes(prvKey));
            result.success(CommonUtil.byteArrayToStr(result_byte));
        } else if(methodCall.method.equals("CoinID_packBYTOMTranJson")) {
            String sigOut = (String) methodCall.argument("sigOut");
            byte[] sigOutByte = HexUtil.hexStringToBytes(sigOut);
            byte[] packByte = XMHCoinUtitls.CoinID_packBYTOMTranJson(sigOutByte, (short) sigOutByte.length);
            String packResult = CommonUtil.byteArrayToStr(packByte);
            result.success(packResult);
        } else if(methodCall.method.equals("CoinID_packBYTOMTranJsonOnly")) {
            String sigOut = (String) methodCall.argument("sigOut");
            byte[] sigOutByte = HexUtil.hexStringToBytes(sigOut);
            byte[] packByte = XMHCoinUtitls.CoinID_packBYTOMTranJsonOnly(sigOutByte, (short) sigOutByte.length);
            String packResult = CommonUtil.byteArrayToStr(packByte);
            result.success(packResult);
        } else if(methodCall.method.equals("CoinID_checkEOSpushValid")) {
            String pushStr = (String) methodCall.argument("pushStr");
            String to = (String) methodCall.argument("to");
            String value = (String) methodCall.argument("value");
            String unit = (String) methodCall.argument("unit");
            boolean valid = XMHCoinUtitls.CoinID_checkEOSpushValid(pushStr, to, value, unit);
            result.success(valid);
        } else if(methodCall.method.equals("CoinID_checkETHpushValid")) {
            String pushStr = (String) methodCall.argument("pushStr");
            String to = (String) methodCall.argument("to");
            String value = (String) methodCall.argument("value");
            int decimal = methodCall.argument("decimal");
            String contractAddr = (String) methodCall.argument("contractAddr");
            boolean valid = XMHCoinUtitls.CoinID_checkETHpushValid(pushStr, to, value, decimal, !TextUtils.isEmpty(contractAddr), !TextUtils.isEmpty(contractAddr) ? contractAddr : "");
            result.success(valid);
        } else if(methodCall.method.equals("CoinID_checkBTCpushValid")) {
            String pushStr = (String) methodCall.argument("pushStr");
            String to = (String) methodCall.argument("to");
            String toValue = (String) methodCall.argument("toValue");
            String from = (String) methodCall.argument("from");
            String fromValue = (String) methodCall.argument("fromValue");
            String usdtValue = (String) methodCall.argument("usdtValue");
            String coinType = (String) methodCall.argument("coinType");
            boolean segwit = (boolean) methodCall.argument("isSegwit");
            boolean valid = XMHCoinUtitls.CoinID_checkBTCpushValid(pushStr, to, toValue, from, fromValue, usdtValue, coinType, segwit);
            result.success(valid);
        } else if(methodCall.method.equals("CoinID_checkBYTOMpushValid")) {
            String pushStr = (String) methodCall.argument("pushStr");
            String to = (String) methodCall.argument("to");
            String toValue = (String) methodCall.argument("toValue");
            String from = (String) methodCall.argument("from");
            String fromValue = (String) methodCall.argument("fromValue");
            boolean valid = XMHCoinUtitls.CoinID_checkBYTOMpushValid(pushStr, to, toValue, from, fromValue);
            result.success(valid);
        } else if(methodCall.method.equals("CoinID_checkAddressValid")) {
            String chainType = (String) methodCall.argument("chainType");
            String address = (String) methodCall.argument("address");
            boolean valid = XMHCoinUtitls.CoinID_checkAddressValid(chainType, address);
            result.success(valid);
        } else if(methodCall.method.equals("CoinID_cvtAddrByEIP55")) {
            String address = (String) methodCall.argument("address");
            result.success(XMHCoinUtitls.CoinID_cvtAddrByEIP55(address));
        } else if(methodCall.method.equals("CoinID_filterUTXO")) {
            String utxoJson = (String) methodCall.argument("utxoJson");
            String amount = (String) methodCall.argument("amount");
            String fee = (String) methodCall.argument("fee");
            int quorum = methodCall.argument("quorum");
            String type = (String) methodCall.argument("type");
            int num = methodCall.argument("num");
            String filterResult = XMHCoinUtitls.CoinID_filterUTXO(utxoJson, amount, fee, quorum, num, type);
            result.success(filterResult);
        } else if(methodCall.method.equals("CoinID_genKeyPair")) {
            Map map = new HashMap();
            byte[] prvKey = new byte[32];
            byte[] pubKey = new byte[33];
            XMHCoinUtitls.CoinID_genKeyPair(prvKey, pubKey);
            map.put("pubKey", HexUtil.encodeHexStr(pubKey));
            map.put("prvKey", HexUtil.encodeHexStr(prvKey));
            result.success(map);
        } else if(methodCall.method.equals("CoinID_keyAgreement")) {
            String pubKey = (String) methodCall.argument("pubKey");
            String prvKey = (String) methodCall.argument("prvKey");
            byte[] output = new byte[16];
            XMHCoinUtitls.CoinID_keyAgreement(HexUtil.hexStringToBytes(prvKey), HexUtil.hexStringToBytes(pubKey), output);
            result.success(HexUtil.encodeHexStr(output));
        } else if(methodCall.method.equals("CoinID_ECDSA_sign")) {
            String msg = (String) methodCall.argument("msg");
            byte[] sigData = new byte[64];
            byte[] msgByte = HexUtil.hexStringToBytes(msg);
            XMHCoinUtitls.CoinID_ECDSA_sign(msgByte, msgByte.length, null, sigData);
            result.success(HexUtil.encodeHexStr(sigData));
        } else if(methodCall.method.equals("CoinID_ECDSA_verify")) {
            String msg = (String) methodCall.argument("msg");
            String sigData = (String) methodCall.argument("sigData");
            byte[] msgByte = HexUtil.hexStringToBytes(msg);
            boolean valid = XMHCoinUtitls.CoinID_ECDSA_verify(msgByte, msgByte.length, HexUtil.hexStringToBytes(sigData), null);
            result.success(valid);
        } else if(methodCall.method.equals("CoinID_genBTCAddress")) {
            String prvKey = (String) methodCall.argument("prvKey");
            boolean segwit = (boolean) methodCall.argument("segwit");
            byte[] prvKeyByte = CommonUtil.strToByteArray(prvKey);
            byte[] btcByte = XMHCoinUtitls.CoinID_ImportBTCPrvKeyByWIF(prvKeyByte, (short) prvKeyByte.length);
            //公钥
            byte[] btcPublicResultByte = new byte[btcByte.length - 32];
            System.arraycopy(btcByte, 32, btcPublicResultByte, 0, btcPublicResultByte.length);
            if(segwit){
                result.success(CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_genBTCAddress((byte)5, btcPublicResultByte, (byte)33, (byte)3)));
            } else {
                result.success(CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_genBTCAddress((byte)0, btcPublicResultByte, (byte)33, (byte)0)));
            }
        } else if(methodCall.method.equals("CoinID_sigPolkadotTransaction")) {
            String pubKey = (String) methodCall.argument("pubKey");
            String prvKey = (String) methodCall.argument("prvKey");
            String jsonTran = (String) methodCall.argument("jsonTran");
            result.success(XMHCoinUtitls.CoinID_sigPolkadotTransaction(jsonTran, prvKey, pubKey));
        } else if(methodCall.method.equals("CoinID_polkadot_getNonceKey")) {
            String address = (String) methodCall.argument("address");
            result.success(XMHCoinUtitls.CoinID_polkadot_getNonceKey(address));
        } else if(methodCall.method.equals("checkMemoValid")) {
            String memos = (String) methodCall.arguments();
            result.success(CreateMomeUtil.checkMemoValid(memos));
        } else if(methodCall.method.equals("scan")) {
            ScanHelper.scan(result);
        } else if(methodCall.method.equals("deviceImei")){
            String imei = "";
            if(TextUtils.isEmpty(imei)){
                imei = Settings.System.getString(getContext().getContentResolver(), Settings.Secure.ANDROID_ID);//10.0以后获取不到UUID，用androidId来代表唯一性
            }
            if (TextUtils.isEmpty(imei)) {
                imei = "0000000000000000";
            }
            result.success(imei);
        } else if(methodCall.method.equals("getAvgRTT")) {
            String url = (String) methodCall.arguments();
            new UpdateAsyncTask(url, new PingValueCallBack() {
                @Override
                public void onValue(String value) {
                    result.success(value);
                }
            }).execute();
        } else if(methodCall.method.equals("pushWeb")){
            int urlType = methodCall.argument("urlType");
            String url = (String) methodCall.argument("url");
            switch (urlType){
                case Constants.URL_TYPE.TYPE_LINKS:
                    Intent intent = new Intent(App.getActivity(), BrowserX5WebActivity.class);
                    intent.putExtra(Constants.INTENT_PARAM.TITLE, "");
                    intent.putExtra(Constants.INTENT_PARAM.SHARE_URL, url);
                    intent.putExtra(Constants.INTENT_PARAM.IS_VDNS, false);
                    App.getActivity().startActivity(intent);
                    break;
                case Constants.URL_TYPE.TYPE_BANCOR:
                    intent = new Intent(App.getActivity(), BanKeMarketActivity.class);
                    intent.putExtra("url", url);
                    App.getActivity().startActivity(intent);
                    break;
                case Constants.URL_TYPE.TYPE_VDNS:
                    intent = new Intent(App.getActivity(), BrowserX5WebActivity.class);
                    intent.putExtra(Constants.INTENT_PARAM.TITLE, "VDNS");
                    intent.putExtra(Constants.INTENT_PARAM.SHARE_URL, url);
                    intent.putExtra(Constants.INTENT_PARAM.IS_VDNS, true);
                    App.getActivity().startActivity(intent);
                    break;
                case Constants.URL_TYPE.TYPE_VDAI:
                    intent = new Intent(App.getActivity(), VdaiWebActivity.class);
                    intent.putExtra("url", url);
                    App.getActivity().startActivity(intent);
                    break;
            }
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        sink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        sink = null;
    }

    // AsyncTask的三个参数很好理解，从左到友分别是启动时的参数，中间过程的百分比，完成后返回的结果
    public class UpdateAsyncTask extends AsyncTask<Integer, Integer, Integer> {
        private String url;
        private PingValueCallBack pingValueCallBack;
        public UpdateAsyncTask(String url, PingValueCallBack callBack) {
            super();
            this.url = url;
            this.pingValueCallBack = callBack;
        }

        @Override
        protected Integer doInBackground(Integer... integers) {
            try {
                return PingUtil.getAvgRTT(url);
            } catch (Exception e){
                return -1;
            }
        }

        protected void onPreExecute() {

        }

        protected void onProgressUpdate(Integer... values) {
            pingValueCallBack.onValue(values[0].toString());
        }

        protected void onPostExecute(Integer result) {
            pingValueCallBack.onValue(result.toString());
        }
    }

    //获取钱包数据
    public static void getWallet(MethodChannel.Result result){
        Map map = new HashMap();
//        map.put("coinType", Constants.COIN_TYPE.TYPE_VNS);
//        dappChannel.invokeMethod("datas", map, result);
    }

    //更新did选中
    public static void updateDid(String walletID, MethodChannel.Result result){
        Map map = new HashMap();
        map.put("walletID", walletID);
        dappChannel.invokeMethod("updateDid", map, result);
    }

    //获取did选中的钱包
    public static void getDid(MethodChannel.Result result){
        dappChannel.invokeMethod("getDid", null, result);
    }

    //解锁
    public static void lock(String walletID, String pin, MethodChannel.Result result){
        Map map = new HashMap();
        map.put("walletID", walletID);
        map.put("pin", pin);
        dappChannel.invokeMethod("lock", map, result);
    }
}
