package com.fictitious.money.purse.web.vdai;

import android.app.Dialog;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.example.ffdemo.R;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.model.ImportPurseEntity;
import com.fictitious.money.purse.model.MinerFeeBean;
import com.fictitious.money.purse.model.VdaiReturnJSBean;
import com.fictitious.money.purse.presenter.PBasePayVdai;
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

import org.json.JSONException;
import org.json.JSONObject;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

import androidx.annotation.Nullable;
import butterknife.BindView;
import butterknife.OnClick;
import cn.droidlover.xdroidmvp.cache.SharedPref;
import cn.droidlover.xdroidmvp.event.BusProvider;
import cn.droidlover.xdroidmvp.mvp.XActivity;
import cn.droidlover.xdroidmvp.net.NetError;
import io.flutter.plugin.common.MethodChannel;

/**
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-11-13 15:16
 * Description:
 * 创建VDalance
 * 存、取质押品
 * VCDP的偿还、生成、转移、关闭
 */
public class BasePayVdaiActivity extends XActivity<PBasePayVdai> {
    @BindView(R.id.title)
    TextView title;
    @BindView(R.id.tv_transactionType)
    TextView tv_transactionType;
    @BindView(R.id.tv_fromAddress)
    TextView tv_fromAddress;
    @BindView(R.id.tv_contractAddress)
    TextView tv_contractAddress;
    @BindView(R.id.tv_money)
    TextView tv_money;
    @BindView(R.id.tv_minersFeeNum)
    TextView tv_minersFeeNum;
    @BindView(R.id.tv_minersFeeMoney)
    TextView tv_minersFeeMoney;
    @BindView(R.id.btn_next)
    TextView btn_next;
    @BindView(R.id.tv_balance)
    TextView tv_balance;
    @BindView(R.id.root_money)
    View root_money;
    @BindView(R.id.root_contract)
    View root_contract;

    private final String TAG = BasePayVdaiActivity.class.getSimpleName();
    private String vnsAddress = "", toAddress = "";// 付款地址 0x97155376bda799b05b10d87a9d69006026812459
    private String contractAddress = "";// vusd合约地址 0x0cb55fe67051eb5afe57fb3b670108074f85643e
    private String transferVusdAddreess = "";// 转移vusd目标地址
    private String token = "VUSD", requestType = "99", vusdNum = "0", vnsNum = "0";
    private boolean nextFlag = false; // 没有获取到交易信息，不允许执行下一步
    private boolean isToken = false; // 是否为代币转账
    private final String TYPE_CREATE = "1"; // 抵押并生成vusd
    private final String TYPE_SAVE = "3"; // 存入vns
    private final String TYPE_GET = "4"; // 取回vns
    private final String TYPE_REPAY = "5"; //偿还
    private final String TYPE_GENERATE = "6"; // 生成
    private final String TYPE_TRANSFER = "7"; // 转移
    private final String TYPE_CLOSE = "8"; // 关闭
    private final String TYPE_ACCEPT = "9"; // 接收
    private final String TYPE_SEND = "10"; // 发送

    List<ImportPurseEntity> purseEntityList;

    @Override
    public int getLayoutId() {
        return R.layout.activity_base_pay_vdai;
    }

