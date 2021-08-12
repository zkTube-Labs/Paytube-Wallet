package com.fictitious.money.purse.presenter;

import com.fictitious.money.purse.listener.OnCompleteDataListener;
import com.fictitious.money.purse.model.MDidSendToken;
import com.fictitious.money.purse.model.MinerFeeBean;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.web.vdai.DidSendTokenActivity;

import cn.droidlover.xdroidmvp.mvp.XPresent;
import cn.droidlover.xdroidmvp.net.NetError;

/**
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-11-14 09:59
 * Description:
 */
public class PDidSendToken extends XPresent<DidSendTokenActivity> {
    private final String TAG = PDidSendToken.class.getSimpleName();
    private final MDidSendToken mDidSendToken;

    public PDidSendToken() {
        mDidSendToken = new MDidSendToken();
    }

    public void getVnsTransInfo(String token, String contract, String from) {
        mDidSendToken.getVnsTransInfo(token, contract, from, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                if (hasV()) {
                    getV().showMinersFeeView((MinerFeeBean) result);
                }
            }

            @Override
            public void onFailure(NetError error) {

            }
        });
    }

    public void trans(String token, String contract, String from, String to, String decimals, String money, byte[] signPrvKey) {
        Logger.e(TAG, "token: " + token + ", contract: " + contract + ", from: " + from + ", to :" + to + ", decimals :" + decimals + ", money: " + money);
        mDidSendToken.pay(token, contract, from, to, decimals, money, signPrvKey, new OnCompleteDataListener() {
            @Override
            public void onComplete(Object result) {
                if (hasV()) {
                    getV().callbackSuccessful((String) result);
                }
            }

            @Override
            public void onFailure(NetError error) {
                if (hasV()) {
                    getV().callbackFailed(error);
                }
            }
        });
    }
}
