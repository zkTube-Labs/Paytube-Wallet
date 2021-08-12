package com.fictitious.money.purse.model;

import com.fictitious.money.purse.results.BaseModel;

import java.io.Serializable;

public class CurrencyPriceResult extends BaseModel implements Serializable {

    /**
     * status : 200
     * msg : OK
     * data : 12.879409040771
     */

    private int status;
    private String msg;
    private String data;

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }
}
