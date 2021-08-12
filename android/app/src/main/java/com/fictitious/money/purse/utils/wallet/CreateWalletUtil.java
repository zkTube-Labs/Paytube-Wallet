package com.fictitious.money.purse.utils.wallet;

import android.text.TextUtils;

import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.DigitalTrans;
import com.fictitious.money.purse.utils.HexUtil;
import com.fictitious.money.purse.utils.XMHCoinUtitls;
import com.google.gson.Gson;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CreateWalletUtil {
    //获取钱包公私钥
    private static String owner_public, owner_private;
    private static String active_public, active_private;
    private static String owner_gps_public, owner_gps_private;
    private static String active_gps_public, active_gps_private;
    private static String eth_public, eth_private;
    private static String vns_public, vns_private;
    private static String btc_public, btc_private;
    private static String btm_public, btm_private;
    private static String ltc_public, ltc_private;
    private static String bch_public, bch_private;
    private static String dash_public, dash_private;
    private static String pk_public, pk_private;

    //eos
    private static byte[] owner_byte, active_byte;
    private static byte[] owner_public_result, active_public_result;
    private static byte[] owner_private_result, active_private_result;

    //gps
    private static byte[] owner_gps_byte, active_gps_byte;
    private static byte[] owner_gps_public_result, active_gps_public_result;
    private static byte[] owner_gps_private_result, active_gps_private_result;

    //eth
    private static byte[] eth_byte;
    private static byte[] eth_public_result, eth_private_result;

    //vns
    private static byte[] vns_byte;
    private static byte[] vns_public_result, vns_private_result;

    //btc
    private static byte[] btc_byte;
    private static byte[] btc_public_result, btc_private_result;

    //btm
    private static byte[] btm_byte;
    private static byte[] btm_public_result, btm_private_result;

    //ltc
    private static byte[] ltc_byte;
    private static byte[] ltc_public_result, ltc_private_result;

    //bch
    private static byte[] bch_byte;
    private static byte[] bch_public_result, bch_private_result;

    //dash
    private static byte[] dash_byte;
    private static byte[] dash_public_result, dash_private_result;

    //polkadot
    private static byte[] pk_byte;
    private static byte[] pk_public_result, pk_private_result;

    public static List createWallet(int common, String words, int chainType, String pin) {
        List wallets = new ArrayList();
        boolean result;
        String[] words_arr = words.split(" ");
        if (common == Constants.LEAD_TYPE.STANDARMEMO) {
            result = XMHCoinUtitls.CoinID_SetMasterStandard(words.trim());
        } else {
            String hex_str = "";
            if (CommonUtil.isChinese(words_arr[0])) {
                for (int i = 0; i < words_arr.length; i++) {
                    try {
                        byte[] hex = new byte[2];
                        byte[] bytes = words_arr[i].getBytes("gb2312");
                        hex[0] = bytes[0];
                        hex[1] = bytes[1];
                        hex_str += DigitalTrans.byte2hex(hex);
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                }

                byte[] mnemonicBuffer = HexUtil.hexStringToBytes(hex_str);
                result = XMHCoinUtitls.CoinID_SetMaster(mnemonicBuffer, (short) mnemonicBuffer.length);
            } else {
                byte[] mnemonicBuffer = CommonUtil.strToByteArray(words.replace(" ", ""));
                result = XMHCoinUtitls.CoinID_SetMaster(mnemonicBuffer, (short) mnemonicBuffer.length);
            }
        }

        if (result) {
            byte[] bytes = XMHCoinUtitls.CoinID_getMasterPubKey();
            if (bytes != null && bytes.length > 0) {
                String masterPubKey = new String(bytes);
                if (!TextUtils.isEmpty(masterPubKey)) {

//                    if(chainType == Constants.COIN_TYPE.TYPE_ALL || chainType == Constants.COIN_TYPE.TYPE_EOS){
//                        //EOS
//                        if(common == Constants.LEAD_TYPE.STANDARMEMO){
//                            String ownerStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/194'/0'/0/0");
//                            String activeStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/194'/0'/0/0");
//                            owner_byte = HexUtil.hexStringToBytes(ownerStr);
//                            active_byte = HexUtil.hexStringToBytes(activeStr);
//                        } else {
//                            XMHCoinUtitls.CoinID_DeriveEOSKeyRoot();
//                            XMHCoinUtitls.CoinID_DeriveEOSKeyAccount(0);
//                            owner_byte = XMHCoinUtitls.CoinID_DeriveEOSKey(0);
//                            active_byte = XMHCoinUtitls.CoinID_DeriveEOSKey(1);
//                        }
//
//                        //私钥
//                        owner_private_result = new byte[32];
//                        active_private_result = new byte[32];
//                        System.arraycopy(owner_byte, 0, owner_private_result, 0, owner_private_result.length);
//                        System.arraycopy(active_byte, 0, active_private_result, 0, active_private_result.length);
//                        owner_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(XMHCoinUtitls.CoinID_ExportEOSPrvKey(owner_private_result), pin));
//                        active_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(XMHCoinUtitls.CoinID_ExportEOSPrvKey(active_private_result), pin));
//
//                        //公钥的
//                        owner_public_result = new byte[owner_byte.length - 32];
//                        active_public_result = new byte[active_byte.length - 32];
//                        System.arraycopy(owner_byte, 32, owner_public_result, 0, owner_public_result.length);
//                        System.arraycopy(active_byte, 32, active_public_result, 0, active_public_result.length);
//                        owner_public = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_ExportEOSPubKey(owner_public_result));
//                        active_public = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_ExportEOSPubKey(active_public_result));
//                        Map map = new HashMap();
//                        map.put("prvKey", owner_private);
//                        map.put("subPrvKey", active_private);
//                        map.put("pubKey", owner_public);
//                        map.put("subPubKey", active_public);
//                        map.put("coinType", Constants.COIN_TYPE.TYPE_EOS);
//                        map.put("address", "");
//                        map.put("masterPubKey", masterPubKey);
//                        wallets.add(map);
//                    }
//
//                    if(chainType == Constants.COIN_TYPE.TYPE_ALL || chainType == Constants.COIN_TYPE.TYPE_GPS){
//                        //GPS
//                        if(common == Constants.LEAD_TYPE.STANDARMEMO){
//                            String ownerStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/194'/0'/0/0");
//                            String activeStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/194'/0'/0/0");
//                            owner_gps_byte = HexUtil.hexStringToBytes(ownerStr);
//                            active_gps_byte = HexUtil.hexStringToBytes(activeStr);
//                        } else {
//                            XMHCoinUtitls.CoinID_DeriveEOSKeyAccount(1);
//                            owner_gps_byte = XMHCoinUtitls.CoinID_DeriveEOSKey(0);
//                            active_gps_byte = XMHCoinUtitls.CoinID_DeriveEOSKey(1);
//                        }
//
//                        //私钥
//                        owner_gps_private_result = new byte[32];
//                        active_gps_private_result = new byte[32];
//                        System.arraycopy(owner_gps_byte, 0, owner_gps_private_result, 0, owner_gps_private_result.length);
//                        System.arraycopy(active_gps_byte, 0, active_gps_private_result, 0, active_gps_private_result.length);
//                        owner_gps_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(XMHCoinUtitls.CoinID_ExportEOSPrvKey(owner_gps_private_result), pin));
//                        active_gps_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(XMHCoinUtitls.CoinID_ExportEOSPrvKey(active_gps_private_result), pin));
//
//                        //公钥的
//                        owner_gps_public_result = new byte[33];
//                        active_gps_public_result = new byte[33];
//                        System.arraycopy(owner_gps_byte, 32, owner_gps_public_result, 0, owner_gps_public_result.length);
//                        System.arraycopy(active_gps_byte, 32, active_gps_public_result, 0, active_gps_public_result.length);
//                        owner_gps_public = XMHCoinUtitls.CoinID_ExportEOSPubByPre("GPS", HexUtil.encodeHexStr(owner_gps_public_result));
//                        active_gps_public = XMHCoinUtitls.CoinID_ExportEOSPubByPre("GPS", HexUtil.encodeHexStr(active_gps_public_result));
//
//                        Map map = new HashMap();
//                        map.put("prvKey", owner_gps_private);
//                        map.put("subPrvKey", active_gps_private);
//                        map.put("pubKey", owner_gps_public);
//                        map.put("subPubKey", active_gps_public);
//                        map.put("coinType", Constants.COIN_TYPE.TYPE_GPS);
//                        map.put("address", "");
//                        map.put("masterPubKey", masterPubKey);
//                        wallets.add(map);
//                    }
/*
                    if (chainType == Constants.COIN_TYPE.TYPE_ALL || chainType == Constants.COIN_TYPE.TYPE_BTC) {
                        //btc
                        if (common == Constants.LEAD_TYPE.STANDARMEMO) {
                            String btcStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/0'/0'/0/0");
                            btc_byte = HexUtil.hexStringToBytes(btcStr);
                        } else {
                            XMHCoinUtitls.CoinID_DeriveBTCKeyRoot();
                            XMHCoinUtitls.CoinID_DeriveBTCKeyAccount(0);
                            btc_byte = XMHCoinUtitls.CoinID_DeriveBTCKey(0);
                        }

                        //私钥
                        btc_private_result = new byte[32];
                        System.arraycopy(btc_byte, 0, btc_private_result, 0, btc_private_result.length);

                        //公钥
                        btc_public_result = new byte[btc_byte.length - 32];
                        System.arraycopy(btc_byte, 32, btc_public_result, 0, btc_public_result.length);

                        btc_public = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_genBTCAddress((byte) 0, btc_public_result, (byte) 33, (byte) 0));
                        btc_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(XMHCoinUtitls.CoinID_ExportBTCPrvKeyByWIF(btc_private_result), pin));

                        Map map = new HashMap();
                        map.put("pubKey", DigitalTrans.byte2hex(btc_public_result));
                        map.put("prvKey", btc_private);
                        map.put("coinType", Constants.COIN_TYPE.TYPE_BTC);
                        map.put("address", btc_public);
                        map.put("masterPubKey", masterPubKey);
                        wallets.add(map);
                    }
                    */
                    if ( chainType == Constants.COIN_TYPE.TYPE_ETH) {
                        //eth
                        if (common == Constants.LEAD_TYPE.STANDARMEMO) {
                            String ethStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/60'/0'/0/0");
                            eth_byte = HexUtil.hexStringToBytes(ethStr);
                        } else {
                            XMHCoinUtitls.CoinID_DeriveETHKeyRoot();
                            XMHCoinUtitls.CoinID_DeriveETHKeyAccount(0);
                            eth_byte = XMHCoinUtitls.CoinID_DeriveETHKey(0);
                        }

                        //私钥
                        eth_private_result = new byte[32];
                        System.arraycopy(eth_byte, 0, eth_private_result, 0, eth_private_result.length);

                        //公钥
                        eth_public_result = new byte[eth_byte.length - 33];
                        System.arraycopy(eth_byte, 33, eth_public_result, 0, eth_public_result.length);

                        eth_public = "0x" + CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_ExportETHPubKey(eth_public_result));
                        eth_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(CommonUtil.strToByteArrayNotAddEnd(DigitalTrans.byte2hex(eth_private_result)), pin));

                        Map map = new HashMap();
                        map.put("pubKey", DigitalTrans.byte2hex(eth_public_result));
                        map.put("prvKey", eth_private);
                        map.put("coinType", Constants.COIN_TYPE.TYPE_ETH);
                        map.put("address", eth_public);
                        map.put("masterPubKey", masterPubKey);
                        wallets.add(map);

                    }

//                    if (chainType == Constants.COIN_TYPE.TYPE_ALL || chainType == Constants.COIN_TYPE.TYPE_POLKADOT) {
//
//                        short[] mnemonicIndexBuffer = new short[words_arr.length];
//                        String[] momeArr = new String[0];
//                        if (CommonUtil.isChinese(words_arr[0])) {
//                            String memos = CommonUtil.readAssetsTxt("chinese_simplified").replace("\r\n", ",").replace("\n", ",").replace("\r", ",").replace("\t", ",");
//                            momeArr = memos.split(",");
//                        } else {
//                            String memos = CommonUtil.readAssetsTxt("english").replace("\r\n", ",").replace("\n", ",").replace("\r", ",").replace("\t", ",");
//                            momeArr = memos.split(",");
//                        }
//
//                        if (momeArr.length > 0) {
//                            ArrayList arrayList = new ArrayList<>(Arrays.asList(momeArr));
//                            for (int i = 0; i < words_arr.length; i++) {
//                                mnemonicIndexBuffer[i] = (short) arrayList.indexOf(words_arr[i]);
//                            }
//                        }
//
//                        //波卡
//                        String pkStr = XMHCoinUtitls.CoinID_genPolkaDotKeyPairByPath(mnemonicIndexBuffer, words_arr.length, "");
//                        pk_byte = HexUtil.hexStringToBytes(pkStr);
//
//                        //私钥
//                        pk_private_result = new byte[64];
//                        System.arraycopy(pk_byte, 0, pk_private_result, 0, pk_private_result.length);
//
//                        //公钥
//                        pk_public_result = new byte[pk_byte.length - 64];
//                        System.arraycopy(pk_byte, 64, pk_public_result, 0, pk_public_result.length);
//
//                        pk_public = XMHCoinUtitls.CoinID_getPolkaDotAddress((byte) 0, HexUtil.encodeHexStr(pk_public_result));
//                        pk_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(CommonUtil.strToByteArrayNotAddEnd(DigitalTrans.byte2hex(pk_private_result)), pin));
//
//                        Map map = new HashMap();
//                        map.put("pubKey", DigitalTrans.byte2hex(pk_public_result));
//                        map.put("prvKey", pk_private);
//                        map.put("coinType", Constants.COIN_TYPE.TYPE_POLKADOT);
//                        map.put("address", pk_public);
//                        map.put("masterPubKey", masterPubKey);
//                        wallets.add(map);
//                    }
//
//                    if (chainType == Constants.COIN_TYPE.TYPE_ALL || chainType == Constants.COIN_TYPE.TYPE_BSC) {
//                        //vns
//                        if (common == Constants.LEAD_TYPE.STANDARMEMO) {
//                            String vnsStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/714'/0'/0/0");
//                            vns_byte = HexUtil.hexStringToBytes(vnsStr);
//                        } else {
//                            XMHCoinUtitls.CoinID_DeriveKeyRoot(0x2ca);
//                            XMHCoinUtitls.CoinID_DeriveKeyAccount(0);
//                            vns_byte = XMHCoinUtitls.CoinID_DeriveKey(0);
//                        }
//
//                        //私钥
//                        vns_private_result = new byte[32];
//                        System.arraycopy(vns_byte, 0, vns_private_result, 0, vns_private_result.length);
//
//                        //公钥
//                        vns_public_result = new byte[vns_byte.length - 33];
//                        System.arraycopy(vns_byte, 33, vns_public_result, 0, vns_public_result.length);
//
//                        vns_public = "0x" + CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_ExportETHPubKey(vns_public_result));
//                        vns_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(CommonUtil.strToByteArrayNotAddEnd(DigitalTrans.byte2hex(vns_private_result)), pin));
//
//                        Map map = new HashMap();
//                        map.put("pubKey", DigitalTrans.byte2hex(vns_public_result));
//                        map.put("prvKey", vns_private);
//                        map.put("coinType", Constants.COIN_TYPE.TYPE_BSC);
//                        map.put("address", vns_public);
//                        map.put("masterPubKey", masterPubKey);
//                        wallets.add(map);
//                    }
//
//                    if (chainType == Constants.COIN_TYPE.TYPE_ALL || chainType == Constants.COIN_TYPE.TYPE_KSM) {
//
//                        short[] mnemonicIndexBuffer = new short[words_arr.length];
//                        String[] momeArr = new String[0];
//                        if (CommonUtil.isChinese(words_arr[0])) {
//                            String memos = CommonUtil.readAssetsTxt("chinese_simplified").replace("\r\n", ",").replace("\n", ",").replace("\r", ",").replace("\t", ",");
//                            momeArr = memos.split(",");
//                        } else {
//                            String memos = CommonUtil.readAssetsTxt("english").replace("\r\n", ",").replace("\n", ",").replace("\r", ",").replace("\t", ",");
//                            momeArr = memos.split(",");
//                        }
//
//                        if (momeArr.length > 0) {
//                            ArrayList arrayList = new ArrayList<>(Arrays.asList(momeArr));
//                            for (int i = 0; i < words_arr.length; i++) {
//                                mnemonicIndexBuffer[i] = (short) arrayList.indexOf(words_arr[i]);
//                            }
//                        }
//
//                        //KSM
//                        String pkStr = XMHCoinUtitls.CoinID_genPolkaDotKeyPairByPath(mnemonicIndexBuffer, words_arr.length, "");
//                        pk_byte = HexUtil.hexStringToBytes(pkStr);
//
//                        //私钥
//                        pk_private_result = new byte[64];
//                        System.arraycopy(pk_byte, 0, pk_private_result, 0, pk_private_result.length);
//
//                        //公钥
//                        pk_public_result = new byte[pk_byte.length - 64];
//                        System.arraycopy(pk_byte, 64, pk_public_result, 0, pk_public_result.length);
//
//                        pk_public = XMHCoinUtitls.CoinID_getPolkaDotAddress((byte) 2, HexUtil.encodeHexStr(pk_public_result));
//                        pk_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(CommonUtil.strToByteArrayNotAddEnd(DigitalTrans.byte2hex(pk_private_result)), pin));
//
//                        Map map = new HashMap();
//                        map.put("pubKey", DigitalTrans.byte2hex(pk_public_result));
//                        map.put("prvKey", pk_private);
//                        map.put("coinType", Constants.COIN_TYPE.TYPE_KSM);
//                        map.put("address", pk_public);
//                        map.put("masterPubKey", masterPubKey);
//                        wallets.add(map);
//                    }


//                    if(chainType == Constants.COIN_TYPE.TYPE_ALL || chainType == Constants.COIN_TYPE.TYPE_BTM){
//                        //btm
//                        if(common == Constants.LEAD_TYPE.STANDARMEMO){
//                            String btmStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44/153/1/0/1");
//                            btm_byte = HexUtil.hexStringToBytes(btmStr);
//                        } else {
//                            XMHCoinUtitls.CoinID_DeriveKeyRoot(0x99);
//                            XMHCoinUtitls.CoinID_DeriveKeyAccount(0);
//                            btm_byte = XMHCoinUtitls.CoinID_DeriveKey(0);
//                        }
//
//                        //私钥
//                        btm_private_result = new byte[64];
//                        System.arraycopy(btm_byte, 0, btm_private_result, 0, btm_private_result.length);
//
//                        //公钥
//                        btm_public_result = new byte[64];
//                        System.arraycopy(btm_byte, 64, btm_public_result, 0, btm_public_result.length);
//
//                        btm_public = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_getBYTOMAddress(btm_public_result));
//                        btm_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(CommonUtil.strToByteArrayNotAddEnd(DigitalTrans.byte2hex(btm_private_result)), pin));
//
//                        Map map = new HashMap();
//                        map.put("pubKey", DigitalTrans.byte2hex(btm_public_result));
//                        map.put("prvKey", btm_private);
//                        map.put("coinType", Constants.COIN_TYPE.TYPE_BTM);
//                        map.put("address", btm_public);
//                        map.put("masterPubKey", masterPubKey);
//                        wallets.add(map);
//                    }

//                    if(chainType == Constants.COIN_TYPE.TYPE_ALL || chainType == Constants.COIN_TYPE.TYPE_LTC){
//                        //ltc
//                        if(common == Constants.LEAD_TYPE.STANDARMEMO){
//                            String ltcStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/2'/0'/0/0");
//                            ltc_byte = HexUtil.hexStringToBytes(ltcStr);
//                        } else {
//                            XMHCoinUtitls.CoinID_DeriveKeyRoot(2);
//                            XMHCoinUtitls.CoinID_DeriveKeyAccount(0);
//                            ltc_byte = XMHCoinUtitls.CoinID_DeriveKey(0);
//                        }
//
//                        //私钥
//                        ltc_private_result = new byte[32];
//                        System.arraycopy(ltc_byte, 0, ltc_private_result, 0, ltc_private_result.length);
//
//                        //公钥
//                        ltc_public_result = new byte[ltc_byte.length - 32];
//                        System.arraycopy(ltc_byte, 32, ltc_public_result, 0, ltc_public_result.length);
//
//                        ltc_public = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_genBTCAddress((byte) 48, ltc_public_result, (byte) 33, (byte) 0));
//                        ltc_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(XMHCoinUtitls.CoinID_ExportPrvKeyByWIF((byte) 176, ltc_private_result), pin));
//
//                        Map map = new HashMap();
//                        map.put("pubKey", DigitalTrans.byte2hex(ltc_public_result));
//                        map.put("prvKey", ltc_private);
//                        map.put("coinType", Constants.COIN_TYPE.TYPE_LTC);
//                        map.put("address", ltc_public);
//                        map.put("masterPubKey", masterPubKey);
//                        wallets.add(map);
//                    }

//                    if(chainType == Constants.COIN_TYPE.TYPE_ALL || chainType == Constants.COIN_TYPE.TYPE_USDT){
//                        //btc
//                        if(common == Constants.LEAD_TYPE.STANDARMEMO){
//                            String btcStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/0'/0'/0/0");
//                            btc_byte = HexUtil.hexStringToBytes(btcStr);
//                        } else {
//                            XMHCoinUtitls.CoinID_DeriveBTCKeyRoot();
//                            XMHCoinUtitls.CoinID_DeriveBTCKeyAccount(0);
//                            btc_byte = XMHCoinUtitls.CoinID_DeriveBTCKey(0);
//                        }
//
//                        //私钥
//                        btc_private_result = new byte[32];
//                        System.arraycopy(btc_byte, 0, btc_private_result, 0, btc_private_result.length);
//
//                        //公钥
//                        btc_public_result = new byte[btc_byte.length - 32];
//                        System.arraycopy(btc_byte, 32, btc_public_result, 0, btc_public_result.length);
//
//                        btc_public = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_genBTCAddress((byte) 0, btc_public_result, (byte) 33, (byte) 0));
//                        btc_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(XMHCoinUtitls.CoinID_ExportBTCPrvKeyByWIF(btc_private_result), pin));
//
//                        Map map = new HashMap();
//                        map.put("pubKey", DigitalTrans.byte2hex(btc_public_result));
//                        map.put("prvKey", btc_private);
//                        map.put("coinType", Constants.COIN_TYPE.TYPE_USDT);
//                        map.put("address", btc_public);
//                        map.put("masterPubKey", masterPubKey);
//                        wallets.add(map);
//                    }


//                                    //bch
//                                    boolean bch_result = XMHCoinUtitls.CoinID_DeriveKeyRoot(0x91);
//                                    if (bch_result) {
//                                        XMHCoinUtitls.CoinID_DeriveKeyAccount(0);
//                                        bch_byte = XMHCoinUtitls.CoinID_DeriveKey(0);
//
//                                        //私钥
//                                        bch_private_result = new byte[32];
//                                        System.arraycopy(bch_byte, 0, bch_private_result, 0, bch_private_result.length);
//
//                                        //公钥
//                                        bch_public_result = new byte[bch_byte.length - 32];
//                                        System.arraycopy(bch_byte, 32, bch_public_result, 0, bch_public_result.length);
//
//                                        bch_public = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_getBCHAddress(bch_public_result));
//                                        bch_private = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_ExportPrvKeyByWIF((byte) 128, bch_private_result));
//                                    }
//
//                                    //dash
//                                    boolean dash_result = XMHCoinUtitls.CoinID_DeriveKeyRoot(5);
//                                    if (dash_result) {
//                                        XMHCoinUtitls.CoinID_DeriveKeyAccount(0);
//                                        dash_byte = XMHCoinUtitls.CoinID_DeriveKey(0);
//
//                                        //私钥
//                                        dash_private_result = new byte[32];
//                                        System.arraycopy(dash_byte, 0, dash_private_result, 0, dash_private_result.length);
//
//                                        //公钥
//                                        dash_public_result = new byte[dash_byte.length - 32];
//                                        System.arraycopy(dash_byte, 32, dash_public_result, 0, dash_public_result.length);
//
//                                        dash_public = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_genBTCAddress((byte) 76, dash_public_result, (byte) 33, (byte) 0));
//                                        dash_private = CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_ExportPrvKeyByWIF((byte) 204, dash_private_result));
//                                    }
                }
            }
        }
        return wallets;
    }
}
