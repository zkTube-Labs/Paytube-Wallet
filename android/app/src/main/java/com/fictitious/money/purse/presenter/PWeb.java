package com.fictitious.money.purse.presenter;

import android.app.Dialog;
import android.text.TextUtils;
import android.widget.TextView;
import android.widget.Toast;

import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.model.AllowanceParams;
import com.fictitious.money.purse.model.EthTokenSeriesParam;
import com.fictitious.money.purse.model.EthTranInfoResult;
import com.fictitious.money.purse.model.ImportPurseEntity;
import com.fictitious.money.purse.model.ReturnPayToJSJsonData;
import com.fictitious.money.purse.model.ReturnTokenSignatureHtml;
import com.fictitious.money.purse.model.TransactionEthParam;
import com.fictitious.money.purse.net.Api;
import com.fictitious.money.purse.results.EthTransReult;
import com.fictitious.money.purse.results.GetEthSeriesParamReult;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.EthSignTransDataUtils;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.utils.VnsPriceUtil;
import com.fictitious.money.purse.web.shop.BrowserX5WebActivity;
import com.fictitious.money.purse.widget.DialogUitl;
import com.fictitious.money.purse.widget.ToastType;
import com.fictitious.money.purse.widget.ToastUtil;
import com.google.gson.Gson;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import cn.droidlover.xdroidmvp.mvp.XPresent;
import cn.droidlover.xdroidmvp.net.ApiSubscriber;
import cn.droidlover.xdroidmvp.net.NetError;
import cn.droidlover.xdroidmvp.net.XApi;

import static java.math.BigDecimal.ROUND_HALF_UP;

/**
 * Description:x5Web
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/2/22 16:27
 */
public class PWeb extends XPresent<BrowserX5WebActivity> {
    private final String TAG = PWeb.class.getSimpleName();
    public String trxid = "", signature = "", jsStr = "";

