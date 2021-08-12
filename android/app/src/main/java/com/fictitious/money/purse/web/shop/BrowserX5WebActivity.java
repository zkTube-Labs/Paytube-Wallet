package com.fictitious.money.purse.web.shop;

import android.Manifest;
import android.app.Dialog;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.example.ffdemo.R;
import com.fictitious.money.purse.Constants;
import com.fictitious.money.purse.activity.QRMainActivity;
import com.fictitious.money.purse.model.EthTranInfoResult;
import com.fictitious.money.purse.model.ImportPurseEntity;
import com.fictitious.money.purse.model.ReturnToJsVnsAddressData;
import com.fictitious.money.purse.net.Api;
import com.fictitious.money.purse.presenter.PWeb;
import com.fictitious.money.purse.rxbus.EventVdnsShop;
import com.fictitious.money.purse.utils.CommonUtil;
import com.fictitious.money.purse.utils.DigitalTrans;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.utils.MethodChannelRegister;
import com.fictitious.money.purse.web.VdnsWebChromeClient;
import com.fictitious.money.purse.widget.CommonPopupWindow;
import com.fictitious.money.purse.widget.DialogUitl;
import com.fictitious.money.purse.widget.txwebview.MyX5WebView;
import com.google.gson.Gson;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.tencent.smtt.sdk.WebSettings;
import com.tencent.smtt.sdk.WebView;
import com.tencent.smtt.sdk.WebViewClient;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import butterknife.BindView;
import cn.droidlover.xdroidmvp.event.BusProvider;
import cn.droidlover.xdroidmvp.mvp.XActivity;
import cn.droidlover.xdroidmvp.router.Router;
import cn.droidlover.xstatecontroller.XStateController;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.functions.Consumer;

import static java.math.BigDecimal.ROUND_HALF_UP;

public class BrowserX5WebActivity extends XActivity<PWeb> implements View.OnClickListener {
    @BindView(R.id.iv_refresh_menu)
    ImageView iv_refresh_menu;
    @BindView(R.id.back_iv)
    ImageView back_iv;
    @BindView(R.id.back_home)
    RelativeLayout back_home;
    @BindView(R.id.title)
    TextView title;
    @BindView(R.id.web_root)
    RelativeLayout web_root;
    @BindView(R.id.webView1)
    FrameLayout mViewParent;
    @BindView(R.id.contentLayout)
    XStateController contentLayout;
    @BindView(R.id.layout_right)
    LinearLayout layout_right;
    @BindView(R.id.refresh_menu)
    RelativeLayout refresh_menu;

    private final String TAG = BrowserX5WebActivity.class.getSimpleName();
    public MyX5WebView mWebView;
    private String url, titleStr;
    private CommonPopupWindow transactionWindow, vndsTransWindow;
    private RotateAnimation rotate;
    public VdnsWebChromeClient vdnsWebChromeClient;
    private boolean isVdns, isTempVdns;//是否是vdns
    private boolean isShow = true;

    ImportPurseEntity purseEntity;

