package com.fictitious.money.purse.listener;

import cn.droidlover.xdroidmvp.net.NetError;

/**
 * Description: 首页数据加载完成的监听器
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/3/8 10:57
 */
public interface OnCompleteDataListener<T> {
    /**
     * 数据加载完成
     *
     * @param result 数据
     */
    void onComplete(T result);

    /**
     * 获取失败：500:服务器错误，-1：网络错误
     */
    void onFailure(NetError error);

    default void onEmpty(){};
}
