package com.fictitious.money.purse.web.vdai;

import android.app.Dialog;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import com.example.ffdemo.R;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.model.ImportPurseEntity;
import com.fictitious.money.purse.model.MinerFeeBean;
import com.fictitious.money.purse.model.ShopReturnJSBean;
import com.fictitious.money.purse.model.VdaiReturnJSBean;
import com.fictitious.money.purse.presenter.PDidSendToken;
import com.fictitious.money.purse.rxbus.EventBanKeShop;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.DigitalTrans;
import com.fictitious.money.purse.utils.HexUtil;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.utils.MethodChannelRegister;
import com.fictitious.money.purse.utils.XMHCoinUtitls;
import com.fictitious.money.purse.widget.DialogUitl;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONObject;

import java.util.List;

import androidx.annotation.Nullable;
import butterknife.BindView;
import butterknife.OnClick;
import cn.droidlover.xdroidmvp.event.BusProvider;
import cn.droidlover.xdroidmvp.mvp.XActivity;
import cn.droidlover.xdroidmvp.net.NetError;
import io.flutter.plugin.common.MethodChannel;

/**
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-11-13 15:16
 * Description: 发送VNS、发送VUSD
 */
public class DidSendTokenActivity extends XActivity<PDidSendToken> {
    @BindView(R.id.title)
    TextView title;
    @BindView(R.id.tv_balance)
    TextView tv_balance;
    @BindView(R.id.tv_money)
    TextView tv_money;
    @BindView(R.id.tv_acceptAddress)
    TextView tv_acceptAddress;
    @BindView(R.id.btn_send)
    Button btn_send;

    private final String TAG = DidSendTokenActivity.class.getSimpleName();
    private final int TO_TOKEN_VNS = 1;
    private final int TO_TOKEN_VUSD = 2;
    private final int TO_TOKEN_TYPE = 0;
    private String symbol = "VNS";
    private String from = "", to = "", money = "0", decimals = "18";// vns：0x97155376bda799b05b10d87a9d69006026812459
    private String contract = "";// vusd：0x4183bbd377fca70c5cfe8529ba3ddaf4ea1d009f
    private boolean isToken = false; // 是否为代币发送
    private boolean nextFlag = false;
    private MinerFeeBean minerFeeBean;

    List<ImportPurseEntity> purseEntityList;

    @Override
    public int getLayoutId() {
        return R.layout.activity_did_send_token;
    }

    @Override
    public void initData(Bundle savedInstanceState) {
        try {
            String dataJson = getIntent().getStringExtra("dataJson");
            Logger.e(TAG, "传递过来的数据：" + dataJson);
            JSONObject obj = new JSONObject(dataJson);
            from = obj.optString("payAddress");
            to = obj.optString("toAddress");
            String vnsNum = obj.optString("vnsNum");
            String vusdNum = obj.optString("vusdNum");
            String payType = obj.optString("payType");
            contract = obj.optString("contract");
            symbol = obj.optString("symbol").toUpperCase();
            isToken = obj.getBoolean("isToken");

            if (!isToken) {
                contract = "";
            }
            if (symbol.equals("VUSD")) {
                decimals = "45";
                money = vusdNum;
            } else if (symbol.equals("VNS")) {
                decimals = "18";
                money = vnsNum;
            }

            title.setText(String.valueOf(payType));
            tv_money.setText(String.valueOf(money));
            tv_acceptAddress.setText(String.valueOf(to));
            ((PDidSendToken) getP()).getVnsTransInfo(symbol, contract, from);
            getDidWallet();
        } catch (Exception e) {
            Logger.e(TAG, "异常了：" + e.getMessage());

            ShopReturnJSBean jsBean = new ShopReturnJSBean();
            ShopReturnJSBean.DataBean dataBean = new ShopReturnJSBean.DataBean();
            jsBean.setStatus(Constants.CODE_H5_TRANSFER.failed400);
            jsBean.setMsg("程序异常!");
            dataBean.setError("程序异常");
            jsBean.setData(dataBean);
            String json = new Gson().toJson(jsBean);
            BusProvider.getBus().post(new EventBanKeShop(json));
        }

    }

    @Override
    public PDidSendToken newP() {
        return new PDidSendToken();
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = getWindow();
        WindowManager.LayoutParams wlp = window.getAttributes();
        Display d = window.getWindowManager().getDefaultDisplay();//获取屏幕宽
        wlp.width = d.getWidth();//宽度按屏幕大小的百分比设置 ;
        wlp.gravity = Gravity.BOTTOM;
        window.setWindowAnimations(R.style.animTranslate);
        window.setAttributes(wlp);
    }

    @OnClick({R.id.iv_close, R.id.btn_cancel, R.id.btn_send})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_close:
            case R.id.btn_cancel:
                finish();
                break;

