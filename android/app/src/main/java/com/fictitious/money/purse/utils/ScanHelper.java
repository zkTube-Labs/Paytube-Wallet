package com.fictitious.money.purse.utils;

import android.content.Intent;

import com.fictitious.money.purse.App;
import com.fictitious.money.purse.activity.QRMainActivity;

import io.flutter.plugin.common.MethodChannel;

public class ScanHelper {
    static MethodChannel.Result mResult;

    public static void scan(MethodChannel.Result result){
        Intent intent = new Intent(App.getContext(), QRMainActivity.class);
        if(App.getActivity() != null){
            App.getActivity().startActivityForResult(intent, 100);
            mResult = result;
        } else {
            Logger.e("ScanHelper","==activity is null==");
        }
    }

    public static void returnResult(String result){
        mResult.success(result);
    }
}
