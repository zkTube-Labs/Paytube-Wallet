package com.fictitious.money.purse.web;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.text.TextUtils;

import com.fictitious.money.purse.App;
import com.fictitious.money.purse.model.BanKeTransactionData;
import com.fictitious.money.purse.model.ImportPurseEntity;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.utils.MethodChannelRegister;
import com.fictitious.money.purse.web.dao.BanKeDao;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tencent.smtt.export.external.interfaces.JsPromptResult;
import com.tencent.smtt.export.external.interfaces.JsResult;
import com.tencent.smtt.sdk.WebChromeClient;
import com.tencent.smtt.sdk.WebView;

import org.json.JSONObject;

import java.util.List;

import androidx.annotation.Nullable;
import io.flutter.plugin.common.MethodChannel;

/**
 * 与h5交互 数据操作
 */
public class BanKeWebChromeClient extends WebChromeClient {
    private final String TAG = BanKeWebChromeClient.class.getSimpleName();
    private WebView mWebView;

    private JsPromptResult result;
    public JsPromptResult getResult() {
        return result;
    }

    private final String REQUESTER_EHE_SHOP = "bancor";
    // 转账操作
    private final int CODE_TRANSACTION = 1;
    // 获取主公钥
    private final int CODE_MASTERPUBKEY = 2;
    // 重新支付转账
    private final int CODE_AFRESH_TRANSACTION = 3;
    // 获取用户选择的单个VNS
    private final int CODE_SELECT_SINGLE_VNS = 5;
    List<ImportPurseEntity> purseEntities;

    public BanKeWebChromeClient(WebView mWebView) {
        this.mWebView = mWebView;
    }

    {
        MethodChannelRegister.getWallet(new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {
                //传递的参数
                purseEntities = new Gson().fromJson(result.toString(), new TypeToken<List<ImportPurseEntity>>() {
                }.getType());
            }

            @Override
            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

            }

            @Override
            public void notImplemented() {

            }
        });
    }

    // 拦截输入框(原理同方式2)
    // 参数message:代表promt（）的内容（不是url）
    // 参数result:代表输入框的返回值
    // {"requester":"eheShop","requestType":1,"data":{"chainType":2,"ethInfo":{"istoken":false,"symbols":"ETH","merchantName":"EHE","to":"16UeX3McLioKJzG2CCc7z95z9e8xDBzdu8","amount":"0.0001"}}}
    @Override
    public boolean onJsPrompt(WebView view, String url, String message, String defaultValue, JsPromptResult result) {
        this.result = result;
        Logger.e(TAG, "收到h5内容：" + message);
        try {
            JSONObject obj = new JSONObject(message);
            String requester = obj.optString("requester");
            String requestType = obj.optString("requestType");
            String data = obj.optString("data");
            Logger.e(TAG, "请求方：" + requester);
            Logger.e(TAG, "请求类型：" + requestType);
            Logger.e(TAG, "请求data：" + data);

            if (!TextUtils.isEmpty(requester) && requester.equals(REQUESTER_EHE_SHOP)) {
                BanKeDao dao = new BanKeDao(mWebView, purseEntities);
                // 如果请求方是eheSop
                switch (requestType) {
                    // 转账交易
                    case CODE_TRANSACTION + "":
                        Gson gson = new Gson();
                        BanKeTransactionData param = gson.fromJson(data, BanKeTransactionData.class);
                        dao.daoTransaction(result, param);
                        break;

                    case CODE_MASTERPUBKEY + "":
                        String json = dao.getAllVnsAddress();
                        // 执行js回调
                        result.confirm(json);
                        break;

                    // ETH 重新转账交易
                    case CODE_AFRESH_TRANSACTION + "":
                        Gson gson2 = new Gson();
                        BanKeTransactionData param2 = gson2.fromJson(data, BanKeTransactionData.class);
                        dao.daoAfreshTransaction(result, param2);
                        break;

                    // 获取用户选择的单个VNS
                    case CODE_SELECT_SINGLE_VNS + "":
                        dao.showSelectDidAddress();
                        break;

                    default:
                        result.confirm("requestType其他业务请求：" + requestType);
                        Logger.e(TAG, "其他业务请求：" + requestType);
                        break;
                }
                return true;
            }

        } catch (Exception e) {
            Logger.e(TAG, "接收h5数据异常：" + e.getMessage());
        }
        return super.onJsPrompt(view, url, message, defaultValue, result);
    }

    // 拦截JS的警告框
    @Override
    public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
        Logger.e(TAG, "onJsAlert 收到回调：" + message);
        AlertDialog.Builder b = new AlertDialog.Builder(App.getActivity());
        b.setTitle("Alert");
        b.setMessage(message);
        b.setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                result.confirm();
            }
        });
        b.setCancelable(false);
        b.create().show();
        return true;
    }

    // 拦截JS的确认框
    @Override
    public boolean onJsConfirm(WebView view, String url, String message, JsResult result) {
        Logger.e(TAG, "onJsConfirm 收到回调：" + message);
        return super.onJsConfirm(view, url, message, result);
    }
}