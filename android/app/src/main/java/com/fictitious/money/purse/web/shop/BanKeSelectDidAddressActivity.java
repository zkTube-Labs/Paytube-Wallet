package com.fictitious.money.purse.web.shop;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.example.ffdemo.R;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.adapter.BanKeSelectDidAddressAdapter;
import com.fictitious.money.purse.model.ImportPurseEntity;
import com.fictitious.money.purse.model.ShopReturnJSBean;
import com.fictitious.money.purse.model.VdaiReturnJSBean;
import com.fictitious.money.purse.rxbus.EventBanKeShop;
import com.fictitious.money.purse.rxbus.EventVdnsShop;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.utils.MethodChannelRegister;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tbruyelle.rxpermissions2.RxPermissions;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import butterknife.BindView;
import butterknife.OnClick;
import cn.droidlover.xdroidmvp.event.BusProvider;
import cn.droidlover.xdroidmvp.mvp.XActivity;
import io.flutter.plugin.common.MethodChannel;

/**
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-10-31 15:16
 * Description: did地址选择
 */
public class BanKeSelectDidAddressActivity extends XActivity {
    @BindView(R.id.img_eyes)
    ImageView img_eyes;
    @BindView(R.id.recyclerView)
    RecyclerView mRecyclerView;
    @BindView(R.id.btn_cancel)
    Button btn_cancel;
    @BindView(R.id.btn_allow)
    Button btn_allow;
    @BindView(R.id.tv_addWallet)
    TextView tv_addWallet;
    @BindView(R.id.img_vdns)
    ImageView img_vdns;
    @BindView(R.id.txt_title)
    TextView txt_title;
    private int optionType;

    private final String TAG = BanKeSelectDidAddressActivity.class.getSimpleName();
    private BanKeSelectDidAddressAdapter mAdapter;
    private String selectDidAddress;
    private ImportPurseEntity selectPurse; // 选中的钱包

    @Override
    public int getLayoutId() {
        return R.layout.activity_select_did_address;
    }

