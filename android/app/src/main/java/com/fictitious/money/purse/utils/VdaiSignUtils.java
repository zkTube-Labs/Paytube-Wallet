package com.fictitious.money.purse.utils;

import android.text.TextUtils;

import com.fictitious.money.purse.model.MinerFeeBean;

import java.math.BigDecimal;
import java.math.BigInteger;

/**
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-11-14 17:05
 * Description: Vdai交易签名
 */
public class VdaiSignUtils {
    private static final String TAG = VdaiSignUtils.class.getSimpleName();

    /**
     * 创建/存入
     */
    public static String vnsJoin_join(MinerFeeBean bean, String vnsAddress, String contract, String money, int decimals, byte[] signPrvKey) {
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }

        // 28ffe6c8
        byte[] byteData = new byte[36];
        byteData[0] = (byte) 0x28;
        byteData[1] = (byte) 0xff;
        byteData[2] = (byte) 0xe6;
        byteData[3] = (byte) 0xc8;

        byte[] byte1 = new byte[32];
        byte[] byteTokenAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteTokenAddress, 0, byte1, byte1.length - byteTokenAddress.length, byteTokenAddress.length);


        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byte1, 0, byteData, 4, byte1.length);

        String data = HexUtil.encodeHexStr(byteData);
        Logger.e(TAG, "vnsJoin_join 拼接：" + data);

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, contract, String.valueOf(new BigDecimal(money).multiply(new BigDecimal(10).pow(decimals)).setScale(0, BigDecimal.ROUND_HALF_UP)), data, p_chainId, HexUtil.encodeHexStr(signPrvKey));

        Logger.e(TAG, p_nonce + "vnsJoin_join 签名：" + result_str);
        return result_str;
    }

    /**
     * 关闭
     */
    public static String vusdJoin_join(MinerFeeBean bean, String vnsAddress, String contract, String hex, byte[] signPrvKey) {
        hex = DigitalTrans.patchHexString(hex, 64);
        Logger.e(TAG, "vusdJoin_join 64位hex：" + hex);
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }

        // 3b4da69f
        byte[] byteData = new byte[36];
        byteData[0] = (byte) 0x3b;
        byteData[1] = (byte) 0x4d;
        byteData[2] = (byte) 0xa6;
        byteData[3] = (byte) 0x9f;

        byte[] byte1 = new byte[32];
        byte[] byteTokenAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteTokenAddress, 0, byte1, byte1.length - byteTokenAddress.length, byteTokenAddress.length);


        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byte1, 0, byteData, 4, byte1.length);

        String data = HexUtil.encodeHexStr(byteData) + hex;
        Logger.e(TAG, "vusdJoin_join 拼接：" + data);

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, contract, "0", data, p_chainId, HexUtil.encodeHexStr(signPrvKey));

        Logger.e(TAG, p_nonce + "vusdJoin_join 签名：" + result_str);
        return result_str;
    }

    // vusdNum 是45次方的
    public static String frobt(String vnsAddress, boolean isVnsNegation, String vnsNum, boolean isVusdNegation, String vusdNum, MinerFeeBean bean, byte[] signPrvKey) {
        Logger.e(TAG, "frob vns金额：" + vnsNum + ", vusd金额：" + vusdNum);
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }
        String vatContractAddress = "ec0b8d49fa29f9e675823d0ee464df16bcf044d1";

        // 62212f22
        byte[] byteData = new byte[196];
        byteData[0] = (byte) 0x62;
        byteData[1] = (byte) 0x21;
        byteData[2] = (byte) 0x2f;
        byteData[3] = (byte) 0x22;

        // 564e53
        byte[] byte0 = new byte[32];
        byte0[0] = (byte) 0x56;
        byte0[1] = (byte) 0x4e;
        byte0[2] = (byte) 0x53;

        // vns地址
        byte[] byte1 = new byte[32];
        byte[] byte2 = new byte[32];
        byte[] byte3 = new byte[32];
        byte[] byteVnsAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteVnsAddress, 0, byte1, byte1.length - byteVnsAddress.length, byteVnsAddress.length);
        System.arraycopy(byteVnsAddress, 0, byte2, byte2.length - byteVnsAddress.length, byteVnsAddress.length);
        System.arraycopy(byteVnsAddress, 0, byte3, byte3.length - byteVnsAddress.length, byteVnsAddress.length);

        byte[] byte4 = new byte[32];
        String vnsDecimalism = new BigDecimal(vnsNum).multiply(new BigDecimal(10).pow(18)).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
        // vns金额
        if (isVnsNegation) {// 是否取反
            String negationHex = DigitalTrans.negationHex(DigitalTrans.bigIntegerToHEXString(vnsDecimalism));
            String decimalismVnsString = new BigInteger(negationHex, 16).toString(10);
            byte[] byteVnsMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(decimalismVnsString));
            // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
            System.arraycopy(byteVnsMoney, 0, byte4, byte4.length - byteVnsMoney.length, byteVnsMoney.length);
            Logger.e(TAG, "vns金额取反 :" + HexUtil.encodeHexStr(byte4));

        } else {
            byte[] byteVnsMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(vnsDecimalism));
            // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
            System.arraycopy(byteVnsMoney, 0, byte4, byte4.length - byteVnsMoney.length, byteVnsMoney.length);
            Logger.e(TAG, "byte4 :" + HexUtil.encodeHexStr(byte4));
        }

        // vusd金额
        byte[] byte5 = new byte[32];
        String vusdDecimalism = new BigDecimal(vusdNum).multiply(new BigDecimal(10).pow(45)).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
        if (isVusdNegation) {
            String negationHex = DigitalTrans.negationHex(DigitalTrans.bigIntegerToHEXString(vusdDecimalism));
            String decimalismVusdString = new BigInteger(negationHex, 16).toString(10);
            byte[] byteVusdMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(decimalismVusdString));
            // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
            System.arraycopy(byteVusdMoney, 0, byte5, byte5.length - byteVusdMoney.length, byteVusdMoney.length);
            Logger.e(TAG, "vusd金额取反 :" + HexUtil.encodeHexStr(byte5));

        } else {
            byte[] byteVusdMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(vusdDecimalism));
            // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
            System.arraycopy(byteVusdMoney, 0, byte5, byte5.length - byteVusdMoney.length, byteVusdMoney.length);
            Logger.e(TAG, "byte5 :" + HexUtil.encodeHexStr(byte5));
        }


        System.arraycopy(byte0, 0, byteData, 4, byte0.length);
        System.arraycopy(byte1, 0, byteData, 4 + byte0.length, byte1.length);
        System.arraycopy(byte2, 0, byteData, 4 + byte0.length + byte1.length, byte2.length);
        System.arraycopy(byte3, 0, byteData, 4 + byte0.length + byte1.length + byte2.length, byte3.length);
        System.arraycopy(byte4, 0, byteData, 4 + byte0.length + byte1.length + byte2.length + byte3.length, byte4.length);
        System.arraycopy(byte5, 0, byteData, 4 + byte0.length + byte1.length + byte2.length + byte3.length + byte4.length, byte5.length);


        String data = HexUtil.encodeHexStr(byteData);
        Logger.e(TAG, "frobt 拼接：" + data);

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, vatContractAddress, "0", data, p_chainId, HexUtil.encodeHexStr(signPrvKey));

        Logger.e(TAG, p_nonce + " frobt 签名：" + result_str);
        return result_str;
    }

    /**
     * 带负数的hex
     * 取vns、偿还、关闭
     */
    public static String vat_frobt(String vnsAddress, boolean isDinkNegation, String dinkHex, boolean isDartNegation, String dartHex, MinerFeeBean bean, byte[] signPrvKey) {

        if (isDinkNegation) {
            dinkHex = DigitalTrans.negationHex(dinkHex);
        } else {
            dinkHex = DigitalTrans.patchHexString(dinkHex, 64);
        }

        if (isDartNegation) {
            dartHex = DigitalTrans.negationHex(dartHex);
        } else {
            dartHex = DigitalTrans.patchHexString(dartHex, 64);
        }

        Logger.e(TAG, "vat_frobt DinkHex：" + dinkHex + ", dartHex：" + dartHex);
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }
        String vatContractAddress = "ec0b8d49fa29f9e675823d0ee464df16bcf044d1";

        // 62212f22
        byte[] byteData = new byte[132];
        byteData[0] = (byte) 0x62;
        byteData[1] = (byte) 0x21;
        byteData[2] = (byte) 0x2f;
        byteData[3] = (byte) 0x22;

        // 564e53
        byte[] byte0 = new byte[32];
        byte0[0] = (byte) 0x56;
        byte0[1] = (byte) 0x4e;
        byte0[2] = (byte) 0x53;

        // vns地址
        byte[] byte1 = new byte[32];
        byte[] byte2 = new byte[32];
        byte[] byte3 = new byte[32];
        byte[] byteVnsAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteVnsAddress, 0, byte1, byte1.length - byteVnsAddress.length, byteVnsAddress.length);
        System.arraycopy(byteVnsAddress, 0, byte2, byte2.length - byteVnsAddress.length, byteVnsAddress.length);
        System.arraycopy(byteVnsAddress, 0, byte3, byte3.length - byteVnsAddress.length, byteVnsAddress.length);

        System.arraycopy(byte0, 0, byteData, 4, byte0.length);
        System.arraycopy(byte1, 0, byteData, 4 + byte0.length, byte1.length);
        System.arraycopy(byte2, 0, byteData, 4 + byte0.length + byte1.length, byte2.length);
        System.arraycopy(byte3, 0, byteData, 4 + byte0.length + byte1.length + byte2.length, byte3.length);


        String data = HexUtil.encodeHexStr(byteData) + dinkHex + dartHex;
        Logger.e(TAG, "vat_frobt 拼接：" + data);

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, vatContractAddress, "0", data, p_chainId, HexUtil.encodeHexStr(signPrvKey));

        Logger.e(TAG, p_nonce + "vat_frobt 签名：" + result_str);
        return result_str;
    }

    public static String exit(MinerFeeBean bean, String vnsAddress, String contract, String vnsNum, byte[] signPrvKey) {
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }

        // ef693bed
        byte[] byteData = new byte[68];
        byteData[0] = (byte) 0xef;
        byteData[1] = (byte) 0x69;
        byteData[2] = (byte) 0x3b;
        byteData[3] = (byte) 0xed;

        byte[] byte0 = new byte[32];
        byte[] byteTokenAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteTokenAddress, 0, byte0, byte0.length - byteTokenAddress.length, byteTokenAddress.length);

        // vns金额
        byte[] byte1 = new byte[32];
        if (new BigDecimal(vnsNum).doubleValue() < 0 && DigitalTrans.isValidInt(vnsNum)) {
            String hex = Integer.toHexString(new BigDecimal(vnsNum).intValue());
            Logger.e(TAG, "检测到金额为负整数，转换16进制hex：" + hex);
            byte[] byteVnsMoney = DigitalTrans.toBytes(hex);
            // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
            System.arraycopy(byteVnsMoney, 0, byte1, byte1.length - byteVnsMoney.length, byteVnsMoney.length);

        } else {
            String decimalismVnsString = new BigDecimal(vnsNum).multiply(new BigDecimal(10).pow(18)).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
            byte[] byteVnsMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(decimalismVnsString));
            // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
            System.arraycopy(byteVnsMoney, 0, byte1, byte1.length - byteVnsMoney.length, byteVnsMoney.length);

        }


        System.arraycopy(byte0, 0, byteData, 4, byte0.length);
        System.arraycopy(byte1, 0, byteData, 4 + byte0.length, byte1.length);
        String data = HexUtil.encodeHexStr(byteData);
        Logger.e(TAG, "exit 拼接：" + data);

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, contract, "0", data, p_chainId, HexUtil.encodeHexStr(signPrvKey));

        Logger.e(TAG, p_nonce + "exit 签名：" + result_str);
        return result_str;
    }

    public static String vnsJoin_exit(MinerFeeBean bean, String vnsAddress, String contract, String vnsHex, byte[] signPrvKey) {
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }

        // ef693bed
        byte[] byteData = new byte[36];
        byteData[0] = (byte) 0xef;
        byteData[1] = (byte) 0x69;
        byteData[2] = (byte) 0x3b;
        byteData[3] = (byte) 0xed;

        byte[] byte0 = new byte[32];
        byte[] byteTokenAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteTokenAddress, 0, byte0, byte0.length - byteTokenAddress.length, byteTokenAddress.length);

        System.arraycopy(byte0, 0, byteData, 4, byte0.length);

        String data = HexUtil.encodeHexStr(byteData) + vnsHex;
        Logger.e(TAG, "vnsJoin.exit 拼接：" + data);

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, contract, "0", data, p_chainId, HexUtil.encodeHexStr(signPrvKey));

        Logger.e(TAG, p_nonce + "vnsJoin.exit 签名：" + result_str);
        return result_str;
    }

    public static String vusd_allowance(String vnsAddress, String contractAddress) {
        Logger.e(TAG, "vns地址：" + vnsAddress);
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }
        if (contractAddress.startsWith("0x")) {
            contractAddress = contractAddress.replace("0x", "");
        }

        // dd62ed3e
        byte[] byteData = new byte[68];
        byteData[0] = (byte) 0xdd;
        byteData[1] = (byte) 0x62;
        byteData[2] = (byte) 0xed;
        byteData[3] = (byte) 0x3e;

        //0x60 填充32字节
        byte[] byte1 = new byte[32];
        byte[] byteVnsAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteVnsAddress, 0, byte1, byte1.length - byteVnsAddress.length, byteVnsAddress.length);


