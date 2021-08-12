package com.fictitious.money.purse.utils;

import android.text.TextUtils;

import com.fictitious.money.purse.Constants;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;

public class DigitalTrans {

    /**
     * 数字字符串转ASCII码字符串
     *
     *            字符串
     * @return ASCII字符串
     */
    public static String StringToAsciiString(String content) {
        String result = "";
        int max = content.length();
        for (int i = 0; i < max; i++) {
            char c = content.charAt(i);
            String b = Integer.toHexString(c);
            result = result + b;
        }
        return result;
    }

    public static String toUtf8(String str) {
        String result = null;
        try {
            result = new String(str.getBytes("UTF-8"), "UTF-8");
        } catch (UnsupportedEncodingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return result;
    }

    public static String integerToAsciiString(String content) {
        String result = "";
        try
        {
            int max = content.length();
            for (int i = 0; i < max; i++) {
                Integer integer = Integer.parseInt(String.valueOf(content.charAt(i)));
                String b = algorismToHEXString(integer);
                result = result + b;
            }
        }
        catch (Exception e)
        {

        }
        return result;
    }

    /**
     * 十六进制转字符串
     *
     * @param hexString
     *            十六进制字符串
     * @param encodeType
     *            编码类型4：Unicode，2：普通编码
     * @return 字符串
     */
    public static String hexStringToString(String hexString, int encodeType) {
        String result = "";
        int max = hexString.length() / encodeType;
        for (int i = 0; i < max; i++) {
            char c = (char) DigitalTrans.hexStringToAlgorism(hexString
                    .substring(i * encodeType, (i + 1) * encodeType));
            result += c;
        }
        return result;
    }
    /**
     * 十六进制字符串装十进制
     *
     * @param hex
     *            十六进制字符串
     * @return 十进制数值
     */
    public static int hexStringToAlgorism(String hex) {
        if(hex.startsWith("0x"))
        {
            hex = hex.replace("0x", "");
        }
        hex = hex.toUpperCase();
        int max = hex.length();
        int result = 0;
        for (int i = max; i > 0; i--) {
            char c = hex.charAt(i - 1);
            int algorism = 0;
            if (c >= '0' && c <= '9') {
                algorism = c - '0';
            } else {
                algorism = c - 55;
            }
            result += Math.pow(16, max - i) * algorism;
        }
        return result;
    }
    /**
     * 十六转二进制
     *
     * @param hex
     *            十六进制字符串
     * @return 二进制字符串
     */
    public static String hexStringToBinary(String hex) {
        hex = hex.toUpperCase();
        String result = "";
        int max = hex.length();
        for (int i = 0; i < max; i++) {
            char c = hex.charAt(i);
            switch (c) {
                case '0':
                    result += "0000";
                    break;
                case '1':
                    result += "0001";
                    break;
                case '2':
                    result += "0010";
                    break;
                case '3':
                    result += "0011";
                    break;
                case '4':
                    result += "0100";
                    break;
                case '5':
                    result += "0101";
                    break;
                case '6':
                    result += "0110";
                    break;
                case '7':
                    result += "0111";
                    break;
                case '8':
                    result += "1000";
                    break;
                case '9':
                    result += "1001";
                    break;
                case 'A':
                    result += "1010";
                    break;
                case 'B':
                    result += "1011";
                    break;
                case 'C':
                    result += "1100";
                    break;
                case 'D':
                    result += "1101";
                    break;
                case 'E':
                    result += "1110";
                    break;
                case 'F':
                    result += "1111";
                    break;
            }
        }
        return result;
    }
    /**
     * ASCII码字符串转数字字符串
     *
     * @param content
     *            ASCII字符串
     * @return 字符串
     */
    public static String AsciiStringToString(String content) {
        String result = "";
        int length = content.length() / 2;
        for (int i = 0; i < length; i++) {
            String c = content.substring(i * 2, i * 2 + 2);
            int a = hexStringToAlgorism(c);
            char b = (char) a;
            String d = String.valueOf(b);
            result += d;
        }
        return result;
    }
    /**
     * 将十进制转换为指定长度的十六进制字符串
     *
     * @param algorism
     *            int 十进制数字
     * @param maxLength
     *            int 转换后的十六进制字符串长度
     * @return String 转换后的十六进制字符串
     */
    public static String algorismToHEXString(int algorism, int maxLength) {
        String result = "";
        result = Integer.toHexString(algorism);

        if (result.length() % 2 == 1) {
            result = "0" + result;
        }
        return patchHexString(result.toUpperCase(), maxLength);
    }

    /**
     * 字节数组转为普通字符串（ASCII对应的字符）
     *
     * @param bytearray
     *            byte[]
     * @return String
     */
    public static String bytetoString(byte[] bytearray) {
        String result = "";
        char temp;

        int length = bytearray.length;
        for (int i = 0; i < length; i++) {
            temp = (char) bytearray[i];
            result += temp;
        }
        return result;
    }
    /**
     * 二进制字符串转十进制
     *
     * @param binary
     *            二进制字符串
     * @return 十进制数值
     */
    public static int binaryToAlgorism(String binary) {
        int max = binary.length();
        int result = 0;
        for (int i = max; i > 0; i--) {
            char c = binary.charAt(i - 1);
            int algorism = c - '0';
            result += Math.pow(2, max - i) * algorism;
        }
        return result;
    }

    /**
     * 十进制转换为十六进制字符串
     *
     * @param algorism
     *            int 十进制的数字
     * @return String 对应的十六进制字符串
     */
    public static String algorismToHEXString(int algorism) {
        String result = "";
        result = Integer.toHexString(algorism);

        if (result.length() % 2 == 1) {
            result = "0" + result;

        }
        result = result.toLowerCase();

        return result;
    }

    /**
     * 十进制的超超超长数，转换十六进制字符串
     * @param bigIntegerPlainString
     * @return
     */
    public static String bigIntegerToHEXString(String bigIntegerPlainString) {
        String result = "";
        result = new BigInteger(bigIntegerPlainString, 10).toString(16);
        if (result.length() % 2 == 1) {
            result = "0" + result;
        }
        result = result.toLowerCase();
        return result;
    }

    public static String hexStringToBigInteger(String hex) {
        String result = "";
        result = new BigInteger(hex, 16).toString(10);
        return result;
    }


    /**
     * 十进制转换为十六进制字符串
     *
     * @param algorism
     *            int 十进制的数字
     * @return String 对应的十六进制字符串
     */
    public static String longToHEXString(long algorism) {
        String result = "";
        result = Long.toHexString(algorism);

        if (result.length() % 2 == 1) {
            result = "0" + result;

        }
        result = result.toLowerCase();

        return result;
    }
    /**
     * HEX字符串前补0，主要用于长度位数不足。
     *
     * @param str
     *            String 需要补充长度的十六进制字符串
     * @param maxLength
     *            int 补充后十六进制字符串的长度
     * @return 补充结果
     */
    static public String patchHexString(String str, int maxLength) {
        String temp = "";
        for (int i = 0; i < maxLength - str.length(); i++) {
            temp = "0" + temp;
        }
        str = (temp + str).substring(0, maxLength);
        return str;
    }
    /**
     * 将一个字符串转换为int
     *
     * @param s
     *            String 要转换的字符串
     * @param defaultInt
     *            int 如果出现异常,默认返回的数字
     * @param radix
     *            int 要转换的字符串是什么进制的,如16 8 10.
     * @return int 转换后的数字
     */
    public static int parseToInt(String s, int defaultInt, int radix) {
        int i = 0;
        try {
            i = Integer.parseInt(s, radix);
        } catch (NumberFormatException ex) {
            i = defaultInt;
        }
        return i;
    }
    /**
     * 将一个十进制形式的数字字符串转换为int
     *
     * @param s
     *            String 要转换的字符串
     * @param defaultInt
     *            int 如果出现异常,默认返回的数字
     * @return int 转换后的数字
     */
    public static int parseToInt(String s, int defaultInt) {
        int i = 0;
        try {
            i = Integer.parseInt(s);
        } catch (NumberFormatException ex) {
            i = defaultInt;
        }
        return i;
    }
    /**
     * 十六进制字符串转为Byte数组,每两个十六进制字符转为一个Byte
     *
     * @param hex
     *            十六进制字符串
     * @return byte 转换结果
     */
    public static byte[] hexStringToByte(String hex) {
        int max = hex.length() / 2;
        byte[] bytes = new byte[max];
        String binarys = DigitalTrans.hexStringToBinary(hex);
        for (int i = 0; i < max; i++) {
            bytes[i] = (byte) DigitalTrans.binaryToAlgorism(binarys.substring(
                    i * 8 + 1, (i + 1) * 8));
            if (binarys.charAt(8 * i) == '1') {
                bytes[i] = (byte) (0 - bytes[i]);
            }
        }
        return bytes;
    }

    /**
     * 将16进制字符串转换为byte[]
     *
     * @param str
     * @return
     */
    public static byte[] toBytes(String str) {
        if(str == null || str.trim().equals("")) {
            return new byte[0];
        }

        byte[] bytes = new byte[str.length() / 2];
        for(int i = 0; i < str.length() / 2; i++) {
            String subStr = str.substring(i * 2, i * 2 + 2);
            bytes[i] = (byte) Integer.parseInt(subStr, 16);
        }

        return bytes;
    }

    /**
     * 十六进制串转化为byte数组
     *
     * @return the array of byte
     */
    public static final byte[] hex2byte(String hex)
            throws IllegalArgumentException {
        if(TextUtils.isEmpty(hex)) {
            return new byte[0];
        }

        if (hex.length() % 2 != 0) {
            return new byte[0];
        }

        try {
            char[] arr = hex.toCharArray();
            byte[] b = new byte[hex.length() / 2];
            for (int i = 0, j = 0, l = hex.length(); i < l; i++, j++) {
                String swap = "" + arr[i++] + arr[i];
                int byteint = Integer.parseInt(swap, 16) & 0xFF;
                b[j] = new Integer(byteint).byteValue();
            }
            return b;
        }catch (Exception e){
            return new byte[0];
        }
    }
    /**
     * 字节数组转换为十六进制字符串
     *
     * @param b
     *            byte[] 需要转换的字节数组
     * @return String 十六进制字符串
     */
    public static final String byte2hex(byte b[]) {
        if (b == null) {
            return "";
        }
        String hs = "";
        String stmp = "";
        for (int n = 0; n < b.length; n++) {
            stmp = Integer.toHexString(b[n] & 0xff);
            if (stmp.length() == 1) {
                hs = hs + "0" + stmp;
            } else {
                hs = hs + stmp;
            }
        }
        return hs.toLowerCase();
    }

    /**
     * 16进制字符串转换为字符串
     *
     * @param s
     * @return
     */
    public static String hexStringToString(String s) {
        if (s == null || s.equals("")) {
            return "";
        }
        s = s.replace(" ", "");
        byte[] baKeyword = new byte[s.length() / 2];
        for (int i = 0; i < baKeyword.length; i++) {
            try {
                baKeyword[i] = (byte) (0xff & Integer.parseInt(
                        s.substring(i * 2, i * 2 + 2), 16));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        try {
            s = new String(baKeyword, "utf-8");
            // 如果有乱码，则返回空串
            if (isMessyCode(s)){
                return "";
            }
        } catch (Exception e1) {
            e1.printStackTrace();
        }
        return s;
    }

    /**
     * 判断是否为乱码
     *
     * @param str
     * @return
     */
    public static boolean isMessyCode(String str) {
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            // 当从Unicode编码向某个字符集转换时，如果在该字符集中没有对应的编码，则得到0x3f（即问号字符?）
            //从其他字符集向Unicode编码转换时，如果这个二进制数在该字符集中没有标识任何的字符，则得到的结果是0xfffd
            //System.out.println("--- " + (int) c);
            if ((int) c == 0xfffd) {
                // 存在乱码
                //System.out.println("存在乱码 " + (int) c);
                return true;
            }
        }
        return false;
    }

    public static byte[] AsciiToHex(String pAscii)
    {
        byte[] pHex = new byte[pAscii.length()/2];

        int nLen = pAscii.length();
        byte[] asicBuf=pAscii.getBytes();
        if ( (nLen % 2) != 0x00)
            return null;
        int nHexLen = nLen / 2;

        for (int i = 0; i < nHexLen; i++)
        {
            byte[] Nibble=new byte[2];

            Nibble[0] = asicBuf[2*i];
            Nibble[1] = asicBuf[2*i +1];
            for (int j = 0; j < 2; j++)
            {
                if (Nibble[j] <= 'F' && Nibble[j] >= 'A')
                    Nibble[j] = (byte)(Nibble[j] - 'A' + (byte)10);
                else if (Nibble[j] <= 'f' && Nibble[j] >= 'a')
                    Nibble[j] = (byte)(Nibble[j] - 'a' + 10);
                else if (Nibble[j] >= '0' && Nibble[j] <= '9')
                    Nibble[j] = (byte)(Nibble[j] - '0');
                else
                    return null;
            }
            pHex[i] = (byte)(Nibble[0] << 4);
            pHex[i] |= Nibble[1];
        }

        return pHex;
    }

    public static byte[] encByAES128CBC(String dataStr, byte[] inputKEY)
    {
        byte[] input = DigitalTrans.AsciiToHex(DigitalTrans.integerToAsciiString(dataStr));
        int inputLen = (input.length + 16) & 0xFFFFFFF0;
        byte[] output = new byte[inputLen];
//        System.out.println("===16进制output==="+DigitalTrans.byte2hex(App.output));
        XMHCoinUtitls.CoinID_EncByAES128CBC(input, (short) input.length, inputKEY, output);
        return  output;
    }

    public static byte[] encByAES128CBC(byte[] input, byte[] inputKEY)
    {
        int inputLen = (input.length + 16) & 0xFFFFFFF0;
        byte[] output = new byte[inputLen];
//        System.out.println("===16进制output==="+DigitalTrans.byte2hex(App.output));
        XMHCoinUtitls.CoinID_EncByAES128CBC(input, (short) input.length, inputKEY, output);
        return  output;
    }

    public static byte[] cardEncByAES128CBC(byte[] input, byte[] inputKEY)
    {
        int inputLen = (input.length + 16) & 0xFFFFFFF0;
        byte[] output = new byte[inputLen];
//        System.out.println("===16进制cardOutPut==="+DigitalTrans.byte2hex(App.cardOutPut));
        XMHCoinUtitls.CoinID_EncByAES128CBC(input, (short) input.length, inputKEY, output);
        return  output;
    }

    /**
     * AES解密算法
     *
     * @param ciphertext 需要解密的内容
     * @param key        解密的key
     * @return 明文 。若返回空串，则表示加密失败
     */
    public static byte[] decKeyByAES128CBC(byte[] ciphertext, String key, int coinType) {
        byte[] inputPIN = CommonUtil.strToByteArrayNotAddEnd(key);
        byte[] encKey = new byte[16];
        if (inputPIN.length < 16) {
            System.arraycopy(inputPIN, 0, encKey, 0, inputPIN.length);
        } else {
            System.arraycopy(inputPIN, 0, encKey, 0, 16);
        }
        byte[] decOutput = new byte[1000];
        short decLen = XMHCoinUtitls.CoinID_DecByAES128CBC(ciphertext, (short) ciphertext.length, encKey, decOutput);
        byte[] result = new byte[decLen];
        System.arraycopy(decOutput, 0, result, 0, decLen);
        String decResultStr = CommonUtil.byteArrayToStr(result);
        if (CommonUtil.isMessyCode(decResultStr)) {
            int length = 64;
            if (coinType == Constants.COIN_TYPE.TYPE_ETH) {
                length = 64;
            }
            result = new byte[length];
            boolean flag = XMHCoinUtitls.CoinID_DecKeyByAES128CBC(ciphertext, (short) ciphertext.length, inputPIN, (byte) inputPIN.length, result, CommonUtil.strToByteArrayNotAddEnd("00000000"), (byte) CommonUtil.strToByteArrayNotAddEnd("00000000").length);
            if (flag) {
                Logger.e("xxxx", "旧方法解密成功！");
            }
        } else {
            Logger.e("xxxx", "新方法解密成功！");
        }
        return result;
    }

    /**
     * AES加密算法
     * @param ciphertext
     * @param key
     * @return
     */
    public static byte[] encKeyByAES128CBC(byte[] ciphertext, String key) {
        byte[] inputPIN = CommonUtil.strToByteArrayNotAddEnd(key);
        byte[] encKey = new byte[16];
        if (inputPIN.length < 16) {
            System.arraycopy(inputPIN, 0, encKey, 0, inputPIN.length);
        } else {
            System.arraycopy(inputPIN, 0, encKey, 0, 16);
        }
        byte[] output = new byte[(ciphertext.length + 16) & 0xf0];
        boolean flag = XMHCoinUtitls.CoinID_EncByAES128CBC(ciphertext, (short) ciphertext.length, encKey, output);
        if (flag) {
            Logger.e("xxxx", "===加密成功！===");
        }
        return output;
    }

    public static String intArr2ByteArr(int[] intArr)
    {
        String[] asicTable=new String[]{"a", "b", "c", "d", "e", "f"};
        int len = intArr.length;
        byte[] index= new byte[len*2];
        String str="";
        int i;
        byte tempH;
        byte tempL;
        for( i =0 ;i <len;i++ )
        {
            index[2*i] = (byte)(intArr[i] >> 8);
            index[2*i + 1] = (byte)(intArr[i]);
            tempH = (byte)( (index[2*i] & 0xF0)>>(byte)4);
            tempL = (byte)(index[2*i]&0x0F);
            if( (tempH >=0) && (tempH <= 9))
            {
                str+= tempH;
            }
            else if( (tempH >9) && (tempH <= 15)) {
                str += asicTable[tempH -10];
            }
            if( (tempL >=0) && (tempL <= 9))
            {
                str+=  tempL;
            }
            else if( (tempL >9) && (tempL <= 15)) {
                str += asicTable[tempL -10];
            }
            tempH = (byte)( (index[2*i + 1] & 0xF0)>>(byte)4);
            tempL = (byte)(index[2*i + 1]&0x0F);
            if( (tempH >=0) && (tempH <= 9))
            {
                str+=  tempH;
            }
            else if( (tempH >9) && (tempH <= 15)) {
                str += asicTable[tempH -10];
            }
            if( (tempL >=0) && (tempL <= 9))
            {
                str+= tempL;
            }
            else if( (tempL >9) && (tempL <= 15)) {
                str += asicTable[tempL -10];
            }
        }

        return str;
    }

    public static String byteArr2String(byte[] byteArr)
    {
        String[] asicTable=new String[]{"a", "b", "c", "d", "e", "f"};
        int len = byteArr.length;
        String str="";
        int i;
        byte tempH;
        byte tempL;
        for( i =0 ;i <len;i++ )
        {

            tempH = (byte)( (byteArr[i] & 0xF0)>>(byte)4);
            tempL = (byte)(byteArr[i]&0x0F);
            if( (tempH >=0) && (tempH <= 9))
            {
                str+=  tempH;
            }
            else if( (tempH >9) && (tempH <= 15)) {
                str += asicTable[tempH -10];
            }
            if( (tempL >=0) && (tempL <= 9))
            {
                str+= tempL;
            }
            else if( (tempL >9) && (tempL <= 15)) {
                str += asicTable[tempL -10];
            }
        }

        return str;
    }

    /**
     * 将正整数的16进制，转换为相反16进制，即负整数的16进制
     */
    public static String negationHex(String hex) {
        if (hex.equals("0")){
            return "0000000000000000000000000000000000000000000000000000000000000000";
        }
        String decimalismVnsString = new BigInteger(hex, 16).toString(10);
        byte[] byte1 = new byte[32];
//        String decimalismVnsString = new BigDecimal("0.002").multiply(new BigDecimal(10).pow(18)).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
        Logger.e("TAG", "10进制 ：" + decimalismVnsString);
        byte[] byteVnsMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(decimalismVnsString));
        Logger.e("TAG", "16进制 ：" + DigitalTrans.bigIntegerToHEXString(decimalismVnsString));
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteVnsMoney, 0, byte1, byte1.length - byteVnsMoney.length, byteVnsMoney.length);
        Logger.e("TAG", "64位 16进制 ：" + HexUtil.encodeHexStr(byte1));

        byte[] temp = new byte[1];
        temp[0] = (byte) 0xff;
        byte[] resultBytes = new byte[32];
        for (int i = 0; i < byte1.length; i++) {
            resultBytes[i] = (byte) (byte1[i] ^ temp[0]);
        }
        String hexStr = HexUtil.encodeHexStr(resultBytes);
        BigInteger big = new BigInteger(hexStr, 16).add(new BigInteger("1"));
        Logger.e("TAG", "10进制+1：" + big.toString(10));
        Logger.e("TAG", "相反负数16进制：" + big.toString(16));
        return big.toString(16);
    }

    /**
     * 判断是否为整形
     *
     * @param value
     * @return
     */
    public static boolean isValidInt(String value) {
        try {
            Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return false;
        }
        return true;
    }
}

