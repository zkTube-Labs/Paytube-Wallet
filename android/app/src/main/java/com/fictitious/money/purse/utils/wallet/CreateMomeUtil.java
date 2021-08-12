package com.fictitious.money.purse.utils.wallet;

import android.text.TextUtils;

import com.fictitious.money.purse.model.MemorizingWordInfo;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.XMHCoinUtitls;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CreateMomeUtil {
    public static Map createWalletMemo(int count){
        String chinese = CommonUtil.readAssetsTxt( "chinese_simplified").replace("\r\n",",").replace("\n",",").replace("\r",",").replace("\t",",");
        String englise = CommonUtil.readAssetsTxt( "english").replace("\r\n",",").replace("\n",",").replace("\r",",").replace("\t",",");
        Map map = new HashMap();
        if(!TextUtils.isEmpty(chinese) && !TextUtils.isEmpty(englise)){
            String[] arr_chinese = chinese.split(",");
            String[] arr_english = englise.split(",");
            byte[] inputByte = null, outputByte = null;
            byte[] commonInputByte = null, commonOutputByte = null;
            if(count == 12)
            {
                inputByte = new byte[17];
                XMHCoinUtitls.CoinID_genTrueRandom(inputByte);
                outputByte = new byte[24];

                commonInputByte = new byte[17];
                XMHCoinUtitls.CoinID_genTrueRandom(commonInputByte);
                commonOutputByte = new byte[24];
            }
            else if(count == 18)
            {
                inputByte = new byte[25];
                XMHCoinUtitls.CoinID_genTrueRandom(inputByte);
                outputByte = new byte[36];

                commonInputByte = new byte[25];
                XMHCoinUtitls.CoinID_genTrueRandom(commonInputByte);
                commonOutputByte = new byte[36];
            }
            else if(count == 24)
            {
                inputByte = new byte[33];
                XMHCoinUtitls.CoinID_genTrueRandom(inputByte);
                outputByte = new byte[48];

                commonInputByte = new byte[33];
                XMHCoinUtitls.CoinID_genTrueRandom(commonInputByte);
                commonOutputByte = new byte[48];
            }

            XMHCoinUtitls.CoinID_generateMnemonicIndex(commonInputByte, (byte) (commonInputByte.length - 1), commonOutputByte);

            XMHCoinUtitls.CoinID_generateMnemonicIndex(inputByte, (byte) (inputByte.length - 1), outputByte);

            map.put("cnMemos", getWordList(arr_chinese, outputByte));
            map.put("enMemos", getWordList(arr_english, outputByte));
            map.put("cnStandMemos", getWordList(arr_chinese, commonOutputByte));
            map.put("enStandMemos", getWordList(arr_english, commonOutputByte));
        }
        return map;
    }

    /**
     * 获取助记词
     * @param arr_mome
     * @param outputByte
     * @return
     */
    static ArrayList getWordList(String[] arr_mome, byte[] outputByte) {
        ArrayList<String> words = new ArrayList<>();
        int byte_length = outputByte.length;
        for (int i = 0; i < byte_length; i += 2) {
            words.add(arr_mome[CommonUtil.byteToInt(outputByte[i], outputByte[i + 1])]);
        }
        return words;
    }

    public static boolean checkMemoValid(String memos){
        boolean isChinese = false;
        List<String> arr_chinese = null;
        List<String> arr_english = null;
        List<MemorizingWordInfo> wordslist = new ArrayList<>();
        String chinese = CommonUtil.readAssetsTxt("chinese_simplified").replace("\r\n",",").replace("\n",",").replace("\r",",").replace("\t",",");
        String englise = CommonUtil.readAssetsTxt("english").replace("\r\n",",").replace("\n",",").replace("\r",",").replace("\t",",");
        String[] chineses = chinese.split(",");
        String[] englishs = englise.split(",");
        if(chineses != null) {
            arr_chinese = Arrays.asList(chinese.split(","));
        }

        if(englishs != null) {
            arr_english = Arrays.asList(englise.split(","));
        }
        String wordList = memos.replaceAll(",", " ").replaceAll("，", " ").trim();
        String[] words = wordList.split(" ");
        List<String> arr_words = Arrays.asList(words);
        if(words.length != 12 && words.length != 18 && words.length != 24) {
            return false;
        } else {
            boolean isError = false;
            for (String s : arr_words) {
                if(!arr_chinese.contains(s)) {
                    isError = false;
                    break;
                } else {
                    isError = true;
                    isChinese = true;
                }
            }
            if(!isError) {
                for (String s : arr_words) {
                    if(!arr_english.contains(s)) {
                        isError = false;
                        break;
                    } else {
                        isError = true;
                        isChinese = false;
                    }
                }
            }

            if(isError) {
                for (String s : arr_words) {
                    if (isChinese) {
                        for (int i = 0; i < arr_chinese.size(); i++) {
                            if (s.equals(arr_chinese.get(i))) {
                                MemorizingWordInfo memorizingWordInfo = new MemorizingWordInfo();
                                memorizingWordInfo.setIndex(i);
                                memorizingWordInfo.setWord(s);
                                wordslist.add(memorizingWordInfo);
                            }
                        }
                    } else {
                        for (int i = 0; i < arr_english.size(); i++) {
                            if (s.equals(arr_english.get(i))) {
                                MemorizingWordInfo memorizingWordInfo = new MemorizingWordInfo();
                                memorizingWordInfo.setIndex(i);
                                memorizingWordInfo.setWord(s);
                                wordslist.add(memorizingWordInfo);
                            }
                        }
                    }
                }
                short[] index_arr = new short[wordslist.size()];
                if (wordslist != null && wordslist.size() > 0) {
                    for (int i = 0; i < wordslist.size(); i++) {
                        index_arr[i] = (short) wordslist.get(i).getIndex();
                    }
                }
                boolean checkMemo = XMHCoinUtitls.CoinID_checkMemoValid(index_arr, (byte) (index_arr.length));
                wordslist.clear();
                return checkMemo;
            } else {
                return false;
            }
        }
    }
}
