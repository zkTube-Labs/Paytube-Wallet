package com.fictitious.money.purse.utils;

import android.text.TextUtils;

import com.fictitious.money.purse.model.CurrencyPriceResult;
import com.fictitious.money.purse.model.GetVnsSeriesCurrencies;
import com.fictitious.money.purse.net.Api;

import java.math.BigDecimal;

import cn.droidlover.xdroidmvp.net.ApiSubscriber;
import cn.droidlover.xdroidmvp.net.NetError;
import cn.droidlover.xdroidmvp.net.XApi;

public class VnsPriceUtil {

    public static void getVnsPrice(String currency, String convert, IVnsPriceListen vnsPriceListen){
        //获取一个VNS能兑换N个USDT
        Api.getServiceVnsPrice().getVnsSeriesCurrencies(currency + "_USDT")
                .compose(XApi.<GetVnsSeriesCurrencies>getApiTransformer())
                .compose(XApi.<GetVnsSeriesCurrencies>getScheduler())
                .subscribe(new ApiSubscriber<GetVnsSeriesCurrencies>() {
                    @Override
                    protected void onFail(NetError error) {
                        vnsPriceListen.getVnsPriceCallBack(null);
                    }

                    @Override
                    public void onNext(GetVnsSeriesCurrencies getVnsSeriesCurrencies) {
                        if(getVnsSeriesCurrencies != null && getVnsSeriesCurrencies.getTicker() != null && getVnsSeriesCurrencies.getTicker().getLast() != null){
                            //获取USDT的单价
                            Api.getServiceOwnerApi().getCurrencyPrice("USDT", convert)
                                    .compose(XApi.<CurrencyPriceResult>getApiTransformer())
                                    .compose(XApi.<CurrencyPriceResult>getScheduler())
                                    .subscribe(new ApiSubscriber<CurrencyPriceResult>() {
                                        @Override
                                        protected void onFail(NetError error) {
                                            vnsPriceListen.getVnsPriceCallBack(null);
                                        }

                                        @Override
                                        public void onNext(CurrencyPriceResult currencyPriceResult) {
                                            try {
                                                if(currencyPriceResult != null && currencyPriceResult.getData() != null) {
                                                    String price = currencyPriceResult.getData();
                                                    if (!TextUtils.isEmpty(price)){
                                                        BigDecimal price_decimal = new BigDecimal(price);
                                                        //vns的单价用usdt对应的数量换算得来的
                                                        BigDecimal vnsPrice = price_decimal.multiply(getVnsSeriesCurrencies.getTicker().getLast()).setScale(12,BigDecimal.ROUND_HALF_UP); // 两数相乘,保留两位小数,且四舍五入
//                                                        System.out.println("==主币==price====" + price);
//                                                        System.out.println("==主币==Ticker====" + getVnsSeriesCurrencies.getTicker().getLast().stripTrailingZeros().toPlainString());
                                                        vnsPriceListen.getVnsPriceCallBack(vnsPrice);
                                                    }
                                                }
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
                                        }
                                    });
                        } else {
                            vnsPriceListen.getVnsPriceCallBack(null);
                        }
                    }
                });
    }

    public interface IVnsPriceListen{
        public void getVnsPriceCallBack(BigDecimal bigDecimal);
    }
}
