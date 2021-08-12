package com.fictitious.money.purse.web.shop;

import android.app.Dialog;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.example.ffdemo.R;
import com.fictitious.money.purse.App;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.listener.OnCompleteDataListener;
import com.fictitious.money.purse.model.BanKeTransactionData;
import com.fictitious.money.purse.model.ImportPurseEntity;
import com.fictitious.money.purse.model.MinerFeeBean;
import com.fictitious.money.purse.model.ShopReturnJSBean;
import com.fictitious.money.purse.presenter.PBanKeMarketShopActivity;
import com.fictitious.money.purse.rxbus.EventBanKeShop;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.DigitalTrans;
import com.fictitious.money.purse.utils.HexUtil;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.utils.MethodChannelRegister;
import com.fictitious.money.purse.utils.XMHCoinUtitls;
import com.fictitious.money.purse.web.dao.BanKeDao;
import com.fictitious.money.purse.widget.DialogUitl;
import com.google.gson.Gson;

import androidx.annotation.Nullable;
import butterknife.BindView;
import butterknife.OnClick;
import cn.droidlover.xdroidmvp.cache.SharedPref;
import cn.droidlover.xdroidmvp.event.BusProvider;
import cn.droidlover.xdroidmvp.mvp.XActivity;
import cn.droidlover.xdroidmvp.net.NetError;
import io.flutter.plugin.common.MethodChannel;

/**
 * 班科兑换
 */
public class BanKeMarketShopActivity extends XActivity<PBanKeMarketShopActivity> {

    private final String TAG = BanKeMarketShopActivity.class.getSimpleName();
    @BindView(R.id.iv_close)
    ImageView ivClose;
    @BindView(R.id.tv_name)
    TextView tvName;
    @BindView(R.id.tv_fromAddress)
    TextView tvFromAddress;
    @BindView(R.id.tv_contractAddress)
    TextView tvContractAddress;
    @BindView(R.id.tv_money)
    TextView tvMoney;
    @BindView(R.id.tv_minersFeeNum)
    TextView tvMinersFeeNum;
    @BindView(R.id.tv_minersFeeMoney)
    TextView tvMinersFeeMoney;
    @BindView(R.id.root_transactionInfo)
    LinearLayout rootTransactionInfo;
    // 与h5协定的主币交易类型，主币类型1 : btc、2 : eth、3：eos、4：vns 5：ehe
    private int transaction_type;
    //  0  主币交易  1 代币交易 2 班科主币兑换代币  3 班科代币兑换主币 4 帮客代币兑换代币
    private int signtype;
    private String money = "", toAddress = "", version = "", remarks = "", token, company,
            contract = "", mac, ethCurrentPrice = "", from = "", chainName = "", smartTokenAddress, vnserTokenAddress, symbols, merchantName, connectorName, tokenName;
    private int decimals = 0;
    private Dialog loadDialog;
    private boolean flagCloseActivity = false;
    // 执行了下一步
    private boolean flagNext = false;
    private MinerFeeBean minerFeeBean;
    private byte[] signPrvKey = new byte[32];
    BanKeTransactionData.InfoBean info;
    ImportPurseEntity purseEntity;

    @Override
    public int getLayoutId() {
        return R.layout.activity_pay_vns_shop;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = getWindow();
        WindowManager.LayoutParams wlp = window.getAttributes();
        Display d = window.getWindowManager().getDefaultDisplay();//获取屏幕宽
        wlp.width = d.getWidth();//宽度按屏幕大小的百分比设置 ;d.getWidth()这个方法已废弃
        wlp.gravity = Gravity.BOTTOM;
        window.setWindowAnimations(R.style.animTranslate);
        window.setAttributes(wlp);
    }

    @Override
    public PBanKeMarketShopActivity newP() {
        return new PBanKeMarketShopActivity();
    }