            case R.id.btn_send:
                next();
                break;
        }
    }

    // 物理键返回
    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    private void getDidWallet(){
        MethodChannelRegister.getWallet(new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {
                purseEntityList = new Gson().fromJson(result.toString(), new TypeToken<List<ImportPurseEntity>>() {
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

    /**
     * 回调失败
     */
    public void callbackFailed(NetError error) {
        String errMgs = getString(R.string.failure_deal);
        int status = Constants.CODE_H5_TRANSFER.failed400;
        if (error != null) {
            error.getMessage();
            errMgs = TextUtils.isEmpty(error.getMessage()) ? errMgs : error.getMessage();
            status = error.getType();
        }

        VdaiReturnJSBean jsBean = new VdaiReturnJSBean();
        jsBean.setStatus(status);
        jsBean.setMsg(errMgs);
        Gson gson = new Gson();
        String json = gson.toJson(jsBean);
        String javascript = "javascript: transfersendResult('" + json + "')";
        Logger.e(TAG, "失败交易回传h5：" + json);

        BusProvider.getBus().post(new EventBanKeShop(javascript));
        finish();
    }

    /**
     * 回调成功
     */
    public void callbackSuccessful(String trxid) {
        VdaiReturnJSBean jsBean = new VdaiReturnJSBean();
        VdaiReturnJSBean.DataBean dataBean = new VdaiReturnJSBean.DataBean();

        jsBean.setStatus(Constants.CODE_H5_TRANSFER.succeed200);
        jsBean.setMsg(getString(R.string.success_deal));
        dataBean.setTxid(String.valueOf(trxid));
        if (minerFeeBean != null && minerFeeBean.getMinerFeeNum() != null) {
            dataBean.setMinersFee(String.valueOf(minerFeeBean.getMinerFeeNum()));
        }
        jsBean.setData(dataBean);
        Gson gson = new Gson();
        String json = gson.toJson(jsBean);
        String javascript = "javascript: transfersendResult('" + json + "')";

        Logger.e(TAG, "交易成功回传h5：" + javascript);
        BusProvider.getBus().post(new EventBanKeShop(javascript));
        finish();
    }


    public void showMinersFeeView(MinerFeeBean minerFeeBean) {
        this.minerFeeBean = minerFeeBean;
        nextFlag = true;
        if (minerFeeBean != null) {// 显示可用余额
            tv_balance.setText(minerFeeBean.getBalance().toPlainString() + " " + symbol + getString(R.string.tv_use_eos_1));
        }
    }


    private void next() {
        if (!nextFlag) {
            btn_send.setText(getString(R.string.tv_refresh));
            ((PDidSendToken) getP()).getVnsTransInfo(symbol, contract, from);
            return;
        }
        btn_send.setText(getString(R.string.tv_send));
        ImportPurseEntity vnsPurse = null;
        if(purseEntityList != null && purseEntityList.size() > 0){
            for (ImportPurseEntity entity : purseEntityList){
                if(entity.getAddress().equals(from)){
                    vnsPurse = entity;
                }
            }
        }
        if (vnsPurse != null) {
            if (vnsPurse.getOriginType() == Constants.ORIGIN_TYPE.CREATE || vnsPurse.getOriginType() == Constants.ORIGIN_TYPE.RESTORE || vnsPurse.getOriginType() == Constants.ORIGIN_TYPE.IMPORT) {
                appUnlock(vnsPurse);
            } else {
                callbackFailed(new NetError("暂不支持硬件、卡钱包", 404));

            }
        } else {
            callbackFailed(new NetError("未找到" + from + "的钱包", 404));
        }

    }

    /**
     * app钱包解锁
     */
    private void appUnlock(ImportPurseEntity purse) {
        DialogUitl.inputDialog(context, getString(R.string.dialog_title_next_id_pwd), getString(R.string.dialog_confirm), getString(R.string.dialog_cancel), false, new DialogUitl.Callback4() {
            @Override
            public void confirm(Dialog dialog, String text, String sha) {
                dialog.dismiss();
                MethodChannelRegister.lock(purse.getWalletID(), text, new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object result) {
                        if(Boolean.parseBoolean(String.valueOf(result))) {
                            if (purse != null && purse.getPrvKey() != null) {
                                String prvkeyStr = CommonUtil.byteArrayToStr(DigitalTrans.decKeyByAES128CBC(HexUtil.hexStringToBytes(purse.getPrvKey()), text, purse.getCoinType()));
                                byte[] prvKeyByte = DigitalTrans.hex2byte(prvkeyStr);
                                byte[] eth_byte = XMHCoinUtitls.CoinID_ImportETHPrvKey(prvKeyByte);
                                byte[] signPrvKey = new byte[32];
                                //私钥
                                System.arraycopy(eth_byte, 0, signPrvKey, 0, signPrvKey.length);

                                ((PDidSendToken) getP()).trans(symbol, null, from, to, decimals, money, signPrvKey);

                            }
                        } else {
                            getvDelegate().toastLong(getString(R.string.dialog_error_pwd));
                        }
                    }

                    @Override
                    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

                    }

                    @Override
                    public void notImplemented() {

                    }
                });
            }

            @Override
            public void cancel(Dialog dialog) {
                dialog.dismiss();
            }
        }).show();
    }
}
