package com.fictitious.money.purse.rxbus;

import android.text.TextUtils;

import cn.droidlover.xdroidmvp.event.IBus;

/**
 * Description:
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/4/11 11:47
 */
public class EventBanKeShop implements IBus.IEvent {
    public String msg;

    public EventBanKeShop() {
    }

    public EventBanKeShop(String msg) {
        if (TextUtils.isEmpty(msg)){
            msg = "";
        }
        this.msg = msg;
    }

    @Override
    public int getTag() {
        return 0;
    }

}