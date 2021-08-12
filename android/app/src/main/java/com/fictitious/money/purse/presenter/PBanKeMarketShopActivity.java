package com.fictitious.money.purse.presenter;

import android.text.TextUtils;

import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.listener.OnCompleteDataListener;
import com.fictitious.money.purse.model.EthTokenSeriesParam;
import com.fictitious.money.purse.model.MBanKeMarketShopActivity;
import com.fictitious.money.purse.model.MinerFeeBean;
import com.fictitious.money.purse.model.ShopReturnJSBean;
import com.fictitious.money.purse.model.TransactionEthParam;
import com.fictitious.money.purse.net.Api;
import com.fictitious.money.purse.results.EthTransReult;
import com.fictitious.money.purse.results.GetEthSeriesParamReult;
import com.fictitious.money.purse.rxbus.EventBanKeShop;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.EthSignTransDataUtils;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.web.shop.BanKeMarketShopActivity;
import com.google.gson.Gson;

import java.math.BigDecimal;
import java.math.BigInteger;

import cn.droidlover.xdroidmvp.event.BusProvider;
import cn.droidlover.xdroidmvp.mvp.XPresent;
import cn.droidlover.xdroidmvp.net.ApiSubscriber;
import cn.droidlover.xdroidmvp.net.NetError;
import cn.droidlover.xdroidmvp.net.XApi;

/**
 * Description:
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/4/4 15:06
 */
public class PBanKeMarketShopActivity extends XPresent<BanKeMarketShopActivity> {
    private final String TAG = PBanKeMarketShopActivity.class.getSimpleName();
    private final MBanKeMarketShopActivity mPayShop;

    public PBanKeMarketShopActivity() {
        mPayShop = new MBanKeMarketShopActivity();
    }

    public void test() {
        String trxid = "这是一个假的trxid，app还没有写交易逻辑";

        ShopReturnJSBean jsBean = new ShopReturnJSBean();
        ShopReturnJSBean.DataBean dataBean = new ShopReturnJSBean.DataBean();
        if (TextUtils.isEmpty(trxid)) {
            jsBean.setStatus(Constants.CODE_H5_TRANSFER.failed401);
            jsBean.setMsg("交易失败!");
            dataBean.setError("主网异常！");
        } else {
            jsBean.setStatus(Constants.CODE_H5_TRANSFER.succeed200);
            jsBean.setMsg("交易成功!");
            dataBean.setTrxid(trxid);
        }

        jsBean.setData(dataBean);
        Gson gson = new Gson();
        String json = gson.toJson(jsBean);
        Logger.e(TAG, "交易回传h5：" + json);

        BusProvider.getBus().post(new EventBanKeShop(json));
    }

