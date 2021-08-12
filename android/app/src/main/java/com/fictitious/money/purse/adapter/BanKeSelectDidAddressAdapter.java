package com.fictitious.money.purse.adapter;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.example.ffdemo.R;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.model.EthTokenSeriesParam;
import com.fictitious.money.purse.model.ImportPurseEntity;
import com.fictitious.money.purse.net.Api;
import com.fictitious.money.purse.results.GetEthSeriesParamReult;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.Logger;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import cn.droidlover.xdroidmvp.net.ApiSubscriber;
import cn.droidlover.xdroidmvp.net.NetError;
import cn.droidlover.xdroidmvp.net.XApi;

import static java.math.BigDecimal.ROUND_HALF_UP;

/**
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-10-31 17:13
 * Description:
 */
public class BanKeSelectDidAddressAdapter extends BaseQuickAdapter<ImportPurseEntity, BaseViewHolder> {
    private final String TAG = BanKeSelectDidAddressAdapter.class.getSimpleName();
    private boolean isShowBalance = false;
    private String selectDidAddress = "";

    public boolean isShowBalance() {
        return isShowBalance;
    }

    public void setShowBalance(boolean showBalance) {
        isShowBalance = showBalance;
        notifyDataSetChanged();
    }

    public BanKeSelectDidAddressAdapter() {
        super(R.layout.item_select_did_address);
    }

    public String getSelectDidAddress() {
        return selectDidAddress;
    }

    public void setSelectDidAddress(String selectDidAddress) {
        this.selectDidAddress = selectDidAddress;
        notifyDataSetChanged();
    }


    @Override
    protected void convert(BaseViewHolder helper, ImportPurseEntity item) {
        try {
            switch (item.getOriginType()) {
                case Constants.ORIGIN_TYPE.CREATE:
                case Constants.ORIGIN_TYPE.RESTORE:
                    helper.setImageResource(R.id.img_item, R.mipmap.ic_add_hot_wallet);
                    break;
                case Constants.ORIGIN_TYPE.COLDS:
                    helper.setImageResource(R.id.img_item, R.mipmap.ic_add_cold_wallet);
                    break;
                case Constants.ORIGIN_TYPE.IMPORT:
                    helper.setImageResource(R.id.img_item, R.mipmap.ic_add_import_wallet);
                    break;
                case Constants.ORIGIN_TYPE.NFC:
                    helper.setImageResource(R.id.img_item, R.mipmap.ic_add_crad_wallet);
                    break;
            }

            if (selectDidAddress.equals(String.valueOf(item.getAddress()))) {
                helper.setVisible(R.id.img_select,true);
            } else {
                helper.setVisible(R.id.img_select,false);
            }

            helper.setText(R.id.tv_name, String.valueOf(item.getDescName()))
                    .setText(R.id.tv_addr, String.valueOf(item.getAddress()));

            getVnsSeriesBalance(item.getAddress(), helper);

            helper.addOnClickListener(R.id.root);
        } catch (Exception e) {
            Logger.e(TAG, "异常啦~~~" + e.getMessage());
        }

    }

    /**
     * 获取vns数量
     */
    private void getVnsSeriesBalance(String address, BaseViewHolder helper) {
        List<Object> lists = new ArrayList<>();
        lists.add(address);
        lists.add("latest");

        EthTokenSeriesParam ethSeriesBalanceParam = new EthTokenSeriesParam();
        ethSeriesBalanceParam.setId(1);
        ethSeriesBalanceParam.setJsonrpc("2.0");
        ethSeriesBalanceParam.setMethod("vns_getBalance");
        ethSeriesBalanceParam.setParams(lists);

        Api.getServiceVns().getEthTokenSeriesParam(ethSeriesBalanceParam)
                .compose(XApi.<GetEthSeriesParamReult>getApiTransformer())
                .compose(XApi.<GetEthSeriesParamReult>getScheduler())
                .subscribe(new ApiSubscriber<GetEthSeriesParamReult>() {
                    @Override
                    protected void onFail(NetError error) {
                        if (isShowBalance) {
                            helper.setText(R.id.tv_amount, "0 VNS");
                        } else {
                            helper.setText(R.id.tv_amount, "****");
                        }
                    }

                    @Override
                    public void onNext(GetEthSeriesParamReult getBtcBalanceResult) {
                        BigDecimal result = new BigDecimal(new BigInteger(CommonUtil.subStrEthBalance(getBtcBalanceResult.getResult()), 16)).divide(new BigDecimal(Math.pow(10, 18)), 10, ROUND_HALF_UP);
                        if (isShowBalance) {
                            if (result != null) {
//                                helper.setText(R.id.tv_amount, result.setScale(4, BigDecimal.ROUND_HALF_UP).stripTrailingZeros().toPlainString() + " VNS");
                                helper.setText(R.id.tv_amount, result.stripTrailingZeros().toPlainString() + " VNS");
                            } else {
                                helper.setText(R.id.tv_amount, "0 VNS");
                            }
                        } else {
                            helper.setText(R.id.tv_amount, "****");
                        }
                    }
                });
    }
}
