package com.fictitious.money.purse.model;

import android.text.TextUtils;

import com.example.ffdemo.R;
import com.fictitious.money.purse.App;
import com.fictitious.money.purse.listener.OnCompleteDataListener;
import com.fictitious.money.purse.net.Api;
import com.fictitious.money.purse.net.TransactionRecordService;
import com.fictitious.money.purse.results.EthTransReult;
import com.fictitious.money.purse.results.GetEthSeriesParamReult;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.DigitalTrans;
import com.fictitious.money.purse.utils.HexUtil;
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
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-11-14 10:01
 * Description:
 */
public class MDidSendToken {
    private final String TAG = MDidSendToken.class.getSimpleName();

//    /**
//     * 获取vns数量
//     */
//    public void getVnsBalance(String vnsAddress, boolean isReplase, OnCompleteDataListener listener) {
//        String url = Api.getChainsNode(Constants.COIN_TYPE.TYPE_VNS, isReplase);
//        List<Object> lists = new ArrayList<>();
//        lists.add(vnsAddress);
//        lists.add("latest");
//
//        EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
//        ethSeriesBalanceParam.setId(1);
//        ethSeriesBalanceParam.setJsonrpc("2.0");
//        ethSeriesBalanceParam.setMethod("vns_getBalance");
//        ethSeriesBalanceParam.setParams(lists);
//
//        Api.getTransactionRecordServiceVns(url).getEthTokenSeriesParam(ethSeriesBalanceParam)
//                .compose(XApi.<GetEthSeriesParamReult>getApiTransformer())
//                .compose(XApi.<GetEthSeriesParamReult>getScheduler())
//                .subscribe(new ApiSubscriber<GetEthSeriesParamReult>() {
//                    @Override
//                    protected void onFail(NetError error) {
//                        Logger.e(TAG, url + "获取失败，自动切换节点获取");
//                        getVnsBalance(vnsAddress, true, listener);
//                    }
//
//                    @Override
//                    public void onNext(GetEthSeriesParamReult getBtcBalanceResult) {
//                        BigDecimal mChainNum = new BigDecimal(new BigInteger(CommonUtil.subStrEthBalance(getBtcBalanceResult.getResult()), 16)).divide(new BigDecimal(Math.pow(10, Constants.CHAIN_DECIMAL_VALUE.ETH)), 10, ROUND_HALF_UP);
//                        Logger.e(TAG, "从节点获取ETH数量：" + mChainNum.toPlainString());
//                        listener.onComplete(mChainNum);
//                    }
//                });
//    }
//
//    /**
//     * 获取vusd数量
//     */
//    public void getVusdBalance(String vnsAddress, String contract, boolean isReplase, OnCompleteDataListener listener) {
//        String url = Api.getChainsNode(Constants.COIN_TYPE.TYPE_VNS, isReplase);
//
//        String data = "0x70a08231000000000000000000000000" + vnsAddress.replace("0x", "");
//        List<Object> lists = new ArrayList<>();
//        AllowanceParams allowanceParams = new AllowanceParams();
//        allowanceParams.setTo(contract);
//        allowanceParams.setData(data);
//        lists.add(allowanceParams);
//        lists.add("latest");
//
//        EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
//        ethSeriesBalanceParam.setId(1);
//        ethSeriesBalanceParam.setJsonrpc("2.0");
//        ethSeriesBalanceParam.setMethod("vns_call");
//        ethSeriesBalanceParam.setParams(lists);
//
//        Api.getTransactionRecordServiceVns(url).getEthTokenSeriesParam(ethSeriesBalanceParam)
//                .compose(XApi.<GetEthSeriesParamReult>getApiTransformer())
//                .compose(XApi.<GetEthSeriesParamReult>getScheduler())
//                .subscribe(new ApiSubscriber<GetEthSeriesParamReult>() {
//                    @Override
//                    protected void onFail(NetError error) {
//                        Logger.e(TAG, url + "获取失败，自动切换节点获取");
//                        getVusdBalance(vnsAddress, contract, true, listener);
//                    }
//
//                    @Override
//                    public void onNext(GetEthSeriesParamReult getBtcBalanceResult) {
//                        BigDecimal result = new BigDecimal(new BigInteger(CommonUtil.subStrEthBalance(getBtcBalanceResult.getResult()), 16)).divide(new BigDecimal(Math.pow(10, 18)), 8, ROUND_HALF_UP);
//                        Logger.e(TAG, "获取vusd代币数量余额：" + result.toPlainString());
//                        listener.onComplete(result);
//
//                    }
//                });
//    }


