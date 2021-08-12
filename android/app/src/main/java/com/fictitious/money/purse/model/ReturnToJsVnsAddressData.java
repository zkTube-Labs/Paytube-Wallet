package com.fictitious.money.purse.model;

import java.io.Serializable;
import java.util.List;

public class ReturnToJsVnsAddressData implements Serializable {

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
        private List<String> addressList;// vns地址

        public List<String> getAddressList() {
            return addressList;
        }

        public void setAddressList(List<String> addressList) {
            this.addressList = addressList;
        }
    }
}
