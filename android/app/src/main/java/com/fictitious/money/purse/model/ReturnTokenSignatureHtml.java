package com.fictitious.money.purse.model;

import java.io.Serializable;
import java.util.List;

/**
 * 签名后返回给h5的数据
 */
public class ReturnTokenSignatureHtml implements Serializable {

    /**
     * status : 200
     * msg : 成功
     * data : {"signatureStr":"xxx"}
     */

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

    public static class DataBean implements Serializable {
        /**
         * signatureStr : xxx
         */
        private int chainType; // 主币类型 1 : btc 、2 : eth 、 3：eos
        private String signatureStr;// 签名内容
        private List<String> addressList;// 绑定地址列表

        public String getTrxid() {
            return trxid;
        }

        public void setTrxid(String trxid) {
            this.trxid = trxid;
        }

        private String trxid;// 链上交易号

        public int getChainType() {
            return chainType;
        }

        public void setChainType(int chainType) {
            this.chainType = chainType;
        }

        public String getSignatureStr() {
            return signatureStr;
        }

        public void setSignatureStr(String signatureStr) {
            this.signatureStr = signatureStr;
        }

        public List<String> getAddressList() {
            return addressList;
        }

        public void setAddressList(List<String> addressList) {
            this.addressList = addressList;
        }


    }
}
