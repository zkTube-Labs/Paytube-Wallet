package com.fictitious.money.purse.model;

import java.io.Serializable;

public class ReturnPayToJSJsonData implements Serializable {
    private int status;
    private String msg;
    private DataBean data;

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

    public DataBean getData() {
        return data;
    }

    public void setData(DataBean data) {
        this.data = data;
    }

    public static class DataBean implements Serializable{
        private String txid;// 交易号
        private String minersFee;// 转出地址

        public String getTxid() {
            return txid;
        }

        public void setTxid(String txid) {
            this.txid = txid;
        }

        public String getMinersFee() {
            return minersFee;
        }

        public void setMinersFee(String minersFee) {
            this.minersFee = minersFee;
        }
    }
}
