package com.fictitious.money.purse.utils.wallet;

import android.text.TextUtils;

import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.model.MemorizingWordInfo;
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

public class ImportWalletUtil {

    //EOS
    private static String temp_public, temp_private;
    private static String owner_public, owner_private;
    private static String active_public, active_private;
    private static byte[] owner_byte, active_byte;
    private static byte[] owner_public_result, active_public_result;
    private static byte[] owner_private_result, active_private_result;

    //GPS
    private static String owner_gps_public, owner_gps_private;
    private static String active_gps_public, active_gps_private;
    private static byte[] owner_gps_byte, active_gps_byte;
    private static byte[] owner_gps_public_result, active_gps_public_result;
    private static byte[] owner_gps_private_result, active_gps_private_result;

    //vns
    private static String vns_public, vns_private;
    private static byte[] vns_byte;
    private static byte[] vns_public_result, vns_private_result;

    //eth
    private static String eth_public, eth_private;
    private static byte[] eth_byte;
    private static byte[] eth_public_result, eth_private_result;

    //btc
    private static String btc_public, btc_private;
    private static byte[] btc_byte;
    private static byte[] btc_public_result, btc_private_result;

    //btm
    private static String btm_public, btm_private;
    private static byte[] btm_byte;
    private static byte[] btm_public_result, btm_private_result;

    //ltc
    private static String ltc_public, ltc_private;
    private static byte[] ltc_byte;
    private static byte[] ltc_public_result, ltc_private_result;

    //bch
    private static String bch_public, bch_private;
    private static byte[] bch_byte;
    private static byte[] bch_public_result, bch_private_result;

    //dash
    private static String dash_public, dash_private;
    private static byte[] dash_byte;
    private static byte[] dash_public_result, dash_private_result;

    //polkadot
    private static String pk_public, pk_private;
    private static byte[] pk_byte;
    private static byte[] pk_public_result, pk_private_result;

