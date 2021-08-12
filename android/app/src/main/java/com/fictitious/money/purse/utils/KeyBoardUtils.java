package com.fictitious.money.purse.utils;

import android.app.Dialog;
import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

public class KeyBoardUtils {
    private static final String TAG = KeyBoardUtils.class.getSimpleName();

    public static void hideKeyBoard(Context context, View view) {
        try {
            InputMethodManager imm = (InputMethodManager) context
                    .getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0); // 强制隐藏键盘

        }catch (Exception e){
            Logger.e(TAG, "view hideKeyBoard异常：" + e.getMessage());
        }
    }

    public static void hideKeyBoard(Context context, Dialog dialog) {
        try {
            InputMethodManager imm = (InputMethodManager) context
                    .getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(dialog.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS); // 强制隐藏键盘
        } catch (Exception e) {
            Logger.e(TAG, "dialog hideKeyBoard异常：" + e.getMessage());
        }

    }

    public static void showKeyBoard(Context context, View view) {
        view.setFocusable(true);
        view.setFocusableInTouchMode(true);
        view.requestFocus();
        view.findFocus();
        InputMethodManager imm = (InputMethodManager) context
                .getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
    }
}