    @Override
    public void initData(Bundle savedInstanceState) {
        transaction_type = getIntent().getIntExtra(Constants.INTENT_PARAM.H5_TRANSACTION_TYPE, 0);
        purseEntity = (ImportPurseEntity)getIntent().getSerializableExtra("wallet");
        switch (transaction_type) {
            case BanKeDao.vns_transaction:
                chainName = "VNS";
                break;
            default:
                getvDelegate().toastLong("暂不支持其他币种购买！");
                break;
        }
        company = SharedPref.getInstance(context).getString("company", "cny");

        // tv_name.setText 需要多添加 "兑换"
        info = (BanKeTransactionData.InfoBean) getIntent().getSerializableExtra("obj");
        if (info != null) {
            Logger.e(TAG, "传递过来的info数据：" + info.toString());
            toAddress = TextUtils.isEmpty(info.getBancorConverterAddress()) ? "" : info.getBancorConverterAddress();
            money = info.getAmount() + "";
            token = info.getSymbols() + "";
            smartTokenAddress = TextUtils.isEmpty(info.getSmartTokenAddress()) ? "" : info.getSmartTokenAddress();
            vnserTokenAddress = TextUtils.isEmpty(info.getEtherTokenAddress()) ? "" : info.getEtherTokenAddress();
            decimals = info.getDecimal();
            signtype = info.getSigntype();
            from = info.getPayAddress();
            symbols = info.getSymbols();
            merchantName = info.getMerchantName();
            connectorName = info.getConnectorName();
            tokenName = info.getTokenName();

            tvMoney.setText(money);// 设置金额
            tvName.setText(getString(R.string.tv_exchange) + info.getMerchantName());// 兑换类型
            tvFromAddress.setText(String.valueOf(from));// 付款地址
            tvContractAddress.setText(String.valueOf(smartTokenAddress));// 合约地址

            if (TextUtils.isEmpty(from)) {
                showTransferFailed("", "付款地址为空", Constants.CODE_H5_TRANSFER.failed401);
            } else {
                if (chainName.equals("VNS")) {
                    // 请求vns矿工费
                    ((PBanKeMarketShopActivity) getP()).getVnsTransInfo(chainName, contract, String.valueOf(from));
                } else {
                    Logger.e(TAG, "暂未处理请求" + chainName + "的矿工费请求");
                }
            }

            if(!"VNS".equals(info.getSymbols()) && !"VNS".equals(info.getMerchantName())){
                signtype = 4;
            }
        }
        DialogUitl.loadingDialog(context, getString(R.string.tv_please_wait));
    }