    /**
     * 请求vns矿工费接口
     *
     * @param from
     */
    public void getVnsTransInfo(String chainType, String contract, String from) {
        if (hasV()){
            getV().showLoading();
        }
        mPayShop.getVnsTransInfo(chainType, contract, from, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                if (hasV()){
                    getV().hideLoading();
                }

                MinerFeeBean bean = (MinerFeeBean) result;
                if (bean != null) {
                    if (hasV()){
                        getV().ShowMinersFeeView(bean);
                    }

                } else {
                    if (hasV()){
                        getV().showFailureData(null);
                    }

                }
            }

            @Override
            public void onFailure(NetError error) {
                if (hasV()){
                    getV().hideLoading();
                    getV().showFailureData(error);
                }
            }
        });
    }

    public void payHotBancor(String from, boolean isToken, boolean isReverse, int decimals, String vnserToken, String smartToken,
                             String p_nonce, String p_gasprice, String p_startgas, String to,
                             String p_value, String p_chainId, byte[] signPrvKey) {
        try {
            if (hasV()){
                getV().showLoading();
            }
            mPayShop.sigtTransaction(from,isToken, isReverse, decimals, vnserToken, smartToken, p_nonce, p_gasprice,
                    p_startgas, to, p_value, p_chainId, signPrvKey, new OnCompleteDataListener() {
                        @Override
                        public void onComplete(Object result) {
                            if (hasV()){
                                getV().hideLoading();
                            }
                            String trxid = (String) result;
                            if (!TextUtils.isEmpty(trxid)) {
                                if (hasV()){
                                    getV().showTransferSuccess(from, trxid);

                                }
                            } else {
                                if (hasV()){
                                    getV().showTransferFailed(from, "trixd为空", Constants.CODE_H5_TRANSFER.failed400);

                                }
                            }
                        }

                        @Override
                        public void onFailure(NetError error) {
                            if (hasV()){
                                getV().hideLoading();
                                getV().showTransferFailed(from, error.getMessage(), Constants.CODE_H5_TRANSFER.failed400);

                            }
                        }
                    });

        } catch (Exception e) {
            e.printStackTrace();
            if (hasV()){
                getV().hideLoading();
                getV().showTransferFailed(from, "程序异常！" + e.getMessage(), Constants.CODE_H5_TRANSFER.failed400);

            }
        }
    }

    public void approveToken(final String nonce, String gasPrice, String estimateGas, String version, String connector, String bancorconvert, byte[] signPrvKey, OnCompleteDataListener listener) {
        EthSignTransDataUtils signTransDataUtils = new EthSignTransDataUtils();
        TransactionEthParam transactionEthParam = signTransDataUtils.sigtBanKerERCTransaction(
                nonce,
                gasPrice,
                String.valueOf(estimateGas),
                version,// 网络 ID
                connector,
                bancorconvert,
                signPrvKey);
        Api.getServiceVns().transactionEth(transactionEthParam)
                .compose(XApi.<EthTransReult>getApiTransformer())
                .compose(XApi.<EthTransReult>getScheduler())
                .subscribe(new ApiSubscriber<EthTransReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        listener.onFailure(error);
                    }
                    @Override
                    public void onNext(EthTransReult ethTransReult) {
                        if (ethTransReult != null && !TextUtils.isEmpty(ethTransReult.getResult())) {
                            String nonceStr = new BigDecimal(nonce).add(new BigDecimal("1")).stripTrailingZeros().toPlainString();
                            listener.onComplete(nonceStr);
                        }
                    }
                });
    }

    public void canApproveToken(final String nonce, String gasPrice, String estimateGas, String version, String connector, String from, String bancorconvert, byte[] signPrvKey, OnCompleteDataListener listener){
        String json = "{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"vns_call\",\"params\":[{\"to\":\"" + connector + "\",\"data\":\"0xdd62ed3e000000000000000000000000"+ from.replace("0x", "") +"000000000000000000000000"+bancorconvert.replace("0x", "")+"\"},\"latest\"]}";
        EthTokenSeriesParam ethSeriesBalanceParam = new Gson().fromJson(json, EthTokenSeriesParam.class);
        Api.getServiceVns().getEthTokenSeriesParam(ethSeriesBalanceParam)
                .compose(XApi.<GetEthSeriesParamReult>getApiTransformer())
                .compose(XApi.<GetEthSeriesParamReult>getScheduler())
                .subscribe(new ApiSubscriber<GetEthSeriesParamReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        listener.onFailure(error);
                    }
                    @Override
                    public void onNext(GetEthSeriesParamReult ethTransReult) {
                        if (ethTransReult != null && !TextUtils.isEmpty(ethTransReult.getResult())) {
                            int result = new BigInteger(CommonUtil.subStrEthBalance(ethTransReult.getResult()), 16).intValue();
                            if(result == 0){
                                approveToken(nonce, gasPrice, estimateGas, version, connector, bancorconvert, signPrvKey, listener);
                            } else {
                                listener.onComplete(nonce);
                            }
                        }
                    }
                });
    }
}
