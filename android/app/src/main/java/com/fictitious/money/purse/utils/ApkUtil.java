package com.fictitious.money.purse.utils;

import android.app.Activity;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Looper;
import android.text.TextUtils;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.fictitious.money.purse.App;

import java.io.File;
import java.io.FileInputStream;
import java.security.MessageDigest;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by EDZ on 2018/7/11.
 */

public class ApkUtil {
    private final static String TAG = ApkUtil.class.getSimpleName();

    public static byte[] getInfoByte() {

        byte[] bitsver = ApkUtil.get8bitsver();
//        Logger.e("测试-版本号", bitsver.length + "个字节：" + new String(bitsver));
        byte[] imei = ApkUtil.get32BitIMEI();
//        Logger.e("测试-imei", imei.length + "个字节：" + new String(imei));

        byte[] data1 = new byte[bitsver.length + imei.length];
        System.arraycopy(bitsver, 0, data1, 0, bitsver.length);
        System.arraycopy(imei, 0, data1, bitsver.length, imei.length);
//        Logger.e("测试-合并第1段", "data1的长度：" + data1.length + "，内容：" + new String(data1));

        byte[] packageName = ApkUtil.get32BitPackageName();
//        Logger.e("测试-packageName", packageName.length + "个字节：" + new String(packageName));
        byte[] md5 = ApkUtil.get32BitMd5();
//        Logger.e("测试-md5", md5.length + "个字节：" + new String(md5));

        byte[] data2 = new byte[packageName.length + md5.length];
        System.arraycopy(packageName, 0, data2, 0, packageName.length);
        System.arraycopy(md5, 0, data2, packageName.length, md5.length);
//        Logger.e("测试-合并第2段", "data2的长度：" + data2.length + "，内容：" + new String(data2));

        byte[] data3 = new byte[data1.length + data2.length];
        System.arraycopy(data1, 0, data3, 0, data1.length);
        System.arraycopy(data2, 0, data3, data1.length, data2.length);
//        Logger.e("测试-合并第3段", "data3的长度：" + data3.length + "，内容：" + new String(data3));

        return data3;
    }

    public static byte[] get8bitsver() {
        String version = getVersion();
        byte[] bytes = version.getBytes();
        byte[] result = new byte[8];
        System.arraycopy(bytes, 0, result, 0, bytes.length);
        return result;
    }

    public static byte[] get32BitIMEI() {
        String imei = App.getNewInstance().getImei();
        byte[] bytes = imei.getBytes();
        byte[] result = new byte[32];
        System.arraycopy(bytes, 0, result, 0, bytes.length);
        return result;
    }

    public static byte[] get32BitPackageName() {
        String packageName = getPackageName();
        byte[] bytes = packageName.getBytes();
        byte[] result = new byte[32];
        System.arraycopy(bytes, 0, result, 0, bytes.length);
        return result;
    }

    public static byte[] get32BitMd5() {
        String apkMD5 = getApkMD5();
        byte[] bytes = apkMD5.getBytes();
        byte[] result = new byte[32];
        System.arraycopy(bytes, 0, result, 0, bytes.length);
        return result;
    }

