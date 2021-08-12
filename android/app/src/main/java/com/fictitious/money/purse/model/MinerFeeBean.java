package com.fictitious.money.purse.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Description: 矿工费
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/4/12 13:57
 */
public class MinerFeeBean implements Serializable {
    private BigDecimal originalGasPrice; // 主网gaslimit
    private BigDecimal originalEstimateGas; //主网gasprice
    private BigDecimal gasPrice;
    private BigDecimal estimateGas;
    // 矿工费 0.000021 ETH
    private String minerFeeNum;
    // vns单价
    private String ethCurrentPrice;
    private int nonce;
    private String version;
    private String gasDes;
    private String from;
    private BigDecimal balance; // 余额

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public BigDecimal getGasPrice() {
        return gasPrice;
    }

    public void setGasPrice(BigDecimal gasPrice) {
        this.gasPrice = gasPrice;
    }

    public BigDecimal getEstimateGas() {
        return estimateGas;
    }

    public void setEstimateGas(BigDecimal estimateGas) {
        this.estimateGas = estimateGas;
    }

    public String getMinerFeeNum() {
        return minerFeeNum;
    }

    public void setMinerFeeNum(String minerFeeNum) {
        this.minerFeeNum = minerFeeNum;
    }

    public String getEthCurrentPrice() {
        return ethCurrentPrice;
    }

    public void setEthCurrentPrice(String ethCurrentPrice) {
        this.ethCurrentPrice = ethCurrentPrice;
    }

    public int getNonce() {
        return nonce;
    }

    public void setNonce(int nonce) {
        this.nonce = nonce;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getGasDes() {
        return gasDes;
    }

    public void setGasDes(String gasDes) {
        this.gasDes = gasDes;
    }

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public BigDecimal getOriginalGasPrice() {
        return originalGasPrice;
    }

    public void setOriginalGasPrice(BigDecimal originalGasPrice) {
        this.originalGasPrice = originalGasPrice;
    }

    public BigDecimal getOriginalEstimateGas() {
        return originalEstimateGas;
    }

    public void setOriginalEstimateGas(BigDecimal originalEstimateGas) {
        this.originalEstimateGas = originalEstimateGas;
    }

    @Override
    public String toString() {
        return "MinerFeeBean{" +
                "gasPrice=" + gasPrice +
                ", originalGasPrice=" + originalGasPrice +
                ", originalEstimateGas=" + originalEstimateGas +
                ", estimateGas=" + estimateGas +
                ", minerFeeNum='" + minerFeeNum + '\'' +
                ", ethCurrentPrice='" + ethCurrentPrice + '\'' +
                ", nonce=" + nonce +
                ", version='" + version + '\'' +
                ", gasDes='" + gasDes + '\'' +
                ", from='" + from + '\'' +
                ", balance=" + balance +
                '}';
    }
}
