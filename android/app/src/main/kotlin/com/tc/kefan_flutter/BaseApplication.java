package com.tc.kefan_flutter;

import android.app.Application;

import io.flutter.app.FlutterApplication;

public class BaseApplication extends FlutterApplication {


    private static BaseApplication sInstance;
    public static String aId = "";


    @Override
    public void onCreate() {
        super.onCreate();
        sInstance = this;
    }

    /**
     * 获得当前app运行的Application
     */
    public static BaseApplication getInstance() {
        if (sInstance == null) {
//            throw new NullPointerException("please inherit BaseApplication or call setApplication.");
            return null;
        }
        return sInstance;
    }

}
