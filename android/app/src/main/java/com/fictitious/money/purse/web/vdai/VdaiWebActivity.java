package com.fictitious.money.purse.web.vdai;

import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.example.ffdemo.R;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.web.VdaiWebChromeClient;
import com.fictitious.money.purse.widget.txwebview.MyX5WebView;
import com.tencent.smtt.export.external.interfaces.SslError;
import com.tencent.smtt.export.external.interfaces.SslErrorHandler;
import com.tencent.smtt.sdk.WebSettings;
import com.tencent.smtt.sdk.WebView;
import com.tencent.smtt.sdk.WebViewClient;

import butterknife.BindView;
import butterknife.OnClick;
import cn.droidlover.xdroidmvp.mvp.XActivity;

/**
 * 与h5接口交互webView，期望兼容通用所有h5业务
 */
public class VdaiWebActivity extends XActivity {
    @BindView(R.id.iv_refresh_menu)
    ImageView iv_refresh_menu;
    @BindView(R.id.title)
    TextView title;
    @BindView(R.id.progressBar)
    ProgressBar progressBar;
    @BindView(R.id.webView1)
    FrameLayout mViewParent;

    private final String TAG = VdaiWebActivity.class.getSimpleName();
    public MyX5WebView mWebView;
    private RotateAnimation rotate;
    private String url;

    @Override
    public int getLayoutId() {
        return R.layout.activity_base_interface_web;
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
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @OnClick({R.id.back_iv, R.id.iv_refresh_menu, R.id.back_home})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.back_iv:
                if (mWebView != null && mWebView.canGoBack()) {
                    mWebView.goBack();
                }
                break;

            case R.id.back_home:
                finish();
                break;

            case R.id.iv_refresh_menu:
                iv_refresh_menu.startAnimation(rotate);
                mWebView.clearCache(true);//清除缓存
                mWebView.reload();
                break;
        }
    }

    private void initView() {
        title.setText(getString(R.string.vdai_title));
        url = getIntent().getStringExtra("url");
        mWebView = new MyX5WebView(context);
        mViewParent.addView(mWebView, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.FILL_PARENT,
                FrameLayout.LayoutParams.FILL_PARENT));
    }

    private void initWebView() {
        mWebView = new MyX5WebView(context);
        mViewParent.addView(mWebView, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.FILL_PARENT,
                FrameLayout.LayoutParams.FILL_PARENT));
        mWebView.clearCache(true);//清除缓存

        WebSettings webSetting = mWebView.getSettings();
        // 解决在Android 5.0上 Webview 默认不允许加载 Http 与 Https 混合内容
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            MIXED_CONTENT_ALWAYS_ALLOW：允许从任何来源加载内容，即使起源是不安全的；
//            MIXED_CONTENT_NEVER_ALLOW：不允许Https加载Http的内容，即不允许从安全的起源去加载一个不安全的资源；
//            MIXED_CONTENT_COMPATIBILITY_MODE：当涉及到混合式内容时，WebView 会尝试去兼容最新Web浏览器的风格。
            webSetting.setMixedContentMode(android.webkit.WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }
        webSetting.setJavaScriptEnabled(true);//支持js
        webSetting.setJavaScriptCanOpenWindowsAutomatically(true); //支持通过JS打开新窗口
        webSetting.setDomStorageEnabled(true);// 开启 DOM storage API 功能
        webSetting.setAllowFileAccess(true);
        webSetting.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);//支持内容重新布局
        webSetting.setSupportZoom(true);//支持缩放，默认为true。是下面那个的前提
        webSetting.setBuiltInZoomControls(true); //设置内置的缩放控件
        webSetting.setUseWideViewPort(true); //将图片调整到适合webview的大小
        webSetting.setGeolocationEnabled(true);
        webSetting.setPluginState(WebSettings.PluginState.ON_DEMAND);
        webSetting.setRenderPriority(WebSettings.RenderPriority.HIGH);//提高渲染的优先级
        webSetting.setTextZoom(100);// 纠正会自动更改页面内字体大小，有些地方会超出范围
        mWebView.setWebContentsDebuggingEnabled(true); // 开启浏览器调试js


        // 设置刷新动画效果
        rotate = new RotateAnimation(0f, 360f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        LinearInterpolator lin = new LinearInterpolator();
        rotate.setInterpolator(lin);
        rotate.setDuration(2000);//设置动画持续周期
        rotate.setRepeatCount(-1);//设置重复次数
        rotate.setFillAfter(true);//动画执行完后是否停留在执行完的状态
        rotate.setStartOffset(10);//执行前的等待时间
        iv_refresh_menu.setAnimation(rotate);

        mWebView.setWebChromeClient(new VdaiWebChromeClient(this, mWebView) {
            @Override
            public void onProgressChanged(WebView webView, int newProgress) {
                super.onProgressChanged(webView, newProgress);
                if (newProgress == 100) {
                    progressBar.setVisibility(View.GONE);//加载完网页进度条消失
                } else {
                    progressBar.setVisibility(View.VISIBLE);//开始加载网页时显示进度条
                    progressBar.setProgress(newProgress);//设置进度值
                }
            }
        });

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
                if (rotate != null) { // 清空刷新图标旋转效果
                    iv_refresh_menu.startAnimation(rotate);
                }
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                if (rotate != null) { // 清空刷新图标旋转效果
                    iv_refresh_menu.clearAnimation();
                }
                title.setText(mWebView.getTitle());
                Logger.e(TAG, "当前url：" + url);
            }
        });
        mWebView.loadUrl(url);
    }

    public void onBackPressed(){
        if (mWebView != null && mWebView.canGoBack()){
            mWebView.goBack();
        }
    }

}
