package com.fictitious.money.purse.utils;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.util.DisplayMetrics;

import com.fictitious.money.purse.App;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class UIUtil {
    public static final String CACHE_FILE = "/JXCache/";

    /*** 获取上下文 */
    public static Context getContext(){
        return App.getContext();
    }

    /**得到Resource对象*/
    public static Resources getResources() {
        return getContext().getResources();
    }

    /**得到string.xml中的字符*/
    public static String getString(int resId) {
        return getResources().getString(resId);
    }

    public static String getString(int resId, Object... formatArgs) {
        return getResources().getString(resId, formatArgs);
    }
    /**得到string.xml中的字符数组*/
    public static String[] getStringArr(int resId) {
        return getResources().getStringArray(resId);
    }

    /**得到color.xml中的颜色值*/
    public static int getColor(int resId) {
        return getResources().getColor(resId);
    }
    /**获取DisplayMetrics */
    public static DisplayMetrics getDisplayMetrics() {
        return getResources().getDisplayMetrics();
    }

    /**
     * 获取本地分享图标
     * @param context
     * @param imgName shareicon.png
     * @param imgId R.raw.shareicon
     * @return
     */
    public static String getAssetsResource(Context context, String imgName, int imgId){
        if (!new File(Environment.getExternalStorageDirectory() + CACHE_FILE + imgName).exists()) {
            InputStream is = context.getResources().openRawResource(imgId);
            Bitmap bmpBitmap = BitmapFactory.decodeStream(is);
            storeInSD(bmpBitmap,GetCacheFilePath(),imgName);
        }
        return Environment.getExternalStorageDirectory() + CACHE_FILE + imgName;
    }

    /**
     * 将图片保存至sdcard目录下
     * @param bitmap 图片源
     * @param path sdcard文件夹
     * @param fileName 文件名
     */
    public static void storeInSD(Bitmap bitmap, String path, String fileName) {
        File file = new File(path);
        if (!file.exists()) {
            file.mkdir();
        }
        File imageFile = new File(file, fileName);
        try {
            imageFile.createNewFile();
            FileOutputStream fos = new FileOutputStream(imageFile);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.flush();
            fos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取图片缓存在sdcard的路径
     * @return
     */
    public static String GetCacheFilePath() {
        String filePath="";
        String rootpath = GetSdcardSystemPath();
        filePath = rootpath + CACHE_FILE;
        File file = new File(filePath);
        if (!file.exists()) {
            file.mkdirs();
        }
        return filePath;
    }

    /**
     * 获取sdcard系统路径
     * @return
     */
    public static String GetSdcardSystemPath(){
        String rootpath = "";
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            rootpath = Environment.getExternalStorageDirectory().toString();
        }
        return rootpath;
    }


}
