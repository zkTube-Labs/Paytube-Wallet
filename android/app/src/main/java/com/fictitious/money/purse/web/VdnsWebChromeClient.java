package com.fictitious.money.purse.web;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.text.TextUtils;

import com.example.ffdemo.R;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.utils.ApkUtil;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.utils.XMHCoinUtitls;
import com.fictitious.money.purse.web.shop.BanKeSelectDidAddressActivity;
import com.fictitious.money.purse.web.shop.BrowserX5WebActivity;
import com.tencent.smtt.export.external.interfaces.JsPromptResult;
import com.tencent.smtt.export.external.interfaces.JsResult;
import com.tencent.smtt.sdk.WebChromeClient;
import com.tencent.smtt.sdk.WebView;

import org.json.JSONObject;

import cn.droidlover.xdroidmvp.router.Router;

/**
 * 与h5交互 数据操作
 */
public class VdnsWebChromeClient extends WebChromeClient {
    private final String TAG = "VDNS";
    private WebView mWebView;
    private BrowserX5WebActivity mActivity;

    private JsPromptResult result;
    public JsPromptResult getResult() {
        return result;
    }

    //设置地址权限
    public static final int CODE_SETADDRESS_PERMISSIONS = 0;
    // 注册一级域名
    public static final int CODE_PAYTOPLEVEL = 1;
    // 域名续费
    public static final int CODE_RENEW = 2;
    // 添加子域名
    public static final int CODE_PAYSUBLEVEL = 3;
    // 转让域名
    public static final int CODE_SETCONTROLLER= 4;
    // 点击复制
    public static final int CODE_CLICKCOPY= 5;
    // 点击扫码
    public static final int CODE_SCANADDRESS= 6;
    // 切换did地址
    public static final int CODE_SWITCH_DID_ADDRESS= 7;
    // 删除二级域名
    public static final int CODE_DELSUBLEVEL= 8;
    // 变更二级域名
    public static final int CODE_SETCONTROLLERSUBLEVEL= 9;

    public VdnsWebChromeClient(BrowserX5WebActivity activity, WebView mWebView) {
        this.mActivity = activity;
        this.mWebView = mWebView;
    }

    // 拦截输入框(原理同方式2)
    // 参数message:代表promt（）的内容（不是url）
    // 参数result:代表输入框的返回值
    // {"requester":"eheShop","requestType":1,"data":{"chainType":2,"ethInfo":{"istoken":false,"symbols":"ETH","merchantName":"EHE","to":"16UeX3McLioKJzG2CCc7z95z9e8xDBzdu8","amount":"0.0001"}}}
    @Override
    public boolean onJsPrompt(WebView view, String url, String message, String defaultValue, JsPromptResult result) {
        this.result = result;
        Logger.e(TAG, "收到h5内容：" + message);
        if(!TextUtils.isEmpty(message)){
            try {
                JSONObject obj = new JSONObject(message);
                int requestType = obj.optInt("num");
                Logger.e(TAG, "requestType：" + requestType);
                switch (requestType){
                    case CODE_PAYTOPLEVEL:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
                        String token = obj.getString("payType");
                        String from = obj.getString("payAddress");
                        mActivity.getVnsTransInfo(from, requestType, token, message);
                        break;
                    case CODE_RENEW:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
                        token = obj.getString("payType");
                        from = obj.getString("payAddress");
                        mActivity.getVnsTransInfo(from, requestType, token, message);
                        break;
                    case CODE_PAYSUBLEVEL:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
                        String anAddress = obj.getString("anAddress");
                        String type = obj.getString("type");
                        if (XMHCoinUtitls.CoinID_checkAddressValid(type.toLowerCase(), anAddress)) {
                            from = obj.getString("address");
                            mActivity.getVnsTransInfo(from, requestType, "VNS", message);
                        } else {
                            mActivity.getvDelegate().toastLong(mActivity.getResources().getString(R.string.tv_input_collection_address_err));
                        }
                        break;
                    case CODE_SETADDRESS_PERMISSIONS:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
                        Router.newIntent(mActivity).to(BanKeSelectDidAddressActivity.class).putInt("OPTINE_TYPE", Constants.VDNS_OPTION_ADDRESS_TYPE.SELECT).launch();
                        break;
                    case CODE_SWITCH_DID_ADDRESS:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
                        Router.newIntent(mActivity).to(BanKeSelectDidAddressActivity.class).putInt("OPTINE_TYPE", Constants.VDNS_OPTION_ADDRESS_TYPE.REPLASE).launch();
                        break;
                    case CODE_SCANADDRESS:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
                        mActivity.openScan();
                        break;
                    case CODE_CLICKCOPY:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
                        ApkUtil.onClickCopy(mActivity, obj.getString("copy"), mActivity.getString(R.string.is_copy));
                        break;
                    case CODE_SETCONTROLLER:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
                        from = obj.getString("from");
                        mActivity.getVnsTransInfo(from, requestType, "VNS", message);
                        break;
                    case CODE_SETCONTROLLERSUBLEVEL:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
//                        from = obj.getString("address");
//                        mActivity.getVnsTransInfo(from, requestType, "VNS", message);
                        break;
                    case CODE_DELSUBLEVEL:
                        ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
                        from = obj.getString("address");
                        mActivity.getVnsTransInfo(from, requestType, "VNS", message);
                        break;
                }
                return true;
            } catch (Exception e) {
                Logger.e(TAG, "接收h5数据异常：" + e.getMessage());
                ((BrowserX5WebActivity)mActivity).vdnsWebChromeClient.getResult().confirm();
            }
        }
        return super.onJsPrompt(view, url, message, defaultValue, result);
    }

    // 拦截JS的警告框
    @Override
    public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
        Logger.e(TAG, "onJsAlert 收到回调：" + message);
        AlertDialog.Builder b = new AlertDialog.Builder(mActivity);
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

//        return super.onJsAlert(view, url, message, result);
    }

    // 拦截JS的确认框
    @Override
    public boolean onJsConfirm(WebView view, String url, String message, JsResult result) {
        Logger.e(TAG, "onJsConfirm 收到回调：" + message);
        return super.onJsConfirm(view, url, message, result);
    }
}