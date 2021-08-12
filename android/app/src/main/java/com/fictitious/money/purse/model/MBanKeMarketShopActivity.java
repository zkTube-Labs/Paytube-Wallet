package com.fictitious.money.purse.model;

import android.text.TextUtils;
import android.util.Log;

import com.fictitious.money.purse.App;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.listener.OnCompleteDataListener;
import com.fictitious.money.purse.net.Api;
import com.fictitious.money.purse.net.TransactionRecordService;
import com.fictitious.money.purse.results.EthTransReult;
import com.fictitious.money.purse.results.GetEthSeriesParamReult;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.DigitalTrans;
import com.fictitious.money.purse.utils.EthSignTransDataUtils;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.utils.VnsPriceUtil;
import com.fictitious.money.purse.utils.XMHCoinUtitls;

import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import cn.droidlover.xdroidmvp.cache.SharedPref;
import cn.droidlover.xdroidmvp.net.ApiSubscriber;
import cn.droidlover.xdroidmvp.net.NetError;
import cn.droidlover.xdroidmvp.net.XApi;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;

import static java.math.BigDecimal.ROUND_HALF_UP;

/**
 * Description:
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/4/4 15:07
 */
public class MBanKeMarketShopActivity {
    private final String TAG = MBanKeMarketShopActivity.class.getSimpleName();

    public void sigtTransaction(String from, boolean isToken, boolean isReverse, int decimals, String vnserToken, String smartToken,
                                String p_nonce, String p_gasprice, String p_startgas, String to,
                                String p_value, String p_chainId, byte[] signPrvKey, OnCompleteDataListener listener) {
        String value = p_value;
        Logger.e(TAG, "p_nonce :" + p_nonce);
        Logger.e(TAG, "p_gasprice :" + p_gasprice);
        Logger.e(TAG, "p_startgas :" + p_startgas);

        byte[] p_data = getDataResult(isReverse, p_value, decimals, vnserToken, smartToken);

        if (isToken) {
            p_value = String.valueOf(new BigDecimal(p_value).multiply(new BigDecimal("1000000000000000000")).setScale(0, BigDecimal.ROUND_HALF_UP));
            // 如果是兑换代币,即用主币付款decimals = 0;
            Logger.e(TAG, "即用主币付款,decimals:" + decimals + ",金额：" + p_value);
        } else {
            p_value = "0";
            // 如果是兑换主币，即用代币付款
            Logger.e(TAG, "即用代币付款,decimals：" + decimals + ",金额为:" + p_value);
        }

        byte[] b_nonce = CommonUtil.strToByteArray(p_nonce);

        byte[] b_gasprice = CommonUtil.strToByteArray(p_gasprice);
        byte[] b_startgas = CommonUtil.strToByteArray(p_startgas);
        if (to.startsWith("0x")) {
            to = to.replace("0x", "");
        }
        byte[] b_to = CommonUtil.strToByteArray(to);
        byte[] b_value = CommonUtil.strToByteArray(p_value);
        byte[] b_chainId = CommonUtil.strToByteArray(p_chainId);

        byte[] result_byte = XMHCoinUtitls.CoinID_sigtEthTransaction(b_nonce, (short) b_nonce.length, b_gasprice, (short) b_gasprice.length, b_startgas, (short) b_startgas.length, b_to, b_value, (short) b_value.length, p_data, (short) p_data.length, b_chainId, (short) b_chainId.length, signPrvKey);
        String result_str = new String(result_byte);
        if (!TextUtils.isEmpty(result_str)) {

            if (from.startsWith("0x")) {
                from = from.replace("0x", "");
            }
            Logger.e(TAG, "参数1：" + result_str);
            Logger.e(TAG, "参数2：" + from);
            Logger.e(TAG, "参数3：" + value);
            Logger.e(TAG, "参数4：" + decimals);
            Logger.e(TAG, "参数6：" + to);
            // 第一个参数是准备提交主网的签名数据，第二个参数to随便填，不做校验，因为是兑给自己，手动去掉0x不然校验不过
            // 第三个参数是用户填写的兑换值，比如1vns，就填1，第四个参数decimal，根据情况填写，vns的话是18，
            // 第五个参数true代表是合约，第六个参数contractAddr填写合约地址
            boolean checkResult = XMHCoinUtitls.CoinID_checkETHpushValid(result_str, from,
                    value, decimals, true, to);
            if (checkResult) {
                Logger.e(TAG, "验证通过");
                transaction("0x" + result_str, listener);
            } else {
                Logger.e(TAG, "验证不通过");
                listener.onFailure(new NetError("签名数据校验不通过", 0));
            }

        } else {
            // 清空私钥
            listener.onFailure(new NetError("数据不对，签名结果为null", 0));
        }
    }

