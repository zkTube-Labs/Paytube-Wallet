package com.fictitious.money.purse.web.shop;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.gifdecoder.GifDecoder;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.resource.drawable.GlideDrawable;
import com.bumptech.glide.load.resource.gif.GifDrawable;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.GlideDrawableImageViewTarget;
import com.bumptech.glide.request.target.Target;
import com.example.ffdemo.R;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.model.ShopReturnJSBean;
import com.fictitious.money.purse.rxbus.EventBanKeShop;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.web.BanKeWebChromeClient;
import com.fictitious.money.purse.widget.txwebview.MyX5WebView;
import com.google.gson.Gson;
import com.tencent.smtt.export.external.interfaces.SslError;
import com.tencent.smtt.export.external.interfaces.SslErrorHandler;
import com.tencent.smtt.sdk.WebView;
import com.tencent.smtt.sdk.WebViewClient;

import butterknife.BindView;
import butterknife.OnClick;
import cn.droidlover.xdroidmvp.event.BusProvider;
import cn.droidlover.xdroidmvp.mvp.XActivity;
import cn.droidlover.xstatecontroller.XStateController;
import io.reactivex.functions.Consumer;

/**
 * Description:
 * Copyright (C), 新明华区块链(深圳)有限公司
 * Author: ouyonghua
 * Email: ou255@qq.com
 * Date: 2019/5/24 15:14
 */
public class BanKeMarketActivity extends XActivity {
    @BindView(R.id.iv_refresh_menu)
    ImageView iv_refresh_menu;
    @BindView(R.id.title)
    TextView title;
    @BindView(R.id.web_root)
    RelativeLayout web_root;
    @BindView(R.id.webView1)
    FrameLayout mViewParent;
    @BindView(R.id.contentLayout)
    XStateController contentLayout;
    @BindView(R.id.txt_top)
    LinearLayout rootTop;

