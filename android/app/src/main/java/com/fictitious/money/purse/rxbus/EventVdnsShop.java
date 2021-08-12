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
public class EventVdnsShop implements IBus.IEvent {
    public String msg;
    public int mType;

    public EventVdnsShop() {
    }

    public EventVdnsShop(String msg, int type) {
        if (TextUtils.isEmpty(msg)){
            msg = "";
        }
        this.msg = msg;
        mType = type;
    }

    @Override
    public int getTag() {
        return 0;
    }

}