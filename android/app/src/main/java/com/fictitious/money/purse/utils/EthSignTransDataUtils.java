package com.fictitious.money.purse.utils;

import android.text.TextUtils;

import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.model.TransactionEthParam;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class EthSignTransDataUtils {

    /**
     * 热钱包eth签名
     *
     * @param p_nonce    第几笔交易， 如“800” ， 代表第 800 笔交易
     * @param p_gasprice Gas 价格， 如“2000000000”
     * @param p_startgas Gas limit， 如“21000”
     * @param to         转账的地址， 类似 0x97b2E2e9C561a659F96EC79161E9DF016117D6Ec
     * @param p_value    转账数目
     * @param p_data     转账备注
     * @param p_chainId  网络 ID， 测试网为 4
     * @param signPrvKey 32 字节私钥
     */
    public static TransactionEthParam signEthTransaction(String p_nonce, String p_gasprice, String p_startgas,
                                                         String to, String p_value, byte[] p_data, String p_chainId,
                                                         byte[] signPrvKey) {
        byte[] b_nonce = CommonUtil.strToByteArray(p_nonce);
        byte[] b_gasprice = CommonUtil.strToByteArray(p_gasprice);
        byte[] b_startgas = CommonUtil.strToByteArray(p_startgas);
        if (to.startsWith("0x")) {
            to = to.replace("0x", "");
        }
        byte[] b_to = CommonUtil.strToByteArray(to);
        byte[] b_value = CommonUtil.strToByteArray(p_value);
        byte[] b_chainId = CommonUtil.strToByteArray(p_chainId);

        byte[] result_byte = XMHCoinUtitls.CoinID_sigtEthTransaction(b_nonce, (short) b_nonce.length,
                b_gasprice, (short) b_gasprice.length, b_startgas, (short) b_startgas.length, b_to, b_value,
                (short) b_value.length, p_data, (short) p_data.length, b_chainId, (short) b_chainId.length, signPrvKey);
        String result_str = new String(result_byte);

        if (!TextUtils.isEmpty(result_str)) {
            TransactionEthParam transactionBtcParam = new TransactionEthParam();
            transactionBtcParam.setId(1);
            transactionBtcParam.setJsonrpc("2.0");
            transactionBtcParam.setMethod("eth_sendRawTransaction");
            List<String> list = new ArrayList<>();
            list.add("0x" + result_str);
            transactionBtcParam.setParams(list);

            return transactionBtcParam;
        }

        return null;
    }

    /**
     * 热钱包vns签名
     *
     * @param p_nonce    第几笔交易， 如“800” ， 代表第 800 笔交易
     * @param p_gasprice Gas 价格， 如“2000000000”
     * @param p_startgas Gas limit， 如“21000”
     * @param to         转账的地址， 类似 0x97b2E2e9C561a659F96EC79161E9DF016117D6Ec
     * @param p_value    转账数目
     * @param p_data     转账备注
     * @param p_chainId  网络 ID， 测试网为 4
     * @param signPrvKey 32 字节私钥
     */
    public static TransactionEthParam signVnsTransaction(String p_nonce, String p_gasprice, String p_startgas,
                                                         String to, String p_value, byte[] p_data, String p_chainId,
                                                         byte[] signPrvKey) {
        byte[] b_nonce = CommonUtil.strToByteArray(p_nonce);
        byte[] b_gasprice = CommonUtil.strToByteArray(p_gasprice);
        byte[] b_startgas = CommonUtil.strToByteArray(p_startgas);
        if (to.startsWith("0x")) {
            to = to.replace("0x", "");
        }
        byte[] b_to = CommonUtil.strToByteArray(to);
        byte[] b_value = CommonUtil.strToByteArray(p_value);
        byte[] b_chainId = CommonUtil.strToByteArray(p_chainId);

        byte[] result_byte = XMHCoinUtitls.CoinID_sigtEthTransaction(b_nonce, (short) b_nonce.length,
                b_gasprice, (short) b_gasprice.length, b_startgas, (short) b_startgas.length, b_to, b_value,
                (short) b_value.length, p_data, (short) p_data.length, b_chainId, (short) b_chainId.length, signPrvKey);
        String result_str = new String(result_byte);

        if (!TextUtils.isEmpty(result_str)) {
            TransactionEthParam transactionBtcParam = new TransactionEthParam();
            transactionBtcParam.setId(1);
            transactionBtcParam.setJsonrpc("2.0");
            transactionBtcParam.setMethod("vns_sendRawTransaction");
            List<String> list = new ArrayList<>();
            list.add("0x" + result_str);
            transactionBtcParam.setParams(list);

            return transactionBtcParam;
        }

        return null;
    }
    /** 热钱包eth签名
     * @param p_nonce 第几笔交易， 如“800” ， 代表第 800 笔交易
     * @param p_gasprice Gas 价格， 如“2000000000”
     * @param p_startgas Gas limit， 如“21000”
     * @param to 转账的地址， 类似 0x97b2E2e9C561a659F96EC79161E9DF016117D6Ec
     * @param p_value 转账数目
     * @param p_data 转账备注
     * @param p_chainId 网络 ID， 测试网为 4
     * @param prvKey 当前钱包秘钥
     * @param pin 交易密码
     */
    public TransactionEthParam sigtEthTransaction(String p_nonce, String p_gasprice, String p_startgas, String to, String p_value, byte[] p_data, String p_chainId, String prvKey, String pin)
    {

        String prvkeyStr = CommonUtil.byteArrayToStr(DigitalTrans.decKeyByAES128CBC(HexUtil.hexStringToBytes(prvKey), pin, Constants.COIN_TYPE.TYPE_ETH));
        byte[] prvKeyByte = DigitalTrans.hex2byte(prvkeyStr);
        byte[] eth_byte = XMHCoinUtitls.CoinID_ImportETHPrvKey(prvKeyByte);
        //私钥
        byte[] signPrvKey = new byte[32];
        System.arraycopy(eth_byte, 0, signPrvKey, 0 , signPrvKey.length);

        byte[] b_nonce = CommonUtil.strToByteArray(p_nonce);
        byte[] b_gasprice = CommonUtil.strToByteArray(p_gasprice);
        byte[] b_startgas = CommonUtil.strToByteArray(p_startgas);
        if(to.startsWith("0x"))
        {
            to = to.replace("0x", "");
        }
        byte[] b_to = CommonUtil.strToByteArray(to);
        byte[] b_value = CommonUtil.strToByteArray(p_value);
        byte[] b_chainId = CommonUtil.strToByteArray(p_chainId);

        byte[] result_byte = XMHCoinUtitls.CoinID_sigtEthTransaction(b_nonce, (short) b_nonce.length, b_gasprice, (short)b_gasprice.length, b_startgas, (short)b_startgas.length, b_to, b_value, (short)b_value.length, p_data, (short)p_data.length, b_chainId, (short)b_chainId.length, signPrvKey);
        String result_str = new String(result_byte);
        if(!TextUtils.isEmpty(result_str))
        {
            TransactionEthParam transactionBtcParam = new TransactionEthParam();
            transactionBtcParam.setId(1);
            transactionBtcParam.setJsonrpc("2.0");
            transactionBtcParam.setMethod("eth_sendRawTransaction");
            List<String> list = new ArrayList<>();
            list.add("0x"+result_str);
            transactionBtcParam.setParams(list);

            return transactionBtcParam;
        }

        return null;
    }

    /**
     * 热钱包eth代币签名
     * @param decimals
     * @param p_nonce 第几笔交易， 如“800” ， 代表第 800 笔交易
     * @param p_gasprice Gas 价格， 如“2000000000”
     * @param p_startgas Gas limit， 如“21000”
     * @param contract 代币合约地址
     * @param p_chainId 网络 ID， 测试网为 4
     * @param to 转账的地址， 类似 0x97b2E2e9C561a659F96EC79161E9DF016117D6Ec
     * @param amount 转账数目
     * @param prvKey 当前钱包秘钥
     * @param pin 交易密码
     * @return
     */
    public TransactionEthParam sigtERCTransaction(int decimals, String p_nonce, String p_gasprice, String p_startgas,
                                                  String contract, String p_chainId, String to, String amount,
                                                  String prvKey, String pin)
    {
        byte[] dataByte = getDataByte(to, amount, decimals);
        if(dataByte != null && dataByte.length > 0)
        {
            return sigtEthTransaction(String.valueOf(p_nonce), p_gasprice, p_startgas, contract, "0", dataByte, p_chainId, prvKey, pin);
        }

        return null;
    }

    /**
     * 热钱包Vdns购买签名
     * @param p_nonce 第几笔交易， 如“800” ， 代表第 800 笔交易
     * @param p_gasprice Gas 价格， 如“2000000000”
     * @param p_startgas Gas limit， 如“21000”
     * @param p_chainId 网络 ID， 测试网为 4
     * @param to 转账的地址， 类似 0x97b2E2e9C561a659F96EC79161E9DF016117D6Ec
     * @param amount 转账数目
     * @param prvKey 当前钱包对象
     * @param pin 交易密码
     * @return
     */
    public TransactionEthParam sigtVdnsERCTransaction(String p_nonce, String p_gasprice, String p_startgas,
                                                      String p_chainId, String to, String amount, String year,
                                                      String vnsd, int payType, String token, String address, String addressType, String prvKey, String pin)
    {
        byte[] dataByte = null;
        if(payType == Constants.VDNS_OPTION.CODE_PAYTOPLEVEL){
            if("VNS".equals(token)){
                dataByte = getPayVnsDataByte(year, vnsd);
            } else {
                dataByte = getPayVpDataByte(year, amount, vnsd);
            }
        } else if(payType == Constants.VDNS_OPTION.CODE_RENEW){
            if("VNS".equals(token)){
                dataByte = getRenewDataByte(year, vnsd);
            } else {
                dataByte = getRenewDataByteVp(year, amount, vnsd);
            }
        } else if(payType == Constants.VDNS_OPTION.CODE_PAYSUBLEVEL){
            dataByte = getSubNameDataByte(vnsd, address, addressType);
        } else if(payType == Constants.VDNS_OPTION.CODE_SETCONTROLLER){
            dataByte = getSetControllerDataByte(vnsd, address);
        } else if(payType == Constants.VDNS_OPTION.CODE_DELSUBLEVEL){
            dataByte = getDelSubLevelDataByte(vnsd);
        } else {
            String data = "095ea7b3000000000000000000000000" + to.replace("0x", "") + "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
            dataByte = HexUtil.hexStringToBytes(data);
        }

        if(dataByte != null && dataByte.length > 0)
        {
            String prvkeyStr = CommonUtil.byteArrayToStr(DigitalTrans.decKeyByAES128CBC(HexUtil.hexStringToBytes(prvKey), pin, Constants.COIN_TYPE.TYPE_ETH));
            byte[] prvKeyByte = DigitalTrans.hex2byte(prvkeyStr);
            byte[] eth_byte = XMHCoinUtitls.CoinID_ImportETHPrvKey(prvKeyByte);
            //私钥
            byte[] signPrvKey = new byte[32];
            System.arraycopy(eth_byte, 0, signPrvKey, 0 , signPrvKey.length);
            if("VNS".equals(token)){
                return signVnsTransaction(String.valueOf(p_nonce), p_gasprice, p_startgas, to, String.valueOf(new BigDecimal(amount).multiply(new BigDecimal("1000000000000000000")).setScale( 0, BigDecimal.ROUND_HALF_UP)), dataByte, p_chainId, signPrvKey);
            } else {
                return signVnsTransaction(String.valueOf(p_nonce), p_gasprice, p_startgas, to, "0", dataByte, p_chainId, signPrvKey);
            }
        }
        return null;
    }

    public TransactionEthParam sigtBanKerERCTransaction(String p_nonce, String p_gasprice, String p_startgas,
                                                        String p_chainId, String connector, String bancorconvert, byte[] signPrvKey)
    {
        Logger.e(getClass().getSimpleName(),"==p_nonce==" + p_nonce);
        Logger.e(getClass().getSimpleName(),"==p_gasprice==" + p_gasprice);
        Logger.e(getClass().getSimpleName(),"==p_startgas==" + p_startgas);
        Logger.e(getClass().getSimpleName(),"==p_chainId==" + p_chainId);
        Logger.e(getClass().getSimpleName(),"==connector==" + connector);
        Logger.e(getClass().getSimpleName(),"==bancorconvert==" + bancorconvert);
        String data = "095ea7b3000000000000000000000000" + bancorconvert.replace("0x", "") + "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
        byte[] dataByte = HexUtil.hexStringToBytes(data);
        Logger.e(getClass().getSimpleName(),"==dataByte==" + HexUtil.formatHexString(dataByte));
        if(dataByte != null && dataByte.length > 0) {
            return signVnsTransaction(String.valueOf(p_nonce), p_gasprice, p_startgas, connector, "0", dataByte, p_chainId, signPrvKey);
        }
        return null;
    }

    /**
     * 用vns购买vdns
     * @param vdns
     * @param year
     * @return
     */
    byte[] getPayVnsDataByte(String year, String vdns){
        String scaiiVdns = DigitalTrans.StringToAsciiString(vdns);
        byte[] vdnsByte = DigitalTrans.AsciiToHex(scaiiVdns);
        byte[] data = new byte[132];
        data[0] = (byte) 0x55;
        data[1] = (byte) 0x51;
        data[2] = (byte) 0xa3;
        data[3] = (byte) 0xb8;
        data[35] = (byte) 0x40;
        byte[] byteYear = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(year));
        int yStarIndex = 68 - byteYear.length;
        System.arraycopy(byteYear, 0, data, yStarIndex, byteYear.length);//购买年数
        data[99] = HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(vdnsByte.length))[0];//vdns的长度
        System.arraycopy(vdnsByte, 0, data, 100, vdnsByte.length);
        return data;
    }

    /**
     * 用vns续费vdns
     * @param year
     * @param vdns
     * @return
     */
    byte[] getRenewDataByte(String year, String vdns){
        String scaiiVdns = DigitalTrans.StringToAsciiString(vdns);
        byte[] vdnsByte = DigitalTrans.AsciiToHex(scaiiVdns);
        byte[] data = new byte[132];
        data[0] = (byte) 0x86;
        data[1] = (byte) 0x7f;
        data[2] = (byte) 0x32;
        data[3] = (byte) 0x47;
        data[35] = (byte) 0x40;
        byte[] byteYear = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(year));
        int yStarIndex = 68 - byteYear.length;
        System.arraycopy(byteYear, 0, data, yStarIndex, byteYear.length);//购买年数
        data[99] = HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(vdnsByte.length))[0];//vdns的长度
        System.arraycopy(vdnsByte, 0, data, 100, vdnsByte.length);
        return data;
    }

    /**
     * 转让子域名
     * @param vdns
     * @param address
     * @return
     */
    byte[] getSetControllerDataByte(String vdns, String address){
        if(TextUtils.isEmpty(vdns) || TextUtils.isEmpty(address)){
            return new byte[0];
        }

        String scaiiVdns = DigitalTrans.StringToAsciiString(vdns);
        byte[] vdnsByte = DigitalTrans.AsciiToHex(scaiiVdns);
        byte[] addrByte = HexUtil.hexStringToBytes(address.replace("0x", ""));
        byte[] data = new byte[132];
        data[0] = (byte) 0x87;
        data[1] = (byte) 0xb8;
        data[2] = (byte) 0x0b;
        data[3] = (byte) 0xa0;
        data[35] = (byte) 0x40;
        int yStarIndex = 68 - addrByte.length;
        System.arraycopy(addrByte, 0, data, yStarIndex, addrByte.length);
        data[99] = HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(vdnsByte.length))[0];//vdns的长度
        System.arraycopy(vdnsByte, 0, data, 100, vdnsByte.length);
        return data;
    }

    byte[] getDelSubLevelDataByte(String vdns){
        String scaiiVdns = DigitalTrans.StringToAsciiString(vdns);
        byte[] vdnsByte = DigitalTrans.AsciiToHex(scaiiVdns);
        byte[] data = new byte[100];
        data[0] = (byte) 0x98;
        data[1] = (byte) 0xbb;
        data[2] = (byte) 0x61;
        data[3] = (byte) 0x91;
        data[35] = (byte) 0x20;
        data[67] = HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(vdnsByte.length))[0];//vdns的长度
        System.arraycopy(vdnsByte, 0, data, 68, vdnsByte.length);
        return data;
    }

    /**
     * vdns 注册子域名
     * @param vdns
     * @return
     */
    public static byte[] getSubNameDataByte(String vdns, String address, String addrType){
        if(TextUtils.isEmpty(vdns) || TextUtils.isEmpty(address) || TextUtils.isEmpty(addrType)){
            return new byte[0];
        }
        String scaiiVdns = DigitalTrans.StringToAsciiString(vdns);
        byte[] vdnsByte = DigitalTrans.AsciiToHex(scaiiVdns);

        String scaiiAddr = DigitalTrans.StringToAsciiString(address);
        byte[] addrByte = DigitalTrans.AsciiToHex(scaiiAddr);

        String scaiiAddrType = DigitalTrans.StringToAsciiString(addrType);
        byte[] addrTypeByte = DigitalTrans.AsciiToHex(scaiiAddrType);

        //3个参数的偏移量
        byte[] deviationVdns = new byte[32];
        byte[] deviationAddress = new byte[32];
        byte[] deviationAddressType = new byte[32];

        //3个参数的字节长度
        byte[] deviationVdnsLen = new byte[32];
        byte[] deviationAddressLen = new byte[32];
        byte[] deviationAddressTypeLen = new byte[32];

        System.arraycopy(HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(vdnsByte.length)), 0, deviationVdnsLen, 32 - HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(vdnsByte.length)).length, HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(deviationVdnsLen.length)).length);
        System.arraycopy(HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(addrByte.length)), 0, deviationAddressLen, 32 - HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(addrByte.length)).length, HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(deviationAddressLen.length)).length);
        System.arraycopy(HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(addrTypeByte.length)), 0, deviationAddressTypeLen, 32 - HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(addrTypeByte.length)).length, HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(deviationAddressTypeLen.length)).length);

        int vdnsLen;
        int addrLen;
        int addrTypeLen;
        if(vdnsByte.length % 32 == 0 && vdnsByte.length > 0){
            vdnsLen = vdnsByte.length;
        } else {
            if(vdnsByte.length / 32 < 1){
                vdnsLen = 32;
            } else {
                vdnsLen = (vdnsByte.length / 32 + 1) * 32;
            }
        }

        if(addrByte.length % 32 == 0 && addrByte.length > 0){
            addrLen = addrByte.length;
        } else {
            if(addrByte.length / 32 < 1){
                addrLen = 32;
            } else {
                addrLen = (addrByte.length / 32 + 1) * 32;
            }
        }

        if(addrTypeByte.length % 32 == 0 && addrTypeByte.length > 0){
            addrTypeLen = addrTypeByte.length;
        } else {
            if(addrTypeByte.length / 32 < 1){
                addrTypeLen = 32;
            } else {
                addrTypeLen = (addrTypeByte.length / 32 + 1) * 32;
            }
        }

        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==vdnsLen==" + vdnsLen);
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==addrLen==" + addrLen);
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==addrTypeLen==" + addrTypeLen);

        byte[] deviationVdnsData = new byte[vdnsLen];
        byte[] deviationAddressData = new byte[addrLen];
        byte[] deviationAddressTypeData = new byte[addrTypeLen];

        System.arraycopy(vdnsByte, 0, deviationVdnsData, 0, vdnsByte.length);
        System.arraycopy(addrByte, 0, deviationAddressData, 0, addrByte.length);
        System.arraycopy(addrTypeByte, 0, deviationAddressTypeData, 0, addrTypeByte.length);

        System.arraycopy(HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(deviationVdns.length + deviationAddress.length + deviationAddressType.length)), 0, deviationVdns, 32 - HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(deviationVdns.length + deviationAddress.length + deviationAddressType.length)).length, HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(deviationVdns.length + deviationAddress.length + deviationAddressType.length)).length);
        System.arraycopy(HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(96 + deviationVdnsData.length + deviationVdnsLen.length)), 0, deviationAddress, 32 - HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(96 + deviationVdnsData.length + deviationVdnsLen.length)).length, HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(96 + deviationVdnsData.length + deviationVdnsLen.length)).length);
        System.arraycopy(HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(96 + deviationVdnsData.length + deviationVdnsLen.length + deviationAddressData.length + deviationAddressLen.length)), 0, deviationAddressType, 32 - HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(96 + deviationVdnsData.length + deviationVdnsLen.length + deviationAddressData.length + deviationAddressLen.length)).length, HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(96 + deviationVdnsData.length + deviationVdnsLen.length + deviationAddressData.length + deviationAddressLen.length)).length);

        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==vdnsByte==" + HexUtil.formatHexString(vdnsByte));
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==addrByte==" + HexUtil.formatHexString(addrByte));
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==addrTypeByte==" + HexUtil.formatHexString(addrTypeByte));

        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==deviationVdns==" + HexUtil.formatHexString(deviationVdns));
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==deviationAddress==" + HexUtil.formatHexString(deviationAddress));
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==deviationAddressType==" + HexUtil.formatHexString(deviationAddressType));

        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==deviationVdnsLen==" + HexUtil.formatHexString(deviationVdnsLen));
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==deviationAddressLen==" + HexUtil.formatHexString(deviationAddressLen));
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==deviationAddressTypeLen==" + HexUtil.formatHexString(deviationAddressTypeLen));

        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==deviationVdnsData==" + HexUtil.formatHexString(deviationVdnsData));
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==deviationAddressData==" + HexUtil.formatHexString(deviationAddressData));
        Logger.e(EthSignTransDataUtils.class.getSimpleName(),"==deviationAddressTypeData==" + HexUtil.formatHexString(deviationAddressTypeData));

        byte[] data = new byte[4 + deviationVdns.length + deviationAddress.length + deviationAddressType.length
                + deviationVdnsLen.length + deviationAddressLen.length + deviationAddressTypeLen.length
                + deviationVdnsData.length + deviationAddressData.length + deviationAddressTypeData.length];
        data[0] = (byte) 0x89;
        data[1] = (byte) 0xfe;
        data[2] = (byte) 0xfd;
        data[3] = (byte) 0x96;

        System.arraycopy(deviationVdns, 0, data, 4, deviationVdns.length);
        System.arraycopy(deviationAddress, 0, data, 4 + deviationVdns.length, deviationAddress.length);
        System.arraycopy(deviationAddressType, 0, data, 4 + deviationVdns.length + deviationAddress.length, deviationAddressType.length);

        System.arraycopy(deviationVdnsLen, 0, data, 4 + deviationVdns.length + deviationAddress.length + deviationAddressType.length, deviationVdnsLen.length);
        System.arraycopy(deviationVdnsData, 0, data, 4 + deviationVdns.length + deviationAddress.length + deviationAddressType.length + deviationVdnsLen.length, deviationVdnsData.length);

        System.arraycopy(deviationAddressLen, 0, data, 4 + deviationVdns.length + deviationAddress.length + deviationAddressType.length + deviationVdnsLen.length + deviationVdnsData.length, deviationAddressLen.length);
        System.arraycopy(deviationAddressData, 0, data, 4 + deviationVdns.length + deviationAddress.length + deviationAddressType.length + deviationVdnsLen.length + deviationVdnsData.length + deviationAddressLen.length, deviationAddressData.length);

        System.arraycopy(deviationAddressTypeLen, 0, data, 4 + deviationVdns.length + deviationAddress.length + deviationAddressType.length + deviationVdnsLen.length + deviationVdnsData.length + deviationAddressLen.length + deviationAddressData.length, deviationAddressTypeLen.length);
        System.arraycopy(deviationAddressTypeData, 0, data, 4 + deviationVdns.length + deviationAddress.length + deviationAddressType.length + deviationVdnsLen.length + deviationVdnsData.length + deviationAddressLen.length + deviationAddressData.length + deviationAddressTypeLen.length, deviationAddressTypeData.length);

        return data;
    }

    /**
     *  用vp购买vdns
     */
    byte[] getPayVpDataByte(String year, String money, String vdns){
        String scaiiVdns = DigitalTrans.StringToAsciiString(vdns);
        byte[] vdnsByte = DigitalTrans.AsciiToHex(scaiiVdns);
        byte[] data = new byte[164];
        data[0] = (byte) 0xf2;
        data[1] = (byte) 0x2d;
        data[2] = (byte) 0x2d;
        data[3] = (byte) 0x99;
        data[35] = (byte) 0x60;
        byte[] byteYear = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(year));
        int yStarIndex = 68 - byteYear.length;
        System.arraycopy(byteYear, 0, data, yStarIndex, byteYear.length);//购买年数

        byte[] moneyYear = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(new BigDecimal(money).multiply(new BigDecimal(Math.pow(10, 18))).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString()));
        int mStarIndex = 100 - moneyYear.length;
        System.arraycopy(moneyYear, 0, data, mStarIndex, moneyYear.length);//购买金额

        data[131] = HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(vdnsByte.length))[0];//vdns的长度
        System.arraycopy(vdnsByte, 0, data, 132, vdnsByte.length);
        return data;
    }

    //用vp续费vdns
    byte[] getRenewDataByteVp(String year, String money, String vdns){
        String scaiiVdns = DigitalTrans.StringToAsciiString(vdns);
        byte[] vdnsByte = DigitalTrans.AsciiToHex(scaiiVdns);
        byte[] data = new byte[164];
        data[0] = (byte) 0x03;
        data[1] = (byte) 0xb1;
        data[2] = (byte) 0x84;
        data[3] = (byte) 0xd2;
        data[35] = (byte) 0x60;
        byte[] byteYear = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(year));
        int yStarIndex = 68 - byteYear.length;
        System.arraycopy(byteYear, 0, data, yStarIndex, byteYear.length);//购买年数

        byte[] moneyYear = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(new BigDecimal(money).multiply(new BigDecimal(Math.pow(10, 18))).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString()));
        int mStarIndex = 100 - moneyYear.length;
        System.arraycopy(moneyYear, 0, data, mStarIndex, moneyYear.length);//购买金额

        data[131] = HexUtil.hexStringToBytes(DigitalTrans.algorismToHEXString(vdnsByte.length))[0];//vdns的长度
        System.arraycopy(vdnsByte, 0, data, 132, vdnsByte.length);
        return data;
    }

    byte[] getDataByte(String to, String amount, int decimals)
    {
        // erc 2.0 代币的转账
        // value 传0
        // to 合约地址
        // data 三部分
        // MethodDID：0xa9059cbb
        // 收款地址 32位字节
        // 金额  32位字节

        byte[] byteData = new byte[68];
        byteData[0] = (byte)0xa9;
        byteData[1] = (byte)0x05;
        byteData[2] = (byte)0x9c;
        byteData[3] = (byte)0xbb;

        if(to.startsWith("0x"))
        {
            to = to.replace("0x", "");
        }

        byte[] resultByteAccount = new byte[32];
        byte[] byteAccount;
        try
        {
            byteAccount = DigitalTrans.toBytes(to);
        }
        catch (Exception e)
        {
            return null;
        }
        System.arraycopy(byteAccount, 0, resultByteAccount, resultByteAccount.length - byteAccount.length, byteAccount.length);

        byte[] resultByteMoney = new byte[32];
        byte[] byteMoney = DigitalTrans.toBytes(DigitalTrans.algorismToHEXString(new BigDecimal(amount).multiply(new BigDecimal(Math.pow(10, decimals))).setScale( 0, BigDecimal.ROUND_HALF_UP).intValue()));
        System.arraycopy(byteMoney, 0, resultByteMoney, resultByteMoney.length - byteMoney.length, byteMoney.length);

        System.arraycopy(resultByteAccount, 0, byteData, 4, resultByteAccount.length);
        System.arraycopy(resultByteMoney, 0, byteData, 36, resultByteMoney.length);

        return byteData;
    }
}