//        String contractAddress = "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68";
        byte[] byte2 = new byte[32];
        byte[] byteTokenAddress = DigitalTrans.toBytes(contractAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteTokenAddress, 0, byte2, byte2.length - byteTokenAddress.length, byteTokenAddress.length);

        System.arraycopy(byte1, 0, byteData, 4, byte1.length);
        System.arraycopy(byte2, 0, byteData, 4 + byte1.length, byte2.length);


        return "0x" + HexUtil.encodeHexStr(byteData);
    }

    public static String approve(MinerFeeBean bean, String money, String vnsTokenContractAddress, String signToAddress, byte[] signPrvKey) {
//        String vnsTokenContractAddress = "cc147bdbf6f86ad4a1c6f12aa7e4fefcb145bc68";
        // 095ea7b3
        byte[] byteData = new byte[68];
        byteData[0] = (byte) 0x09;
        byteData[1] = (byte) 0x5e;
        byteData[2] = (byte) 0xa7;
        byteData[3] = (byte) 0xb3;

        //0x60 填充32字节
        byte[] byte1 = new byte[32];
        byte[] byteTokenAddress = DigitalTrans.toBytes(vnsTokenContractAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteTokenAddress, 0, byte1, byte1.length - byteTokenAddress.length, byteTokenAddress.length);

        //hexmoney 填充32 字节
        byte[] byte2 = new byte[32];

        if (money.equals("-1")) {
            for (int i = 0; i < byte2.length; i++) {
                byte2[i] = (byte) 0xff;
            }
        } else {
            String decimalismString = new BigDecimal(money).multiply(new BigDecimal(10).pow(18)).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
            byte[] byteMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(decimalismString));
            System.arraycopy(byteMoney, 0, byte2, byte2.length - byteMoney.length, byteMoney.length);
        }

        System.arraycopy(byte1, 0, byteData, 4, byte1.length);
        System.arraycopy(byte2, 0, byteData, 4 + byte1.length, byte2.length);

        String approve = HexUtil.encodeHexStr(byteData);

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        Logger.e(TAG, p_nonce + " approve 拼接：" + approve);
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, signToAddress, "0", approve, p_chainId, HexUtil.encodeHexStr(signPrvKey));

        return result_str;
    }

    public static String hope(MinerFeeBean bean, String data, byte[] signPrvKey) {
        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, "ec0b8d49fa29f9e675823d0ee464df16bcf044d1", "0", data, p_chainId, HexUtil.encodeHexStr(signPrvKey));
        Logger.e(TAG, p_nonce + " hope 签名：" + result_str);
        return result_str;
    }

    public static String forkt(MinerFeeBean bean, String vnsAddress, String targetAddress, String ink, String art, byte[] signPrvKey) {
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }
        if (targetAddress.startsWith("0x")) {
            targetAddress = targetAddress.replace("0x", "");
        }

        byte[] byte1 = new byte[32];
        byte[] byteVnsAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteVnsAddress, 0, byte1, byte1.length - byteVnsAddress.length, byteVnsAddress.length);
        String hexVnsAddress = HexUtil.encodeHexStr(byte1);
        Logger.e(TAG, "16进制vns地址：" + hexVnsAddress);

        byte[] byte2 = new byte[32];
        byte[] byteTargetAddress = DigitalTrans.toBytes(targetAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteTargetAddress, 0, byte2, byte2.length - byteTargetAddress.length, byteTargetAddress.length);
        String hexTargetAddress = HexUtil.encodeHexStr(byte2);
        Logger.e(TAG, "16进制vns地址：" + hexTargetAddress);

        String data = "534a1de7564e530000000000000000000000000000000000000000000000000000000000" + hexVnsAddress + hexTargetAddress + ink + art;

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        Logger.e(TAG, p_nonce + " forkt 拼接：" + data);
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, "ec0b8d49fa29f9e675823d0ee464df16bcf044d1", "0", data, p_chainId, HexUtil.encodeHexStr(signPrvKey));
        Logger.e(TAG, "forkt 签名：" + result_str);
        return result_str;
    }

    public static String grep(MinerFeeBean bean, String vnsAddress, String hexRet, byte[] signPrvKey) {
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }

        byte[] byte1 = new byte[32];
        byte[] byteVnsAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteVnsAddress, 0, byte1, byte1.length - byteVnsAddress.length, byteVnsAddress.length);
        String hexVnsAddress = HexUtil.encodeHexStr(byte1);
        Logger.e(TAG, "16进制vns地址：" + hexVnsAddress);

