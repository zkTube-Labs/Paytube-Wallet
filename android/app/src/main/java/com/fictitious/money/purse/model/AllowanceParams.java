package com.fictitious.money.purse.model;

import java.io.Serializable;

/**
 * Description:
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/7/26 17:33
 */
public class AllowanceParams implements Serializable {

    /**
     * to : 0x8f8be9b81209ce166a29ecf26829fce08f0b39df
     * data : 0xdd62ed3e00000000000000000000000097155376bda799b05b10d87a9d69006026812459000000000000000000000000d27d1ebd08d8ec75970b348f62f75991446376a8
     */

    private String to;
    private String data;

    public String getTo() {
        return to;
    }

    public void setTo(String to) {
        this.to = to;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }
}
