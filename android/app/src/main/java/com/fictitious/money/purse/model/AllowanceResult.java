package com.fictitious.money.purse.model;

import com.fictitious.money.purse.results.BaseModel;

import java.io.Serializable;

/**
 * 获取VNS数量
 */
public class AllowanceResult extends BaseModel implements Serializable {

    /**
     {
     "jsonrpc": "2.0",
     "id": 1,
     "result": "0x0000000000000000000000000000000000000000000000000000000000000000"
     }
     */

    private String jsonrpc;
    private int id;
    private String result;

    public String getJsonrpc() {
        return jsonrpc;
    }

    public void setJsonrpc(String jsonrpc) {
        this.jsonrpc = jsonrpc;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    @Override
    public String toString() {
        return "AllowanceResult{" +
                "jsonrpc='" + jsonrpc + '\'' +
                ", id=" + id +
                ", result='" + result + '\'' +
                '}';
    }
}