    //代币转账
    private byte[] getDataByte(String to_account, String decimals, String money, OnCompleteDataListener listener) {
        // erc 2.0 代币的转账
        // value 传0
        // to 合约地址
        // data 三部分
        // MethodDID：0xa9059cbb
        // 收款地址 32位字节
        // 金额  32位字节

        if (TextUtils.isEmpty(decimals)) {
            listener.onFailure(new NetError(App.getContext().getString(R.string.tv_error_trans_decimals), 400));
            return null;
        }

        byte[] byteData = new byte[68];
        byteData[0] = (byte) 0xa9;
        byteData[1] = (byte) 0x05;
        byteData[2] = (byte) 0x9c;
        byteData[3] = (byte) 0xbb;

        String to = to_account;

        if (to.startsWith("0x")) {
            to = to.replace("0x", "");
        }

        byte[] resultByteAccount = new byte[32];
        byte[] byteAccount;
        try {
            byteAccount = DigitalTrans.toBytes(to);
        } catch (Exception e) {
            listener.onFailure(new NetError(App.getContext().getString(R.string.error_format_account_to_be_credited), 400));
            return null;
        }
        System.arraycopy(byteAccount, 0, resultByteAccount, resultByteAccount.length - byteAccount.length, byteAccount.length);

        byte[] resultByteMoney = new byte[32];
        String decimalismString = new BigDecimal(money).multiply(new BigDecimal(Math.pow(10, Integer.parseInt(TextUtils.isEmpty(decimals) ? "0" : decimals)))).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
        byte[] byteMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(decimalismString));
        if (byteMoney != null && byteMoney.length >= 32) {
            System.arraycopy(byteMoney, 0, resultByteMoney, 0, resultByteMoney.length);
        } else {
            System.arraycopy(byteMoney, 0, resultByteMoney, resultByteMoney.length - byteMoney.length, byteMoney.length);
        }
        System.arraycopy(resultByteAccount, 0, byteData, 4, resultByteAccount.length);
        System.arraycopy(resultByteMoney, 0, byteData, 36, resultByteMoney.length);
        return byteData;
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
                    dataBean1.setResult("0xEA60");
                    dataBeanX1.setData(dataBean1);
                    dataBeanXList.add(dataBeanX1);

                    ethTranInfoResult.setData(dataBeanXList);
                    showVnsTransInfo(ethTranInfoResult, from, listener);

                    return null;

//                EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
//                ethSeriesBalanceParam.setId(1);
//                ethSeriesBalanceParam.setJsonrpc("2.0");
//                ethSeriesBalanceParam.setMethod("eth_gasPrice");
//                return service.getEthTokenSeriesParam(ethSeriesBalanceParam);
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

