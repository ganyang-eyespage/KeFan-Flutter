package com.tc.kefan_flutter.methodchannel;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tc.kefan_flutter.util.AppUtil;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;

public class AppInfoMethodChannel implements MethodChannel.MethodCallHandler {


    private static MethodChannel olistChannel;

    public AppInfoMethodChannel() {
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        olistChannel = new MethodChannel(registrar.messenger(), MethodChannelManger.APP_INFO);
        AppInfoMethodChannel instance = new AppInfoMethodChannel();
        olistChannel.setMethodCallHandler(instance);
    }

    static Activity activity;

    public static void registerWith(FlutterEngine flutterEngine, Activity mActivity) {
        activity = mActivity;
        olistChannel = new MethodChannel(flutterEngine.getDartExecutor(), MethodChannelManger.APP_INFO);
        AppInfoMethodChannel instance = new AppInfoMethodChannel();
        olistChannel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        Log.e("----AppInfoChannel: ", " " + methodCall.method);
        switch (methodCall.method) {
            case "getAppInfo":
                try {
                    Map map = new HashMap();
                    map.put("X-Aid", ""); //  谷歌广告ID需要在子线程获取，所以先获取 GoogleID，再赋值给Application全局变量
                    map.put("X-Client-ID", AppUtil.getClientID());
                    map.put("X-Version", AppUtil.getVersionCode());
                    map.put("Model", AppUtil.getModel());
                    map.put("Lang", AppUtil.getLang());
                    result.success(map); //  result 回調必須在UI 线程 ，默认当前线程为UI 线程
                } catch (Exception e) {
                    Log.e("----AppInfoChannel: ", "Exception " + e.getMessage());
                    e.printStackTrace();
                    result.error("AppInfoChannelError", e.getMessage(), null);
                }
                break;
            case "getAdvertisingId":
                Observable.fromCallable(() -> {
                    return "test AdvertisingId";
                }).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        result.success(s);
                    }
                });
                break;
        }

    }

}
