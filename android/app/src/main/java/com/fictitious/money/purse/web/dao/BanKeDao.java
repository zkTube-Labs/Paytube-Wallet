package com.fictitious.money.purse.web.dao;

import com.fictitious.money.purse.App;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.model.BanKeTransactionData;
import com.fictitious.money.purse.model.ImportPurseEntity;
import com.fictitious.money.purse.model.ShopReturnJSBean;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.web.shop.BanKeMarketShopActivity;
import com.fictitious.money.purse.web.shop.BanKeSelectDidAddressActivity;
import com.google.gson.Gson;
import com.tencent.smtt.export.external.interfaces.JsPromptResult;
import com.tencent.smtt.sdk.WebView;

import java.util.ArrayList;
import java.util.List;

import cn.droidlover.xdroidmvp.router.Router;

/**
 * Description: 处理js回调
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/2/11 10:38
 */
public class BanKeDao {
    private final String TAG = BanKeDao.class.getSimpleName();
    private WebView mWebView;
    // ETH转账
    public static final int eth_transaction = 2;
    // VNS转账
    public static final int vns_transaction = 4;
    // EHE转账
    public static final int ehe_transaction = 5;
    // BTM转账
    public static final int btm_transaction = 6;

    ImportPurseEntity selectPurse;
    List<ImportPurseEntity> purseEntities;

    public BanKeDao(WebView mWebView, List<ImportPurseEntity> purseEntities) {
        this.mWebView = mWebView;
        this.purseEntities = purseEntities;
    }



    /**
     * 获取所有钱包下的vns地址
     *
     * @return
     */
    public String getAllVnsAddress() {
        Gson gson = new Gson();
        ShopReturnJSBean jsBean = new ShopReturnJSBean();
        ShopReturnJSBean.DataBean dataBean = new ShopReturnJSBean.DataBean();
        ArrayList<String> vnsAddressList = new ArrayList<>();
        try {
            for (ImportPurseEntity entity : purseEntities) {
                String address = entity.getAddress();
                vnsAddressList.add(address);
                Logger.e(TAG, "添加了一个vns：" + address);
            }

            if (vnsAddressList.size() > 0) {
                jsBean.setStatus(Constants.CODE_H5_TRANSFER.succeed200);
                jsBean.setMsg("获取成功!");
                dataBean.setVnsAddress(vnsAddressList);
            } else {
                jsBean.setStatus(Constants.CODE_H5_TRANSFER.failed401);
                jsBean.setMsg("获取失败!");
                dataBean.setError("没有导入vns钱包");
            }

            jsBean.setData(dataBean);
            String json = gson.toJson(jsBean);
            Logger.e(TAG, "获取所有钱包下的vns地址给h5：" + json);
            return json;
        } catch (Exception e) {
            jsBean.setStatus(Constants.CODE_H5_TRANSFER.failed400);
            jsBean.setMsg("程序异常!");
            dataBean.setError("程序异常");
            jsBean.setData(dataBean);
            String json = gson.toJson(jsBean);
            Logger.e(TAG, "获取所有钱包下的vns地址给h5：" + json);
            return json;
        }

    }

    /**
     * 转账交易
     */
    public void daoTransaction(JsPromptResult promptResult, BanKeTransactionData data) {
        if (data != null) {
            int chainType = data.getChainType();
            switch (chainType) {
                case vns_transaction:
                    BanKeTransactionData.InfoBean vnsInfo = data.getInfo();
                    for(ImportPurseEntity importPurseEntity : purseEntities){
                        if(importPurseEntity.getAddress().equals(vnsInfo.getPayAddress())){
                            selectPurse = importPurseEntity;
                            break;
                        }
                    }
                    transaction(vnsInfo, selectPurse, vns_transaction);
                    break;
                default:
                    promptResult.confirm("暂不支持其他货币支付：" + chainType);
                    Logger.e(TAG, "暂不支持其他货币支付：" + chainType);
                    break;
            }
        } else {
            Logger.e(TAG, "data对象为空");
            promptResult.confirm("data对象为空");
        }
    }

    /**
     * 重新转账交易
     *
     * @param result
     * @param data
     */
    public void daoAfreshTransaction(JsPromptResult result, BanKeTransactionData data) {
        if (data != null) {
            int chainType = data.getChainType();
            switch (chainType) {
                case vns_transaction:
                    BanKeTransactionData.InfoBean ethInfo = data.getInfo();
                    for(ImportPurseEntity importPurseEntity : purseEntities){
                        if(importPurseEntity.getAddress().equals(ethInfo.getPayAddress())){
                            selectPurse = importPurseEntity;
                            break;
                        }
                    }
                    afreshTransaction(ethInfo, selectPurse, vns_transaction);
                    break;
                default:
                    Logger.e(TAG, "chainType其他货币：" + chainType);
                    break;
            }
        } else {
            Logger.e(TAG, "data对象为空");
            result.confirm("data对象为空");
        }
    }

    /**
     * 重新交易
     *
     * @param info
     */
    private void afreshTransaction(BanKeTransactionData.InfoBean info, ImportPurseEntity purseEntity, int type_transaction) {
        Logger.e(TAG, "弹出重新转账界面");
        // 弹出转账界面
        Router.newIntent(App.getActivity()).to(BanKeMarketShopActivity.class)
                .putSerializable("obj", info)
                .putSerializable("wallet", purseEntity)
                .putBoolean("afreshPay", true)
                .putInt(Constants.INTENT_PARAM.H5_TRANSACTION_TYPE, type_transaction)
                .launch();

    }

    /**
     * 转账交易
     *
     * @param info
     */
    private void transaction(BanKeTransactionData.InfoBean info, ImportPurseEntity purseEntity, int type_transaction) {
        if (info == null) {
            Logger.e(TAG, "info空了");
        } else {
            if (vns_transaction == type_transaction) {
                Logger.e(TAG, "弹出vns转账界面");
                // 弹出转账界面
                Router.newIntent(App.getActivity()).to(BanKeMarketShopActivity.class)
                        .putSerializable("obj", info)
                        .putSerializable("wallet", purseEntity)
                        .putBoolean("afreshPay", false)
                        .putInt(Constants.INTENT_PARAM.H5_TRANSACTION_TYPE, type_transaction)
                        .launch();
            } else {
                Logger.e(TAG, "不支持其他转账 ");
            }
        }
    }

    /**
     * 显示did地址选择界面
     */
    public void showSelectDidAddress() {
        // 弹出did地址选择界面
        Router.newIntent(App.getActivity()).to(BanKeSelectDidAddressActivity.class)
                .launch();
    }
}

