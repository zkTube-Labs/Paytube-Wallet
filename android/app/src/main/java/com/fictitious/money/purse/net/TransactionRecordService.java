package com.fictitious.money.purse.net;

import com.fictitious.money.purse.model.AllowanceResult;
import com.fictitious.money.purse.model.CurrencyPriceResult;
import com.fictitious.money.purse.model.EthTokenSeriesParam;
import com.fictitious.money.purse.model.EthTranInfoResult;
import com.fictitious.money.purse.model.GetAllowanceParam;
import com.fictitious.money.purse.model.GetVnsSeriesCurrencies;
import com.fictitious.money.purse.model.TransactionEthParam;
import com.fictitious.money.purse.results.EthTransReult;
import com.fictitious.money.purse.results.GetEthSeriesParamReult;

import java.util.Map;

import io.reactivex.Flowable;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Query;

/**
 * Created by EDZ on 2018/7/5.
 */

public interface TransactionRecordService {
    //支付eth
    @POST(".")
    Flowable<EthTransReult> transactionEth(@Body TransactionEthParam transactionEthParam);

    //获取以太系代币的参数
    @POST(".")
    Flowable<GetEthSeriesParamReult> getEthTokenSeriesParam(@Body EthTokenSeriesParam ethTokenSeriesBalanceParam);

    //获取币种的价格
    @GET(Api.API_LOAD_BALANCING + Api.API_VERSION + "/api/mobile/getCurrencyPrice")
    Flowable<CurrencyPriceResult> getCurrencyPrice(@Query("currency") String currency, @Query("convert") String convert);

    //获取vns的交易信息
    @POST(Api.API_LOAD_BALANCING + Api.API_VERSION + "/api/mobile/vns/getVNSAddressInfo")
    Flowable<EthTranInfoResult> getVNSAddressInfoList(@Body Map<String, Object> map);

    //获取vns的单价
    @GET("/api/v1/ticker.do")
    Flowable<GetVnsSeriesCurrencies> getVnsSeriesCurrencies(@Query("symbol") String symbol);

    //查看gps代币还能够调用VNS账户多少个token
    @POST("/")
    Flowable<AllowanceResult> GetAllowance(@Body GetAllowanceParam param);
}