    @Override
    public void initData(Bundle savedInstanceState) {
        try {
            String dataJson = getIntent().getStringExtra("dataJson");
            Logger.e(TAG, "传递过来的数据：" + dataJson);
            JSONObject obj = new JSONObject(dataJson);
            vnsAddress = obj.optString("payAddress");
            requestType = obj.optString("num");
            String payType = obj.optString("payType");
            contractAddress = obj.optString("contract");
            vnsNum = obj.optString("vnsNum");
            vusdNum = obj.optString("vusdNum");
            token = obj.optString("symbol").toUpperCase();
            transferVusdAddreess = obj.optString("transferVusdAddreess");

            if (TextUtils.isEmpty(vnsNum)) {
                vnsNum = "0";
            }
            if (TextUtils.isEmpty(vusdNum)) {
                vusdNum = "0";
            }

            tv_transactionType.setText(String.valueOf(payType));
            tv_fromAddress.setText(String.valueOf(vnsAddress));
            tv_contractAddress.setText(String.valueOf(contractAddress));

            if (token.equals("VNS")) {
                tv_money.setText(vnsNum + " " + token);

            } else {
                tv_money.setText(vusdNum + " " + token);
            }

            showTransOrCloseOrAcceptView();
            showSendView(obj);

            ((PBasePayVdai) getP()).getVnsTransInfo(token, vnsAddress, contractAddress);
            getDidWallet();
        } catch (Exception e) {
            Logger.e(TAG, "异常了：" + e.getMessage());

            VdaiReturnJSBean jsBean = new VdaiReturnJSBean();
            VdaiReturnJSBean.DataBean dataBean = new VdaiReturnJSBean.DataBean();
            jsBean.setStatus(Constants.CODE_H5_TRANSFER.failed400);
            jsBean.setMsg("程序异常!");
            dataBean.setError("程序异常");
            jsBean.setData(dataBean);
            String json = new Gson().toJson(jsBean);
            BusProvider.getBus().post(new EventBanKeShop(json));
        }

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

    @Override
    public PBasePayVdai newP() {
        return new PBasePayVdai();
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

    @OnClick({R.id.iv_close, R.id.btn_cancel, R.id.btn_next})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_close:
            case R.id.btn_cancel:
                finish();
                break;
            case R.id.btn_next:
                next();
                break;
        }
    }

    private void showSendView(JSONObject obj) throws JSONException {
        if (requestType.equals(TYPE_SEND)) {
            toAddress = obj.optString("toAddress");
            isToken = obj.getBoolean("isToken");
        }
        if (!isToken && requestType.equals(TYPE_SEND)) {
            tv_money.setText(vnsNum + " " + token);
            root_contract.setVisibility(View.GONE);
        } else if (isToken && requestType.equals(TYPE_SEND)) {
            tv_money.setText(vusdNum + " " + token);
        }
    }

    private void showTransOrCloseOrAcceptView() {
        // 转移/关闭/接收不需要显示金额
        if (requestType.equals(TYPE_TRANSFER) || requestType.equals(TYPE_CLOSE) || requestType.equals(TYPE_ACCEPT)) {
            root_money.setVisibility(View.GONE);
        }
    }

