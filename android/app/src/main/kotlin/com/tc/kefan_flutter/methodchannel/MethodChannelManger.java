package com.tc.kefan_flutter.methodchannel;

import android.app.Activity;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;


public class MethodChannelManger {

    public static final String APP_INFO = "com.tc.kefan/appInfo";

    private MethodChannelManger() {

    }

    public static MethodChannelManger getInstance() {
        return new MethodChannelManger();
    }

    public void registerAllMethod(FlutterActivity flutterActivity) {
        AppInfoMethodChannel.registerWith(flutterActivity.registrarFor(APP_INFO));
    }

    public void registerAllMethod(FlutterEngine engine, Activity activity) {
        AppInfoMethodChannel.registerWith(engine, activity);
    }


}
