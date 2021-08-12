package com.fictitious.money.purse.net;

import com.fictitious.money.purse.App;
import com.fictitious.money.purse.Constants;

import java.io.IOException;
import java.io.InputStream;

import cn.droidlover.xdroidmvp.language.LanguageLocalManageUtil;
import cn.droidlover.xdroidmvp.net.XApi;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

/**
 * Created by wanglei on 2016/12/31.
 */

public class Api {
    public static final String API_BASE_URL = "https://api.coinid.pro";
    public static final String API_LOAD_BALANCING = "/coinidplus";
    public static final String API_VERSION = "/v1";

    //链地址
//    public static final String API_TRAN_EOS_URL = "https://mainnet-eos.coinid.pro";
//    public static final String API_TRAN_BTC_URL = "https://mainnet-btc.coinid.pro";
//    public static final String API_TRAN_ETH_URL = "https://mainnet-eth.coinid.pro";
//    public static final String API_TRAN_VNS_URL = "https://mainnet-gvns.coinid.pro";
//    public static final String API_TRAN_BTM_URL = "https://mainnet-bytom.coinid.pro";
//    public static final String API_TRAN_LTC_URL = "https://api.blockchair.com";
//    public static final String API_TRAN_GPS_URL = "http://47.244.46.65:8888"; // gps生产链
//    public static final String API_TRAN_GPS_URL = "http://203.86.25.125:8444"; // gps测试链
//    public static final String API_TRAN_GPS_URL = "http://47.75.195.8:8088"; // gps生产链备用节点

    public static final String API_VDNS_URL = "http://oss.coinid.pro/allVdns/load.html";
    public static final String API_BANCOR_CN_URL = "http://oss.coinid.pro/CoinidPro/newBancor/load.html";
    public static final String API_BANCOR_EN_URL = "http://oss.coinid.pro/CoinidPro/enNewBancors/load.html";
    public static final String API_TRAN_VNS_URL = "https://mainnet-gvns.coinid.pro/";
    public static final String API_TRAN_LTC_URL = "https://ltc.ihashrate.com";
    public static final String API_TRAN_BTM_URL = "https://blockmeta.com";
    public static final String API_TRAN_CURRENCIES_URL = "http://api.cex.plus";
    public static final String API_TRAN_BTC_SAT_URL = "https://bitcoinfees.earn.com";
    public static final String API_TRAN_LTC_SAT_URL = "https://api.blockcypher.com";
    public static final String API_TRAN_ETH_GAS_URL = "https://ethgasstation.info";
    public static final String API_TRAN_USDT_URL = "https://api.omniexplorer.info";
    public static final String API_TRAN_BTC_LTC_STATUS_URL = "https://api.blockchair.com";
    public static final String API_TRAN_BTM_STATUS_URL = "https://blockmeta.com";
    public static final String API_TRAN_ETH_STATUS_URL = "https://jsonrpc.medishares.net";

    private static TransactionRecordService transactionVnsRecordService, serviceVnsPrice, serviceOwnerApi;
    final static InputStream[] inputStreams = new InputStream[1];
    static Interceptor mInterceptor = new Interceptor() {
        @Override
        public Response intercept(Chain chain) throws IOException {
            String language = "zh";
            if(LanguageLocalManageUtil.getSelectLanguage(App.getContext()) == 1 || LanguageLocalManageUtil.getSelectLanguage(App.getContext()) == 2) {
                language = "zh";
            } else {
                language = "en";
            }
            Request request = chain.request()
                    .newBuilder()
                    .addHeader("language", language)
                    .addHeader("info", App.requestHeader)
                    .build();
            return chain.proceed(request);
        }
    };

    {
        if(App.isUseHttps)
        {
            try {
                inputStreams[0] = App.getContext().getAssets().open("coinid.cer");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 获取Vns交易服务
     * @return
     */
    public static TransactionRecordService getServiceVns() {
        if(transactionVnsRecordService == null) {
            synchronized (Api.class) {
                transactionVnsRecordService = XApi.getInstance().getRetrofit(API_TRAN_VNS_URL, true, mInterceptor).create(TransactionRecordService.class);
            }
        }
        return transactionVnsRecordService;
    }

    public static TransactionRecordService getServiceVnsPrice() {
        if(serviceVnsPrice == null) {
            synchronized (Api.class) {
                serviceVnsPrice = XApi.getInstance().getRetrofit(API_TRAN_CURRENCIES_URL, true, mInterceptor).create(TransactionRecordService.class);
            }
        }
        return serviceVnsPrice;
    }

    public static TransactionRecordService getServiceOwnerApi() {
        if(serviceOwnerApi == null) {
            synchronized (Api.class) {
                serviceOwnerApi = XApi.getInstance().getRetrofit(API_BASE_URL, true, mInterceptor).create(TransactionRecordService.class);
            }
        }
        return serviceOwnerApi;
    }
}