//        byte[] byte2 = new byte[32];
//        String decimalismString = new BigDecimal(hexRet).multiply(new BigDecimal(10).pow(18)).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
//        byte[] byteMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(decimalismString));
//        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
//        System.arraycopy(byteMoney, 0, byte2, byte2.length - byteMoney.length, byteMoney.length);
//        String hexRetNum = HexUtil.encodeHexStr(byte2);
//        Logger.e(TAG, "ret数量 16进制：" + hexRetNum);

        String data = "5e2d8768564e530000000000000000000000000000000000000000000000000000000000" + hexVnsAddress + hexRet;

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        Logger.e(TAG, p_nonce + " grep 拼接：" + data);
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, "56700c91e35cf1a071b43356cb96945e13673e5c", "0", data, p_chainId, HexUtil.encodeHexStr(signPrvKey));
        Logger.e(TAG, "grep 签名：" + result_str);
        return result_str;
    }

    // vns主币签名
    public static String signVns(MinerFeeBean bean, String to, String vnsNum, byte[] signPrvKey) {
        if (to.startsWith("0x")) {
            to = to.replace("0x", "");
        }
        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());

        String decimalismString = new BigDecimal(vnsNum).multiply(new BigDecimal(10).pow(18)).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, to, decimalismString, "", p_chainId, HexUtil.encodeHexStr(signPrvKey));
        return result_str;
    }

    // vns代币签名
    public static String signToken(MinerFeeBean bean, String to, String contract, String moneny, String decimals, byte[] signPrvKey) {
        if (to.startsWith("0x")) {
            to = to.replace("0x", "");
        }
        if (contract.startsWith("0x")) {
            contract = contract.replace("0x", "");
        }
        // erc 2.0 代币的转账
        // value 传0
        // to 合约地址
        // data 三部分
        // MethodDID：0xa9059cbb
        // 收款地址 32位字节
        // 金额  32位字节

        byte[] byteData = new byte[68];
        byteData[0] = (byte) 0xa9;
        byteData[1] = (byte) 0x05;
        byteData[2] = (byte) 0x9c;
        byteData[3] = (byte) 0xbb;


        byte[] resultByteAccount = new byte[32];
        byte[] byteAccount;
        byteAccount = DigitalTrans.toBytes(to);
        System.arraycopy(byteAccount, 0, resultByteAccount, resultByteAccount.length - byteAccount.length, byteAccount.length);

        byte[] resultByteMoney = new byte[32];
        String decimalismString = new BigDecimal(moneny).multiply(new BigDecimal(Math.pow(10, Integer.parseInt(TextUtils.isEmpty(decimals) ? "0" : decimals)))).setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();
        byte[] byteMoney = DigitalTrans.toBytes(DigitalTrans.bigIntegerToHEXString(decimalismString));
        if (byteMoney != null && byteMoney.length >= 32) {
            System.arraycopy(byteMoney, 0, resultByteMoney, 0, resultByteMoney.length);
        } else {
            System.arraycopy(byteMoney, 0, resultByteMoney, resultByteMoney.length - byteMoney.length, byteMoney.length);
        }
        System.arraycopy(resultByteAccount, 0, byteData, 4, resultByteAccount.length);
        System.arraycopy(resultByteMoney, 0, byteData, 36, resultByteMoney.length);

        String p_nonce = String.valueOf(bean.getNonce());
        String p_gasprice = String.valueOf(bean.getGasPrice());
        String p_startgas = String.valueOf(bean.getEstimateGas());
        String p_chainId = String.valueOf(bean.getVersion());
        String hexStr = HexUtil.encodeHexStr(byteData);
        Logger.e(TAG, "代币签名拼接：" + hexStr);

        String result_str = XMHCoinUtitls.CoinID_sigETH_TX_by_str(p_nonce, p_gasprice, p_startgas, contract, "0", hexStr, p_chainId, HexUtil.encodeHexStr(signPrvKey));
        return result_str;
    }

    /**
     * 关闭时，查询exit余额
     */
    public static String gem(String vnsAddress) {
        if (vnsAddress.startsWith("0x")) {
            vnsAddress = vnsAddress.replace("0x", "");
        }

        byte[] byte1 = new byte[32];
        byte[] byteVnsAddress = DigitalTrans.toBytes(vnsAddress);
        // 1：要复制的数据，2：要复制数据的起始位置。3：目标数组。4：目标数组开始位置，5：要复制的数组长度
        System.arraycopy(byteVnsAddress, 0, byte1, byte1.length - byteVnsAddress.length, byteVnsAddress.length);
        String hexVnsAddress = HexUtil.encodeHexStr(byte1);

        String result = "214414d5564E530000000000000000000000000000000000000000000000000000000000" + hexVnsAddress;
        Logger.e(TAG, "gem 拼接：" + result);
        return result;
    }
}