    @Override
    public void initData(Bundle savedInstanceState) {
        optionType = getIntent().getIntExtra("OPTINE_TYPE", -1);
        if(optionType == 1){
            img_vdns.setBackground(getResources().getDrawable(R.mipmap.icon_item_appliction_6));
            txt_title.setText(getResources().getString(R.string.tv_vdns_did_title));
        } else if(optionType == 2) {
            img_vdns.setBackground(getResources().getDrawable(R.mipmap.ic_vusd_select_did));
            txt_title.setText(getResources().getString(R.string.vdaiPlatform));
        }
        getData();

        RxPermissions rxPermissions = new RxPermissions(this);
        rxPermissions
                .requestEach(Manifest.permission.READ_PHONE_STATE)
                .subscribe(permission -> { // will emit 2 Permission objects
                    if (permission.granted) {
                        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
                            String[] permissions = new String[1];
                            permissions[0] = Manifest.permission.READ_PHONE_STATE;
                            ActivityCompat.requestPermissions(this, permissions, 2000);
                        } else {

                        }
                    } else if (permission.shouldShowRequestPermissionRationale) {

                    } else {

                    }
                });
    }

    void getData(){
        MethodChannelRegister.getWallet(new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {
                //传递的参数
                List<ImportPurseEntity> vnsLists = new Gson().fromJson(result.toString(), new TypeToken<List<ImportPurseEntity>>() {
                }.getType());
                try {
                    if (vnsLists.size() == 0) {
                        img_eyes.setVisibility(View.INVISIBLE);
                        showEmptyView();
                    } else {
                        img_eyes.setVisibility(View.VISIBLE);
                        tv_addWallet.setVisibility(View.GONE);
                        mRecyclerView.setVisibility(View.VISIBLE);
                    }

                    // 获取所有vns钱包，如果被打开过，则取被打开的vns,否则没被打开过的，默认取第一个
                    ImportPurseEntity openWallet = null;
                    for(ImportPurseEntity importPurseEntity : vnsLists){
                        if(importPurseEntity.isDidChoose()){
                            openWallet = importPurseEntity;
                            break;
                        }
                    }
                    if (openWallet != null) {
                        selectDidAddress = openWallet.getAddress();
                        selectPurse = openWallet;
                    } else if (openWallet == null && vnsLists.size() > 0) {
                        selectDidAddress = vnsLists.get(0).getAddress();
                        selectPurse = vnsLists.get(0);
                    }

                    mRecyclerView.setLayoutManager(new LinearLayoutManager(context));
                    mAdapter = new BanKeSelectDidAddressAdapter();
                    mRecyclerView.setAdapter(mAdapter);
                    mAdapter.setNewData(vnsLists);
                    mAdapter.setSelectDidAddress(selectDidAddress);
                    mAdapter.setOnItemChildClickListener(new BaseQuickAdapter.OnItemChildClickListener() {
                        @Override
                        public void onItemChildClick(BaseQuickAdapter adapter, View view, int position) {
                            ImportPurseEntity purse = (ImportPurseEntity) adapter.getItem(position);
                            selectDidAddress = purse.getAddress();
                            selectPurse = purse;
                            Logger.e(TAG, "选择了VNS:" + selectDidAddress);
                            mAdapter.setSelectDidAddress(selectDidAddress);

                            //修改选择的钱包
                            MethodChannelRegister.updateDid(purse.getWalletID(), new MethodChannel.Result() {
                                @Override
                                public void success(@Nullable Object result) {

                                }

                                @Override
                                public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

                                }

                                @Override
                                public void notImplemented() {

                                }
                            });
                        }
                    });
                } catch (Exception e) {
                    Logger.e(TAG, "异常了：" + e.getMessage());

                    System.out.println();

                    ShopReturnJSBean jsBean = new ShopReturnJSBean();
                    ShopReturnJSBean.DataBean dataBean = new ShopReturnJSBean.DataBean();
                    jsBean.setStatus(Constants.CODE_H5_TRANSFER.failed400);
                    jsBean.setMsg("程序异常!");
                    dataBean.setError("程序异常");
                    jsBean.setData(dataBean);
                    String json = new Gson().toJson(jsBean);
                    BusProvider.getBus().post(new EventBanKeShop(json));
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
    public Object newP() {
        return null;
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

    @OnClick({R.id.img_eyes, R.id.btn_cancel, R.id.btn_allow, R.id.tv_addWallet})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.img_eyes:
                if (mAdapter != null) {
                    mAdapter.setShowBalance(!mAdapter.isShowBalance());
                    if (mAdapter.isShowBalance()) {
                        img_eyes.setImageResource(R.mipmap.ic_banke_moneny_see);
                    } else {
                        img_eyes.setImageResource(R.mipmap.ic_banke_moneny_nosee);
                    }
                }
                break;
            case R.id.btn_cancel:
                notSelectDidAddress();
                finish();
                break;
            case R.id.tv_addWallet:
            case R.id.btn_allow:
                selectDidAddress();
                break;
        }
    }

    private void showEmptyView() {
        btn_allow.setBackgroundResource(R.mipmap.bg_vdns_btn_cancel);
        btn_allow.setTextColor(getResources().getColor(R.color.color_ACBBCF));
        tv_addWallet.setVisibility(View.VISIBLE);
        mRecyclerView.setVisibility(View.GONE);
    }

    // 物理键返回
    @Override
    public void onBackPressed() {
        super.onBackPressed();
        notSelectDidAddress();
    }

    private void selectDidAddress() {
        if (TextUtils.isEmpty(selectDidAddress)) {
            notSelectDidAddress();
            finish();
            return;
        }

        // 判断钱包类型
        if (selectPurse != null && (selectPurse.getOriginType() == Constants.ORIGIN_TYPE.NFC || selectPurse.getOriginType() == Constants.ORIGIN_TYPE.COLDS)) {
            notSelectDidAddress();
            getvDelegate().toastLong(getString(R.string.notOpenDes));
        }

        if(optionType == Constants.VDNS_OPTION_ADDRESS_TYPE.SELECT || optionType == Constants.VDNS_OPTION_ADDRESS_TYPE.REPLASE){
            BusProvider.getBus().post(new EventVdnsShop(selectDidAddress, optionType));
        } else if(optionType == Constants.VDNS_OPTION_ADDRESS_TYPE.VDAIN){
            // 用户选择did地址
            VdaiReturnJSBean jsBean = new VdaiReturnJSBean();
            VdaiReturnJSBean.DataBean dataBean = new VdaiReturnJSBean.DataBean();
            jsBean.setStatus(Constants.CODE_H5_TRANSFER.succeed200);
            jsBean.setMsg(getString(R.string.get_data_success));
            ArrayList<String> vnsAddressList = new ArrayList<>();
            vnsAddressList.add(selectDidAddress);
            dataBean.setAddressList(vnsAddressList);
            jsBean.setData(dataBean);
            Gson gson = new Gson();
            String json = gson.toJson(jsBean);
            String javascript = "javascript: returnReplaceAddressResult('" + json + "')";
            Logger.e(TAG, "交易回传h5：" + json);
            BusProvider.getBus().post(new EventBanKeShop(javascript));
        } else {
            // 用户选择did地址
            ShopReturnJSBean jsBean = new ShopReturnJSBean();
            ShopReturnJSBean.DataBean dataBean = new ShopReturnJSBean.DataBean();
            jsBean.setStatus(Constants.CODE_H5_TRANSFER.succeed200);
            jsBean.setMsg(getString(R.string.get_data_success));
            ArrayList<String> vnsAddressList = new ArrayList<>();
            vnsAddressList.add(selectDidAddress);
            dataBean.setVnsAddress(vnsAddressList);
            jsBean.setData(dataBean);
            Gson gson = new Gson();
            String json = gson.toJson(jsBean);
            Logger.e(TAG, "交易回传h5：" + json);
            BusProvider.getBus().post(new EventBanKeShop(json));
        }
        finish();
    }

    private void notSelectDidAddress() {
        // 用户没选择did地址
        if(optionType == Constants.VDNS_OPTION_ADDRESS_TYPE.SELECT || optionType == Constants.VDNS_OPTION_ADDRESS_TYPE.REPLASE){
            BusProvider.getBus().post(new EventVdnsShop("", optionType));
        } else {
            ShopReturnJSBean jsBean = new ShopReturnJSBean();
            jsBean.setStatus(Constants.CODE_H5_TRANSFER.failed401);
            jsBean.setMsg(getString(R.string.get_data_error));
            Gson gson = new Gson();
            String json = gson.toJson(jsBean);
            Logger.e(TAG, "交易回传h5：" + json);
            BusProvider.getBus().post(new EventBanKeShop(json));
        }
    }
}
