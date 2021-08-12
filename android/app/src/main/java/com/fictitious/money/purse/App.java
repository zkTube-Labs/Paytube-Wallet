package com.fictitious.money.purse;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;

import com.fictitious.money.purse.utils.ApkUtil;
import com.fictitious.money.purse.utils.Base64Utils;
import com.fictitious.money.purse.utils.XMHCoinUtitls;
import com.tencent.smtt.sdk.QbSdk;

import androidx.core.app.ActivityCompat;
import cn.droidlover.xdroidmvp.net.NetError;
import cn.droidlover.xdroidmvp.net.NetProvider;
import cn.droidlover.xdroidmvp.net.RequestHandler;
import cn.droidlover.xdroidmvp.net.XApi;
import io.flutter.app.FlutterApplication;
import okhttp3.CookieJar;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;

/**
 * Created by wanglei on 2016/12/31.
 */

public class App extends FlutterApplication {

    private static Context context;
    private static Activity activity;
    public static String requestHeader = "";
    private static String imei = "";
    public static App appApplication = null;
    public static boolean isUseHttps = true;

    @Override
    public void onCreate() {
        super.onCreate();
        context = this;
        appApplication = this;
        System.loadLibrary("native-lib");
        try {
            XMHCoinUtitls.CoinID_authValidAPP(this);
        } catch (Exception e) {
            System.loadLibrary("native-lib");
        }
        try {
            requestHeader = Base64Utils.encode(ApkUtil.getInfoByte());
        } catch (Exception e) {
            e.printStackTrace();
        }
        initX5WebView();
        XApi.registerProvider(new NetProvider() {

            @Override
            public Interceptor[] configInterceptors() {
                return new Interceptor[0];
            }

            @Override
            public void configHttps(OkHttpClient.Builder builder) {

            }

            @Override
            public CookieJar configCookie() {
                return null;
            }

            @Override
            public RequestHandler configHandler() {
                return null;
            }

            @Override
            public long configConnectTimeoutMills() {
                return 0;
            }

            @Override
            public long configReadTimeoutMills() {
                return 0;
            }

            @Override
            public boolean configLogEnable() {
                return true;
            }

            @Override
            public boolean handleError(NetError error) {
                return false;
            }

            @Override
            public boolean dispatchProgressEnable() {
                return false;
            }
        });
    }

    private void initX5WebView() {
        QbSdk.PreInitCallback cb = new QbSdk.PreInitCallback() {

            @Override
            public void onViewInitFinished(boolean arg0) {
                // TODO Auto-generated method stub
                //x5內核初始化完成的回调，为true表示x5内核加载成功，否则表示x5内核加载失败，会自动切换到系统内核。
                Log.d("app", " onViewInitFinished is " + arg0);
            }

            @Override
            public void onCoreInitFinished() {
                // TODO Auto-generated method stub
            }
        };
        //x5内核初始化接口
        QbSdk.initX5Environment(getApplicationContext(), cb);
    }

    public static String getImei() {
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(context.TELEPHONY_SERVICE);
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {

        } else {
            imei = telephonyManager.getDeviceId();
        }

        if (TextUtils.isEmpty(imei)) {
            imei = "0000000000000000";
        }

        return imei;
    }

    public static App getNewInstance() {
        return appApplication;
    }

    public static Context getContext() {
        return context;
    }

    public static Activity getActivity() {
        return activity;
    }

    public static void setActivity(Activity activity) {
        App.activity = activity;
    }
}
