package com.fictitious.money.purse.model;

import java.io.Serializable;

public class ImportPurseEntity implements Serializable {
    private String address;
    private String walletID;
    private int originType;
    private String pubKey;
    private String prvKey;
    private int coinType;
    private Object descName;
    private boolean didChoose;

    public String getWalletID() {
        return walletID;
    }

    public void setWalletID(String walletID) {
        this.walletID = walletID;
    }

    public String getPubKey() {
        return pubKey;
    }

    public void setPubKey(String pubKey) {
        this.pubKey = pubKey;
    }

    public int getCoinType() {
        return coinType;
    }

    public void setCoinType(int coinType) {
        this.coinType = coinType;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Object getDescName() {
        return descName;
    }

    public void setDescName(Object descName) {
        this.descName = descName;
    }

    public String getPrvKey() {
        return prvKey;
    }

    public void setPrvKey(String prvKey) {
        this.prvKey = prvKey;
    }

    public int getOriginType() {
        return originType;
    }

    public void setOriginType(int originType) {
        this.originType = originType;
    }

    public boolean isDidChoose() {
        return didChoose;
    }

    public void setDidChoose(boolean didChoose) {
        this.didChoose = didChoose;
    }
}
