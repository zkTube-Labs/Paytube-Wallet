package com.fictitious.money.purse.web;

import android.app.Activity;
import android.text.TextUtils;

import com.fictitious.money.purse.rxbus.EventBanKeShop;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.web.dao.VdaiDao;
import com.tencent.smtt.export.external.interfaces.JsPromptResult;
import com.tencent.smtt.export.external.interfaces.JsResult;
import com.tencent.smtt.sdk.WebChromeClient;
import com.tencent.smtt.sdk.WebView;

import org.json.JSONObject;

import cn.droidlover.xdroidmvp.event.BusProvider;
import io.reactivex.functions.Consumer;

/**
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-11-13 11:34
 * Description:
 */
public class VdaiWebChromeClient extends WebChromeClient {
    private final String TAG = VdaiWebChromeClient.class.getSimpleName();
    private WebView mWebView;
    private Activity mActivity;


    public VdaiWebChromeClient(Activity activity, WebView mWebView) {
        this.mActivity = activity;
        this.mWebView = mWebView;
        initBus();
    }

    // 拦截输入框(原理同方式2)
    // 参数message:代表promt（）的内容（不是url）
    // 参数result:代表输入框的返回值
    // {"requester":"eheShop","requestType":1,"data":{"chainType":2,"ethInfo":{"istoken":false,"symbols":"ETH","merchantName":"EHE","to":"16UeX3McLioKJzG2CCc7z95z9e8xDBzdu8","amount":"0.0001"}}}
    @Override
    public boolean onJsPrompt(WebView view, String url, String message, String defaultValue, JsPromptResult result) {
        Logger.e(TAG, "收到h5内容：" + message);
        try {
            JSONObject obj = new JSONObject(message);
            String requester = obj.optString("requester");
            String requestType = obj.optString("num");
            String data = obj.optString("data");
            Logger.e(TAG, "请求方：" + requester);
            Logger.e(TAG, "请求类型：" + requestType);
            Logger.e(TAG, "请求data：" + data);
            switch (requester) {
                case "vdai":
                    VdaiDao vdaiDao = new VdaiDao(mActivity);
                    vdaiDao.api(requestType, message);
                    break;
            }
            result.confirm();
            return true;

        } catch (Exception e) {
            Logger.e(TAG, "接收h5数据异常：" + e.getMessage());
        }
        return super.onJsPrompt(view, url, message, defaultValue, result);
    }

    // 拦截JS的警告框
//    @Override
//    public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
//        try {
//            Logger.e(TAG, "onJsAlert 收到回调：" + message);
//            AlertDialog.Builder b = new AlertDialog.Builder(mActivity);
//            b.setTitle("Alert");
//            b.setMessage(message);
//            b.setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
//                @Override
//                public void onClick(DialogInterface dialog, int which) {
//                    result.confirm();
//                }
//            });
//            b.setCancelable(false);
//            b.create().show();
//        } catch (Exception e) {
//            result.confirm();
//            Logger.e(TAG, "onJsAlert 异常：" + e.getMessage());
//        }
//
//        return true;
//    }

    // 拦截JS的确认框
    @Override
    public boolean onJsConfirm(WebView view, String url, String message, JsResult result) {
        Logger.e(TAG, "onJsConfirm 收到回调：" + message);
        return super.onJsConfirm(view, url, message, result);
    }

    private void initBus() {
        BusProvider.getBus().toFlowable(EventBanKeShop.class)
                .subscribe(new Consumer<EventBanKeShop>() {
                    @Override
                    public void accept(EventBanKeShop event) {

                        mActivity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                // 执行js回调
                                if (TextUtils.isEmpty(event.msg)) {
                                    Logger.e(TAG, "要传递给h5的数据为空！！");
                                } else {
                                    mWebView.loadUrl(event.msg);
                                    Logger.e(TAG, "加载指定函数：" + event.msg);
                                }
                            }
                        });
                    }
                });

    }
}