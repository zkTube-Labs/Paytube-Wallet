package com.fictitious.money.purse.model;

import java.io.Serializable;
import java.util.List;

public class TransactionEthParam implements Serializable {

    /**
     * jsonrpc : 2.0
     * method : eth_sendRawTransaction
     * params : ["0xf86b01850165a0bc00825cec9400c56e8277000000a04d538277000000207a99e5872386f26fc100008026a074ec1c3a8b92cd82f80f9156f70f89bbd17fcbfa310c8414fe6a176648d53078a030d090d6878dec7626a2dd9e922018275e6942d1d0b1c5bc104e85746f95d49f"]
     * id : 1
     */

    private String jsonrpc;
    private String method;
    private int id;
    private List<String> params;

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

    public List<String> getParams() {
        return params;
    }

    public void setParams(List<String> params) {
        this.params = params;
    }
}
