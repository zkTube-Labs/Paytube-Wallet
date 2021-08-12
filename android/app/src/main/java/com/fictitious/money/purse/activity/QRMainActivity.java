package com.fictitious.money.purse.activity;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Vibrator;
import android.text.TextUtils;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.Toast;

import com.example.ffdemo.R;
import com.fictitious.money.purse.utils.Logger;
import com.fictitious.money.purse.utils.ScanHelper;
import com.lqr.picselect.LQRPhotoSelectUtils;
import com.qingmei2.library.util.ImageUtil;
import com.tbruyelle.rxpermissions2.RxPermissions;

import java.io.File;

import androidx.core.app.ActivityCompat;
import cn.bingoogolapple.qrcode.core.QRCodeView;
import cn.bingoogolapple.qrcode.zxing.QRCodeDecoder;
import cn.bingoogolapple.qrcode.zxing.ZXingView;
import kr.co.namee.permissiongen.PermissionFail;
import kr.co.namee.permissiongen.PermissionGen;
import kr.co.namee.permissiongen.PermissionSuccess;

public class QRMainActivity extends Activity implements QRCodeView.Delegate, View.OnClickListener {
    ZXingView mZXingView;
    ImageView img_back;
    ImageView img_photo;

    private boolean openFlashlight = false;
    private LQRPhotoSelectUtils mLqrPhotoSelectUtils;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_qrmain);
        mZXingView = (ZXingView)findViewById(R.id.zxingview);
        img_back = (ImageView) findViewById(R.id.img_back);
        img_photo = (ImageView) findViewById(R.id.img_photo);

        img_back.setOnClickListener(this);
        img_photo.setOnClickListener(this);

        initData();
    }

    public void initData() {
        //全屏
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        RxPermissions rxPermissions = new RxPermissions(this);
        rxPermissions
                .requestEach(Manifest.permission.CAMERA)
                .subscribe(permission -> { // will emit 2 Permission objects
                    if (permission.granted) {
                        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                            String[] permissions = new String[1];
                            permissions[0] = Manifest.permission.CAMERA;
                            ActivityCompat.requestPermissions(this, permissions, 2000);
                        } else {
                            Logger.e(getLocalClassName(),"权限允许");
                            mZXingView.startCamera(); // 打开后置摄像头开始预览，但是并未开始识别
                            mZXingView.startSpotAndShowRect(); // 显示扫描框，并开始识别
                        }
                    } else if (permission.shouldShowRequestPermissionRationale) {
                        // Denied permission without ask never again
                        Logger.e(getLocalClassName(), "权限拒绝");
                        finish();
                    } else {
                        // Denied permission with ask never again
                        // Need to go to the settings
                        Logger.e(getLocalClassName(), "权限永远拒绝");
                        finish();
                    }
                });


        // 1、创建LQRPhotoSelectUtils（一个Activity对应一个LQRPhotoSelectUtils）
        mLqrPhotoSelectUtils = new LQRPhotoSelectUtils(QRMainActivity.this, new LQRPhotoSelectUtils.PhotoSelectListener() {
            @Override
            public void onFinish(File outputFile, Uri outputUri) {
                // 4、当拍照或从图库选取图片成功后回调
                new AsyncTask<Void, Void, String>() {
                    @Override
                    protected String doInBackground(Void... params) {
                        return QRCodeDecoder.syncDecodeQRCode(ImageUtil.getImageAbsolutePath(QRMainActivity.this, outputUri));
                    }

                    @Override
                    protected void onPostExecute(String result) {
                        if (TextUtils.isEmpty(result)) {
                            Toast.makeText(QRMainActivity.this, getString(R.string.failed_qr_code_recognition), Toast.LENGTH_LONG).show();
                        } else {
                            ScanHelper.returnResult(result);
                            finish();
                        }
                    }
                }.execute();
            }
        }, true);

        // 设置扫描二维码的代理
        mZXingView.setDelegate(this);
    }

    @Override
    protected void onStart() {
        super.onStart();
        mZXingView.startCamera(); // 打开后置摄像头开始预览，但是并未开始识别
//        mZXingView.startCamera(Camera.CameraInfo.CAMERA_FACING_FRONT); // 打开前置摄像头开始预览，但是并未开始识别
        mZXingView.startSpotAndShowRect(); // 显示扫描框，并开始识别
    }

    @Override
    protected void onStop() {
        mZXingView.stopCamera(); // 关闭摄像头预览，并且隐藏扫描框
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        mZXingView.onDestroy(); // 销毁二维码扫描控件
        super.onDestroy();
    }

    @Override
    public void onScanQRCodeSuccess(String result) {
        vibrate();
        ScanHelper.returnResult(result);
        finish();
    }

    @Override
    public void onCameraAmbientBrightnessChanged(boolean isDark) {
        // 这里是通过修改提示文案来展示环境是否过暗的状态，接入方也可以根据 isDark 的值来实现其他交互效果
        String tipText = mZXingView.getScanBoxView().getTipText();
        String ambientBrightnessTip = "\n环境过暗，请打开闪光灯";
        if (isDark) {
            if (!tipText.contains(ambientBrightnessTip)) {
                mZXingView.getScanBoxView().setTipText(tipText + ambientBrightnessTip);
            }
        } else {
            if (tipText.contains(ambientBrightnessTip)) {
                tipText = tipText.substring(0, tipText.indexOf(ambientBrightnessTip));
                mZXingView.getScanBoxView().setTipText(tipText);
            }
        }

    }

    @Override
    public void onScanQRCodeOpenCameraError() {
        Logger.e(getLocalClassName(), "打开相机出错");
    }

    /**
     * 打开手电筒
     *
     * @param view
     */
    public void openFlashlight(View view) {
        openFlashlight = !openFlashlight;
        if (openFlashlight) {
            mZXingView.openFlashlight();
        } else {
            mZXingView.closeFlashlight();
        }
    }

    /**
     * 手机震动
     */
    @SuppressLint("MissingPermission")
    private void vibrate() {
        Vibrator vibrator = (Vibrator) getSystemService(VIBRATOR_SERVICE);
        vibrator.vibrate(200);
    }

    @PermissionSuccess(requestCode = LQRPhotoSelectUtils.REQ_SELECT_PHOTO)
    private void selectPhoto() {
        mLqrPhotoSelectUtils.selectPhoto();
    }

    @PermissionFail(requestCode = LQRPhotoSelectUtils.REQ_SELECT_PHOTO)
    private void showTip2() {
//        Toast.makeText(getApplicationContext(), "请到设置开启对应权限", Toast.LENGTH_SHORT).show();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // 2、在Activity中的onActivityResult()方法里与LQRPhotoSelectUtils关联
        mLqrPhotoSelectUtils.attachToActivityForResult(requestCode, resultCode, data);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.img_back:
                finish();
                break;
            case R.id.img_photo:
                PermissionGen.needPermission(this,
                        LQRPhotoSelectUtils.REQ_SELECT_PHOTO,
                        new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,
                                Manifest.permission.WRITE_EXTERNAL_STORAGE}
                );
                break;
        }
    }
}
