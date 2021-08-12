package com.fictitious.money.purse.model;

import com.fictitious.money.purse.results.BaseModel;

import java.io.Serializable;
import java.util.List;

public class EthTranInfoResult extends BaseModel implements Serializable {

    /**
     * status : 200
     * msg : OK
     * data : [{"name":"transaction","data":{"jsonrpc":"2.0","result":"0x0","id":67}},{"name":"version","data":{"jsonrpc":"2.0","result":"1","id":67}},{"name":"gasPrice","data":{"jsonrpc":"2.0","result":"0x12c684c00","id":67}},{"name":"estimateGas","data":{"jsonrpc":"2.0","result":"0x5cec","id":67}},{"name":"balance","data":{"jsonrpc":"2.0","result":"0x16345785d8a0000","id":1}}]
     */

    private int status;
    private String msg;
    private List<DataBeanX> data;

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

    public List<DataBeanX> getData() {
        return data;
    }

    public void setData(List<DataBeanX> data) {
        this.data = data;
    }

    public static class DataBeanX implements Serializable {
        /**
         * name : transaction
         * data : {"jsonrpc":"2.0","result":"0x0","id":67}
         */

        private String name;
        private DataBean data;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public DataBean getData() {
            return data;
        }

        public void setData(DataBean data) {
            this.data = data;
        }

        public static class DataBean implements Serializable {
            /**
             * jsonrpc : 2.0
             * result : 0x0
             * id : 67
             */

            private String jsonrpc;
            private String result;
            private int id;

            public String getJsonrpc() {
                return jsonrpc;
            }

            public void setJsonrpc(String jsonrpc) {
                this.jsonrpc = jsonrpc;
            }

            public String getResult() {
                return result;
            }

            public void setResult(String result) {
                this.result = result;
            }

            public int getId() {
                return id;
            }

            public void setId(int id) {
                this.id = id;
            }
        }
    }
}