    private final String TAG = BanKeMarketActivity.class.getSimpleName();
    private RotateAnimation rotate;
    private MyX5WebView mWebView;
    private String mUrl, originUrl;
    private BanKeWebChromeClient webChromeClient;
    private ImageView ivLoading;
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {      //判断标志位
                case 1:// 播放下一个gif
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Glide.with(context).load(R.drawable.loading2).asGif().into(ivLoading);
                        }
                    });
                    break;
            }
        }
    };

    @Override
    public int getLayoutId() {
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE| WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
        return R.layout.fragment_bankemarket;
    }

    @Override
    public Object newP() {
        return null;
    }

    @Override
    public void initData(Bundle savedInstanceState) {
        try {
            initView();
            initWebView();
            initBus();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void initView() {
        title.setText(R.string.bancor);
        mUrl = originUrl = getIntent().getStringExtra("url");
        // 设置刷新动画效果
        rotate = new RotateAnimation(0f, 360f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        LinearInterpolator lin = new LinearInterpolator();
        rotate.setInterpolator(lin);
        rotate.setDuration(2000);//设置动画持续周期
        rotate.setRepeatCount(-1);//设置重复次数
        rotate.setFillAfter(true);//动画执行完后是否停留在执行完的状态
        rotate.setStartOffset(10);//执行前的等待时间
        iv_refresh_menu.setAnimation(rotate);

        View loadView = View.inflate(context, R.layout.view_loading, null);
        ivLoading = loadView.findViewById(R.id.iv_loading);
        Glide.with(this)
                .load(R.drawable.loading1)
                .diskCacheStrategy(DiskCacheStrategy.SOURCE)
                .listener(new RequestListener<Integer, GlideDrawable>() {

                    @Override
                    public boolean onException(Exception arg0, Integer arg1,
                                               Target<GlideDrawable> arg2, boolean arg3) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(GlideDrawable resource,
                                                   Integer model, Target<GlideDrawable> target,
                                                   boolean isFromMemoryCache, boolean isFirstResource) {
                        int duration = 0;
                        // 计算动画时长
                        GifDrawable drawable = (GifDrawable) resource;
                        GifDecoder decoder = drawable.getDecoder();
                        for (int i = 0; i < drawable.getFrameCount(); i++) {
                            duration += decoder.getDelay(i);
                        }
                        //发送延时消息，通知动画结束
                        handler.sendEmptyMessageDelayed(1, duration);
                        return false;
                    }
                }) //仅仅加载一次gif动画
                .into(new GlideDrawableImageViewTarget(ivLoading, 1));
        contentLayout.loadingView(loadView);
    }

    private void initWebView() {
        mWebView = new MyX5WebView(BanKeMarketActivity.this);
        mViewParent.addView(mWebView, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.FILL_PARENT,
                FrameLayout.LayoutParams.FILL_PARENT));
        mWebView.clearCache(true);//清除缓存
        mWebView.setWebContentsDebuggingEnabled(true); // 开启浏览器调试js
        mWebView.setWebViewClient(new WebViewClient() {
            @Override
            public void onReceivedSslError(WebView webView, SslErrorHandler sslErrorHandler, SslError sslError) {
                //handler.cancel(); 默认的处理方式，WebView变成空白页
                //handler.process();接受证书
                //handleMessage(Message msg); 其他处理
                sslErrorHandler.proceed();
                Logger.e(TAG, "ssl 错误！" + sslError.toString());
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                return false;
            }

            @Override
            public void onPageStarted(WebView webView, String s, Bitmap bitmap) {
                super.onPageStarted(webView, s, bitmap);
                if (contentLayout != null) {
                    contentLayout.showLoading();
                }
                if (rotate != null) { // 清空刷新图标旋转效果
                    iv_refresh_menu.startAnimation(rotate);
                }
            }
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                if (contentLayout != null) {
                    contentLayout.showContent();
                }
                if (rotate != null) { // 清空刷新图标旋转效果
                    iv_refresh_menu.clearAnimation();
                }
                mUrl = url;
                title.setText(mWebView.getTitle());
            }
        });
        mWebView.loadUrl(mUrl);

        // 与js交互
        webChromeClient = new BanKeWebChromeClient(mWebView);
        mWebView.setWebChromeClient(webChromeClient);
    }

    @OnClick({R.id.back_iv, R.id.refresh_menu, R.id.back_home})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.back_iv:
                if (mWebView != null && mWebView.canGoBack()){
                    mWebView.goBack();
                } else {
                    finish();
                }
                break;

            case R.id.back_home:
                finish();
                break;

            case R.id.refresh_menu:
                iv_refresh_menu.startAnimation(rotate);
                mWebView.clearCache(true);//清除缓存
                mWebView.reload();
                break;
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Logger.e(TAG, "onActivityResult >>>");
    }


    public void onBackPressed(){
        if (mWebView != null && mWebView.canGoBack()){
            mWebView.goBack();
        } else {
            finish();
        }
    }

    private void initBus() {
        BusProvider.getBus().toFlowable(EventBanKeShop.class)
                .subscribe(new Consumer<EventBanKeShop>() {
                    @Override
                    public void accept(EventBanKeShop event) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                if (webChromeClient.getResult() == null) {
                                    Logger.e(TAG, "htmlShopWebChromeClient 空！！");
                                    if(mUrl.equals(originUrl)){
                                        finish();
                                    }
                                    return;
                                }
                                // 执行js回调
                                if (TextUtils.isEmpty(event.msg)) {
                                    webChromeClient.getResult().confirm();
                                    if(mUrl.equals(originUrl)){
                                        finish();
                                    }
                                    Logger.e(TAG, "收到转账数据为空！！");
                                } else {
                                    webChromeClient.getResult().confirm(event.msg);
                                    ShopReturnJSBean jsBean = new Gson().fromJson(event.msg, ShopReturnJSBean.class);
                                    if(jsBean != null && jsBean.getStatus() == Constants.CODE_H5_TRANSFER.failed401){
                                        if(mUrl.equals(originUrl)){
                                            finish();
                                        }
                                    }
                                    Logger.e(TAG, "收到转账数据！！" + event.msg);
                                }
                            }
                        });
                    }
                });
    }
}
