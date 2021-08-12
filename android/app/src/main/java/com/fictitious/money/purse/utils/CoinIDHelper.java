package com.fictitious.money.purse.utils;

import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.utils.wallet.CreateMomeUtil;
import com.fictitious.money.purse.utils.wallet.CreateWalletUtil;
import com.fictitious.money.purse.utils.wallet.ExportKeyStoreUtil;
import com.fictitious.money.purse.utils.wallet.ExportPrvKeyUtil;
import com.fictitious.money.purse.utils.wallet.ImportWalletUtil;

import java.util.List;
import java.util.Map;

public class CoinIDHelper {

   /**
    * 获取助记词
    * @param count
    * @return
    */
   public static Map createWalletMemo(int count){
      return CreateMomeUtil.createWalletMemo(count);
   }

   /**
    * 导入钱包
    * @param content
    * @param pin
    * @param coinType
    * @param leadType
    * @return
    */
   public static List importWalletFrom(String content, String pin, int coinType, int leadType, int originType){
      if(originType == Constants.ORIGIN_TYPE.IMPORT){
         return ImportWalletUtil.importPurse(leadType, coinType, pin, content);
      } else {
         return CreateWalletUtil.createWallet(leadType, content, coinType, pin);
      }
   }

   /**
    * 导出私钥
    * @param content
    * @param pin
    * @param coinType
    * @return
    */
   public static Map exportPrvFrom(String content, String pin, int coinType){
      return ExportPrvKeyUtil.exportPrvKey(content, pin, coinType);
   }

   /**
    * 导出keystore
    * @param content
    * @param pin
    * @param coinType
    * @return
    */
   public static Map exportKeyStoreFrom(String content, String pin, int coinType){
      return ExportKeyStoreUtil.exportKeyStore(content, pin, coinType);
   }
}