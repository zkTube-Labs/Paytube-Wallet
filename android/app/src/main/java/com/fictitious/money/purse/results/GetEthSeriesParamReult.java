package com.fictitious.money.purse.results;

import java.io.Serializable;

public class GetEthSeriesParamReult extends BaseModel implements Serializable {

    /**
     * jsonrpc : 2.0
     * result : 0x00000000000000000000000000000000000000000000000000000000093908ef
     * id : 1
     */

    private String jsonrpc;
    private String result;
    private int id;

    public String getJsonrpc() {
        return jsonrpc;
    }

    public void setJsonrpc(String jsonrpc) {
        this.jsonrpc = jsonrpc;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "GetEthSeriesParamReult{" +
                "jsonrpc='" + jsonrpc + '\'' +
                ", result='" + result + '\'' +
                ", id=" + id +
                '}';
    }
}
