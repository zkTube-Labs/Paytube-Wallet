package com.fictitious.money.purse.model;

import java.io.Serializable;
import java.util.List;

public class EthTokenSeriesParam implements Serializable {

    /**
     * id : 1
     * jsonrpc : 2.0
     * method : eth_call
     * params : [{"to":"0x0f8c45b896784a1e408526b9300519ef8660209c","data":"0x70a08231000000000000000000000000b9af7a63b5fcef11c35891ef033dec6db7a4562b"},"latest"]
     */

    private int id;
    private String jsonrpc;
    private String method;
    private List<Object> params;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

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

    public List<Object> getParams() {
        return params;
    }

    public void setParams(List<Object> params) {
        this.params = params;
    }
}
