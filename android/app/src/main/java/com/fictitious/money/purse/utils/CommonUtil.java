package com.fictitious.money.purse.utils;

import android.app.Activity;
import android.app.Dialog;
import android.text.TextUtils;

import com.example.ffdemo.R;
import com.fictitious.money.purse.App;
import com.fictitious.money.purse.widget.DialogUitl;

import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Description:
 * Date: 2015-10-22  17:46
 * User: wushan
 */
public class CommonUtil {
    /**
     * 读取assets下的txt文件，返回utf-8 String
     * @param fileName 不包括后缀
     * @return
     */
    public static String readAssetsTxt(String fileName){
        try {
            //Return an AssetManager instance for your application's package
            InputStream is = App.getContext().getAssets().open(fileName+".txt");
            int size = is.available();
            // Read the entire asset into a local byte buffer.
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            // Convert the buffer into a string.
            String text = new String(buffer, "utf-8");
            // Finally stick the string into the text view.
            return text;
        } catch (IOException e) {
            // Should never happen!
//            throw new RuntimeException(e);
            e.printStackTrace();
        }
        return "读取错误，请检查文件名";
    }

    public static byte[] strToByteArray(String str) {
        if (str == null) {
            return null;
        }
        byte[] byteArray = str.getBytes();
        if(byteArray == null){
            byteArray = new byte[0];
        }
        if(byteArray.length >= 1 && byteArray[byteArray.length - 1] != '\0'){
            byte[] newByteArray = new byte[byteArray.length + 1];
            System.arraycopy(byteArray, 0, newByteArray, 0, byteArray.length);
            newByteArray[byteArray.length] = '\0';
            return newByteArray;
        }
        return byteArray;
    }

    public static byte[] strToByteArrayNotAddEnd(String str) {
        if (str == null) {
            return null;
        }
        byte[] byteArray = str.getBytes();
        if(byteArray == null){
            byteArray = new byte[0];
        }
        return byteArray;
    }

    public static String byteArrayToStr(byte[] byteArray) {
        if (byteArray == null) {
            return null;
        }
        String str = new String(byteArray);
        if(TextUtils.isEmpty(str)){
            str = "";
        }
        return str;
    }

    public static boolean isChinese(String str) {
        String regEx = "[\\u4e00-\\u9fa5]+";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 判断字符串是否是乱码
     * @param strName 字符串
     * @return 是否是乱码
     */
    public static boolean isMessyCode(String strName) {
        Pattern p = Pattern.compile("\\s*|t*|r*|n*");
        Matcher m = p.matcher(strName);
        String after = m.replaceAll("");
        String temp = after.replaceAll("\\p{P}", "");
        char[] ch = temp.trim().toCharArray();
        float chLength = ch.length;
        float count = 0;
        for (int i = 0; i < ch.length; i++) {
            char c = ch[i];
            if (!Character.isLetterOrDigit(c)) {
                if (!isChinese(c)) {
                    count = count + 1;
                }
            }
        }
        float result = count / chLength;
        if (result > 0.4) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 判断字符是否是中文
     *
     * @param c 字符
     * @return 是否是中文
     */
    public static boolean isChinese(char c) {
        Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
        if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
                || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION
                || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
                || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS) {
            return true;
        }
        return false;
    }

    public static short byteToInt(byte a, byte b) {
        return (short)((a<<8)|(b&0xFF));
    }

    public static String subStrEthBalance(String hex){
        if(hex != null){
            if(hex.startsWith("0x")){
                hex = hex.replace("0x", "");
            }
            for(int i = 0; i < hex.length(); i ++){
                if(!String.valueOf(hex.charAt(i)).equals("0")){
                    String result = hex.substring(i, hex.length());
                    return result;
                }
            }
        }
        return "00";
    }

    public static String getFloat(Double num) {
        DecimalFormat df = new DecimalFormat("0.00");
        return df.format(num);
    }

    public static void showTranErrMsgDialog(Activity activity , String code, String msg)
    {
        DialogUitl.messageDialog(activity, code, msg, activity.getString(R.string.dialog_not_capture_yes), new DialogUitl.Callback2() {
            @Override
            public void confirm(Dialog dialog) {
                dialog.dismiss();
            }
        }).show();
    }
}
