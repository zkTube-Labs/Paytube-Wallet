package com.fictitious.money.purse.utils;

import android.util.Log;


/**
 * Created by ouyonghua on 2016/9/8.
 */
public class Logger {

    public static boolean isShowLog = false;

    /**
     * 输入info级别的Log，tag可以是任何的对象，如果是String则直接使用，其它对象使用它的类名
     * @param objTag
     * @param msg
     */
    public static void i(Object objTag, Object msg) {
        if (!isShowLog) {
            return;
        }

        String tag;
        if (objTag instanceof String) {
            tag = (String) objTag;
        } else if (objTag instanceof Class) {
            tag = ((Class) objTag).getSimpleName();
        } else {
            tag = objTag.getClass().getSimpleName();
        }

        Log.i(tag, msg == null || msg.toString() == null ? "null" : msg.toString());
    }

    public static void e(Object objTag, Object msg) {
        if (!isShowLog) {
            return;
        }

        String tag;
        if (objTag instanceof String) {
            tag = (String) objTag;
        } else if (objTag instanceof Class) {
            tag = ((Class) objTag).getSimpleName();
        } else {
            tag = objTag.getClass().getSimpleName();
        }

        Log.e(tag, msg == null || msg.toString() == null ? "null" : msg.toString());
    }

    public static void w(Object objTag, Object msg) {
        if (!isShowLog) {
            return;
        }

        String tag;
        if (objTag instanceof String) {
            tag = (String) objTag;
        } else if (objTag instanceof Class) {
            tag = ((Class) objTag).getSimpleName();
        } else {
            tag = objTag.getClass().getSimpleName();
        }

        Log.w(tag, msg == null || msg.toString() == null ? "null" : msg.toString());
    }

    public static void d(Object objTag, Object msg) {
        if (!isShowLog) {
            return;
        }

        String tag;
        if (objTag instanceof String) {
            tag = (String) objTag;
        } else if (objTag instanceof Class) {
            tag = ((Class) objTag).getSimpleName();
        } else {
            tag = objTag.getClass().getSimpleName();
        }

        Log.d(tag, msg == null || msg.toString() == null ? "null" : msg.toString());
    }



}
