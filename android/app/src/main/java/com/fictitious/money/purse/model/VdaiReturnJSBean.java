package com.fictitious.money.purse.model;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * Description:
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/4/11 14:26
 */
public class VdaiReturnJSBean implements Serializable {

    /**
     * msg : 获取成功！
     * status : 200
     * data : {"masterPubKey":"0xxxxxx"}
     */

    private String msg;
    private int status;
    private DataBean data;

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public DataBean getData() {
        return data;
    }

    public void setData(DataBean data) {
        this.data = data;
    }

    public static class DataBean implements Serializable {

        /**
         * masterPubKey : 0xxxxxx
         */

        private String symbols;
        private String imei;
        private String masterPubKey;
        private String error;
        private String txid;
        private String minersFee;// 矿工费
        private String fromAddress;// 付款地址
        private ArrayList<String> addressList;// 所有钱包的vns地址

        public ArrayList<String> getAddressList() {
            return addressList;
        }

        public void setAddressList(ArrayList<String> addressList) {
            this.addressList = addressList;
        }

        public String getSymbols() {
            return symbols;
        }

        public void setSymbols(String symbols) {
            this.symbols = symbols;
        }

        public String getMinersFee() {
            return minersFee;
        }

        public void setMinersFee(String minersFee) {
            this.minersFee = minersFee;
        }

        public String getFromAddress() {
            return fromAddress;
        }

        public void setFromAddress(String fromAddress) {
            this.fromAddress = fromAddress;
        }

        public String getTxid() {
            return txid;
        }

        public void setTxid(String txid) {
            this.txid = txid;
        }

        public String getError() {
            return error;
        }

        public void setError(String error) {
            this.error = error;
        }

        public String getMasterPubKey() {
            return masterPubKey;
        }

        public void setMasterPubKey(String masterPubKey) {
            this.masterPubKey = masterPubKey;
        }

        public String getImei() {
            return imei;
        }

        public void setImei(String imei) {
            this.imei = imei;
        }

    }
}
