package com.fictitious.money.purse.utils.wallet;

import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.DigitalTrans;
import com.fictitious.money.purse.utils.HexUtil;
import com.fictitious.money.purse.utils.XMHCoinUtitls;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class ExportKeyStoreUtil {
    public static Map exportKeyStore(String content, String pin, int coinType){
        Map map = new HashMap();
        String keyStore = getWalletKeystore(content, pin, coinType);
        map.put("coinType", coinType);
        map.put("keyStore", keyStore);
        return map;
    }

    static String getWalletKeystore(String content, String pwd, int coinType){
        byte[] prvKey = DigitalTrans.decKeyByAES128CBC(HexUtil.hexStringToBytes(content), pwd, coinType);

            byte[] keyStoreByte = null;
            byte[] salt = new byte[64];
            byte[] iv = new byte[32];
            byte[] uuid = new byte[32];
            Random random = new Random();
            String saltStr = "";
            String ivStr = "";
            String uuidStr = "";
            for(int i = 0; i < salt.length; i ++){
                saltStr += random.nextInt(10);
            }
            salt = CommonUtil.strToByteArray(saltStr);
            for(int i = 0; i < iv.length; i ++){
                ivStr += random.nextInt(10);
            }
            iv = CommonUtil.strToByteArray(ivStr);
            for(int i = 0; i < uuid.length; i ++){
                uuidStr += random.nextInt(10);
            }
            uuid = CommonUtil.strToByteArray(uuidStr);
            if(coinType == Constants.COIN_TYPE.TYPE_ETH) {
               
                keyStoreByte = new byte[32];
                byte[] keyByte = HexUtil.hexStringToBytes(CommonUtil.byteArrayToStr(prvKey));
                System.arraycopy(keyByte, 0, keyStoreByte, 0 , keyStoreByte.length);//私钥
            }
            if(keyStoreByte != null){
                try {
//                Log.d("keystore", "===pwd==" + HexUtil.formatHexString(CommonUtil.strToByteArray(pwd)));
//                Log.d("keystore", "===pwd.length==" + (byte) CommonUtil.strToByteArray(pwd).length);
                    // System.out.println("keyStoreByte ");
                    // for(int a = 0 ; a< keyStoreByte.length ; a++ ){
                    //       System.out.println(keyStoreByte[a]);
                    // }
                    // System.out.println( HexUtil.formatHexString(keyStoreByte));
                    // System.out.println(" keyStoreByte len ");
                    // System.out.println( (byte) keyStoreByte.length);
//                Log.d("keystore", "===salt==" + HexUtil.formatHexString(salt));
//                Log.d("keystore", "===iv==" + HexUtil.formatHexString(iv));
//                Log.d("keystore", "===uuid==" + HexUtil.formatHexString(uuid));
                    byte[] jsonByte = XMHCoinUtitls.CoinID_exportKeyStore(keyStoreByte, (byte) keyStoreByte.length, (byte) 0, CommonUtil.strToByteArray(pwd), (byte) CommonUtil.strToByteArray(pwd).length, salt, iv, uuid);
                    String json = new String(jsonByte);
                    return json;
                }catch (Exception e){
                    e.printStackTrace();
                }
            }

        return "";
    }
}
