package com.fictitious.money.purse.model;

import java.io.Serializable;

/**
 * Description:
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/4/11 10:19
 */
public class BanKeTransactionData implements Serializable {

    /**
     * chainType : 2
     * info : {"istoken":false,"symbols":"ETH","merchantName":"EHE","to":"16UeX3McLioKJzG2CCc7z95z9e8xDBzdu8","amount":"0.0001"}
     */

    private int chainType;
    private InfoBean info;

    public int getChainType() {
        return chainType;
    }

    public void setChainType(int chainType) {
        this.chainType = chainType;
    }

    public InfoBean getInfo() {
        return info;
    }

    public void setInfo(InfoBean info) {
        this.info = info;
    }

    @Override
    public String toString() {
        return "ShopTransactionData{" +
                "chainType=" + chainType +
                ", info=" + info +
                '}';
    }

    public static class InfoBean implements Serializable {
        /**
         * istoken : false
         * symbols : ETH
         * merchantName : EHE
         * to : 16UeX3McLioKJzG2CCc7z95z9e8xDBzdu8
         * amount : 0.0001
         */

        private boolean istokenConvert;
        private int signtype;
        private int decimal;
        private String symbols;
        private String merchantName;
        private String amount;
        private String bancorConverterAddress;
        private String smartTokenAddress; // 合约地址
        private String etherTokenAddress;
        private String payAddress;
        private String connectorName;
        private String tokenName;

        public String getPayAddress() {
            return payAddress;
        }

        public void setPayAddress(String payAddress) {
            this.payAddress = payAddress;
        }

        public int getDecimal() {
            return decimal;
        }

        public void setDecimal(int decimal) {
            this.decimal = decimal;
        }

        public boolean isIstokenConvert() {
            return istokenConvert;
        }

        public void setIstokenConvert(boolean istokenConvert) {
            this.istokenConvert = istokenConvert;
        }

        public int getSigntype() {
            return signtype;
        }

        public void setSigntype(int signtype) {
            this.signtype = signtype;
        }

        public String getSymbols() {
            return symbols;
        }

        public void setSymbols(String symbols) {
            this.symbols = symbols;
        }

        public String getMerchantName() {
            return merchantName;
        }

        public void setMerchantName(String merchantName) {
            this.merchantName = merchantName;
        }

        public String getAmount() {
            return amount;
        }

        public void setAmount(String amount) {
            this.amount = amount;
        }

        public String getBancorConverterAddress() {
            return bancorConverterAddress;
        }

        public void setBancorConverterAddress(String bancorConverterAddress) {
            this.bancorConverterAddress = bancorConverterAddress;
        }

        public String getSmartTokenAddress() {
            return smartTokenAddress;
        }

        public void setSmartTokenAddress(String smartTokenAddress) {
            this.smartTokenAddress = smartTokenAddress;
        }

        public String getEtherTokenAddress() {
            return etherTokenAddress;
        }

        public void setEtherTokenAddress(String etherTokenAddress) {
            this.etherTokenAddress = etherTokenAddress;
        }

        public String getConnectorName() {
            return connectorName;
        }

        public void setConnectorName(String connectorName) {
            this.connectorName = connectorName;
        }

        public String getTokenName() {
            return tokenName;
        }

        public void setTokenName(String tokenName) {
            this.tokenName = tokenName;
        }

        @Override
        public String toString() {
            return "InfoBean{" +
                    "payAddress=" + payAddress +
                    ", istokenConvert=" + istokenConvert +
                    ", signtype=" + signtype +
                    ", decimal=" + decimal +
                    ", symbols='" + symbols + '\'' +
                    ", merchantName='" + merchantName + '\'' +
                    ", amount='" + amount + '\'' +
                    ", bancorConverterAddress='" + bancorConverterAddress + '\'' +
                    ", smartTokenAddress='" + smartTokenAddress + '\'' +
                    ", etherTokenAddress='" + etherTokenAddress + '\'' +
                    ", connectorName='" + connectorName + '\'' +
                    ", tokenName='" + tokenName + '\'' +
                    '}';
        }
    }
}
