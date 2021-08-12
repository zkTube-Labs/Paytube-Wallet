package com.fictitious.money.purse.results;

import java.io.Serializable;

public class EthTransReult extends BaseModel implements Serializable {

    /**
     * jsonrpc : 2.0
     * id : 1
     * error : {"code":-32000,"message":"invalid sender"}
     */

    private String jsonrpc;
    private int id;
    private ErrorBean error;
    private String result;

    public String getJsonrpc() {
        return jsonrpc;
    }

    public void setJsonrpc(String jsonrpc) {
        this.jsonrpc = jsonrpc;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public ErrorBean getError() {
        return error;
    }

    public void setError(ErrorBean error) {
        this.error = error;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    @Override
    public String toString() {
        return "EthTransReult{" +
                "jsonrpc='" + jsonrpc + '\'' +
                ", id=" + id +
                ", error=" + error +
                ", result='" + result + '\'' +
                '}';
    }

    public static class ErrorBean implements Serializable {
        /**
         * code : -32000
         * message : invalid sender
         */

        private int code;
        private String message;

        public int getCode() {
            return code;
        }

        public void setCode(int code) {
            this.code = code;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        @Override
        public String toString() {
            return "ErrorBean{" +
                    "code=" + code +
                    ", message='" + message + '\'' +
                    '}';
        }
    }
}