    private void next() {
        if (!nextFlag) {
            btn_next.setText(getString(R.string.tv_refresh));
            ((PBasePayVdai) getP()).getVnsTransInfo(token, vnsAddress, contractAddress);
            return;
        }
        btn_next.setText(getString(R.string.tv_next));
        ImportPurseEntity vnsPurse = null;
        if(purseEntityList != null && purseEntityList.size() > 0){
            for (ImportPurseEntity entity : purseEntityList){
                if(entity.getAddress().equals(vnsAddress)){
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
            callbackFailed(new NetError("未找到" + vnsAddress + "的钱包", 404));
        }
    }

    /**
     * 显示矿工费
     */
    public void showMinersFeeView(MinerFeeBean bean) {
        nextFlag = true;
        btn_next.setText(getString(R.string.tv_next));
        if (requestType.equals(TYPE_SEND) && bean.getBalance() != null) {
            tv_balance.setVisibility(View.VISIBLE);
            tv_balance.setText(bean.getBalance().stripTrailingZeros().toPlainString() + token.toUpperCase() + getString(R.string.tv_use_eos_1));
        }

        String minerFeeNum = String.valueOf(bean.getMinerFeeNum());
        tv_minersFeeNum.setText(minerFeeNum + " VNS");
        // 矿工费价格 = 矿工费数量 * 单价
        String minerPriceStr = new BigDecimal(bean.getEthCurrentPrice()).multiply(new BigDecimal(minerFeeNum))
                .setScale(2, RoundingMode.HALF_UP)
                .stripTrailingZeros().toPlainString();
        String company = SharedPref.getInstance(context).getString("company", "cny");
        if (company.toUpperCase().equals("CNY")) {
            tv_minersFeeMoney.setText("≈ ¥ " + minerPriceStr);
        } else {
            tv_minersFeeMoney.setText("≈ $ " + minerPriceStr);
        }
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
        String javascript = "";

        switch (requestType) {
            case TYPE_CREATE:
                javascript = "javascript: cresteVdaiResult('" + json + "')";
                break;
            case TYPE_SAVE:
                javascript = "javascript: depositVnsResult('" + json + "')";
                break;
            case TYPE_GET:
                javascript = "javascript: returnGetVdaiAddressResult('" + json + "')";
                break;
            case TYPE_REPAY:
                javascript = "javascript: repayVnsResult('" + json + "')";
                break;
            case TYPE_GENERATE:
                javascript = "javascript: generateVnsResult('" + json + "')";
                break;
            case TYPE_TRANSFER:
                javascript = "javascript: transferVusdResult('" + json + "')";
                break;
            case TYPE_ACCEPT:
                javascript = "javascript: receiveTransferVusdResult('" + json + "')";
                break;
            case TYPE_CLOSE:
                javascript = "javascript: cancelVusdResult('" + json + "')";
                break;
            case TYPE_SEND:
                javascript = "javascript: transfersendResult('" + json + "')";
                break;
        }
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
        dataBean.setMinersFee(tv_minersFeeNum.getText().toString().trim());
        jsBean.setData(dataBean);
        Gson gson = new Gson();
        String json = gson.toJson(jsBean);
        String javascript = "";

        switch (requestType) {
            case TYPE_CREATE:
                javascript = "javascript: cresteVdaiResult('" + json + "')";
                break;
            case TYPE_SAVE:
                javascript = "javascript: depositVnsResult('" + json + "')";
                break;
            case TYPE_GET:
                javascript = "javascript: retrieveVnsResult('" + json + "')";
                break;
            case TYPE_REPAY:
                javascript = "javascript: repayVnsResult('" + json + "')";
                break;
            case TYPE_GENERATE:
                javascript = "javascript: generateVnsResult('" + json + "')";
                break;
            case TYPE_TRANSFER:
                javascript = "javascript: transferVusdResult('" + json + "')";
                break;
            case TYPE_ACCEPT:
                javascript = "javascript: receiveTransferVusdResult('" + json + "')";
                break;
            case TYPE_CLOSE:
                javascript = "javascript: cancelVusdResult('" + json + "')";
                break;
            case TYPE_SEND:
                javascript = "javascript: transfersendResult('" + json + "')";
                break;
        }

        Logger.e(TAG, "交易回传h5：" + javascript);
        BusProvider.getBus().post(new EventBanKeShop(javascript));
        finish();
    }

    /**
     * 签名支付类型
     */
    private void payTypeInfo(byte[] signPrvKey) {
        PBasePayVdai pBasePayVdai = (PBasePayVdai) getP();
        switch (requestType) {
            case TYPE_CREATE:
                pBasePayVdai.payCreateCDP(token, vnsAddress, contractAddress, vnsNum, vusdNum, signPrvKey);
                break;
            case TYPE_SAVE:
                pBasePayVdai.paySaveVns(token, vnsAddress, contractAddress, vnsNum, vusdNum, signPrvKey);
                break;
            case TYPE_GET:
                pBasePayVdai.payGetVns(token, vnsAddress, contractAddress, vnsNum, vusdNum, signPrvKey);
                break;
            case TYPE_REPAY:
                pBasePayVdai.payRepayVusd(token, vnsAddress, contractAddress, vnsNum, vusdNum, signPrvKey);
                break;
            case TYPE_GENERATE:
                pBasePayVdai.payGenerateVusd(token, vnsAddress, contractAddress, vusdNum, signPrvKey);
                break;
            case TYPE_TRANSFER:
                pBasePayVdai.payTransferVusd(token, vnsAddress, contractAddress, transferVusdAddreess, signPrvKey);
                break;
            case TYPE_ACCEPT:
                pBasePayVdai.payAccept(token, vnsAddress, contractAddress, transferVusdAddreess, signPrvKey);
                break;
            case TYPE_CLOSE:
                pBasePayVdai.payCloseVusd(vnsAddress, contractAddress, signPrvKey);
                break;
            case TYPE_SEND:
                String money = "0";
                if (isToken) {
                    money = vusdNum;
                } else {
                    money = vnsNum;
                }
                pBasePayVdai.paySend(isToken, token, vnsAddress, toAddress, contractAddress, money, "18", signPrvKey);
                break;
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
                                payTypeInfo(signPrvKey);
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
