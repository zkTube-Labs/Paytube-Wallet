package com.fictitious.money.purse.web.dao;

import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.widget.Toast;

import com.example.ffdemo.R;
import com.fictitious.money.purse.App;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.web.shop.BanKeSelectDidAddressActivity;
import com.fictitious.money.purse.web.vdai.BasePayVdaiActivity;

import org.json.JSONException;
import org.json.JSONObject;

import cn.droidlover.xdroidmvp.router.Router;

/**
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-11-13 11:35
 * Description:
 */
public class VdaiDao {
    private final String TAG = VdaiDao.class.getSimpleName();
    private Activity mActivity;

    public VdaiDao(Activity activity) {
        mActivity = activity;
    }

    public void api(String requestType, String dataJson) {
        switch (requestType) {
            case "0":
                // 弹出did地址选择界面
                Router.newIntent(mActivity).to(BanKeSelectDidAddressActivity.class).putInt("OPTINE_TYPE", Constants.VDNS_OPTION_ADDRESS_TYPE.VDAIN).launch();
                break;

            case "1":
            case "3":
            case "4":
            case "5":
            case "6":
            case "7":
            case "8":
            case "9":
            case "10":
                // 弹出交易支付界面
                Router.newIntent(mActivity).to(BasePayVdaiActivity.class).putString("dataJson", dataJson).launch();
                break;

            case "12":
                copyAddress(dataJson);
                break;

            // 弹出创建VUSD界面
            default:
                Toast.makeText(mActivity, "requestType:" + requestType + "尚未处理！！！", Toast.LENGTH_LONG).show();
                break;
        }
    }

    /**
     * 复制地址
     */
    private void copyAddress(String dataJson) {
        JSONObject obj = null;
        try {
            obj = new JSONObject(dataJson);
            String copyAddress = obj.optString("replicateAddress");
            Logger.e(TAG, "要复制的内容：" + copyAddress);

            ClipboardManager cm = (ClipboardManager) mActivity.getSystemService(
                    Context.CLIPBOARD_SERVICE);
            cm.setPrimaryClip(ClipData.newPlainText("coinidPro_copy", copyAddress));
            Toast.makeText(mActivity, App.getContext().getString(R.string.is_copy), Toast.LENGTH_SHORT).show();
        } catch (JSONException e) {
            Logger.e(TAG, "json异常了：" + e.getMessage());
        }

    }
}

