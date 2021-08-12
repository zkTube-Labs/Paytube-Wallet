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
import com.fictitious.money.purse.utils.VdaiSignUtils;
import com.fictitious.money.purse.utils.VnsPriceUtil;
import com.fictitious.money.purse.utils.XMHCoinUtitls;

import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
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
public class MBasePayVdai {
    private final String TAG = MBasePayVdai.class.getSimpleName();

    /**
     * 发送
     */
    public void paySend(boolean isToken, String token, String fromAddress, String toAddress, String contract, String money, String decimals, byte[] signPrvKey, OnCompleteDataListener listener) {
        if (!TextUtils.isEmpty(fromAddress) && !XMHCoinUtitls.CoinID_checkAddressValid("vns", fromAddress)) {
            Logger.e(TAG, "付款地址不正确");
            listener.onFailure(new NetError(App.getContext().getString(R.string.tv_input_collection_address_err), 400));
            return;
        }
        if (!TextUtils.isEmpty(toAddress) && !XMHCoinUtitls.CoinID_checkAddressValid("vns", toAddress)) {
            Logger.e(TAG, "收款地址不正确");
            listener.onFailure(new NetError(App.getContext().getString(R.string.tv_input_collection_address_err), 400));
            return;
        }
        if (!isToken) {
            token = "VMS";
        }
        getVnsTransInfo(token, fromAddress, contract, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                MinerFeeBean bean = (MinerFeeBean) result;
                String signData = "";
                if (isToken) {
                    signData = VdaiSignUtils.signToken(bean, toAddress, contract, money, decimals, signPrvKey);
                } else {
                    signData = VdaiSignUtils.signVns(bean, toAddress, money, signPrvKey);
                }
                if (TextUtils.isEmpty(signData)) {
                    listener.onFailure(new NetError(App.getContext().getString(R.string.tv_error_trans_check), 400));
                } else {
                    transaction(signData, listener);
                }
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(new NetError("交易失败", 404));
            }
        });
    }

    /**
     * 生成Vusd
     */
    public void payGenerateVusd(String token, String vnsAddress, String vnsJoinContractAddress, String vusdNum, byte[] signPrvKey, OnCompleteDataListener listener) {
        getVnsTransInfo(token, vnsAddress, vnsJoinContractAddress, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                MinerFeeBean bean = (MinerFeeBean) result;
                String data = "0x4538c4eb000000000000000000000000" + vnsAddress.replace("0x", "") + "000000000000000000000000cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68";
                GetAllowanceParam params = new GetAllowanceParam();
                params.setId(1);
                params.setJsonrpc("2.0");
                params.setMethod("vns_call");
                List<Object> lists = new ArrayList<>();

                AllowanceParams allowanceParams = new AllowanceParams();
                allowanceParams.setTo("0xec0b8d49fa29f9e675823d0ee464df16bcf044d1");
                allowanceParams.setData(data);
                lists.add(allowanceParams);
                lists.add("latest");

                params.setParams(lists);
                // vat.can
                Api.getServiceVns().GetAllowance(params)
                        .compose(XApi.<AllowanceResult>getApiTransformer())
                        .compose(XApi.<AllowanceResult>getScheduler())
                        .subscribe(new ApiSubscriber<AllowanceResult>() {
                            @Override
                            protected void onFail(NetError error) {
                                listener.onFailure(new NetError(error, 0));
                            }

                            @Override
                            public void onNext(AllowanceResult result) {
                                try {
                                    if (result == null) {
                                        listener.onFailure(new NetError("获取Allowance失败", 400));
                                        Logger.e(TAG, "获取Allowance失败");
                                        return;
                                    }
                                    String hexString = result.getResult();
                                    Logger.e(TAG, "得到result：" + result.toString());
                                    if (TextUtils.isEmpty(hexString)) {
                                        hexString = "0";
                                    }
                                    if (hexString.startsWith("0x")) {
                                        hexString = hexString.replace("0x", "");
                                    }


                                    BigInteger bigInteger = new BigInteger(hexString, 10);
                                    long longValue = bigInteger.longValue();
                                    Logger.e(TAG, "10进制：" + longValue);
                                    BigDecimal bigDecimal = new BigDecimal(bigInteger);
                                    if (bigDecimal.compareTo(BigDecimal.ZERO) == 0) {
                                        // 查看为0，则先hope
                                        Logger.e(TAG, "vat.can 为0，则先hope");
                                        String hopeData = "a3b22fc4000000000000000000000000cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68";
                                        String hope = VdaiSignUtils.hope(bean, hopeData, signPrvKey);
                                        transaction(hope, new OnCompleteDataListener() {
                                            @Override
                                            public void onComplete(Object result) {
                                                bean.setNonce(bean.getNonce() + 1);
                                                generateFrobtToExit(bean);
                                            }

                                            @Override
                                            public void onFailure(NetError error) {

                                            }
                                        });
                                    } else {
                                        Logger.e(TAG, "vat.can 不为0");
                                        generateFrobtToExit(bean);
                                    }


                                } catch (Exception e) {
                                    e.printStackTrace();
                                    listener.onFailure(new NetError(e, 0));
                                }

                            }
                        });
            }

            private void generateFrobtToExit(MinerFeeBean bean) {
                selectVCDPGlobalQualityRatio(false, new OnCompleteDataListener() {
                    @Override
                    public void onComplete(Object result) {
                        String rateHex = (String) result;
                        BigInteger rateBigInteger = new BigInteger(rateHex, 16);
                        BigDecimal rateBigDecimal = new BigDecimal(rateBigInteger.toString(10));
                        // 输入的vusd * 10^18 * ilk.rate
                        BigDecimal vusdBigDecimal = new BigDecimal(vusdNum);
                        BigDecimal resultBigDecimal = vusdBigDecimal.multiply(new BigDecimal(10).pow(18)).multiply(rateBigDecimal);
                        BigInteger resultBigInteger = new BigInteger(resultBigDecimal.setScale(0, BigDecimal.ROUND_DOWN).toPlainString(), 10);

                        String frobt = VdaiSignUtils.vat_frobt(vnsAddress, false, "0", false, resultBigInteger.toString(16), bean, signPrvKey);
                        transaction(frobt, new OnCompleteDataListener() {
                            @Override
                            public void onComplete(Object result) {
                                bean.setNonce(bean.getNonce() + 1);
                                String exit = VdaiSignUtils.exit(bean, vnsAddress, "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68", vusdNum, signPrvKey);
                                transaction(exit, listener);
                            }

                            @Override
                            public void onFailure(NetError error) {
                                listener.onFailure(new NetError("交易失败", 404));
                            }
                        });

                    }

                    @Override
                    public void onFailure(NetError error) {
                        listener.onFailure(new NetError("交易失败", 404));
                    }
                });
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(new NetError("获取交易信息失败 失败", 404));

            }
        });

    }

    /**
     * 转移VUSD
     */
    public void payTransferVusd(boolean isReplase, String token, String vnsAddress, String vnsJoinContractAddress, String targetAddress, byte[] signPrvKey, OnCompleteDataListener listener) {
        getVnsTransInfo(token, vnsAddress, vnsJoinContractAddress, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                MinerFeeBean bean = (MinerFeeBean) result;
                selectDebtRelationship(vnsAddress, isReplase, new OnCompleteDataListener() {
                    @Override
                    public void onComplete(Object result) {
                        HashMap<String, String> hashMap = (HashMap<String, String>) result;
                        String ink = hashMap.get("ink");
                        String art = hashMap.get("art");
                        selectVCDPGlobalQualityRatio(false, new OnCompleteDataListener() {
                            @Override
                            public void onComplete(Object result) {
                                String rateHex = (String) result;
                                BigInteger rateBigInteger = new BigInteger(rateHex, 16);
                                BigInteger artBigInteger = new BigInteger(art, 16);
                                // urn.art*ilk.rate
                                BigInteger multiply = artBigInteger.multiply(rateBigInteger);
                                Logger.e(TAG, "urn.art*ilk.rate 10进制：" + multiply.toString(10));
                                Logger.e(TAG, "urn.art*ilk.rate 16进制：" + multiply.toString(16));
                                String artHex = DigitalTrans.patchHexString(multiply.toString(16), 64);
                                String forkt = VdaiSignUtils.forkt(bean, vnsAddress, targetAddress, ink, artHex, signPrvKey);
                                transaction(forkt, listener);
                            }

                            @Override
                            public void onFailure(NetError error) {
                                listener.onFailure(new NetError("交易失败", 404));
                            }
                        });
                    }

                    @Override
                    public void onFailure(NetError error) {
                        listener.onFailure(new NetError("交易失败", 404));
                    }
                });
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(new NetError("获取交易信息失败 失败", 404));
            }
        });
    }

    /**
     * 接收
     */
    public void payAccept(boolean isReplase, String token, String vnsAddress, String vnsJoinContractAddress, String targetAddress, byte[] signPrvKey, OnCompleteDataListener listener) {
        getVnsTransInfo(token, vnsAddress, vnsJoinContractAddress, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                MinerFeeBean bean = (MinerFeeBean) result;
                String tempAddress = "";
                if (targetAddress.startsWith("0x")) {
                    tempAddress = targetAddress.replace("0x", "");
                }
                String hopeData = "a3b22fc4000000000000000000000000" + tempAddress;
                String hope = VdaiSignUtils.hope(bean, hopeData, signPrvKey);
                transaction(hope, listener);
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(new NetError("获取交易信息失败 失败", 404));
            }
        });
    }

    /**
     * 关闭VUSD
     */
    public void payCloseVusd(boolean isReplase, String vnsAddress, String vnsJoinContractAddress, byte[] signPrvKey, OnCompleteDataListener listener) {

        getVnsTransInfo("VUSD", vnsAddress, vnsJoinContractAddress, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                MinerFeeBean bean = (MinerFeeBean) result;
                // 获取urn.art
                selectDebtRelationship(vnsAddress, isReplase, new OnCompleteDataListener() {
                    @Override
                    public void onComplete(Object result) {
                        HashMap<String, String> hashMap = (HashMap<String, String>) result;
                        String artHex = hashMap.get("art");
                        BigInteger artBigIntegerHex = new BigInteger(artHex, 16);
                        BigDecimal artDecimal = new BigDecimal(artBigIntegerHex.toString(10));
                        Logger.e(TAG, "获取art 10进制值：" + artDecimal.toPlainString());

                        String dinkHex = hashMap.get("ink");
                        // 获取ilk.rate
                        selectVCDPGlobalQualityRatio(false, new OnCompleteDataListener() {
                            @Override
                            public void onComplete(Object result) {
                                String rateHex = (String) result;
                                BigInteger rateBigIntegerHex = new BigInteger(rateHex, 16);
                                BigDecimal rateDecimal = new BigDecimal(rateBigIntegerHex.toString(10));
                                Logger.e(TAG, "获取rate 10进制值：" + rateDecimal.toPlainString());

                                // Dart = urn.Art*ilk.rate
                                BigDecimal dartDecimal = artDecimal.multiply(rateDecimal);
                                Logger.e(TAG, "Dart = urn. Art*ilk.rate 10进制值:" + dartDecimal.toPlainString());
                                BigInteger bigInteger = new BigInteger(dartDecimal.toPlainString(), 10);
                                String dartHex = bigInteger.toString(16);
                                Logger.e(TAG, "Dart = urn. Art*ilk.rate 16进制值:" + dartHex);

                                String temp = "";
                                if (vnsAddress.startsWith("0x")) {
                                    temp = vnsAddress.replace("0x", "");
                                }
                                // 获取vat.vusd
                                String vat_vusd_data = "0xbf95b4d7000000000000000000000000" + temp;
                                vusdAllowance(isReplase, "0xec0b8d49fa29f9e675823d0ee464df16bcf044d1", vat_vusd_data, new OnCompleteDataListener() {
                                    @Override
                                    public void onComplete(Object result) {
                                        BigDecimal vatVusdDecimal = (BigDecimal) result;
                                        Logger.e(TAG, "获取vat.vusd 10进制值为： " + vatVusdDecimal.toPlainString());
                                        // 如果是 urn.Art*ilk.rate > vat.vusd
                                        if (dartDecimal.compareTo(vatVusdDecimal) == 1) {
                                            Logger.e(TAG, "urn.Art*ilk.rate > vat.vusd , 看 vusd.allowance 是否要approve，再vusdJoin.join((urn.deb – vat.vusd)/10^27)，后frobt、vnsJoin.exit");
                                            String vusdAllowanceData = VdaiSignUtils.vusd_allowance(vnsAddress, "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68"); // vusd.allowance
                                            vusdAllowance(false, "0x4183bbd377fca70c5cfe8529ba3ddaf4ea1d009f", vusdAllowanceData, new OnCompleteDataListener() {
                                                @Override
                                                public void onComplete(Object result) {
                                                    BigDecimal vusdAllowceDecimal = (BigDecimal) result;
                                                    Logger.e(TAG, "获取Vusd.allowce 10进制值为： " + vusdAllowceDecimal.toPlainString());
                                                    BigDecimal subDecimal = dartDecimal.subtract(vatVusdDecimal);
                                                    subDecimal = subDecimal.divide(new BigDecimal(10).pow(27)).setScale(0, BigDecimal.ROUND_DOWN).add(new BigDecimal(1));// 去掉小数位+1
                                                    // join(urn. Art*ilk.rate – vat.vusd)/10^27)
                                                    String joinDecimalStr = subDecimal.toPlainString();
                                                    BigInteger joinHex = new BigInteger(joinDecimalStr, 10);
                                                    Logger.e(TAG, "join(urn. Art*ilk.rate – vat.vusd)/10^27) ，10进制结果为：" + joinDecimalStr);
                                                    if (vusdAllowceDecimal.compareTo(BigDecimal.ZERO) == 1 && vusdAllowceDecimal.compareTo(subDecimal) > -1) {
                                                        // 如果 Vusd.allowce > 0 && Vusd.allowce >= (urn. Art*ilk.rate – vat.vusd)/10^27)
                                                        Logger.e(TAG, "满足Vusd.allowce > 0 && Vusd.allowce >= (urn. Art*ilk.rate – vat.vusd)/10^27)条件。直接vusdJoin.join((urn. Art*ilk.rate – vat.vusd)/10^27),vat.frobt再vnsJoin.exit");
                                                        String vusdJoin_join = VdaiSignUtils.vusdJoin_join(bean, vnsAddress, "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68", joinHex.toString(16), signPrvKey);
                                                        transaction(vusdJoin_join, new OnCompleteDataListener() {
                                                            @Override
                                                            public void onComplete(Object result) {
                                                                bean.setNonce(bean.getNonce() + 1);
                                                                String vat_frobt = VdaiSignUtils.vat_frobt(vnsAddress, true, dinkHex, true, dartHex, bean, signPrvKey);
                                                                transaction(vat_frobt, new OnCompleteDataListener() {
                                                                    @Override
                                                                    public void onComplete(Object result) {
                                                                        bean.setNonce(bean.getNonce() + 1);
                                                                        String vnsJoin_exit = VdaiSignUtils.vnsJoin_exit(bean, vnsAddress, "0cb55fe67051eb5afe57fb3b670108074f85643e", dinkHex, signPrvKey);
                                                                        transaction(vnsJoin_exit, new OnCompleteDataListener() {
                                                                            @Override
                                                                            public void onComplete(Object result) {
                                                                                gem(bean, (String) result);
                                                                            }

                                                                            @Override
                                                                            public void onFailure(NetError error) {
                                                                                listener.onFailure(new NetError("交易失败", 404));
                                                                            }
                                                                        });
                                                                    }

                                                                    @Override
                                                                    public void onFailure(NetError error) {
                                                                        listener.onFailure(new NetError("交易失败", 404));
                                                                    }
                                                                });
                                                            }

                                                            @Override
                                                            public void onFailure(NetError error) {
                                                                listener.onFailure(new NetError("交易失败", 404));
                                                            }
                                                        });

                                                    } else {
                                                        Logger.e(TAG, "Vusd.allowce < (urn. Art*ilk.rate – vat.vusd)/10^27) ,要approve，再vnsJoin、frobt、vnsJoin.next");
                                                        String approve = VdaiSignUtils.approve(bean, "-1", "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68", "4183bbd377fca70c5cfe8529ba3ddaf4ea1d009f", signPrvKey);
                                                        transaction(approve, new OnCompleteDataListener() {
                                                            @Override
                                                            public void onComplete(Object result) {
                                                                bean.setNonce(bean.getNonce() + 1);
                                                                String vusdJoin = VdaiSignUtils.vnsJoin_exit(bean, vnsAddress, "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68", joinHex.toString(16), signPrvKey);
                                                                transaction(vusdJoin, new OnCompleteDataListener() {
                                                                    @Override
                                                                    public void onComplete(Object result) {
                                                                        bean.setNonce(bean.getNonce() + 1);
                                                                        String frobt = VdaiSignUtils.vat_frobt(vnsAddress, true, dinkHex, true, dartHex, bean, signPrvKey);
                                                                        transaction(frobt, new OnCompleteDataListener() {
                                                                            @Override
                                                                            public void onComplete(Object result) {
                                                                                bean.setNonce(bean.getNonce() + 1);
                                                                                String vnsJoin_exit = VdaiSignUtils.vnsJoin_exit(bean, vnsAddress, "0cb55fe67051eb5afe57fb3b670108074f85643e", dinkHex, signPrvKey);
                                                                                transaction(vnsJoin_exit, new OnCompleteDataListener() {
                                                                                    @Override
                                                                                    public void onComplete(Object result) {
                                                                                        gem(bean, (String) result);
                                                                                    }

                                                                                    @Override
                                                                                    public void onFailure(NetError error) {
                                                                                        listener.onFailure(new NetError("交易失败", 404));
                                                                                    }
                                                                                });
                                                                            }

                                                                            @Override
                                                                            public void onFailure(NetError error) {
                                                                                listener.onFailure(new NetError("交易失败", 404));
                                                                            }
                                                                        });
                                                                    }

                                                                    @Override
                                                                    public void onFailure(NetError error) {
                                                                        listener.onFailure(new NetError("交易失败", 404));
                                                                    }
                                                                });
                                                            }

                                                            @Override
                                                            public void onFailure(NetError error) {
                                                                listener.onFailure(new NetError("交易失败", 404));
                                                            }
                                                        });
                                                    }

                                                }

                                                @Override
                                                public void onFailure(NetError error) {
                                                    listener.onFailure(new NetError("交易失败", 404));
                                                }
                                            });

                                        } else {
                                            Logger.e(TAG, "urn.Art*ilk.rate <= vat.vusd ，vat.frobt(Dink) vnsJoin.exit");
                                            String vat_frobt = VdaiSignUtils.vat_frobt(vnsAddress, true, dinkHex, true, dartHex, bean, signPrvKey);
                                            transaction(vat_frobt, new OnCompleteDataListener() {
                                                @Override
                                                public void onComplete(Object result) {
                                                    bean.setNonce(bean.getNonce() + 1);
                                                    String vnsJoin_exit = VdaiSignUtils.vnsJoin_exit(bean, vnsAddress, "0cb55fe67051eb5afe57fb3b670108074f85643e", dinkHex, signPrvKey);
                                                    transaction(vnsJoin_exit, new OnCompleteDataListener() {
                                                        @Override
                                                        public void onComplete(Object result) {
                                                            gem(bean, (String) result);
                                                        }

                                                        @Override
                                                        public void onFailure(NetError error) {
                                                            listener.onFailure(new NetError("交易失败", 404));
                                                        }
                                                    });
                                                }

                                                @Override
                                                public void onFailure(NetError error) {
                                                    listener.onFailure(new NetError("交易失败", 404));
                                                }
                                            });
                                        }
                                    }

                                    @Override
                                    public void onFailure(NetError error) {
                                        listener.onFailure(new NetError("交易失败", 404));
                                    }
                                });

                            }

                            @Override
                            public void onFailure(NetError error) {
                                listener.onFailure(new NetError("交易失败", 404));
                            }
                        });
                    }

                    @Override
                    public void onFailure(NetError error) {
                        selectDebtRelationship(vnsAddress, true, listener);
                    }
                });

            }

            private void gem(MinerFeeBean bean, String trxid) {
                String gem = VdaiSignUtils.gem(vnsAddress);
                vnsCall(false, gem, new OnCompleteDataListener() {
                    @Override
                    public void onComplete(Object result) {
                        String gemHexString = (String) result;
                        if (TextUtils.isEmpty(gemHexString)) {
                            listener.onFailure(new NetError("data null", 400));
                            return;
                        }
                        if (gemHexString.startsWith("0x")) {
                            gemHexString = gemHexString.replace("0x", "");
                        }
                        BigInteger bigInteger = new BigInteger(gemHexString, 16);
                        Logger.e(TAG, "获取gem 16进制值：" + bigInteger.toString(16));
                        Logger.e(TAG, "获取gem 10进制值：" + bigInteger.toString(10));
                        BigDecimal bigDecimal = new BigDecimal(bigInteger.toString(10));
                        if (bigDecimal.compareTo(BigDecimal.ZERO) != 0) {
                            bean.setNonce(bean.getNonce() + 1);
                            String vnsJoin_exit = VdaiSignUtils.vnsJoin_exit(bean, vnsAddress, "0cb55fe67051eb5afe57fb3b670108074f85643e", gemHexString, signPrvKey);
                            transaction(vnsJoin_exit, listener);
                        }else {
                            listener.onComplete(trxid);
                        }
                    }

                    @Override
                    public void onFailure(NetError error) {
                        listener.onFailure(new NetError("gem 请求失败", 404));
                    }
                });
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(new NetError("获取交易信息失败 失败", 404));
            }
        });

    }

    /**
     * 偿还VUSD
     */
    public void payRepayVusd(boolean isReplase, String token, String vnsAddress, String vnsJoinContractAddress, String vnsNum, String vusdNum, byte[] signPrvKey, OnCompleteDataListener listener) {
        getVnsTransInfo(token, vnsAddress, vnsJoinContractAddress, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                try {
                    BigDecimal vusdBigDecimal = new BigDecimal(vusdNum);
                    MinerFeeBean bean = (MinerFeeBean) result;
                    String vusd_allowance = VdaiSignUtils.vusd_allowance(vnsAddress, "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68");
                    allowance(false, "0x4183bbd377fca70c5cfe8529ba3ddaf4ea1d009f", vusd_allowance, 18, new OnCompleteDataListener() {
                        @Override
                        public void onComplete(Object result) {
                            BigDecimal vusdAllowanceBigDecimal = (BigDecimal) result;
                            if (vusdAllowanceBigDecimal.compareTo(vusdBigDecimal) > -1) {
                                Logger.e(TAG, "Vusd.allowce >= vusd，则vusdJoin.join、vat.frobt");
                                repayJoinToFrobt(bean, vnsAddress, vusdBigDecimal, signPrvKey, listener);

                            } else {
                                Logger.e(TAG, "Vusd.allowce < vusd，则先approve、vusdJoin.join、vat.frobt");
                                String approve = VdaiSignUtils.approve(bean, "-1", "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68", "4183bbd377fca70c5cfe8529ba3ddaf4ea1d009f", signPrvKey);
                                transaction(approve, new OnCompleteDataListener() {
                                    @Override
                                    public void onComplete(Object result) {
                                        bean.setNonce(bean.getNonce() + 1);
                                        repayJoinToFrobt(bean, vnsAddress, vusdBigDecimal, signPrvKey, listener);
                                    }

                                    @Override
                                    public void onFailure(NetError error) {
                                        listener.onFailure(new NetError("交易失败", 404));
                                    }
                                });
                            }
                        }

                        private void repayJoinToFrobt(MinerFeeBean bean, String vnsAddress, BigDecimal vusdBigDecimal, byte[] signPrvKey, OnCompleteDataListener listener) {
                            selectVCDPGlobalQualityRatio(false, new OnCompleteDataListener() {
                                @Override
                                public void onComplete(Object result) {
                                    String rateHex = (String) result;
                                    BigInteger rateBigInteger = new BigInteger(rateHex, 16);
                                    BigDecimal rateBigDecimal = new BigDecimal(rateBigInteger.toString(10));
                                    // 输入的vusd * 10^18 * ilk.rate
                                    BigDecimal vusdBigDecimal = new BigDecimal(vusdNum);
                                    BigDecimal resultBigDecimal = vusdBigDecimal.multiply(new BigDecimal(10).pow(18)).multiply(rateBigDecimal);
                                    BigInteger resultBigInteger = new BigInteger(resultBigDecimal.setScale(0, BigDecimal.ROUND_DOWN).toPlainString(), 10);

                                    // 输入值的vusd*ilk.rate*10^18
                                    byte[] vusdBytes = new byte[32];
                                    String vusdDecimalism = vusdBigDecimal.multiply(new BigDecimal(10).pow(18)).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
                                    byte[] byteVusdMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(vusdDecimalism));
                                    // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
                                    System.arraycopy(byteVusdMoney, 0, vusdBytes, vusdBytes.length - byteVusdMoney.length, byteVusdMoney.length);
                                    Logger.e(TAG, "vusd数量转换为hex :" + HexUtil.encodeHexStr(vusdBytes));

                                    String vusdHex = HexUtil.encodeHexStr(vusdBytes);

                                    String vusdJoin_join = VdaiSignUtils.vusdJoin_join(bean, vnsAddress, "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68", vusdHex, signPrvKey);
                                    transaction(vusdJoin_join, new OnCompleteDataListener() {
                                        @Override
                                        public void onComplete(Object result) {
                                            bean.setNonce(bean.getNonce() + 1);
                                            String vat_frobt = VdaiSignUtils.vat_frobt(vnsAddress, false, "0", true, resultBigInteger.toString(16), bean, signPrvKey);
                                            transaction(vat_frobt, listener);
//                                            transaction(frobt, new OnCompleteDataListener() {
//                                                @Override
//                                                public void onComplete(Object result) {
//                                                    String trxid = (String) result;
//                                                    selectDebtRelationship(vnsAddress, false, new OnCompleteDataListener() {
//                                                        @Override
//                                                        public void onComplete(Object result) {
//                                                            HashMap<String, String> hashMap = (HashMap<String, String>) result;
//                                                            String ret = hashMap.get("ret");
//                                                            BigInteger retBigIntegerHex = new BigInteger(ret, 16);
//                                                            BigDecimal retDecimal = new BigDecimal(retBigIntegerHex.toString(10));
//                                                            Logger.e(TAG, "获取retBigDecimal值 10进制：" + retDecimal.toPlainString());
//                                                            if (retDecimal.compareTo(new BigDecimal(0)) != 0) {
//                                                                String jdAllowance = VdaiSignUtils.vusd_allowance(vnsAddress, "f98db8d89a9c947bcca54dedb7509d743868d743");
//                                                                vusdAllowance(false, "0xcdcad0eb1364ad13892996c899a6baa5179c4318", jdAllowance, new OnCompleteDataListener() {
//                                                                    @Override
//                                                                    public void onComplete(Object result) {
//                                                                        BigDecimal jdAllowanceBigDecimal = (BigDecimal) result;
//                                                                        if (retDecimal.compareTo(jdAllowanceBigDecimal) > -1) {
//                                                                            Logger.e(TAG, "urns.ret不为0 且 urns.ret >= jd.allowance");
//                                                                            if (jdAllowanceBigDecimal.compareTo(new BigDecimal(0)) != 0) {
//                                                                                Logger.e(TAG, "jd.allowance != 0,则 arrpove 0");
//                                                                                bean.setNonce(bean.getNonce() + 1);
//                                                                                String jdApprove = VdaiSignUtils.approve(bean, "0", "f98db8d89a9c947bcca54dedb7509d743868d743", "cdcad0eb1364ad13892996c899a6baa5179c4318", signPrvKey);
//                                                                                transaction(jdApprove, new OnCompleteDataListener() {
//                                                                                    @Override
//                                                                                    public void onComplete(Object result) {
//                                                                                        bean.setNonce(bean.getNonce() + 1);
//                                                                                        String grep = VdaiSignUtils.grep(bean, vnsAddress, ret, signPrvKey);
//                                                                                        transaction(grep, listener);
//                                                                                    }
//
//                                                                                    @Override
//                                                                                    public void onFailure(NetError error) {
//                                                                                        listener.onFailure(new NetError("交易失败", 404));
//                                                                                    }
//                                                                                });
//                                                                            } else {
//                                                                                Logger.e(TAG, "非jd.allowance != 0,则 arrpove -1");
//                                                                                bean.setNonce(bean.getNonce() + 1);
//                                                                                String jdApprove = VdaiSignUtils.approve(bean, "-1", "f98db8d89a9c947bcca54dedb7509d743868d743", "cdcad0eb1364ad13892996c899a6baa5179c4318", signPrvKey);
//                                                                                transaction(jdApprove, new OnCompleteDataListener() {
//                                                                                    @Override
//                                                                                    public void onComplete(Object result) {
//                                                                                        bean.setNonce(bean.getNonce() + 1);
//                                                                                        String grep = VdaiSignUtils.grep(bean, vnsAddress, ret, signPrvKey);
//                                                                                        transaction(grep, listener);
//                                                                                    }
//
//                                                                                    @Override
//                                                                                    public void onFailure(NetError error) {
//                                                                                        listener.onFailure(new NetError("交易失败", 404));
//                                                                                    }
//                                                                                });
//                                                                            }
//                                                                        } else {
//                                                                            Logger.e(TAG, "urns.ret不为0 且 urns.ret < jd.allowance ，直接grep");
//                                                                            bean.setNonce(bean.getNonce() + 1);
//                                                                            String grep = VdaiSignUtils.grep(bean, vnsAddress, ret, signPrvKey);
//                                                                            transaction(grep, listener);
//                                                                        }
//                                                                    }
//
//                                                                    @Override
//                                                                    public void onFailure(NetError error) {
//                                                                        listener.onFailure(new NetError("交易失败", 404));
//                                                                    }
//                                                                });
//                                                            } else {
//                                                                listener.onComplete(trxid);
//                                                            }
//
//                                                        }
//
//                                                        @Override
//                                                        public void onFailure(NetError error) {
//                                                            listener.onFailure(new NetError("交易失败", 404));
//                                                        }
//                                                    });
//                                                }
//
//                                                @Override
//                                                public void onFailure(NetError error) {
//                                                    listener.onFailure(new NetError("交易失败", 404));
//                                                }
//                                            });
                                        }

                                        @Override
                                        public void onFailure(NetError error) {
                                            listener.onFailure(new NetError("交易失败", 404));
                                        }
                                    });
                                }

                                @Override
                                public void onFailure(NetError error) {
                                    listener.onFailure(new NetError("交易失败", 404));
                                }
                            });
                        }

                        @Override
                        public void onFailure(NetError error) {
                            listener.onFailure(new NetError("交易失败", 404));
                        }
                    });

                } catch (Exception e) {
                    listener.onFailure(new NetError(e.getMessage(), 400));
                }
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(new NetError("交易失败", 404));
            }
        });

    }

    /**
     * 存入vns
     */
    public void paySaveVns(String token, String vnsAddress, String
            vnsJoinContractAddress, String vnsNum, String vusdNum,
                           byte[] signPrvKey, OnCompleteDataListener listener) {
        getVnsTransInfo(token, vnsAddress, vnsJoinContractAddress, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                try {
                    MinerFeeBean bean = (MinerFeeBean) result;
                    String vnsJoin_join = VdaiSignUtils.vnsJoin_join(bean, vnsAddress, "0cb55fe67051eb5afe57fb3b670108074f85643e", vnsNum, 18, signPrvKey);
                    transaction(vnsJoin_join, new OnCompleteDataListener() {
                        @Override
                        public void onComplete(Object result) {
                            bean.setNonce(bean.getNonce() + 1);
                            String vat_frobt = VdaiSignUtils.frobt(vnsAddress, false, vnsNum, false, vusdNum, bean, signPrvKey);
                            transaction(vat_frobt, listener);
                        }

                        @Override
                        public void onFailure(NetError error) {
                            listener.onFailure(new NetError("交易失败", 404));
                        }
                    });

                } catch (Exception e) {
                    listener.onFailure(new NetError(e.getMessage(), 400));
                }
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(new NetError("交易失败", 404));
            }
        });
    }

    /**
     * 创建CDP
     */
    public void payCreateCDP(boolean isReplase, String token, String vnsAddress, String
            vnsJoinContractAddress, String vnsNum, String vusdNum,
                             byte[] signPrvKey, OnCompleteDataListener listener) {
        getVnsTransInfo(token, vnsAddress, vnsJoinContractAddress, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                try {
                    MinerFeeBean bean = (MinerFeeBean) result;
                    String vnsJoin_join = VdaiSignUtils.vnsJoin_join(bean, vnsAddress, "0cb55fe67051eb5afe57fb3b670108074f85643e", vnsNum, 18, signPrvKey);
                    transaction(vnsJoin_join, new OnCompleteDataListener() {
                        @Override
                        public void onComplete(Object result) {
                            bean.setNonce(bean.getNonce() + 1);
                            selectVCDPGlobalQualityRatio(false, new OnCompleteDataListener() {
                                @Override
                                public void onComplete(Object result) {
                                    String rateHex = (String) result;
                                    BigInteger rateBigIntegerHex = new BigInteger(rateHex, 16);
                                    BigDecimal rateDecimal = new BigDecimal(rateBigIntegerHex.toString(10));
                                    BigDecimal ratePow = new BigDecimal(10).pow(18);
                                    BigDecimal rateBD = rateDecimal.multiply(ratePow);
                                    Logger.e(TAG, "获取rateBigDecimal值：" + rateBD.toPlainString());

                                    // 输入值的vusd*ilk.rate*10^18
                                    String tempVusd = new BigDecimal(vusdNum).multiply(rateBD).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
                                    Logger.e(TAG, "输入值的vusd*ilk.rate*10^18 结果：" + tempVusd);
                                    BigInteger bigInteger = new BigInteger(tempVusd, 10);

                                    byte[] vnsBytes = new byte[32];
                                    String vnsDecimalism = new BigDecimal(vnsNum).multiply(new BigDecimal(10).pow(18)).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
                                    byte[] byteVnsMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(vnsDecimalism));
                                    // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
                                    System.arraycopy(byteVnsMoney, 0, vnsBytes, vnsBytes.length - byteVnsMoney.length, byteVnsMoney.length);
                                    Logger.e(TAG, "vns数量转换为hex :" + HexUtil.encodeHexStr(vnsBytes));

                                    String dinkHex = HexUtil.encodeHexStr(vnsBytes);
                                    String dartHex = bigInteger.toString(16);

                                    String frobt = VdaiSignUtils.vat_frobt(vnsAddress, false, dinkHex, false, dartHex, bean, signPrvKey);
                                    transaction(frobt, new OnCompleteDataListener() {
                                        @Override
                                        public void onComplete(Object result) {
                                            createVatCan(vnsAddress, isReplase, new OnCompleteDataListener() {
                                                @Override
                                                public void onComplete(Object result) {
                                                    BigDecimal bigDecimal = (BigDecimal) result;
                                                    if (bigDecimal.compareTo(new BigDecimal(0)) == 0) {
                                                        Logger.e(TAG, "等于0");
                                                        // 如果vat.can ==0 则 hope，再exit，
                                                        bean.setNonce(bean.getNonce() + 1);
                                                        String hopeData = "a3b22fc4000000000000000000000000cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68";
                                                        String hope = VdaiSignUtils.hope(bean, hopeData, signPrvKey);
                                                        transaction(hope, new OnCompleteDataListener() {
                                                            @Override
                                                            public void onComplete(Object result) {
                                                                bean.setNonce(bean.getNonce() + 1);
                                                                String exit = VdaiSignUtils.exit(bean, vnsAddress, "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68", vusdNum, signPrvKey);
                                                                transaction(exit, listener);
                                                            }

                                                            @Override
                                                            public void onFailure(NetError error) {
                                                                listener.onFailure(new NetError("交易失败", 404));
                                                            }
                                                        });

                                                    } else {
                                                        Logger.e(TAG, "不等于0");
                                                        // 如果vat.can !=0 则 exit
                                                        bean.setNonce(bean.getNonce() + 1);
                                                        String exit = VdaiSignUtils.exit(bean, vnsAddress, "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68", vusdNum, signPrvKey);
                                                        transaction(exit, listener);
                                                    }
                                                }

                                                @Override
                                                public void onFailure(NetError error) {
                                                    listener.onFailure(new NetError("交易失败", 404));
                                                }
                                            });
                                        }

                                        @Override
                                        public void onFailure(NetError error) {
                                            listener.onFailure(new NetError("交易失败", 404));
                                        }
                                    });
                                }

                                @Override
                                public void onFailure(NetError error) {

                                }
                            });
                        }

                        @Override
                        public void onFailure(NetError error) {
                            listener.onFailure(new NetError("交易失败", 404));
                        }
                    });

                } catch (Exception e) {
                    listener.onFailure(new NetError(e.getMessage(), 400));
                }
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(new NetError("交易失败", 404));
            }
        });
    }

    /**
     * 取回质押品 即 取回vns
     *
     * @param token
     * @param vnsAddress
     * @param vnsJoinContractAddress
     * @param vnsNum
     * @param vusdNum
     * @param signPrvKey
     * @param listener
     */
    public void payGetVns(String token, String vnsAddress, String
            vnsJoinContractAddress, String vnsNum, String vusdNum,
                          byte[] signPrvKey, OnCompleteDataListener listener) {
        getVnsTransInfo(token, vnsAddress, vnsJoinContractAddress, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                try {
                    MinerFeeBean bean = (MinerFeeBean) result;
                    String vat_frobt = VdaiSignUtils.frobt(vnsAddress, true, vnsNum, false, vusdNum, bean, signPrvKey);
                    transaction(vat_frobt, new OnCompleteDataListener() {
                        @Override
                        public void onComplete(Object result) {
                            bean.setNonce(bean.getNonce() + 1);
                            String exit = VdaiSignUtils.exit(bean, vnsAddress, "0cb55fe67051eb5afe57fb3b670108074f85643e", vnsNum, signPrvKey);
                            transaction(exit, listener);
                        }

                        @Override
                        public void onFailure(NetError error) {
                            listener.onFailure(new NetError("交易失败", 404));
                        }
                    });

                } catch (Exception e) {
                    listener.onFailure(new NetError(e.getMessage(), 400));
                }
            }

            @Override
            public void onFailure(NetError error) {
                listener.onFailure(new NetError("交易失败", 404));
            }
        });
    }

    /**
     * 获取vns矿工费和交易信息
     */
    public void getVnsTransInfo(String token, String from, String
            contract, OnCompleteDataListener listener) {
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

    void showEthTransInfo(EthTranInfoResult ethTranInfoResult, String
            from, OnCompleteDataListener listener) {
        MinerFeeBean bean = new MinerFeeBean();
        bean.setFrom(from);
        int nonce;
        String version = "";
        BigDecimal gasPrice = null, estimateGas = null;
        Logger.e(TAG, "获取eth的交易信息成功！" + ethTranInfoResult.toString());
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
//                        gasPrice = new BigDecimal(50);
                        bean.setGasPrice(gasPrice);
                        Logger.e(TAG, "获取 gasPrice：" + gasPrice.toString());
                    } else if ("estimateGas".equals(dataBeanX.getName()) || "tokenEstimateGas".equals(dataBeanX.getName())) {
//                        estimateGas = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16));
                        estimateGas = new BigDecimal(8000000);
                        bean.setEstimateGas(estimateGas);
                        Logger.e(TAG, "获取 estimateGas：" + estimateGas.toString());
                    } else if ("balance".equals(dataBeanX.getName())) {
                        BigDecimal balance = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16)).divide(new BigDecimal("1000000000000000000"), 10, ROUND_HALF_UP);
                        double amount = balance.doubleValue();
                        bean.setBalance(balance);
                        Logger.e(TAG, "获取 主币的余额：" + amount);
                    } else if ("tokenBalance".equals(dataBeanX.getName())) {
                        BigDecimal balance = new BigDecimal(new BigInteger(CommonUtil.subStrEthBalance(dataBeanX.getData().getResult()), 16)).divide(new BigDecimal(10).pow(18), 10, ROUND_HALF_UP);
                        bean.setBalance(balance);
                        Logger.e(TAG, "获取 代币的余额：" + balance.toPlainString());
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

    void getVnsCurrencyPrice(MinerFeeBean bean, OnCompleteDataListener listener) {
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

    private void transaction(String param, OnCompleteDataListener listener) {
        if (TextUtils.isEmpty(param)) {
            Logger.e(TAG, "签名失败");
            listener.onFailure(new NetError(App.getContext().getString(R.string.tv_error_deal_sign), 404));
            return;
        }
        TransactionEthParam transactionBtcParam = new TransactionEthParam();
        transactionBtcParam.setId(1);
        transactionBtcParam.setJsonrpc("2.0");
        transactionBtcParam.setMethod("vns_sendRawTransaction");
        List<String> list = new ArrayList<>();
        list.add("0x" + param);
        transactionBtcParam.setParams(list);

        Api.getServiceVns().transactionEth(transactionBtcParam)
                .compose(XApi.<EthTransReult>getApiTransformer())
                .compose(XApi.<EthTransReult>getScheduler())
                .subscribe(new ApiSubscriber<EthTransReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        try {
                            listener.onFailure(new NetError("交易失败", 404));
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
                            if (!TextUtils.isEmpty(trxid)) {
                                listener.onComplete(trxid);
                            } else {
                                listener.onFailure(new NetError(ethTransReult.getError().getMessage(), 0));
                            }
                            if (ethTransReult.getError() != null && !TextUtils.isEmpty(ethTransReult.getError().getMessage())) {
                                listener.onFailure(new NetError(ethTransReult.getError().getMessage(), 0));
                            }
                        } catch (Exception e) {
                            Logger.e(TAG, "异常了：" + e.getMessage());
                            listener.onFailure(new NetError(e, 0));
                        }

                    }
                });

    }

    public void getNoce(String vnsAddress) {
        List<Object> lists = new ArrayList<>();
        lists.add(vnsAddress);
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
                    }

                    @Override
                    public void onNext(GetEthSeriesParamReult getEthSeriesParamReult) {
                        Logger.e(TAG, "nonce请求：" + getEthSeriesParamReult.toString());

                        int nonce = DigitalTrans.hexStringToAlgorism(getEthSeriesParamReult.getResult());

                        Logger.e(TAG, "获取交易序号nonce：" + nonce);
                    }
                });
    }

    public void getBalance(String token, String vnsAddress, String contract, boolean isReplase, OnCompleteDataListener listener) {
            EthTokenSeriesParam ethSeriesBalanceParam = null;
            if ("VNS".equals(token)) {
                List<Object> lists = new ArrayList<>();
                lists.add(vnsAddress);
                lists.add("latest");

                ethSeriesBalanceParam = new EthTokenSeriesParam();
                ethSeriesBalanceParam.setId(1);
                ethSeriesBalanceParam.setJsonrpc("2.0");
                ethSeriesBalanceParam.setMethod("vns_getBalance");
                ethSeriesBalanceParam.setParams(lists);
            } else {
                String data = "0x70a08231000000000000000000000000" + vnsAddress.replace("0x", "");
                List<Object> lists = new ArrayList<>();
                AllowanceParams allowanceParams = new AllowanceParams();
                allowanceParams.setTo(contract);
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
                            getBalance(token, vnsAddress, contract, true, listener);
                        }

                        @Override
                        public void onNext(GetEthSeriesParamReult getEthSeriesParamReult) {
                            int decimals;
                            if (token.equals("VNS")) {
                                decimals = 18;
                            } else {
                                decimals = 45;
                            }
                            BigDecimal balance = new BigDecimal(new BigInteger(CommonUtil.subStrEthBalance(getEthSeriesParamReult.getResult()), 16)).divide(new BigDecimal(10).pow(decimals), 10, ROUND_HALF_UP);
                            Logger.e(TAG, token + "余额：" + balance.toPlainString());
                            listener.onComplete(balance);
                        }
                    });
    }

    public void allowance(boolean isReplase, String toAddress, String data, int decimals, OnCompleteDataListener listener) {
            GetAllowanceParam params = new GetAllowanceParam();
            params.setId(1);
            params.setJsonrpc("2.0");
            params.setMethod("vns_call");
            List<Object> lists = new ArrayList<>();

            AllowanceParams allowanceParams = new AllowanceParams();
            allowanceParams.setTo(toAddress);
            allowanceParams.setData(data);
            lists.add(allowanceParams);
            lists.add("latest");

            params.setParams(lists);

            Api.getServiceVns().GetAllowance(params)
                    .compose(XApi.<AllowanceResult>getApiTransformer())
                    .compose(XApi.<AllowanceResult>getScheduler())
                    .subscribe(new ApiSubscriber<AllowanceResult>() {
                        @Override
                        protected void onFail(NetError error) {
                            allowance(true, toAddress, data, decimals, listener);
                        }

                        @Override
                        public void onNext(AllowanceResult result) {
                            try {
                                if (result == null) {
                                    listener.onFailure(new NetError("获取Allowance失败", 400));
                                    Logger.e(TAG, "获取Allowance失败");
                                    return;
                                }
                                String hexString = result.getResult();
//                                String hexString = "000000000000000000000000000044e06a4ea1e122213a7bd71b580000000000";
                                Logger.e(TAG, "得到result：" + result.toString());
                                if (TextUtils.isEmpty(hexString)) {
                                    hexString = "0";
                                }
                                if (hexString.startsWith("0x")) {
                                    hexString = hexString.replace("0x", "");
                                    if (TextUtils.isEmpty(hexString)) {
                                        hexString = "0";
                                    }
                                }

                                BigInteger bigInteger = new BigInteger(hexString, 16);
                                Logger.e(TAG, "获取allowance 16进制值：" + bigInteger.toString(16));
                                BigDecimal bigDecimal = new BigDecimal(bigInteger.toString(10));
                                Logger.e(TAG, "获取allowance 10进制值：" + bigInteger.toString(10));
                                BigDecimal pow = new BigDecimal(10).pow(decimals);
                                BigDecimal allowanceBigDecimal = bigDecimal.divide(pow);
                                Logger.e(TAG, "获取allowance值：" + allowanceBigDecimal.toPlainString());

                                listener.onComplete(allowanceBigDecimal);


                            } catch (Exception e) {
                                e.printStackTrace();
                                listener.onFailure(new NetError(e, 0));
                            }

                        }
                    });

    }

    public void vusdAllowance(boolean isReplase, String toAddress, String data, OnCompleteDataListener listener) {

            GetAllowanceParam params = new GetAllowanceParam();
            params.setId(1);
            params.setJsonrpc("2.0");
            params.setMethod("vns_call");
            List<Object> lists = new ArrayList<>();

            AllowanceParams allowanceParams = new AllowanceParams();
            allowanceParams.setTo(toAddress);
            allowanceParams.setData(data);
            lists.add(allowanceParams);
            lists.add("latest");

            params.setParams(lists);

            Api.getServiceVns().GetAllowance(params)
                    .compose(XApi.<AllowanceResult>getApiTransformer())
                    .compose(XApi.<AllowanceResult>getScheduler())
                    .subscribe(new ApiSubscriber<AllowanceResult>() {
                        @Override
                        protected void onFail(NetError error) {
                            vusdAllowance(true, toAddress, data, listener);
                        }

                        @Override
                        public void onNext(AllowanceResult result) {
                            try {
                                if (result == null) {
                                    listener.onFailure(new NetError("获取Allowance失败", 400));
                                    Logger.e(TAG, "获取Allowance失败");
                                    return;
                                }
                                String hexString = result.getResult();
//                                String hexString = "000000000000000000000000000044e06a4ea1e122213a7bd71b580000000000";
                                Logger.e(TAG, "得到result：" + result.toString());
                                if (TextUtils.isEmpty(hexString)) {
                                    hexString = "0";
                                }
                                if (hexString.startsWith("0x")) {
                                    hexString = hexString.replace("0x", "");
                                    if (TextUtils.isEmpty(hexString)) {
                                        hexString = "0";
                                    }
                                }

                                BigInteger bigInteger = new BigInteger(hexString, 16);
                                Logger.e(TAG, "获取allowance 16进制值：" + bigInteger.toString(16));
                                BigDecimal bigDecimal = new BigDecimal(bigInteger.toString(10));
                                Logger.e(TAG, "获取allowance 10进制值：" + bigDecimal.toPlainString());
                                listener.onComplete(bigDecimal);
                            } catch (Exception e) {
                                e.printStackTrace();
                                listener.onFailure(new NetError(e, 0));
                            }

                        }
                    });

    }

    // 查询债务
    public void selectDebtRelationship(String vnsAddress, boolean isReplase, OnCompleteDataListener listener) {
        String data = "0x2424be5c564E530000000000000000000000000000000000000000000000000000000000000000000000000000000000" + vnsAddress.replace("0x", "");
        GetAllowanceParam params = new GetAllowanceParam();
        params.setId(1);
        params.setJsonrpc("2.0");
        params.setMethod("vns_call");
        List<Object> lists = new ArrayList<>();

        AllowanceParams allowanceParams = new AllowanceParams();
        allowanceParams.setTo("0xec0b8d49fa29f9e675823d0ee464df16bcf044d1");
        allowanceParams.setData(data);
        lists.add(allowanceParams);
        lists.add("latest");

        params.setParams(lists);
        Api.getServiceVns().GetAllowance(params)
                .compose(XApi.<AllowanceResult>getApiTransformer())
                .compose(XApi.<AllowanceResult>getScheduler())
                .subscribe(new ApiSubscriber<AllowanceResult>() {
                    @Override
                    protected void onFail(NetError error) {
                        Logger.e(TAG, "查询债务失败");
                        selectDebtRelationship(vnsAddress, true, listener);
                    }

                    @Override
                    public void onNext(AllowanceResult result) {
                        try {
                            if (result == null) {
                                listener.onFailure(new NetError("查询债务失败", 400));
                                Logger.e(TAG, "查询债务失败");
                                return;
                            }
                            String hexString = result.getResult();
                            Logger.e(TAG, "得到result：" + result.toString());
                            if (TextUtils.isEmpty(hexString)) {
                                hexString = "0";
                            }
                            if (hexString.startsWith("0x")) {
                                hexString = hexString.replace("0x", "");
                            }
                            Logger.e(TAG, "得到hex：" + hexString.toString());
                            Logger.e(TAG, "长度：" + hexString.length());

                            String ink = hexString.substring(0, 64);// ink ^18
                            Logger.e(TAG, "ink：" + ink);
                            String art = hexString.substring(64, 128);// art ^18
                            Logger.e(TAG, "art：" + art);
                            String deb = hexString.substring(128, 192);// deb ^45
                            Logger.e(TAG, "deb：" + deb);
                            String ret = hexString.substring(192, 256);// ret
                            Logger.e(TAG, "ret：" + ret);

                            HashMap<String, String> hashMap = new HashMap<>();
                            hashMap.put("ink", ink);
                            hashMap.put("art", art);
                            hashMap.put("deb", deb);
                            hashMap.put("ret", ret);
                            listener.onComplete(hashMap);

                        } catch (Exception e) {
                            Logger.e(TAG, "selectDebtRelationship异常了：" + e.getMessage());
                            listener.onFailure(new NetError(e, 0));
                        }

                    }
                });
    }

    // 创建CDP查看是否同意分割
    public void createVatCan(String vnsAddress, boolean isReplase, OnCompleteDataListener listener) {
        String data = "0x4538c4eb000000000000000000000000" + vnsAddress.replace("0x", "") + "000000000000000000000000cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68";
        GetAllowanceParam params = new GetAllowanceParam();
        params.setId(1);
        params.setJsonrpc("2.0");
        params.setMethod("vns_call");
        List<Object> lists = new ArrayList<>();

        AllowanceParams allowanceParams = new AllowanceParams();
        allowanceParams.setTo("0xec0b8d49fa29f9e675823d0ee464df16bcf044d1");
        allowanceParams.setData(data);
        lists.add(allowanceParams);
        lists.add("latest");

        params.setParams(lists);
        Api.getServiceVns().GetAllowance(params)
                .compose(XApi.<AllowanceResult>getApiTransformer())
                .compose(XApi.<AllowanceResult>getScheduler())
                .subscribe(new ApiSubscriber<AllowanceResult>() {
                    @Override
                    protected void onFail(NetError error) {
                        Logger.e(TAG, "查询债务失败");
                        selectDebtRelationship(vnsAddress, true, listener);
                    }

                    @Override
                    public void onNext(AllowanceResult result) {
                        try {
                            if (result == null) {
                                listener.onFailure(new NetError("查询债务失败", 400));
                                Logger.e(TAG, "查询债务失败");
                                return;
                            }
                            String hexString = result.getResult();
                            Logger.e(TAG, "得到result：" + result.toString());
                            if (TextUtils.isEmpty(hexString)) {
                                hexString = "0";
                            }
                            if (hexString.startsWith("0x")) {
                                hexString = hexString.replace("0x", "");
                            }

                            BigInteger bigInteger = new BigInteger(hexString, 16);
                            Logger.e(TAG, "16进制：" + bigInteger.toString(16));
                            String decimal = bigInteger.toString(10);
                            Logger.e(TAG, "10进制：" + decimal);
                            BigDecimal bigDecimal = new BigDecimal(decimal);

                            listener.onComplete(bigDecimal);

                        } catch (Exception e) {
                            Logger.e(TAG, "selectDebtRelationship异常了：" + e.getMessage());
                            listener.onFailure(new NetError(e, 0));
                        }

                    }
                });
    }

    // VCDP全局质押率
    public void selectVCDPGlobalQualityRatio(boolean isReplase, OnCompleteDataListener listener) {
        String data = "0xd9638d36564E530000000000000000000000000000000000000000000000000000000000";
        GetAllowanceParam params = new GetAllowanceParam();
        params.setId(1);
        params.setJsonrpc("2.0");
        params.setMethod("vns_call");
        List<Object> lists = new ArrayList<>();

        AllowanceParams allowanceParams = new AllowanceParams();
        allowanceParams.setTo("0xec0b8d49fa29f9e675823d0ee464df16bcf044d1");
        allowanceParams.setData(data);
        lists.add(allowanceParams);
        lists.add("latest");

        params.setParams(lists);
        Api.getServiceVns().GetAllowance(params)
                .compose(XApi.<AllowanceResult>getApiTransformer())
                .compose(XApi.<AllowanceResult>getScheduler())
                .subscribe(new ApiSubscriber<AllowanceResult>() {
                    @Override
                    protected void onFail(NetError error) {
                        Logger.e(TAG, "查询 VCDP全局质押率失败");
                        selectVCDPGlobalQualityRatio(true, listener);
                    }

                    @Override
                    public void onNext(AllowanceResult result) {
                        try {
                            if (result == null) {
                                listener.onFailure(new NetError("查询 VCDP全局质押率失败", 400));
                                Logger.e(TAG, "查询 VCDP全局质押率失败");
                                return;
                            }
                            String hexString = result.getResult();
                            Logger.e(TAG, "得到result：" + result.toString());
                            if (TextUtils.isEmpty(hexString)) {
                                hexString = "0";
                            }
                            if (hexString.startsWith("0x")) {
                                hexString = hexString.replace("0x", "");
                            }
                            Logger.e(TAG, "得到hex：" + hexString.toString());
                            Logger.e(TAG, "长度：" + hexString.length());

                            String rate = hexString.substring(128, 192);// 27次方
                            Logger.e(TAG, "rate：" + rate);
                            listener.onComplete(rate);

                        } catch (Exception e) {
                            Logger.e(TAG, "VCDP全局质押率异常了：" + e.getMessage());
                            listener.onFailure(new NetError(e, 0));
                        }

                    }
                });
    }


    private void vnsCall(boolean isReplase, String data, OnCompleteDataListener listener) {
        GetAllowanceParam params = new GetAllowanceParam();
        params.setId(1);
        params.setJsonrpc("2.0");
        params.setMethod("vns_call");
        List<Object> lists = new ArrayList<>();

        AllowanceParams allowanceParams = new AllowanceParams();
        allowanceParams.setTo("0xec0b8d49fa29f9e675823d0ee464df16bcf044d1");
        allowanceParams.setData("0x" + data);
        lists.add(allowanceParams);
        lists.add("latest");

        params.setParams(lists);
        Api.getServiceVns().GetAllowance(params)
                .compose(XApi.<AllowanceResult>getApiTransformer())
                .compose(XApi.<AllowanceResult>getScheduler())
                .subscribe(new ApiSubscriber<AllowanceResult>() {
                    @Override
                    protected void onFail(NetError error) {
                        Logger.e(TAG, "查询 VCDP全局质押率失败");
                        vnsCall(isReplase, data, listener);
                    }

                    @Override
                    public void onNext(AllowanceResult result) {
                        try {
                            if (result == null) {
                                listener.onFailure(new NetError("data null", 400));
                                return;
                            }
                            String hexString = result.getResult();
                            listener.onComplete(hexString);

                        } catch (Exception e) {
                            Logger.e(TAG, "vnsCall 异常了：" + e.getMessage());
                            listener.onFailure(new NetError(e, 0));
                        }

                    }
                });
    }
}