    @OnClick({R.id.iv_close, R.id.btn_next})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_close:
                flagCloseActivity = true;
                showTransferFailed(from, "取消交易", Constants.CODE_H5_TRANSFER.failed401);
                finish();
                break;
            case R.id.btn_next:
                selectWalletUnLock();
                break;
        }
    }

    private void selectWalletUnLock() {
        // 标识点击了下一步，当转账失败时，回传放弃支付
        flagNext = true;
        switch (purseEntity.getOriginType()) {
            case Constants.ORIGIN_TYPE.CREATE:
            case Constants.ORIGIN_TYPE.RESTORE:
            case Constants.ORIGIN_TYPE.IMPORT:
                unLockCurrentWalletOrImportWallet();
                break;
            default:
                getvDelegate().toastLong(getString(R.string.comingSoon));
                break;
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        showTransferFailed(from, "取消交易", Constants.CODE_H5_TRANSFER.failed401);
    }

    public void showFailureData(NetError error) {
        if (error != null) {
            getvDelegate().toastLong(error.getMessage() + "");
        }
    }

    public void showEmptyData() {
    }

    public void showLoading() {
        loadDialog = DialogUitl.loadingDialog(context, context.getString(R.string.tv_please_wait));
        try {
            if(!loadDialog.isShowing()){
                loadDialog.show();
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void hideLoading() {
        if (loadDialog != null) {
            loadDialog.dismiss();
        }
    }

    // 转账成功
    public void showTransferSuccess(String from, String trxid) {
        getvDelegate().toastLong(getString(R.string.success_transfer));

        ShopReturnJSBean jsBean = new ShopReturnJSBean();
        ShopReturnJSBean.DataBean dataBean = new ShopReturnJSBean.DataBean();

        jsBean.setStatus(Constants.CODE_H5_TRANSFER.succeed200);
        jsBean.setMsg(getString(R.string.success_transfer));
        dataBean.setChainType(transaction_type);
        dataBean.setSymbols(token);
        dataBean.setTrxid(trxid);
        dataBean.setMinersFee(minerFeeBean.getMinerFeeNum() + "");
        dataBean.setFromAddress(from);

        jsBean.setData(dataBean);
        Gson gson = new Gson();
        String json = gson.toJson(jsBean);
        Logger.e(TAG, "交易回传h5：" + json);

        BusProvider.getBus().post(new EventBanKeShop(json));
        finish();
    }

    // 转账失败
    public void showTransferFailed(String from, String error, int status) {
        Gson gson = new Gson();
        ShopReturnJSBean jsBean = new ShopReturnJSBean();
        ShopReturnJSBean.DataBean dataBean = new ShopReturnJSBean.DataBean();
        dataBean.setChainType(transaction_type);
        dataBean.setSymbols(token);
        jsBean.setStatus(status);
        if (minerFeeBean != null && minerFeeBean.getMinerFeeNum() != null) {
            dataBean.setMinersFee(minerFeeBean.getMinerFeeNum() + "");
        }
        dataBean.setFromAddress(from);

        if (TextUtils.isEmpty(error)) {
            jsBean.setMsg(getString(R.string.failure_transfer));
        } else {
            jsBean.setMsg(error);
        }

        if (flagCloseActivity && !flagNext) {
            // 只点击关闭操作，还没到下一步操作
            BusProvider.getBus().post(new EventBanKeShop(null));
            finish();

        } else {
            jsBean.setData(dataBean);
            String json = gson.toJson(jsBean);
            Logger.e(TAG, "交易失败 交易回传h5：" + json);

            BusProvider.getBus().post(new EventBanKeShop(json));
            finish();
        }

    }

    // 显示矿工费界面
//    @Override
    public void ShowMinersFeeView(MinerFeeBean bean) {
        minerFeeBean = bean;
        Logger.e(TAG, "显示矿工费界面:" + bean.toString());
        tvMinersFeeNum.setText(bean.getMinerFeeNum() + " " + chainName); // 矿工费数量
//        tvGwei.setText(bean.getGasDes() + ""); // 矿工费gwei
        String company = SharedPref.getInstance(App.getContext()).getString("company", "cny");
        if("cny".equals(company)){
            tvMinersFeeMoney.setText("≈ ¥"+bean.getEthCurrentPrice());
        } else {
            tvMinersFeeMoney.setText("≈ $"+bean.getEthCurrentPrice());
        }
    }

    /**
     * 解锁当前身份钱包
     */
    private void unLockCurrentWalletOrImportWallet() {
        DialogUitl.inputDialog(this, getString(R.string.dialog_title_next_id_pwd), getString(R.string.dialog_confirm), getString(R.string.dialog_cancel), false, new DialogUitl.Callback4() {
            @Override
            public void confirm(Dialog dialog, String text, String sha) {
                dialog.dismiss();
                MethodChannelRegister.lock(purseEntity.getWalletID(), text, new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object result) {
                        if (Boolean.parseBoolean(String.valueOf(result))) {
                            if (purseEntity.getPrvKey() != null) {
                                String prvkeyStr = CommonUtil.byteArrayToStr(DigitalTrans.decKeyByAES128CBC(HexUtil.hexStringToBytes(purseEntity.getPrvKey()), text, purseEntity.getCoinType()));
                                byte[] prvKeyByte = DigitalTrans.hex2byte(prvkeyStr);
                                byte[] eth_byte = XMHCoinUtitls.CoinID_ImportETHPrvKey(prvKeyByte);
                                //私钥
                                System.arraycopy(eth_byte, 0, signPrvKey, 0, signPrvKey.length);
                                // 兑换CXE
//                        ((PBanKeMarketShopActivity) getP()).payHotBancor(true, 18, "0xe7e43751431a96761808db697c8edc050fb283bf",
//                                "0x5ba2ffd4527c2a8276716d5c22aabce94128ceed", String.valueOf(nonce),
//                                String.valueOf(gasPrice), "8000000", toAddress, "0.000123456", version, signPrvKey);

                                // 0  主币交易  1 代币交易 2 班科主币兑换代币  3 班科代币兑换主币
                                switch (signtype) {
                                    case 2:
                                        Logger.e(TAG, "班客主币兑换代币,signtype:" + signtype);
                                        if(Double.parseDouble(minerFeeBean.getMinerFeeNum().replaceAll(" VNS", "")) + Double.parseDouble(info.getAmount()) > minerFeeBean.getBalance().doubleValue()) {
                                            getvDelegate().toastShort(getString(R.string.tv_insufficient_number));
                                        } else {
                                            ((PBanKeMarketShopActivity) getP()).payHotBancor(from, true, false, decimals, vnserTokenAddress,
                                                    smartTokenAddress, String.valueOf(minerFeeBean.getNonce()),
                                                    String.valueOf(minerFeeBean.getGasPrice()), String.valueOf(minerFeeBean.getEstimateGas()), toAddress, money, String.valueOf(minerFeeBean.getVersion()), signPrvKey);
                                        }
                                        break;
                                    case 3:
                                        Logger.e(TAG, "班客代币兑换主币,signtype:" + signtype);
                                        if(Double.parseDouble(minerFeeBean.getMinerFeeNum().replaceAll(" VNS", "")) > minerFeeBean.getBalance().doubleValue()) {
                                            getvDelegate().toastShort(getString(R.string.tv_insufficient_number));
                                        } else {
                                            ((PBanKeMarketShopActivity) getP()).payHotBancor(from, false, true, decimals, vnserTokenAddress,
                                                    smartTokenAddress, String.valueOf(minerFeeBean.getNonce()),
                                                    String.valueOf(minerFeeBean.getGasPrice()), String.valueOf(minerFeeBean.getEstimateGas()), toAddress, money, String.valueOf(minerFeeBean.getVersion()), signPrvKey);
                                        }
                                        break;
                                    case 4:
                                        Logger.e(TAG, "班客代币兑换代币,signtype:" + signtype);
                                        if(Double.parseDouble(minerFeeBean.getMinerFeeNum().replaceAll(" VNS", "")) > minerFeeBean.getBalance().doubleValue()) {
                                            getvDelegate().toastShort(getString(R.string.tv_insufficient_number));
                                        } else {
                                            //查询是否已经批准使用合约
                                            ((PBanKeMarketShopActivity) getP()).canApproveToken(minerFeeBean.getNonce() + "", minerFeeBean.getOriginalGasPrice().stripTrailingZeros().toPlainString(), minerFeeBean.getOriginalEstimateGas().stripTrailingZeros().toPlainString(), minerFeeBean.getVersion(), info.getEtherTokenAddress(), info.getPayAddress(), info.getBancorConverterAddress(), signPrvKey, new OnCompleteDataListener() {
                                                @Override
                                                public void onComplete(Object result) {
                                                    if(symbols.equals(connectorName)){
                                                        //buy
                                                        ((PBanKeMarketShopActivity) getP()).payHotBancor(from, false, false, decimals, vnserTokenAddress,
                                                                smartTokenAddress, String.valueOf(minerFeeBean.getNonce()),
                                                                String.valueOf(minerFeeBean.getGasPrice()), String.valueOf(minerFeeBean.getEstimateGas()), toAddress, money, String.valueOf(minerFeeBean.getVersion()), signPrvKey);

                                                    } else if(symbols.equals(tokenName)){
                                                        //sell
                                                        ((PBanKeMarketShopActivity) getP()).payHotBancor(from, false, true, decimals, vnserTokenAddress,
                                                                smartTokenAddress, String.valueOf(minerFeeBean.getNonce()),
                                                                String.valueOf(minerFeeBean.getGasPrice()), String.valueOf(minerFeeBean.getEstimateGas()), toAddress, money, String.valueOf(minerFeeBean.getVersion()), signPrvKey);
                                                    } else {
                                                        Logger.e(TAG, "交易类型判断失败");
                                                    }
                                                }

                                                @Override
                                                public void onFailure(NetError error) {
                                                    getvDelegate().toastLong(error.getMessage());
                                                    finish();
                                                }
                                            });
                                        }
                                        break;
                                    default:
                                        Logger.e(TAG, "班客暂不支持其他交易服务,signtype:" + signtype);
                                        break;
                                }
                                initPrvKeyByte();
                            }
                        } else {
                            getvDelegate().toastLong(getString(R.string.dialog_error_pwd));
                        }
                    }

                    @Override
                    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

                    }

                    @Override
                    public void notImplemented() {

                    }
                });
            }

            @Override
            public void cancel(Dialog dialog) {
                dialog.dismiss();
            }
        }).show();
    }

    //清空内存里面的公钥
    void initPrvKeyByte(){
        for (byte b : signPrvKey) {
            b = 0x00;
        }
    }
}
