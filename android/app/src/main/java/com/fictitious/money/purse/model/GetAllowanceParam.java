package com.fictitious.money.purse.model;

import java.io.Serializable;
import java.util.List;

/**
 * Description: ${DESCRIPTION}
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2018/11/3 17:29
 */
public class GetAllowanceParam implements Serializable {

    /**
     * {"jsonrpc":"2.0","method":"vns_call","params":[{"to":"0x8f8be9b81209ce166a29ecf26829fce08f0b39df","data":"0xdd62ed3e00000000000000000000000097155376bda799b05b10d87a9d69006026812459000000000000000000000000d27d1ebd08d8ec75970b348f62f75991446376a8"},"latest"],"id":1}
     */

    private String jsonrpc;
    private String method;
    private int id;
    private List<Object> params;

    public String getJsonrpc() {
        return jsonrpc;
    }

    public void setJsonrpc(String jsonrpc) {
        this.jsonrpc = jsonrpc;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public List<Object> getParams() {
        return params;
    }

    public void setParams(List<Object> params) {
        this.params = params;
    }


}
