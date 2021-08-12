package com.fictitious.money.purse;

public class Constants {
    public static String VP_INQUIRE_CONTRACT = "0x0824C2eb8c9c59613726190A346537684860b934";

    public interface COIN_TYPE {

        int TYPE_ETH = 0;

    }

    public interface URL_TYPE {
        int TYPE_LINKS = 0;
        int TYPE_BANCOR = 1;
        int TYPE_VDNS = 2;
        int TYPE_VDAI = 3;
    }

    public interface LEAD_TYPE {
        int PRVKEY = 0;
        int KEYSTORE = 1;
        int STANDARMEMO = 2;
    }

    public interface ORIGIN_TYPE{
        int CREATE = 0; //创建
        int RESTORE = 1; //恢复
        int IMPORT = 2; //导入
        int COLDS = 3; //冷
        int NFC = 4; //nfc
        int MULTISIGN = 5; //预留多签
    }

    public interface CODE_H5_TRANSFER {
        // 转账成功
        int succeed200 = 200;
        // 程序异常
        int failed400 = 400;
        // 转账失败
        int failed401 = 401;
        // 余额不足，转账失败
        int notSufficientFunds402 = 402;
        // 取消交易（中途取消交易操作）
        int giveupPay403 = 403;
    }

    /**
     * 网络请求响应码
     */
    public interface NET_RESULT_CODE {
        int STATUS_CODE_200 = 200;// 请求成功
        int STATUS_CODE_400 = 400;// 请求异常
        int STATUS_CODE_404 = 404;// 请求失败
    }


    public interface VDNS_OPTION_ADDRESS_TYPE {
        int SELECT = 0;
        int REPLASE = 1;
        int VDAIN = 2;
    }

    public interface VDNS_OPTION{
        //设置地址权限
        public static final int CODE_SETADDRESS_PERMISSIONS = 0;
        // 注册一级域名
        public static final int CODE_PAYTOPLEVEL = 1;
        // 域名续费
        public static final int CODE_RENEW = 2;
        // 添加子域名
        public static final int CODE_PAYSUBLEVEL = 3;
        // 转让域名
        public static final int CODE_SETCONTROLLER= 4;
        // 点击复制
        public static final int CODE_CLICKCOPY= 5;
        // 点击扫码
        public static final int CODE_SCANADDRESS= 6;
        // 切换did地址
        public static final int CODE_SWITCH_DID_ADDRESS= 7;
        // 删除二级域名
        public static final int CODE_DELSUBLEVEL= 8;
        // 变更二级域名
        public static final int CODE_SETCONTROLLERSUBLEVEL= 9;
    }

    /**
     * web的url
     */
    public interface WEB_PARAM {
        // 积分兑换
//        String REDEEM_URL = "file:///android_asset/javascript.html";
        String REDEEM_URL = "http://192.168.0.179/h5/exchange.html";

        // 8am地址
        String EIGHT_AM_URL = "http://wallet.8amfund.com/coinid?lang=hk";
        String LOCAL_EIGHT_AM_URL = "file:///android_asset/javascript.html";
        // eth代币签名
        String ETH_TOKEN_SIGNATURE = "ethTokenSignature";
        // 获取eth地址
        String GET_ETH_ADDRESS = "getEthAddress";
        // 获取eth地址
        String GET_GPS_ADDRESS = "getGpsAddress";

        // 与h5交互时的主币类型
        int BTC_CHAINTYPE = 1;
        int ETH_CHAINTYPE = 2;
        int EOS_CHAINTYPE = 3;
        int GPS_CHAINTYPE = 4;
    }

    /**
     * intent传递参数
     */
    public interface INTENT_PARAM {
        // 是否分享
        String IS_SHARE = "is_share_intent_param";
        // 分享链接
        String TITLE = "title";
        // 分享链接
        String SHARE_URL = "url";
        // 分享描述
        String SHARE_DES = "des";
        // 助记词语言类型 0：中文 1：英文
        String INTENT_CODE_MNEMONIC_WORD_LANGUAGE_TYPE = "intent_code_mnemonic_word_language_type";
        // 助记词长度（12、18、24位）
        String INTENT_CODE_MNEMONIC_WORD_LENGTH = "intent_code_mnemonic_word_length";
        String INTENT_SETINGS_TYPE = "intent_setings_type";
        // 帮其他人支付注册EOS账户标识
        String INTENT_REGISTER_EOS_ACCOUNT_FLAG = "intent_register_eos_account_flag";
        // 注册EOS账户-bean
        String INTENT_REGISTER_EOS_ACCOUNT_BEAN = "intent_register_eos_account_bean";
        // 返回给h5的数据bean
        String RETURN_TO_JS_SIGN_BEAN = "returnToJsSignBean";
        // 交易号 trxid
        String TRXID = "trxid";
        // 币种交易类型
        String TRANSACTION_TYPE = "transaction_type";
        // 交易号签名
        String WALLETSIG = "intent_walletsig";
        // 标识是否为其他人注册
        String IS_OTHER_REGISTER_FLAG = "isOtherRegisterFlag";
        // 标识是哪一种类型的主币转账
        String H5_TRANSACTION_TYPE = "h5_transaction_type";
        // 是否取消交易
        String IS_CANCEL_TRANSACTION = "isCancelTransaction";
        // 是否从h5商城跳转
        String IS_SHOP = "is_shop";
        // 是否从VDNS跳转
        String IS_VDNS = "is_vdns";
        // 是否被pos机扫码
        String isPosScan = "intent_is_pos_scan";
        // 是否显示协议和隐私
        String IS_AGREEMENT_OR_PRIVACY = "is_agreement_or_privacy";
        // 签名密钥
        String PRV_KEY = "private_key";
        // 钱包密码
        String PIN = "pin";
        // 钱包类型
        String ORIGIN_TYPE = "origin_type";
    }
}