    /**
     * push到主网
     *
     * @return
     */
    public void push(int decimals, String nonce, String gasPrice, String estimateGas, String contract,
                     String version, String from, String to, String amount, ImportPurseEntity purse, String pin) {
        Logger.e(TAG, "签名前参数decimals：" + decimals + ",：nonce：" + nonce + ",gasPrice：" + gasPrice +
                " ,estimateGas：" + estimateGas + " ,contract：" + contract + " ,version：" + version +
                ",from：" + from + ",to：" + to + ",amount：" + amount);
        Dialog loadDialog = DialogUitl.loadingDialog(getV(), "请稍候...");
        loadDialog.show();
        ReturnTokenSignatureHtml returnTokenSignatureHtml = new ReturnTokenSignatureHtml();
        try {
            // 从热钱包（当前身份下钱包）里查eth地址，是否匹配付款地址，如果匹配成功，则交易；否则提示热钱包没有该eth钱包
            if (purse != null) {
                Logger.e(TAG, "没有绑定地址或当前身份下没有该：" + from + " 地址钱包");
                returnTokenSignatureHtml.setStatus(Constants.NET_RESULT_CODE.STATUS_CODE_404);
                returnTokenSignatureHtml.setMsg("无法转账！当前身份下的钱包或导入钱包中没有该：" + from + " 地址钱包");
                returnToJsResult(returnTokenSignatureHtml);
                loadDialog.dismiss();
            } else {
                // 进行签名操作 "0x16e8a9171fb5bae9a04c6b4b1248046e897a5551"
                EthSignTransDataUtils signTransDataUtils = new EthSignTransDataUtils();
                TransactionEthParam transactionEthParam = signTransDataUtils.sigtERCTransaction(
                        decimals,
                        nonce,
                        gasPrice,
                        String.valueOf(estimateGas),
                        contract,// 转账地址
                        version,// 网络 ID
                        to, // 收款地址
                        amount,
                        purse.getPrvKey(),
                        pin);

                List<String> params = transactionEthParam.getParams();
                ReturnTokenSignatureHtml.DataBean dataBean = new ReturnTokenSignatureHtml.DataBean();
                // 设置当前主币种类型为eth
                dataBean.setChainType(Constants.WEB_PARAM.ETH_CHAINTYPE);

                for (String param : params) {
                    signature = param;
                }

                Api.getServiceVns().transactionEth(transactionEthParam)
                        .compose(XApi.<EthTransReult>getApiTransformer())
                        .compose(XApi.<EthTransReult>getScheduler())
                        .subscribe(new ApiSubscriber<EthTransReult>() {
                            @Override
                            protected void onFail(NetError error) {
                                loadDialog.dismiss();
                                getV().getvDelegate().toastLong(error.getLocalizedMessage());
                                returnTokenSignatureHtml.setStatus(Constants.NET_RESULT_CODE.STATUS_CODE_404);
                                returnTokenSignatureHtml.setMsg("转账请求失败！");
                                returnToJsResult(returnTokenSignatureHtml);
                            }

                            @Override
                            public void onNext(EthTransReult ethTransReult) {
                                loadDialog.dismiss();
                                if (ethTransReult != null) {
                                    if (!TextUtils.isEmpty(ethTransReult.getResult())) {
                                        getV().getvDelegate().toastLong("转账成功");
                                        trxid = ethTransReult.getResult();
                                        Logger.e(TAG, "获取trxid：" + trxid);

                                        if (!TextUtils.isEmpty(signature) && !TextUtils.isEmpty(trxid)) {
                                            // 签名成功，且获取trxid，回传成功json
                                            dataBean.setSignatureStr(signature);
                                            dataBean.setTrxid(trxid);
                                            returnTokenSignatureHtml.setData(dataBean);
                                            Logger.e(TAG, "xmx签名成功数据为：" + signature);
                                            returnTokenSignatureHtml.setStatus(Constants.NET_RESULT_CODE.STATUS_CODE_200);
                                            returnTokenSignatureHtml.setMsg("签名成功！");
                                        } else {
                                            dataBean.setSignatureStr(signature);
                                            dataBean.setTrxid(trxid);
                                            returnTokenSignatureHtml.setData(dataBean);
                                            Logger.e(TAG, "签名数据为空，或者trxid为空");
                                            returnTokenSignatureHtml.setStatus(Constants.NET_RESULT_CODE.STATUS_CODE_404);
                                            returnTokenSignatureHtml.setMsg("转账失败！签名数据为空，或者trxid为空");
                                        }

                                    } else {
                                        if (ethTransReult.getError() != null) {
                                            CommonUtil.showTranErrMsgDialog(getV(), String.valueOf(ethTransReult.getError().getCode()), ethTransReult.getError().getMessage());
                                        }
                                        returnTokenSignatureHtml.setStatus(Constants.NET_RESULT_CODE.STATUS_CODE_404);
                                        returnTokenSignatureHtml.setMsg("转账失败！" + ethTransReult.getError().getMessage());
                                    }
                                } else {
                                    returnTokenSignatureHtml.setStatus(Constants.NET_RESULT_CODE.STATUS_CODE_404);
                                    returnTokenSignatureHtml.setMsg("转账失败！返回数据为空");
                                }

                                returnToJsResult(returnTokenSignatureHtml);
                            }
                        });
            }


        } catch (Exception e) {
            returnTokenSignatureHtml.setStatus(Constants.NET_RESULT_CODE.STATUS_CODE_404);
            returnTokenSignatureHtml.setMsg("签名异常！");
            returnToJsResult(returnTokenSignatureHtml);

        }
    }

    private void returnToJsResult(ReturnTokenSignatureHtml returnTokenSignatureHtml) {
        // 无论签名是否成功，回传json给h5
        jsStr = new Gson().toJson(returnTokenSignatureHtml);
        Logger.e(TAG, "回传json给h5：" + jsStr);

        String returnJs = "javascript:returnEthTokenSignatureResult('" + jsStr + "')";
        getV().mWebView.post(new Runnable() {
            @Override
            public void run() {
                // 注意调用的JS方法名要对应上
                getV().mWebView.loadUrl(returnJs);
            }
        });
    }