    private void transaction(String param, OnCompleteDataListener listener) {
        TransactionEthParam transactionBtcParam = new TransactionEthParam();
        transactionBtcParam.setId(1);
        transactionBtcParam.setJsonrpc("2.0");
        transactionBtcParam.setMethod("vns_sendRawTransaction");
        List<String> list = new ArrayList<>();
        list.add(param);
        transactionBtcParam.setParams(list);

        Api.getServiceVns().transactionEth(transactionBtcParam)
                .compose(XApi.<EthTransReult>getApiTransformer())
                .compose(XApi.<EthTransReult>getScheduler())
                .subscribe(new ApiSubscriber<EthTransReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        try {
                            listener.onFailure(error);
                            Logger.e(TAG, "交易失败：" + error.getMessage());
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public void onNext(EthTransReult ethTransReult) {
                        try {
                            Logger.e(TAG, "交易成功：" + ethTransReult.toString());
                            String trxid = ethTransReult.getResult();
                            Logger.e(TAG, "Trixd：" + trxid);
                            listener.onComplete(trxid);
                        } catch (Exception e) {
                            e.printStackTrace();
                            listener.onFailure(new NetError(e, 0));
                        }

                    }
                });

    }

    /**
     * 班科协议
     *
     * @param isReverse
     * @param money
     * @param decimals
     * @param vnserToken
     * @param smartToken
     */
    private byte[] getDataResult(boolean isReverse, String money, int decimals, String vnserToken, String smartToken) {
        if (vnserToken.startsWith("0x")) {
            vnserToken = vnserToken.replace("0x", "");
            Logger.e(TAG, "去成功：" + vnserToken);
        }

        if (smartToken.startsWith("0x")) {
            smartToken = smartToken.replace("0x", "");
            Logger.e(TAG, "去掉成功：" + smartToken);
        }

        //0xf0,0x84,0x3b,0xa9  4字节
        byte[] byteData = new byte[228];
        byteData[0] = (byte) 0xf0;
        byteData[1] = (byte) 0x84;
        byteData[2] = (byte) 0x3b;
        byteData[3] = (byte) 0xa9;


        //0x60 填充32字节
        byte[] byte1 = new byte[32];
        byte[] byte_oneValue = new byte[1];
        byte_oneValue[0] = (byte) 0x60;
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byte_oneValue, 0, byte1, byte1.length - byte_oneValue.length, byte_oneValue.length);