    public static List importPurse(int leadType, int mCoin_type, String pin, String content)
    {
        boolean isChinese = false;
        List<MemorizingWordInfo> wordslist = new ArrayList<>();
        List wallets = new ArrayList();
        if( leadType == Constants.LEAD_TYPE.STANDARMEMO)
        {
            String chinese = CommonUtil.readAssetsTxt("chinese_simplified").replace("\r\n",",").replace("\n",",").replace("\r",",").replace("\t",",");
            String englise = CommonUtil.readAssetsTxt("english").replace("\r\n",",").replace("\n",",").replace("\r",",").replace("\t",",");
            String[] chineses = chinese.split(",");
            String[] englishs = englise.split(",");
            List<String> arr_chinese = new ArrayList<>();
            List<String> arr_english = new ArrayList<>();

            if(chineses != null)
            {
                arr_chinese = Arrays.asList(chinese.split(","));
            }

            if(englishs != null)
            {
                arr_english = Arrays.asList(englise.split(","));
            }

            String wordList = content.replaceAll(",", " ").replaceAll("，", " ").trim();
            String[] words = wordList.split(" ");
            List<String> arr_words = Arrays.asList(words);
            if(words.length != 12 && words.length != 18 && words.length != 24)
            {
                return wallets;
            }
            else
            {
                boolean isError = false;
                for (String s : arr_words)
                {
                    if(!arr_chinese.contains(s))
                    {
                        isError = false;
                        break;
                    }
                    else
                    {
                        isError = true;
                        isChinese = true;
                    }
                }

                if(!isError)
                {
                    for (String s : arr_words)
                    {
                        if(!arr_english.contains(s))
                        {
                            isError = false;
                            break;
                        }
                        else
                        {
                            isError = true;
                            isChinese = false;
                        }
                    }
                }

                if(isError)
                {
                    for (String s : arr_words)
                    {
                        if(isChinese){
                            for (int i = 0; i < arr_chinese.size(); i ++)
                            {
                                if(s.equals(arr_chinese.get(i)))
                                {
                                    MemorizingWordInfo memorizingWordInfo = new MemorizingWordInfo();
                                    memorizingWordInfo.setIndex(i);
                                    memorizingWordInfo.setWord(s);
                                    wordslist.add(memorizingWordInfo);
                                }
                            }
                        } else {
                            for (int i = 0; i < arr_english.size(); i ++)
                            {
                                if(s.equals(arr_english.get(i)))
                                {
                                    MemorizingWordInfo memorizingWordInfo = new MemorizingWordInfo();
                                    memorizingWordInfo.setIndex(i);
                                    memorizingWordInfo.setWord(s);
                                    wordslist.add(memorizingWordInfo);
                                }
                            }
                        }
                    }

                    String[] words_arr = content.replaceAll(",", " ").replaceAll("，", " ").trim().split(" ");
                    short[] index_arr = new short[wordslist.size()];
                    String hex_str = "";
                    boolean result;
                    if(wordslist !=  null && wordslist.size() > 0){
                        for (int i = 0; i < wordslist.size(); i ++) {
                            index_arr[i] = (short) wordslist.get(i).getIndex();
                        }
                    }
                    boolean checkMemo = XMHCoinUtitls.CoinID_checkMemoValid(index_arr, (byte) (index_arr.length));
                    if(!checkMemo){
                        wordslist.clear();
                        return wallets;
                    }

                    if(leadType == Constants.LEAD_TYPE.STANDARMEMO){
                        result =  XMHCoinUtitls.CoinID_SetMasterStandard(content.replaceAll(",", " ").replaceAll("，", " ").trim());
                    } else {
                        if (isChinese) {
                            for (int i = 0; i < words_arr.length; i ++) {
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
                            result =  XMHCoinUtitls.CoinID_SetMaster(mnemonicBuffer, (short) mnemonicBuffer.length);//先验证助记词
                        } else {
                            byte[] mnemonicBuffer = CommonUtil.strToByteArray(wordList.replace(" ", ""));
                            result =  XMHCoinUtitls.CoinID_SetMaster(mnemonicBuffer, (short) mnemonicBuffer.length);//先验证助记词
                        }
                    }

                    if(result){

                         if(mCoin_type == Constants.COIN_TYPE.TYPE_ETH)
                        {
                            if(leadType == Constants.LEAD_TYPE.STANDARMEMO){
                                String ethStr = XMHCoinUtitls.CoinID_deriveKeyByPath("44'/60'/0'/0/0");
                                eth_byte = HexUtil.hexStringToBytes(ethStr);
                            } else {
                                XMHCoinUtitls.CoinID_DeriveETHKeyRoot();
                                XMHCoinUtitls.CoinID_DeriveETHKeyAccount(0);
                                eth_byte = XMHCoinUtitls.CoinID_DeriveETHKey(0);
                            }
                            return getEthPurse(eth_byte,  pin);
                        }

                    }
                    else
                    {
                        return wallets;
                    }
                }
                else
                {
                    return wallets;
                }
            }
        }
        else if(leadType == Constants.LEAD_TYPE.KEYSTORE)
        {
            byte[] jsonByte = CommonUtil.strToByteArray(content);
            byte[] passWordByte = CommonUtil.strToByteArray(pin);
            byte[] outLen = new byte[2];

                if(mCoin_type == Constants.COIN_TYPE.TYPE_ETH){
                eth_byte = XMHCoinUtitls.CoinID_importKeyStore(jsonByte, passWordByte, (byte) passWordByte.length, outLen);
                return getEthPurse(eth_byte, pin);
            }

        }
        else if(leadType == Constants.LEAD_TYPE.PRVKEY)
        {
            String prvStr = content.replace("\r\n","").replace("\n","").replace("\r","").replace("\t","").replace(" ", "").replace(" ", "").trim();

             if(mCoin_type == Constants.COIN_TYPE.TYPE_ETH)
            {
                byte[] prvKey;
                try {
                    prvKey = DigitalTrans.hex2byte(prvStr);
                } catch (Exception e) {
                    return wallets;
                }

                if(prvKey == null || prvKey.length != 32){
                    return wallets;
                }

                eth_byte = XMHCoinUtitls.CoinID_ImportETHPrvKey(prvKey);
                return getEthPurse(eth_byte, pin);
            }

        }
        return wallets;
    }

    static List getEthPurse(byte[] eth_byte, String pin){
        List wallet = new ArrayList();
        if(eth_byte == null || eth_byte.length <= 33){
            return wallet;
        }

        //私钥
        eth_private_result = new byte[32];
        System.arraycopy(eth_byte, 0, eth_private_result, 0 , eth_private_result.length);

        //公钥
        eth_public_result = new byte[eth_byte.length - 33];
        System.arraycopy(eth_byte, 33, eth_public_result, 0 , eth_public_result.length);

        eth_public = "0x"+ CommonUtil.byteArrayToStr(XMHCoinUtitls.CoinID_ExportETHPubKey(eth_public_result));
//        eth_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(eth_private_result, pin));
        eth_private = DigitalTrans.byte2hex(DigitalTrans.encKeyByAES128CBC(CommonUtil.strToByteArrayNotAddEnd(DigitalTrans.byte2hex(eth_private_result)), pin));

        Map map = new HashMap();
        map.put("prvKey", eth_private);
        map.put("pubKey", DigitalTrans.byte2hex(eth_public_result));
        map.put("coinType", Constants.COIN_TYPE.TYPE_ETH);
        map.put("address", eth_public);
        map.put("masterPubKey", "");
        wallet.add(map);
        return wallet;
    }

}