    public void getVnsCurrencies(TextView textView, String minerFee, String company){
        VnsPriceUtil.getVnsPrice("VNS", company, new VnsPriceUtil.IVnsPriceListen() {
            @Override
            public void getVnsPriceCallBack(BigDecimal bigDecimal) {
                if(bigDecimal != null){
                    if("cny".equals(company)){
                        textView.setText( "≈¥" + bigDecimal.multiply(new BigDecimal(minerFee)).setScale(2,BigDecimal.ROUND_HALF_UP).stripTrailingZeros().toPlainString());
                    } else {
                        textView.setText("≈$" + bigDecimal.multiply(new BigDecimal(minerFee)).setScale(2,BigDecimal.ROUND_HALF_UP).stripTrailingZeros().toPlainString());
                    }
                } else {
                    if(textView != null){
                        if("cny".equals(company)){
                            textView.setText("≈¥0.00");
                        } else {
                            textView.setText("≈$0.00");
                        }
                    }
                }
            }
        });
    }

    List<EthTranInfoResult.DataBeanX> dataBeanXList = new ArrayList<>();
    public void getGasPrice(String from, int payType, String token, String jsonMsg){
        EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
        ethSeriesBalanceParam.setId(1);
        ethSeriesBalanceParam.setJsonrpc("2.0");
        ethSeriesBalanceParam.setMethod("vns_gasPrice");

        Api.getServiceVns().getEthTokenSeriesParam(ethSeriesBalanceParam)
                .compose(XApi.<GetEthSeriesParamReult>getApiTransformer())
                .compose(XApi.<GetEthSeriesParamReult>getScheduler())
                .subscribe(new ApiSubscriber<GetEthSeriesParamReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        ((BrowserX5WebActivity)getV()).vdnsWebChromeClient.getResult().confirm();
                    }

                    @Override
                    public void onNext(GetEthSeriesParamReult getEthSeriesParamReult) {
                        EthTranInfoResult.DataBeanX dataBeanX = new EthTranInfoResult.DataBeanX();
                        EthTranInfoResult.DataBeanX.DataBean dataBean = new EthTranInfoResult.DataBeanX.DataBean();
                        dataBeanX.setName("gasPrice");
                        dataBean.setResult(getEthSeriesParamReult.getResult());
                        dataBeanX.setData(dataBean);
                        dataBeanXList.add(dataBeanX);
                        getNoce(from, payType, token, jsonMsg);
                    }
                });
    }

    public void getNoce(String from, int payType, String token, String jsonMsg){

        List<Object> lists = new ArrayList<>();
        lists.add(from);
        lists.add("latest");
        EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
        ethSeriesBalanceParam.setId(1);
        ethSeriesBalanceParam.setJsonrpc("2.0");
        ethSeriesBalanceParam.setMethod("vns_getTransactionCount");
        ethSeriesBalanceParam.setParams(lists);

        Api.getServiceVns().getEthTokenSeriesParam(ethSeriesBalanceParam)
                .compose(XApi.<GetEthSeriesParamReult>getApiTransformer())
                .compose(XApi.<GetEthSeriesParamReult>getScheduler())
                .subscribe(new ApiSubscriber<GetEthSeriesParamReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        ((BrowserX5WebActivity)getV()).vdnsWebChromeClient.getResult().confirm();
                    }

                    @Override
                    public void onNext(GetEthSeriesParamReult getEthSeriesParamReult) {
                        EthTranInfoResult.DataBeanX dataBeanX = new EthTranInfoResult.DataBeanX();
                        EthTranInfoResult.DataBeanX.DataBean dataBean = new EthTranInfoResult.DataBeanX.DataBean();
                        dataBeanX.setName("transaction");
                        dataBean.setResult(getEthSeriesParamReult.getResult());
                        dataBeanX.setData(dataBean);
                        dataBeanXList.add(dataBeanX);
                        getVersion(from, payType, token, jsonMsg);
                    }
                });
    }

    public void getVersion(String from, int payType, String token, String jsonMsg){

        EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
        ethSeriesBalanceParam.setId(1);
        ethSeriesBalanceParam.setJsonrpc("2.0");
        ethSeriesBalanceParam.setMethod("net_version");

        Api.getServiceVns().getEthTokenSeriesParam(ethSeriesBalanceParam)
                .compose(XApi.<GetEthSeriesParamReult>getApiTransformer())
                .compose(XApi.<GetEthSeriesParamReult>getScheduler())
                .subscribe(new ApiSubscriber<GetEthSeriesParamReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        ((BrowserX5WebActivity)getV()).vdnsWebChromeClient.getResult().confirm();
                    }

                    @Override
                    public void onNext(GetEthSeriesParamReult getEthSeriesParamReult) {
                        EthTranInfoResult.DataBeanX dataBeanX = new EthTranInfoResult.DataBeanX();
                        EthTranInfoResult.DataBeanX.DataBean dataBean = new EthTranInfoResult.DataBeanX.DataBean();
                        dataBeanX.setName("version");
                        dataBean.setResult(getEthSeriesParamReult.getResult());
                        dataBeanX.setData(dataBean);
                        dataBeanXList.add(dataBeanX);
                        getBalance(from, payType, token, jsonMsg);
                    }
                });
    }

    public void getBalance(String from, int payType, String token, String jsonMsg){

        EthTokenSeriesParam ethSeriesBalanceParam = null;

        if("VNS".equals(token)){
            List<Object> lists = new ArrayList<>();
            lists.add(from);
            lists.add("latest");

            ethSeriesBalanceParam = new EthTokenSeriesParam();
            ethSeriesBalanceParam.setId(1);
            ethSeriesBalanceParam.setJsonrpc("2.0");
            ethSeriesBalanceParam.setMethod("vns_getBalance");
            ethSeriesBalanceParam.setParams(lists);
        } else {
            String data = "0x70a08231000000000000000000000000" + from.replace("0x", "");
            List<Object> lists = new ArrayList<>();
            AllowanceParams allowanceParams = new AllowanceParams();
            allowanceParams.setTo(Constants.VP_INQUIRE_CONTRACT);
            allowanceParams.setData(data);
            lists.add(allowanceParams);
            lists.add("latest");

            ethSeriesBalanceParam = new EthTokenSeriesParam();
            ethSeriesBalanceParam.setId(1);
            ethSeriesBalanceParam.setJsonrpc("2.0");
            ethSeriesBalanceParam.setMethod("vns_call");
            ethSeriesBalanceParam.setParams(lists);
        }

        Api.getServiceVns().getEthTokenSeriesParam(ethSeriesBalanceParam)
                .compose(XApi.<GetEthSeriesParamReult>getApiTransformer())
                .compose(XApi.<GetEthSeriesParamReult>getScheduler())
                .subscribe(new ApiSubscriber<GetEthSeriesParamReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        ((BrowserX5WebActivity)getV()).vdnsWebChromeClient.getResult().confirm();
                    }

                    @Override
                    public void onNext(GetEthSeriesParamReult getEthSeriesParamReult) {
                        EthTranInfoResult ethTranInfoResult = new EthTranInfoResult();
                        EthTranInfoResult.DataBeanX dataBeanX = new EthTranInfoResult.DataBeanX();
                        EthTranInfoResult.DataBeanX.DataBean dataBean = new EthTranInfoResult.DataBeanX.DataBean();
                        if("VNS".equals(token)){
                            dataBeanX.setName("balance");
                        } else {
                            dataBeanX.setName("tokenBalance");
                        }
                        dataBean.setResult(getEthSeriesParamReult.getResult());
                        dataBeanX.setData(dataBean);
                        dataBeanXList.add(dataBeanX);

                        EthTranInfoResult.DataBeanX dataBeanX1 = new EthTranInfoResult.DataBeanX();
                        EthTranInfoResult.DataBeanX.DataBean dataBean1 = new EthTranInfoResult.DataBeanX.DataBean();
                        dataBeanX1.setName("estimateGas");
                        dataBean1.setResult("0x2dc6c0");
                        dataBeanX1.setData(dataBean1);
                        dataBeanXList.add(dataBeanX1);

                        ethTranInfoResult.setData(dataBeanXList);
                        getV().initVdnsTransPopupWindow(jsonMsg, ethTranInfoResult);
                    }
                });
    }

    public void buyVdns(String nonce, String gasPrice, String estimateGas, String version, String from, String to, String amount, int payType, String token, String year, String vdns, String address, String addressType, ImportPurseEntity purse, String pin) {
        Logger.e(TAG, "签名前参数year：" + year + ",：nonce：" + nonce + ",gasPrice：" + gasPrice +
                " ,estimateGas：" + estimateGas + " ,vdns：" + vdns + " ,version：" + version +
                ",from：" + from + ",to：" + to + ",amount：" + amount + ",payType：" + payType + ",address：" + address + ",addressType：" + addressType);
        Dialog loadDialog = DialogUitl.loadingDialog(getV(), "请稍候...");
        loadDialog.show();
        EthSignTransDataUtils signTransDataUtils = new EthSignTransDataUtils();
        TransactionEthParam transactionEthParam = signTransDataUtils.sigtVdnsERCTransaction(
                nonce,
                gasPrice,
                String.valueOf(estimateGas),
                version,// 网络 ID
                to, // 收款地址
                amount,
                year,
                vdns,
                payType,
                token,
                address,
                addressType,
                purse.getPrvKey(),
                pin);

        Api.getServiceVns().transactionEth(transactionEthParam)
                .compose(XApi.<EthTransReult>getApiTransformer())
                .compose(XApi.<EthTransReult>getScheduler())
                .subscribe(new ApiSubscriber<EthTransReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        loadDialog.dismiss();
                        getV().getvDelegate().toastLong(error.getLocalizedMessage());
                    }
                    @Override
                    public void onNext(EthTransReult ethTransReult) {
                        loadDialog.dismiss();
                        if (ethTransReult != null && !TextUtils.isEmpty(ethTransReult.getResult())) {
                            ReturnPayToJSJsonData returnPayToJSJsonData = new ReturnPayToJSJsonData();
                            returnPayToJSJsonData.setStatus(200);
                            returnPayToJSJsonData.setMsg("获取成功！");
                            ReturnPayToJSJsonData.DataBean dataBean = new ReturnPayToJSJsonData.DataBean();
                            dataBean.setTxid(ethTransReult.getResult());
                            dataBean.setMinersFee(new BigDecimal(gasPrice).multiply(new BigDecimal(estimateGas)).divide(new BigDecimal("1000000000000000000"),10, ROUND_HALF_UP).doubleValue() + token);
                            returnPayToJSJsonData.setData(dataBean);
                            String javascript = "javascript: payResult('"+ new Gson().toJson(returnPayToJSJsonData) +"')";
                            getV().mWebView.post(new Runnable() {
                                @Override
                                public void run() {
                                    getV().mWebView.loadUrl(javascript);
                                }
                            });
                        } else {
                            ToastUtil.showToast("交易发起失败", ToastType.FAILURE, Toast.LENGTH_SHORT);
                        }
                    }
                });
    }

    public void approveVP(final String nonce, String gasPrice, String estimateGas, String version, String from, String to, String amount, int payType, String token, String year, String vdns, String address, String addressType, ImportPurseEntity purse, String pin) {
        Dialog loadDialog = DialogUitl.loadingDialog(getV(), "请稍候...");
        loadDialog.show();
        EthSignTransDataUtils signTransDataUtils = new EthSignTransDataUtils();
        TransactionEthParam transactionEthParam = signTransDataUtils.sigtVdnsERCTransaction(
                nonce,
                gasPrice,
                String.valueOf(estimateGas),
                version,// 网络 ID
                Constants.VP_INQUIRE_CONTRACT, // 收款地址
                amount,
                year,
                vdns,
                -1,
                token,
                address,
                addressType,
                purse.getPrvKey(),
                pin);
        Api.getServiceVns().transactionEth(transactionEthParam)
                .compose(XApi.<EthTransReult>getApiTransformer())
                .compose(XApi.<EthTransReult>getScheduler())
                .subscribe(new ApiSubscriber<EthTransReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        loadDialog.dismiss();
                        getV().getvDelegate().toastLong(error.getLocalizedMessage());
                    }
                    @Override
                    public void onNext(EthTransReult ethTransReult) {
                        loadDialog.dismiss();
                        if (ethTransReult != null && !TextUtils.isEmpty(ethTransReult.getResult())) {
                            String nonceStr = new BigDecimal(nonce).add(new BigDecimal("1")).stripTrailingZeros().toPlainString();
                            buyVdns(nonceStr, gasPrice, estimateGas, version, from, to, amount, payType, token, year, vdns, address, addressType, purse, pin);
                        }
                    }
                });
    }

    public void canApproveVP(String nonce, String gasPrice, String estimateGas, String version, String from, String to, String amount, int payType, String token, String year, String vdns, String address, String addressType, ImportPurseEntity purse, String pin){
        Logger.e(TAG, "签名前参数year：" + year + ",：nonce：" + nonce + ",gasPrice：" + gasPrice +
                " ,estimateGas：" + estimateGas + " ,vdns：" + vdns + " ,version：" + version +
                ",from：" + from + ",to：" + to + ",amount：" + amount + ",payType：" + payType);
        Dialog loadDialog = DialogUitl.loadingDialog(getV(), "请稍候...");
        loadDialog.show();
        String json = "{\"jsonrpc\":\"2.0\",\"method\":\"vns_call\",\"params\":[{\"to\":\""+ Constants.VP_INQUIRE_CONTRACT +"\",\"data\":\"0xdd62ed3e000000000000000000000000" + from.replace("0x", "") + "000000000000000000000000"+ to.replace("0x", "") +"\"},\"latest\"],\"id\":1}";
        EthTokenSeriesParam ethSeriesBalanceParam = new Gson().fromJson(json, EthTokenSeriesParam.class);
        Api.getServiceVns().getEthTokenSeriesParam(ethSeriesBalanceParam)
                .compose(XApi.<GetEthSeriesParamReult>getApiTransformer())
                .compose(XApi.<GetEthSeriesParamReult>getScheduler())
                .subscribe(new ApiSubscriber<GetEthSeriesParamReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        loadDialog.dismiss();
                        getV().getvDelegate().toastLong(error.getLocalizedMessage());
                    }
                    @Override
                    public void onNext(GetEthSeriesParamReult ethTransReult) {
                        loadDialog.dismiss();
                        if (ethTransReult != null && !TextUtils.isEmpty(ethTransReult.getResult())) {
                            int result = new BigInteger(CommonUtil.subStrEthBalance(ethTransReult.getResult()), 16).intValue();
                            if(result == 0){
                                approveVP(nonce, gasPrice, estimateGas, version, from, to, amount, payType, token, year, vdns, address, addressType, purse, pin);
                            } else {
                                buyVdns(nonce, gasPrice, estimateGas, version, from, to, amount, payType, token, year, vdns, address, addressType, purse, pin);
                            }
                        }
                    }
                });
    }
}