    @Override
    public void initData(Bundle savedInstanceState) {
        Intent intent = getIntent();
        titleStr = intent.getStringExtra(Constants.INTENT_PARAM.TITLE);
        url = intent.getStringExtra(Constants.INTENT_PARAM.SHARE_URL);
        isVdns = intent.getBooleanExtra(Constants.INTENT_PARAM.IS_VDNS, false);
        isTempVdns = intent.getBooleanExtra(Constants.INTENT_PARAM.IS_VDNS, false);

        Logger.e(TAG, "要展示的url:" + url);

        initView();
        initWebView();
        initBus();
        String s = "^((2[0-4]\\d|25[0-5]|[1]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[1]?\\d\\d?)\\:([1-9]|[1-9][0-9]|[1-9][0-9][0-9]|[1-9][0-9][0-9][0-9]|[1-6][0-5][0-5][0-3][0-5])$";
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

    private void initBus() {
        BusProvider.getBus().toFlowable(EventVdnsShop.class)
                .subscribe(new Consumer<EventVdnsShop>() {
                    @Override
                    public void accept(EventVdnsShop event) {
                        if(mWebView != null){
                            if(event.mType == Constants.VDNS_OPTION_ADDRESS_TYPE.SELECT){
                                if(!TextUtils.isEmpty(event.msg)){
                                    getDidWallet();
                                    ReturnToJsVnsAddressData returnToJsVnsAddressData = new ReturnToJsVnsAddressData();
                                    List<String> addressList = new ArrayList<>();
                                    ReturnToJsVnsAddressData.DataBean dataBean = new ReturnToJsVnsAddressData.DataBean();
                                    returnToJsVnsAddressData.setStatus(200);
                                    addressList.add(event.msg);
                                    dataBean.setAddressList(addressList);
                                    returnToJsVnsAddressData.setData(dataBean);
                                    String jsonStr = new Gson().toJson(returnToJsVnsAddressData);
                                    Logger.e(TAG, "返回给h5的json数据：" + jsonStr);
                                    String javascript = "javascript: returnGetVnsAddressResult('" + jsonStr + "')";
                                    mWebView.post(new Runnable() {
                                        @Override
                                        public void run() {
                                            mWebView.loadUrl(javascript);
                                        }
                                    });
                                } else {
                                    finish();
                                }
                            } else if (event.mType == Constants.VDNS_OPTION_ADDRESS_TYPE.REPLASE){
                                getDidWallet();
                                ReturnToJsVnsAddressData returnToJsVnsAddressData = new ReturnToJsVnsAddressData();
                                List<String> addressList = new ArrayList<>();
                                ReturnToJsVnsAddressData.DataBean dataBean = new ReturnToJsVnsAddressData.DataBean();
                                returnToJsVnsAddressData.setStatus(200);
                                addressList.add(event.msg);
                                dataBean.setAddressList(addressList);
                                returnToJsVnsAddressData.setData(dataBean);
                                String jsonStr = new Gson().toJson(returnToJsVnsAddressData);
                                Logger.e(TAG, "返回给h5的json数据：" + jsonStr);
                                String javascript = "javascript: returnGetVnsAddressResult('" + jsonStr + "')";
                                // 判断是哪个币种转账，则把数据回传给js指定的函数
                                mWebView.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        mWebView.loadUrl(javascript);
                                    }
                                });
                            }
                        }
                    }
                });
    }

    private void getDidWallet(){
        MethodChannelRegister.getDid(new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {
                purseEntity = new Gson().fromJson(result.toString(), ImportPurseEntity.class);
            }

            @Override
            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

            }

            @Override
            public void notImplemented() {

            }
        });
    }

    private void initView() {
        title.setText(titleStr);
        back_iv.setOnClickListener(this);
        refresh_menu.setOnClickListener(this);
        back_home.setOnClickListener(this);

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
        contentLayout.loadingView(loadView);
    }

    private void initWebView() {
        mWebView = new MyX5WebView(BrowserX5WebActivity.this);
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

//        setWebViewCacha();

        vdnsWebChromeClient = new VdnsWebChromeClient(BrowserX5WebActivity.this, mWebView);
        mWebView.setWebChromeClient(vdnsWebChromeClient);

        mWebView.setWebViewClient(new WebViewClient() {
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

                if(Api.API_VDNS_URL.equals(url)){
                    if(isVdns){
                        new Handler().postDelayed(new Runnable(){
                            public void run() {
                                if(isShow){
                                    Router.newIntent(BrowserX5WebActivity.this).to(BanKeSelectDidAddressActivity.class).putInt("OPTINE_TYPE", Constants.VDNS_OPTION_ADDRESS_TYPE.SELECT).launch();
                                }
                                isVdns = false;
                            }
                        }, 500);
                    } else {
                        finish();
                    }
                }

                if (isTempVdns){
                    title.setText(mWebView.getTitle());
                }
            }
        });
        mWebView.loadUrl(url);
    }

    private static final String APP_CACAHE_DIRNAME = "/webcache";

    /**
     * LOAD_CACHE_ONLY:  不使用网络，只读取本地缓存数据
     * LOAD_DEFAULT:  根据cache-control决定是否从网络上取数据。
     * LOAD_CACHE_NORMAL: API level 17中已经废弃, 从API level 11开始作用同LOAD_DEFAULT模式
     * LOAD_NO_CACHE: 不使用缓存，只从网络获取数据.
     * LOAD_CACHE_ELSE_NETWORK，只要本地有，无论是否过期，或者no-cache，都使用缓存中的数据
     */
    private void setWebViewCacha() {
        mWebView.getSettings().setJavaScriptEnabled(true);
        mWebView.getSettings().setRenderPriority(WebSettings.RenderPriority.HIGH);
        mWebView.getSettings().setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);  //设置 缓存模式
        // 开启 DOM storage API 功能
        mWebView.getSettings().setDomStorageEnabled(true);
        //开启 database storage API 功能
        mWebView.getSettings().setDatabaseEnabled(true);
        String cacheDirPath = getFilesDir().getAbsolutePath() + APP_CACAHE_DIRNAME;
        //      String cacheDirPath = getCacheDir().getAbsolutePath()+Constant.APP_DB_DIRNAME;
        Log.e(TAG, "缓存目录cacheDirPath=" + cacheDirPath);
        //设置数据库缓存路径
        mWebView.getSettings().setDatabasePath(cacheDirPath);
        //设置  Application Caches 缓存目录
        mWebView.getSettings().setAppCachePath(cacheDirPath);
        //开启 Application Caches 功能
        mWebView.getSettings().setAppCacheEnabled(true);
        // 设置缓存大小
        mWebView.getSettings().setAppCacheMaxSize(Long.MAX_VALUE);
    }

    /**
     * 清除WebView缓存
     */
    public void clearWebViewCache() {

        //清理Webview缓存数据库
        try {
            deleteDatabase("webview.db");
            deleteDatabase("webviewCache.db");
        } catch (Exception e) {
            e.printStackTrace();
        }

        //WebView 缓存文件
        File appCacheDir = new File(getFilesDir().getAbsolutePath() + APP_CACAHE_DIRNAME);
        Log.e(TAG, "appCacheDir path=" + appCacheDir.getAbsolutePath());

        File webviewCacheDir = new File(getCacheDir().getAbsolutePath() + "/webviewCache");
        Log.e(TAG, "webviewCacheDir path=" + webviewCacheDir.getAbsolutePath());

        //删除webview 缓存目录
        if (webviewCacheDir.exists()) {
            deleteFile(webviewCacheDir);
        }
        //删除webview 缓存 缓存目录
        if (appCacheDir.exists()) {
            deleteFile(appCacheDir);
        }
    }

    /**
     * 递归删除 文件/文件夹
     *
     * @param file
     */
    public void deleteFile(File file) {

        Log.e(TAG, "delete file path=" + file.getAbsolutePath());

        if (file.exists()) {
            if (file.isFile()) {
                file.delete();
            } else if (file.isDirectory()) {
                File files[] = file.listFiles();
                for (int i = 0; i < files.length; i++) {
                    deleteFile(files[i]);
                }
            }
            file.delete();
        } else {
            Log.e(TAG, "delete file no exists " + file.getAbsolutePath());
        }
    }

    @Override
    public int getLayoutId() {
        return R.layout.activity_browser_x5_web;
    }

    @Override
    public PWeb newP() {
        return new PWeb();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            // 刷新
            case R.id.refresh_menu:
                iv_refresh_menu.startAnimation(rotate);
                mWebView.reload();
                break;
            // 回退
            case R.id.back_iv:
                if (back_home.isShown() && mWebView != null && mWebView.canGoBack()){
                    mWebView.goBack();
                } else {
                    finish();
                }
                break;
            case R.id.back_home:
                finish();
                break;
        }
    }

    /**
     * 复制链接
     *
     * @param msg
     */
    private void onClickCopy(String msg) {
        // 从API11开始android推荐使用android.content.ClipboardManager
        // 为了兼容低版本我们这里使用旧版的android.text.ClipboardManager，虽然提示deprecated，但不影响使用。
        ClipboardManager cm = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
        // 将文本内容放到系统剪贴板里。
        cm.setText(url);
        getvDelegate().toastShort(msg);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {

        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (mWebView != null && mWebView.canGoBack()) {
                mWebView.goBack();
                return true;
            } else
                return super.onKeyDown(keyCode, event);
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if (intent == null || mWebView == null || intent.getData() == null)
            return;
        mWebView.loadUrl(intent.getData().toString());
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mWebView != null) {
            mWebView.onPause();
        }
        dismissLoadingDialog();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mWebView != null) mWebView.onResume();
    }

    @Override
    protected void onDestroy() {
        if (mWebView != null) {
            mWebView.loadDataWithBaseURL(null, "", "text/html", "utf-8", null);
            mWebView.clearHistory();

            ((ViewGroup) mWebView.getParent()).removeView(mWebView);
            mWebView.destroy();
            mWebView = null;
        }
        isShow = false;
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        /** attention to this below ,must add this**/
        if(requestCode == 101 && data != null){
            ReturnToJsVnsAddressData returnToJsVnsAddressData = new ReturnToJsVnsAddressData();
            List<String> addressList = new ArrayList<>();
            ReturnToJsVnsAddressData.DataBean dataBean = new ReturnToJsVnsAddressData.DataBean();
            if(TextUtils.isEmpty(data.getStringExtra("to_account"))){
                returnToJsVnsAddressData.setStatus(500);
                returnToJsVnsAddressData.setMsg("fail");
            } else {
                returnToJsVnsAddressData.setStatus(200);
                returnToJsVnsAddressData.setMsg("success");
                addressList.add(data.getStringExtra("to_account"));
            }
            dataBean.setAddressList(addressList);
            returnToJsVnsAddressData.setData(dataBean);
            String jsonStr = new Gson().toJson(returnToJsVnsAddressData);
            Logger.e(TAG, "返回给h5的json数据：" + jsonStr);
            String javascript = "javascript: getAddress('" + jsonStr + "')";
            mWebView.post(new Runnable() {
                @Override
                public void run() {
                    mWebView.loadUrl(javascript);
                }
            });
        }
        Logger.e(TAG, "回调码：" + resultCode);
    }

    /**
     * 屏幕横竖屏切换时避免出现window leak的问题
     */
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
//        mShareAction.close();
    }

    private Dialog loadDialog;

    public void showLoadingDialog() {

        loadDialog = DialogUitl.loadingDialog(BrowserX5WebActivity.this, BrowserX5WebActivity.this.getString(R.string.tv_please_wait));
        loadDialog.show();
    }

    public void dismissLoadingDialog() {
        if (loadDialog != null) {
            loadDialog.dismiss();
        }
    }

    private BigDecimal gasPrice = null, estimateGas = null;
    private int nonce;
    private String version = "";


    /**
     * 调起vdns域名交易支付信息窗口
     */
    BigDecimal balance = null;
    BigDecimal vns_b;

    JSONObject obj = null;
    String year = null;
    String payNum = null;
    String token = null;
    String host = null;
    String secrecy = null;
    String contract = null;
    String from = null;
    int requestType;

    String father;
    String type;
    String anAddress;//解析地址

    public void initVdnsTransPopupWindow(String jsonMsg, EthTranInfoResult ethTranInfoResult) {
        // create popup window
        vndsTransWindow = new CommonPopupWindow(BrowserX5WebActivity.this, R.layout.dialog_popwindow_vdns_trans_info, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT) {
            @Override
            protected void initView() {
                try {
                    obj = new JSONObject(jsonMsg);
                    requestType = obj.optInt("num");
                    if(requestType == VdnsWebChromeClient.CODE_PAYSUBLEVEL){
                        father = obj.getString("father");
                        host = obj.getString("son");
                        type = obj.getString("type");
                        from = obj.getString("address");
                        contract = obj.getString("contract");
                        anAddress = obj.getString("anAddress");
                        payNum = "0";
                        token = "VNS";
                    } else if(requestType == VdnsWebChromeClient.CODE_SETCONTROLLER){
                        from = obj.getString("from");
                        host = obj.getString("vnsyuming");
                        contract = obj.getString("contract");
                        anAddress = obj.getString("to");
                        payNum = "0";
                        token = "VNS";
                    } else if(requestType == VdnsWebChromeClient.CODE_SETCONTROLLERSUBLEVEL){

                    } else if(requestType == VdnsWebChromeClient.CODE_DELSUBLEVEL){
                        from = obj.getString("address");
                        host = obj.getString("yuming");
                        contract = obj.getString("contract");
                        payNum = "0";
                        token = "VNS";
                    } else if(requestType == VdnsWebChromeClient.CODE_RENEW){
                        year = obj.getString("year");
                        payNum = obj.getString("payNum");
                        token = obj.getString("payType");
                        host = obj.getString("vnsyuming");
                        contract = obj.getString("contract");
                        from = obj.getString("payAddress");
                    } else {
                        year = obj.getString("year");
                        payNum = obj.getString("payNum");
                        token = obj.getString("payType");
                        host = obj.getString("vnsyuming");
                        secrecy = obj.getString("secrecy");
                        contract = obj.getString("contract");
                        from = obj.getString("payAddress");
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                if(obj != null && ethTranInfoResult != null && ethTranInfoResult.getData() != null && ethTranInfoResult.getData().size() > 0)
                {
                    for (EthTranInfoResult.DataBeanX dataBeanX : ethTranInfoResult.getData())
                    {
                        if(dataBeanX.getData() != null && !TextUtils.isEmpty(dataBeanX.getData().getResult()))
                        {
                            if("transaction".equals(dataBeanX.getName()) || "nonce".equals(dataBeanX.getName()))
                            {
                                nonce = DigitalTrans.hexStringToAlgorism(dataBeanX.getData().getResult());
                            }
                            else if("version".equals(dataBeanX.getName()))
                            {
//                                if("VNS".equals(token)) {
//                                    version = "2018";
//                                } else {
//                                    version = dataBeanX.getData().getResult();
//                                }
                                version = "2018";
                            }
                            else if("gasPrice".equals(dataBeanX.getName()))
                            {
//                                gasPrice = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16));
                                gasPrice = new BigDecimal("50000000000");
                            }
                            else if("estimateGas".equals(dataBeanX.getName()) || "tokenEstimateGas".equals(dataBeanX.getName()))
                            {
                                estimateGas = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16));
                            }
                            else if("balance".equals(dataBeanX.getName()))
                            {
                                balance = new BigDecimal(new BigInteger(dataBeanX.getData().getResult().substring(2), 16)).divide(new BigDecimal("1000000000000000000"),10, ROUND_HALF_UP);
                            }
                            else if("tokenBalance".equals(dataBeanX.getName()))
                            {
                                balance =  new BigDecimal(new BigInteger(CommonUtil.subStrEthBalance(dataBeanX.getData().getResult()), 16)).divide(new BigDecimal(Math.pow(10, 18)),10, ROUND_HALF_UP);
                            }
                        }
                    }
                }

                View view = getContentView();
                TextView txt_amount = view.findViewById(R.id.txt_amount);
                TextView tv_to = view.findViewById(R.id.tv_to);
                TextView tv_from = view.findViewById(R.id.tv_from);
                TextView tv_miner_fee = view.findViewById(R.id.tv_miner_fee);
                TextView tv_miner_fee_money = view.findViewById(R.id.tv_miner_fee_money);
                TextView tv_buy_host = view.findViewById(R.id.tv_buy_host);

                if(requestType == VdnsWebChromeClient.CODE_PAYTOPLEVEL || requestType == VdnsWebChromeClient.CODE_PAYSUBLEVEL){
                    tv_buy_host.setText(getResources().getString(R.string.tv_register_name));
                } else if(requestType == VdnsWebChromeClient.CODE_DELSUBLEVEL){
                    tv_buy_host.setText(getResources().getString(R.string.tv_del_name));
                }  else if(requestType == VdnsWebChromeClient.CODE_SETCONTROLLER || requestType == VdnsWebChromeClient.CODE_SETCONTROLLERSUBLEVEL) {
                    tv_buy_host.setText(getResources().getString(R.string.tv_trans_name));
                } else if(requestType == VdnsWebChromeClient.CODE_RENEW) {
                    tv_buy_host.setText(getResources().getString(R.string.tv_renew_name));
                }

                txt_amount.setText(payNum + token);
                tv_to.setText(contract);
                tv_from.setText(from);
                if(gasPrice != null && estimateGas != null) {
                    vns_b = estimateGas.multiply(gasPrice).divide(new BigDecimal("1000000000000000000"),10, ROUND_HALF_UP);
                    tv_miner_fee.setText(vns_b.stripTrailingZeros().toPlainString() + "VNS");
                    ((PWeb) getP()).getVnsCurrencies(tv_miner_fee_money, vns_b.stripTrailingZeros().toPlainString(), "cny");
                }
                ImageView img_close = view.findViewById(R.id.img_close);
                img_close.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        vndsTransWindow.dismiss();
                    }
                });
                Button btn_next = view.findViewById(R.id.btn_next);
                btn_next.setOnClickListener(new View.OnClickListener() {
                    private Dialog inputDialog_pay;
                    @Override
                    public void onClick(View v) {
                        if(balance != null && vns_b != null && balance.doubleValue() >= Double.parseDouble(payNum) + vns_b.doubleValue()){
                            vndsTransWindow.dismiss();
                            // 显示输入密码提示窗
                            inputDialog_pay = DialogUitl.inputDialog(BrowserX5WebActivity.this, getResources().getString(R.string.please_input_pwd), getResources().getString(R.string.dialog_confirm), getResources().getString(R.string.dialog_cancel), true, new DialogUitl.Callback4() {
                                @Override
                                public void confirm(Dialog dialog, String text, String sha) {
                                    inputDialog_pay.dismiss();
                                    MethodChannelRegister.lock(purseEntity.getWalletID(), text, new MethodChannel.Result() {
                                        @Override
                                        public void success(@Nullable Object result) {
                                            if (Boolean.parseBoolean(String.valueOf(result))) {
                                                if("VP".equals(token)){
                                                    ((PWeb)getP()).canApproveVP(String.valueOf(nonce), gasPrice.stripTrailingZeros().toPlainString(), estimateGas.stripTrailingZeros().toPlainString(), version, from, contract, payNum, requestType, token, year, host, anAddress, type, purseEntity, text);
                                                } else {
                                                    ((PWeb)getP()).buyVdns(String.valueOf(nonce), gasPrice.stripTrailingZeros().toPlainString(), estimateGas.stripTrailingZeros().toPlainString(), version, from, contract, payNum, requestType, token, year, host, anAddress, type, purseEntity, text);
                                                }
                                            } else {
                                                getvDelegate().toastLong(getResources().getString(R.string.dialog_error_pwd));
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
                                    inputDialog_pay.dismiss();
                                }
                            });
                            inputDialog_pay.show();
                        } else {
                            getvDelegate().toastShort(getResources().getString(R.string.tv_insufficient_balance));
                        }
                    }
                });
            }

            @Override
            protected void initEvent() {
                vdnsWebChromeClient.getResult().confirm();
                new Handler().postDelayed(new Runnable(){
                    public void run() {
                        showPopupWindow(vndsTransWindow);
                    }
                }, 1);
            }

            @Override
            protected void initWindow() {
                super.initWindow();
                PopupWindow instance = getPopupWindow();
                instance.setOnDismissListener(new PopupWindow.OnDismissListener() {
                    @Override
                    public void onDismiss() {
                        WindowManager.LayoutParams lp = getWindow().getAttributes();
                        lp.alpha = 1.0f;
                        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
                        getWindow().setAttributes(lp);
                    }
                });
            }
        };
    }

    /**
     * 弹出窗口
     */
    private void showPopupWindow(CommonPopupWindow commonPopupWindow) {
        if (commonPopupWindow != null) {
            PopupWindow popupWindow = commonPopupWindow.getPopupWindow();
            popupWindow.setAnimationStyle(R.style.animTranslate);
            commonPopupWindow.showAtLocation(web_root, Gravity.BOTTOM, 0, 0);
            WindowManager.LayoutParams lp = getWindow().getAttributes();
            lp.alpha = 0.3f;
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
            getWindow().setAttributes(lp);
        }
    }

    public void setTitle(String titleStr){
        title.setText(titleStr);
    }

    public void getVnsTransInfo(String from, int payType, String token, String jsonMsg){
        ((PWeb)getP()).getGasPrice(from, payType, token, jsonMsg);
    }

    public void openScan(){
        Router.newIntent(BrowserX5WebActivity.this).to(QRMainActivity.class).putString("from", "vdns").requestCode(101).launch();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        finish();
    }
}