        //hexmoney 填充32 字节
        byte[] byte2 = new byte[32];
        String decimalismString = new BigDecimal(money).multiply(new BigDecimal(Math.pow(10, decimals))).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
        byte[] byteMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(decimalismString));
        System.arraycopy(byteMoney, 0, byte2, byte2.length - byteMoney.length, byteMoney.length);


        // 0x01 填充32字节
        byte[] byte3 = new byte[32];
        byte[] byte_twoValue = new byte[1];
        byte_twoValue[0] = (byte) 0x01;
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byte_twoValue, 0, byte3, byte3.length - byte_twoValue.length, byte_twoValue.length);


        //0x03 填充32字节
        byte[] byte4 = new byte[32];
        byte[] byte_threeValue = new byte[1];
        byte_threeValue[0] = (byte) 0x03;
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byte_threeValue, 0, byte4, byte4.length - byte_threeValue.length, byte_threeValue.length);


        // 如果是 vns - > token  则 vnserToken 填充32字节，SmartToken 填充32字节，SmartToken   填充32字节

        byte[] byte5 = new byte[32];
        byte[] byteVnser = null;
        try {
            byteVnser = DigitalTrans.toBytes(vnserToken);
            Logger.e(TAG, "byteVnser 转换：" + vnserToken);
        } catch (Exception e) {
            Logger.e(TAG, "byteVnser 异常：" + e.getMessage());
            return byteData;
        }
        System.arraycopy(byteVnser, 0, byte5, byte5.length - byteVnser.length, byteVnser.length);


        byte[] byte6 = new byte[32];
        byte[] byteSmartToken = null;
        try {
            byteSmartToken = DigitalTrans.toBytes(smartToken);
            Logger.e(TAG, "byteSmartToken 转换：" + smartToken);
        } catch (Exception e) {
            Logger.e(TAG, "byteSmartToken 异常：" + e.getMessage());
            return byteData;
        }
        System.arraycopy(byteSmartToken, 0, byte6, byte6.length - byteSmartToken.length, byteSmartToken.length);


        byte[] byte7 = new byte[32];
        byte[] byteSmartToken2 = null;
        try {
            byteSmartToken2 = DigitalTrans.toBytes(smartToken);
            Logger.e(TAG, "byteSmartToken2 转换：" + smartToken);
        } catch (Exception e) {
            Logger.e(TAG, "byteSmartToken2 异常：" + e.getMessage());
            return byteData;
        }
        System.arraycopy(byteSmartToken2, 0, byte7, byte7.length - byteSmartToken2.length, byteSmartToken2.length);


        System.arraycopy(byte1, 0, byteData, 4, byte1.length);
        System.arraycopy(byte2, 0, byteData, 4 + byte1.length, byte2.length);
        System.arraycopy(byte3, 0, byteData, 4 + byte1.length + byte2.length, byte3.length);
        System.arraycopy(byte4, 0, byteData, 4 + byte1.length + byte2.length + byte3.length, byte4.length);
        if (!isReverse) {
            Logger.e(TAG, "不颠倒");
            System.arraycopy(byte5, 0, byteData, 4 + byte1.length + byte2.length + byte3.length + byte4.length, byte5.length);
            System.arraycopy(byte6, 0, byteData, 4 + byte1.length + byte2.length + byte3.length + byte4.length + byte5.length, byte6.length);
            System.arraycopy(byte7, 0, byteData, 4 + byte1.length + byte2.length + byte3.length + byte4.length + byte5.length + byte6.length, byte7.length);
        } else {
            // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
            Logger.e(TAG, "颠倒");
            System.arraycopy(byte6, 0, byteData, 4 + byte1.length + byte2.length + byte3.length + byte4.length, byte6.length);
            System.arraycopy(byte7, 0, byteData, 4 + byte1.length + byte2.length + byte3.length + byte4.length + byte6.length, byte7.length);
            System.arraycopy(byte5, 0, byteData, 4 + byte1.length + byte2.length + byte3.length + byte4.length + byte6.length + byte7.length, byte5.length);
        }

        return byteData;
    }


    /**
     * 热钱包支付
     */
    public void hotPay(int type, String p_nonce, BigDecimal gasPrice, BigDecimal estimateGas, String to, String p_value,
                       String remarks, String version, byte[] signPrvKey, OnCompleteDataListener listener) {
        String value = String.valueOf(new BigDecimal(p_value).multiply(new BigDecimal("1000000000000000000"))
                .setScale(0, BigDecimal.ROUND_HALF_UP));
        byte[] p_data = CommonUtil.strToByteArray(remarks);

        // VNS转账
        if (type == Constants.COIN_TYPE.TYPE_ETH) {
            Logger.e(TAG, "VNS转账");
            TransactionEthParam vnsParam = EthSignTransDataUtils.signVnsTransaction(p_nonce, String.valueOf(gasPrice.setScale(0, ROUND_HALF_UP)),
                    String.valueOf(estimateGas), to, value, p_data, version, signPrvKey);

            Api.getServiceVns().transactionEth(vnsParam)
                    .compose(XApi.getApiTransformer())
                    .compose(XApi.getScheduler())
                    .subscribe(new ApiSubscriber<EthTransReult>() {
                        @Override
                        protected void onFail(NetError error) {
                            listener.onFailure(error);
                        }

                        @Override
                        public void onNext(EthTransReult ethTransReult) {
                            try {
                                if (ethTransReult != null) {
                                    String trxid = ethTransReult.getResult();
                                    if (TextUtils.isEmpty(trxid)) {
                                        listener.onFailure(new NetError("" + ethTransReult.getError().getMessage(), 3));
                                    } else {
                                        listener.onComplete(trxid);
                                    }
                                } else {
                                    listener.onFailure(null);
                                }
                            } catch (Exception e) {
                                Log.e(TAG, "eth转账异常：" + e.getMessage());
                                listener.onFailure(null);
                            }
                        }
                    });
        } else if (type == Constants.COIN_TYPE.TYPE_ETH) {
            // ETH转账
            Logger.e(TAG, "ETH转账");
            TransactionEthParam param = EthSignTransDataUtils.signEthTransaction(p_nonce, String.valueOf(gasPrice.setScale(0, ROUND_HALF_UP)),
                    String.valueOf(estimateGas), to, value, p_data, version, signPrvKey);
            Api.getServiceVns().transactionEth(param)
                    .compose(XApi.getApiTransformer())
                    .compose(XApi.getScheduler())
                    .subscribe(new ApiSubscriber<EthTransReult>() {
                        @Override
                        protected void onFail(NetError error) {
                            listener.onFailure(error);
                        }

                        @Override
                        public void onNext(EthTransReult ethTransReult) {
                            try {
                                if (ethTransReult != null) {
                                    String trxid = ethTransReult.getResult();
                                    if (TextUtils.isEmpty(trxid)) {
                                        listener.onFailure(new NetError("" + ethTransReult.getError().getMessage(), 3));
                                    } else {
                                        listener.onComplete(trxid);
                                    }
                                } else {
                                    listener.onFailure(null);
                                }
                            } catch (Exception e) {
                                Log.e(TAG, "eth转账异常：" + e.getMessage());
                                listener.onFailure(null);
                            }
                        }
                    });
        } else {
            Log.e(TAG, "暂无其他币种转账：" + type);
            listener.onFailure(null);
        }
    }

    public void getVnsTransInfo(String token, String contract, String from, OnCompleteDataListener listener) {
        EthTranInfoResult ethTranInfoResult = new EthTranInfoResult();
        List<EthTranInfoResult.DataBeanX> dataBeanXList = new ArrayList<>();
        Retrofit mRetrofit = new Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create())
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .baseUrl(Api.API_TRAN_VNS_URL)
                .build();
        TransactionRecordService service = mRetrofit.create(TransactionRecordService.class);

        EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
        ethSeriesBalanceParam.setId(1);
        ethSeriesBalanceParam.setJsonrpc("2.0");
        ethSeriesBalanceParam.setMethod("vns_gasPrice");

        service.getEthTokenSeriesParam(ethSeriesBalanceParam).flatMap(new Function<GetEthSeriesParamReult, Publisher<GetEthSeriesParamReult>>() {
            @Override
            public Publisher<GetEthSeriesParamReult> apply(GetEthSeriesParamReult getEthSeriesParamReult) throws Exception {
                EthTranInfoResult.DataBeanX dataBeanX = new EthTranInfoResult.DataBeanX();
                EthTranInfoResult.DataBeanX.DataBean dataBean = new EthTranInfoResult.DataBeanX.DataBean();
                dataBeanX.setName("gasPrice");
                dataBean.setResult(getEthSeriesParamReult.getResult());
                dataBeanX.setData(dataBean);
                dataBeanXList.add(dataBeanX);

                List<Object> lists = new ArrayList<>();
                lists.add(from);
                lists.add("latest");
                EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
                ethSeriesBalanceParam.setId(1);
                ethSeriesBalanceParam.setJsonrpc("2.0");
                ethSeriesBalanceParam.setMethod("vns_getTransactionCount");
                ethSeriesBalanceParam.setParams(lists);
                return service.getEthTokenSeriesParam(ethSeriesBalanceParam);
            }
        }).flatMap(new Function<GetEthSeriesParamReult, Publisher<GetEthSeriesParamReult>>() {
            @Override
            public Publisher<GetEthSeriesParamReult> apply(GetEthSeriesParamReult getEthSeriesParamReult) throws Exception {
                EthTranInfoResult.DataBeanX dataBeanX = new EthTranInfoResult.DataBeanX();
                EthTranInfoResult.DataBeanX.DataBean dataBean = new EthTranInfoResult.DataBeanX.DataBean();
                dataBeanX.setName("transaction");
                dataBean.setResult(getEthSeriesParamReult.getResult());
                dataBeanX.setData(dataBean);
                dataBeanXList.add(dataBeanX);

                EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
                ethSeriesBalanceParam.setId(1);
                ethSeriesBalanceParam.setJsonrpc("2.0");
                ethSeriesBalanceParam.setMethod("net_version");
                return service.getEthTokenSeriesParam(ethSeriesBalanceParam);
            }
        }).flatMap(new Function<GetEthSeriesParamReult, Publisher<GetEthSeriesParamReult>>() {
            @Override
            public Publisher<GetEthSeriesParamReult> apply(GetEthSeriesParamReult getEthSeriesParamReult) throws Exception {
                EthTranInfoResult.DataBeanX dataBeanX = new EthTranInfoResult.DataBeanX();
                EthTranInfoResult.DataBeanX.DataBean dataBean = new EthTranInfoResult.DataBeanX.DataBean();
                dataBeanX.setName("version");
                dataBean.setResult(getEthSeriesParamReult.getResult());
                dataBeanX.setData(dataBean);
                dataBeanXList.add(dataBeanX);

                if ("VNS".equals(token)) {
                    List<Object> lists = new ArrayList<>();
                    lists.add(from);
                    lists.add("latest");

                    EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
                    ethSeriesBalanceParam.setId(1);
                    ethSeriesBalanceParam.setJsonrpc("2.0");
                    ethSeriesBalanceParam.setMethod("vns_getBalance");
                    ethSeriesBalanceParam.setParams(lists);

                    return service.getEthTokenSeriesParam(ethSeriesBalanceParam);
                } else {
                    String data = "0x70a08231000000000000000000000000" + from.replace("0x", "");
                    List<Object> lists = new ArrayList<>();
                    AllowanceParams allowanceParams = new AllowanceParams();
                    allowanceParams.setTo(contract);
                    allowanceParams.setData(data);
                    lists.add(allowanceParams);
                    lists.add("latest");

                    EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
                    ethSeriesBalanceParam.setId(1);
                    ethSeriesBalanceParam.setJsonrpc("2.0");
                    ethSeriesBalanceParam.setMethod("vns_call");
                    ethSeriesBalanceParam.setParams(lists);

                    return service.getEthTokenSeriesParam(ethSeriesBalanceParam);
                }
            }
        }).map(new Function<GetEthSeriesParamReult, Object>() {
            @Override
            public Publisher<GetEthSeriesParamReult> apply(GetEthSeriesParamReult getEthSeriesParamReult) throws Exception {
                EthTranInfoResult.DataBeanX dataBeanX = new EthTranInfoResult.DataBeanX();
                EthTranInfoResult.DataBeanX.DataBean dataBean = new EthTranInfoResult.DataBeanX.DataBean();
                if ("VNS".equals(token)) {
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
                if("VNS".equals(token)){
                    dataBean1.setResult("0x5cec");
                } else {
                    dataBean1.setResult("0xEA60");
                }
                dataBeanX1.setData(dataBean1);
                dataBeanXList.add(dataBeanX1);

                ethTranInfoResult.setData(dataBeanXList);
                showEthTransInfo(ethTranInfoResult, from, listener);

                return null;
            }
        }).subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Object>() {
                    @Override
                    public void onSubscribe(Subscription s) {

                    }

                    @Override
                    public void onNext(Object o) {

                    }

                    @Override
                    public void onError(Throwable t) {

                    }

                    @Override
                    public void onComplete() {

                    }
                });
    }

    void showEthTransInfo(EthTranInfoResult ethTranInfoResult, String from, OnCompleteDataListener listener) {
        MinerFeeBean bean = new MinerFeeBean();
        bean.setFrom(from);
        int nonce;
        String version = "";
        BigDecimal gasPrice = null, estimateGas = null, eth_b = null;
        Logger.e(TAG, "获取eth的交易信息成功！");
        if (ethTranInfoResult != null && ethTranInfoResult.getData() != null && ethTranInfoResult.getData().size() > 0) {
            for (EthTranInfoResult.DataBeanX dataBeanX : ethTranInfoResult.getData()) {
                if (dataBeanX.getData() != null && !TextUtils.isEmpty(dataBeanX.getData().getResult())) {
                    if ("transaction".equals(dataBeanX.getName()) || "nonce".equals(dataBeanX.getName())) {
                        nonce = DigitalTrans.hexStringToAlgorism(dataBeanX.getData().getResult());
                        bean.setNonce(nonce);
                        Logger.e(TAG, "获取交易序号nonce：" + nonce);
                    } else if ("version".equals(dataBeanX.getName())) {
                        version = "2018";
                        bean.setVersion(version);
                        Logger.e(TAG, "获取 version：" + version);
                    } else if ("gasPrice".equals(dataBeanX.getName())) {
//                                            gasPrice = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16)); 500000000000
                        gasPrice = new BigDecimal("50000000000");
                        bean.setOriginalGasPrice(new BigDecimal("50000000000"));//2级帮客的aprove
                        bean.setGasPrice(gasPrice);
                        Logger.e(TAG, "获取 gasPrice：" + gasPrice.toString());
                    } else if ("estimateGas".equals(dataBeanX.getName()) || "tokenEstimateGas".equals(dataBeanX.getName())) {
//                                            estimateGas = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16)); 4700000
                        estimateGas = new BigDecimal("8000000");
                        bean.setOriginalEstimateGas(new BigDecimal("8000000"));//2级帮客的aprove
                        bean.setEstimateGas(estimateGas);
                        Logger.e(TAG, "获取 estimateGas：" + estimateGas.toString());
                    } else if ("balance".equals(dataBeanX.getName())) {
                        // 主币的余额
                        BigDecimal balance = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16)).divide(new BigDecimal("1000000000000000000"), 10, ROUND_HALF_UP);
                        double amount = balance.doubleValue();
                        bean.setBalance(balance);
                        Logger.e(TAG, "获取 主币的余额：" + amount);
                    } else if ("tokenBalance".equals(dataBeanX.getName())) {
                        // 代币的余额
                        BigDecimal balance = new BigDecimal(dataBeanX.getData().getResult());
                        double amount = balance.doubleValue();
                        bean.setBalance(balance);
                        Logger.e(TAG, "获取 代币的余额：" + amount);
                    }

                    if (gasPrice != null && estimateGas != null) {
                        eth_b = estimateGas.multiply(gasPrice).divide(new BigDecimal("1000000000000000000"), 10, ROUND_HALF_UP);
                        // 矿工费
                        bean.setMinerFeeNum(eth_b.stripTrailingZeros().toPlainString());
                        bean.setGasDes("=Gas(" + estimateGas + ")*GasPrice(" + gasPrice.divide(new BigDecimal("1000000000"), 4, ROUND_HALF_UP).stripTrailingZeros().toPlainString() + "gwei)");
                    }
                }
            }
        }

        if (!TextUtils.isEmpty(version) && gasPrice != null && estimateGas != null) {
            eth_b = estimateGas.multiply(gasPrice).divide(new BigDecimal("1000000000000000000"), 10, ROUND_HALF_UP);

            // 矿工费
            bean.setMinerFeeNum(eth_b.stripTrailingZeros().toPlainString());
            bean.setGasDes("=Gas(" + estimateGas + ")*GasPrice(" + gasPrice.divide(new BigDecimal("1000000000"), 4, ROUND_HALF_UP).stripTrailingZeros().toPlainString() + "gwei)");


            getVnsCurrencyPrice(bean, eth_b, listener);

        } else {
            listener.onFailure(new NetError("请求矿工费得到某个字段为空！", 404));
        }
    }

    void getVnsCurrencyPrice(MinerFeeBean bean, final BigDecimal eth_b, OnCompleteDataListener listener) {
        String company = SharedPref.getInstance(App.getContext()).getString("company", "cny");
        VnsPriceUtil.getVnsPrice("VNS", company, new VnsPriceUtil.IVnsPriceListen() {
            @Override
            public void getVnsPriceCallBack(BigDecimal bigDecimal) {
                String money;
                if (bigDecimal != null && eth_b != null) {
                    String price = bigDecimal.stripTrailingZeros().toPlainString();
                    money = CommonUtil.getFloat(Double.parseDouble(price) * eth_b.doubleValue());
                } else {
                    money = "0";
                }
                bean.setEthCurrentPrice(money);
                listener.onComplete(bean);
            }
        });
    }
}
