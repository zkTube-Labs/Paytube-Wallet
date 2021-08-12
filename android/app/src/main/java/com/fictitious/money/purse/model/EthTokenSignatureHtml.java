package com.fictitious.money.purse.model;

public class EthTokenSignatureHtml {

    /**
     * chainType : 2
     * jsonData : {"from":"0xb9af7A63b5FCef11C35891EF033dEC6DB7a4562B","to":"0x10F9CbB8ae236e6da7f549CA3D5004feAEA49bfB","istoken":true,"symbols":"XMX","decimals":8,"contract":"0x0f8c45b896784a1e408526b9300519ef8660209c","amount":"10","memo":""}
     */

    private int chainType;// 对某主币下的代币签名类型 1 : btc 、2 : eth 、 3：eos
    private JsonDataBean jsonData;

    public int getChainType() {
        return chainType;
    }

    public void setChainType(int chainType) {
        this.chainType = chainType;
    }

    public JsonDataBean getJsonData() {
        return jsonData;
    }

    public void setJsonData(JsonDataBean jsonData) {
        this.jsonData = jsonData;
    }

    @Override
    public String toString() {
        return "EthTokenSignatureHtml{" +
                "chainType=" + chainType +
                ", jsonData=" + jsonData +
                '}';
    }

    public static class JsonDataBean {
        /**
         * from : 0xb9af7A63b5FCef11C35891EF033dEC6DB7a4562B
         * to : 0x10F9CbB8ae236e6da7f549CA3D5004feAEA49bfB
         * istoken : true
         * symbols : XMX
         * decimals : 8
         * contract : 0x0f8c45b896784a1e408526b9300519ef8660209c
         * amount : 10
         * memo :
         */

        private String from;// 付款地址
        private String to;// 收款地址
        private boolean istoken; // 是否代币转账
        private String symbols;// 交易币种符号: xmx /eth /eos/iq
        private int decimals;// 精确位数
        private String contract;// 合约地址
        private String amount;// 转账金额
        private String memo; //备注，没有则空

        public String getFrom() {
            return from;
        }

        public void setFrom(String from) {
            this.from = from;
        }

        public String getTo() {
            return to;
        }

        public void setTo(String to) {
            this.to = to;
        }

        public boolean isIstoken() {
            return istoken;
        }

        public void setIstoken(boolean istoken) {
            this.istoken = istoken;
        }

        public String getSymbols() {
            return symbols;
        }

        public void setSymbols(String symbols) {
            this.symbols = symbols;
        }

        public int getDecimals() {
            return decimals;
        }

        public void setDecimals(int decimals) {
            this.decimals = decimals;
        }

        public String getContract() {
            return contract;
        }

        public void setContract(String contract) {
            this.contract = contract;
        }

        public String getAmount() {
            return amount;
        }

        public void setAmount(String amount) {
            this.amount = amount;
        }

        public String getMemo() {
            return memo;
        }

        public void setMemo(String memo) {
            this.memo = memo;
        }

        @Override
        public String toString() {
            return "JsonDataBean{" +
                    "from='" + from + '\'' +
                    ", to='" + to + '\'' +
                    ", istoken=" + istoken +
                    ", symbols='" + symbols + '\'' +
                    ", decimals=" + decimals +
                    ", contract='" + contract + '\'' +
                    ", amount='" + amount + '\'' +
                    ", memo='" + memo + '\'' +
                    '}';
        }
    }
}