    /**
     * 获取版本号
     *
     * @return
     */
    public static String getVersion() {
        try {
            PackageManager manager = App.getContext().getPackageManager();
            PackageInfo info = manager.getPackageInfo(App.getContext().getPackageName(), 0);
            String version = info.versionName;
            return version;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 获取版本号数
     * @return
     */
    public static int getVersionCode() {
        try {
            PackageManager manager = App.getContext().getPackageManager();
            PackageInfo info = manager.getPackageInfo(App.getContext().getPackageName(), 0);
            int version = info.versionCode;
            return version;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public static String getPackageName() {
        return App.getContext().getPackageName();
    }

    public static String getApkMD5() {
        File file = new File(App.getContext().getPackageCodePath());
        if (!file.isFile()) {
            return null;
        }
        MessageDigest digest = null;
        FileInputStream in = null;
        byte buffer[] = new byte[1024];
        int len;
        try {
            digest = MessageDigest.getInstance("MD5");
            in = new FileInputStream(file);
            while ((len = in.read(buffer, 0, 1024)) != -1) {
                digest.update(buffer, 0, len);
            }
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return bytesToHexString(digest.digest());
    }

    private static String bytesToHexString(byte[] src) {
        StringBuilder stringBuilder = new StringBuilder("");
        if (src == null || src.length <= 0) {
            return null;
        }
        for (int i = 0; i < src.length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        return stringBuilder.toString();
    }


    public static String zc_number = "^\\d+$";//纯数字
    public static String zc_char = "^[a-zA-Z]+$";//纯字母
    public static String zc_symbol = "^[`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]]+$";//纯特殊字符
    public static String zc_char_number = "^(?!\\d+$)(?![a-zA-Z]+$)[a-zA-Z\\d]+$";//字母+数字
    public static String zc_char_symbol = "^(?![a-zA-Z]+$)(?![`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]]+$)[a-zA-Z`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]]+$";//数字+特殊字符
    public static String zc_number_symbol = "^(?!\\d+$)(?![`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]]+$)[\\d`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]]+$";//数字+特殊字符
    public static String zc_number_symbol_char = "[-\\da-zA-Z`=\\\\ ;',./~!`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]*()_+|{}:<>?]*((\\d+[a-zA-Z]+[-`=\\\\ ;',./~!`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]*()_+|{}:<>?]+)|(\\d+[-`=\\\\ ;',./~!`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]*()_+|{}:<>?]+[a-zA-Z]+)|([a-zA-Z]+\\d+[-`=\\\\ ;',./~!`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]*()_+|{}:<>?]+)|([a-zA-Z]+[-`=\\\\ ;',./~!`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]*()_+|{}:<>?]+\\d+)|([-`=\\\\ ;',./~!`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]*()_+|{}:<>?]+\\d+[a-zA-Z]+)|([-`=\\\\ ;',./~!`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]*()_+|{}:<>?]+[a-zA-Z]+\\d+))[-\\da-zA-Z`=\\\\ ;',./~!`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'·~！@#¥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、\\[\\]*()_+|{}:<>?]*";

    public static boolean usePattern(String value_str, String pattern_str) {
        Pattern p = Pattern.compile(pattern_str);
        Matcher m = p.matcher(value_str);
        return m.matches();
    }

    public static void onClickCopy(Activity activity, String content, String msg) {
        // 从API11开始android推荐使用android.content.ClipboardManager
        // 为了兼容低版本我们这里使用旧版的android.text.ClipboardManager，虽然提示deprecated，但不影响使用。
        ClipboardManager cm = (ClipboardManager) activity.getSystemService(Context.CLIPBOARD_SERVICE);
        // 将文本内容放到系统剪贴板里。
        cm.setText(content);
        Toast.makeText(activity, msg, Toast.LENGTH_SHORT).show();
    }

    public static void onClickCopy(Activity activity, TextView textView, String msg) {
        // 从API11开始android推荐使用android.content.ClipboardManager
        // 为了兼容低版本我们这里使用旧版的android.text.ClipboardManager，虽然提示deprecated，但不影响使用。
        ClipboardManager cm = (ClipboardManager) activity.getSystemService(Context.CLIPBOARD_SERVICE);
        // 将文本内容放到系统剪贴板里。
        cm.setText(textView.getText());
        if(!TextUtils.isEmpty(msg)){
            Toast.makeText(activity, msg, Toast.LENGTH_SHORT).show();
        }
    }

    public static void onClickCopy(Activity activity, EditText textView, String msg) {
        // 从API11开始android推荐使用android.content.ClipboardManager
        // 为了兼容低版本我们这里使用旧版的android.text.ClipboardManager，虽然提示deprecated，但不影响使用。
        ClipboardManager cm = (ClipboardManager) activity.getSystemService(Context.CLIPBOARD_SERVICE);
        // 将文本内容放到系统剪贴板里。
        cm.setText(textView.getText());
        Toast.makeText(activity, msg, Toast.LENGTH_SHORT).show();
    }

    /**
     * 判断当前是否主线程
     *
     * @return
     */
    public static boolean isMainThread() {
        return Looper.getMainLooper() == Looper.myLooper();
    }
}
