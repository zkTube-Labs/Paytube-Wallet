package com.fictitious.money.purse.utils.wallet;

import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.DigitalTrans;
import com.fictitious.money.purse.utils.HexUtil;

import java.util.HashMap;
import java.util.Map;

public class ExportPrvKeyUtil {
    public static Map exportPrvKey(String content, String pin, int coinType){
        Map map = new HashMap();
        map.put("coinType", coinType);
        map.put("prvKey", CommonUtil.byteArrayToStr(DigitalTrans.decKeyByAES128CBC(HexUtil.hexStringToBytes(content), pin, coinType)));
        return map;
    }
}