    private void showVnsTransInfo(EthTranInfoResult ethTranInfoResult, String from, OnCompleteDataListener listener) {
        MinerFeeBean bean = new MinerFeeBean();
        bean.setFrom(from);
        int nonce;
        String version = "";
        BigDecimal gasPrice = null, estimateGas = null;
        Logger.e(TAG, "获取vns的交易信息成功！" + ethTranInfoResult.toString());
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
                        gasPrice = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16));
                        bean.setGasPrice(gasPrice);
                        Logger.e(TAG, "获取 gasPrice：" + gasPrice.toString());
                    } else if ("estimateGas".equals(dataBeanX.getName()) || "tokenEstimateGas".equals(dataBeanX.getName())) {
                        estimateGas = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16));
                        bean.setEstimateGas(estimateGas);
                        Logger.e(TAG, "获取 estimateGas：" + estimateGas.toString());
                    } else if ("balance".equals(dataBeanX.getName())) {
                        BigDecimal balance = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16)).divide(new BigDecimal("1000000000000000000"), 10, ROUND_HALF_UP);
                        double amount = balance.doubleValue();
                        bean.setBalance(balance);
                        Logger.e(TAG, "获取 主币的余额：" + amount);
                    } else if ("tokenBalance".equals(dataBeanX.getName())) {
                        BigDecimal balance = new BigDecimal(new BigInteger(CommonUtil.subStrEthBalance(dataBeanX.getData().getResult()), 16)).divide(new BigDecimal(Math.pow(10, 18)), 10, ROUND_HALF_UP);
                        double amount = balance.doubleValue();
                        bean.setBalance(balance);
                        Logger.e(TAG, "获取 代币的余额：" + amount);
                    }
                }
            }
        }

        if (gasPrice != null && estimateGas != null) {
            BigDecimal eth_b = estimateGas.multiply(gasPrice).divide(new BigDecimal("1000000000000000000"), 10, ROUND_HALF_UP);
            // 矿工费
            bean.setMinerFeeNum(eth_b.stripTrailingZeros().toPlainString());
            bean.setGasDes("=Gas(" + estimateGas + ")*GasPrice(" + gasPrice.divide(new BigDecimal("1000000000"), 4, ROUND_HALF_UP).stripTrailingZeros().toPlainString() + "gwei)");
            getVnsCurrencyPrice(bean, listener);
        } else {
            listener.onFailure(new NetError("请求矿工费得到某个字段为空！", 404));
        }
    }

    private void getVnsCurrencyPrice(MinerFeeBean bean, OnCompleteDataListener listener) {
        String company = SharedPref.getInstance(App.getContext()).getString("company", "cny");
        VnsPriceUtil.getVnsPrice("VNS", company, new VnsPriceUtil.IVnsPriceListen() {
            @Override
            public void getVnsPriceCallBack(BigDecimal bigDecimal) {
                String money;
                if (bigDecimal != null) {
                    money = bigDecimal.stripTrailingZeros().toPlainString();
                } else {
                    money = "0";
                }
                Logger.e(TAG, "请求得到VNS单价：" + money);
                bean.setEthCurrentPrice(money);
                listener.onComplete(bean);
            }
        });
    }


    private void signData(boolean isReplase, MinerFeeBean bean, String token, String decimals, String to, String contract,
                          String money, byte[] signPrvKey, OnCompleteDataListener listener) {

        if (to.startsWith("0x")) {
            to = to.replace("0x", "");
        }
        if (contract != null && contract.startsWith("0x")) {
            contract = to.replace("0x", "");
        }

        byte[] p_data;
        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());

        String result_str = "";
        if ("VNS".equals(token.trim())) {
            Logger.e(TAG, "主币签名");
            BigDecimal bigDecimal = new BigDecimal(money).multiply(new BigDecimal(10).pow(Integer.valueOf(decimals))).setScale(0, ROUND_HALF_UP);
            result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, to, bigDecimal.toPlainString(), "", p_chainId, HexUtil.encodeHexStr(signPrvKey));
        } else {
            Logger.e(TAG, "代币签名");
            p_data = getDataByte(contract, decimals, money, listener);
            money = "0";
            result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, to, money, HexUtil.encodeHexStr(p_data), p_chainId, HexUtil.encodeHexStr(signPrvKey));
        }

        if (TextUtils.isEmpty(result_str)) {
            listener.onFailure(new NetError(App.getContext().getString(R.string.tv_error_signature), 400));
            return;
        }


        if (TextUtils.isEmpty(decimals)) {
            listener.onFailure(new NetError(App.getContext().getString(R.string.tv_error_trans_decimals), 400));
            return;
        }

        if (result_str.startsWith("0x")) {
            result_str = result_str.replace("0x", "");
        }

        boolean isCeck = XMHCoinUtitls.CoinID_checkETHpushValid(result_str, to, money, Integer.parseInt(TextUtils.isEmpty(decimals) ? "0" : decimals), !TextUtils.isEmpty(contract), !TextUtils.isEmpty(contract) ? contract : "");
        if (!isCeck) {
            listener.onFailure(new NetError(App.getContext().getString(R.string.tv_error_trans_check), 400));
            return;
        }

            TransactionEthParam transactionBtcParam = new TransactionEthParam();
            transactionBtcParam.setId(1);
            transactionBtcParam.setJsonrpc("2.0");
            transactionBtcParam.setMethod("vns_sendRawTransaction");
            List<String> list = new ArrayList<>();
            list.add("0x" + result_str);
            transactionBtcParam.setParams(list);

            Api.getServiceVns().transactionEth(transactionBtcParam)
                    .compose(XApi.<EthTransReult>getApiTransformer())
                    .compose(XApi.<EthTransReult>getScheduler())
//                    .compose(PayEthActivity.this.<EthTransReult>bindToLifecycle())
                    .subscribe(new ApiSubscriber<EthTransReult>() {
                        @Override
                        protected void onFail(NetError error) {
                            Logger.e(TAG, "交易失败：" + error.getMessage());
                            listener.onFailure(error);
                        }

                        @Override
                        public void onNext(EthTransReult ethTransReult) {
                            try {
                                Logger.e(TAG, "交易成功：" + ethTransReult.toString());
                                String trxid = ethTransReult.getResult();
                                if (!TextUtils.isEmpty(trxid)) {
                                    listener.onComplete(trxid);
                                    Logger.e(TAG, "Trixd：" + trxid);
                                } else {
                                    listener.onFailure(new NetError(ethTransReult.getError().getMessage(), 0));
                                }
                            } catch (Exception e) {
                                listener.onFailure(new NetError(e.getMessage(), 400));
                            }
                        }
                    });

    }

    public void pay(String token, String contract, String from, String to, String decimals, String money, byte[] signPrvKey, OnCompleteDataListener listener) {
        getVnsTransInfo(token, contract, from, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                MinerFeeBean bean = (MinerFeeBean) result;
                signData(false, bean, token, decimals, to, contract, money, signPrvKey, listener);
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(error);
            }
        });
    }
}
