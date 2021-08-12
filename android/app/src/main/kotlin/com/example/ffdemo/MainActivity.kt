package com.example.ffdemo

import com.fictitious.money.purse.App
import com.fictitious.money.purse.utils.MethodChannelRegister
import com.flutter.flutter_app_upgrade.FlutterAppUpgradePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        App.setActivity(this);
        //注册通道
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannelRegister.registerMemo(flutterEngine)
        MethodChannelRegister.registerWallet(flutterEngine)
        MethodChannelRegister.registerNative(flutterEngine)
        MethodChannelRegister.registerDAPP(flutterEngine)
        MethodChannelRegister.registerScan(flutterEngine)
        MethodChannelRegister.registerScanEvent(flutterEngine)
        flutterEngine.plugins.add(FlutterAppUpgradePlugin())
    }
}
