package com.tc.kefan_flutter.util;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.TextUtils;

import androidx.core.app.ActivityCompat;

import com.tc.kefan_flutter.BaseApplication;

import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;
import java.util.Locale;
import java.util.UUID;

public class AppUtil {



    private static String clientID = "";

    public static String getClientID() {
        if (!TextUtils.isEmpty(clientID)) {
            return clientID;
        }
        try {
            String devId = getDeviceId();
            if (TextUtils.isEmpty(devId) || (!TextUtils.isEmpty(devId) && devId.length() < 5)) {
                if (TextUtils.isEmpty(UUID.randomUUID().toString())) {
                    SPUtils.saveValue("UUID", UUID.randomUUID().toString());
                }
                clientID = SPUtils.getValue("UUID", "").toString();
            } else {
                clientID = devId;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return clientID;
    }


    /**
     * @return 获取应用版本名称
     */
    public static String getVersionName() {
        try {
            PackageManager packageManager = BaseApplication.getInstance().getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(BaseApplication.getInstance().getPackageName(), 0);
            return packageInfo.versionName;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * @return 获取应用版本号
     */
    public static int getVersionCode() {
        try {
            PackageManager packageManager = BaseApplication.getInstance().getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(BaseApplication.getInstance().getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private static String deviceId = "";

    public static String getDeviceId() {
        Context context = BaseApplication.getInstance();
        StringBuffer buffer = new StringBuffer();
        if (!TextUtils.isEmpty(deviceId)) {
            return deviceId;
        }
        try {
            buffer.append("mac:").append(getLocalMacAddress(BaseApplication.getInstance())).append(",");
            buffer.append("androidId:").append(getLocalAndroidId(BaseApplication.getInstance())).append(",")
                    .append(":SERIAL:").append((Build.VERSION.SDK_INT >= 9) ? Build.SERIAL : "")
                    .append(":PRODUCT:").append(Build.PRODUCT)
                    .append(":BOARD:").append(Build.BOARD)
                    .append(":MODEL:").append(Build.MODEL)
                    .append(":ID:").append(Build.ID);
            TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                String imei = tm.getDeviceId();
                buffer.append("imei:").append(imei);
            }
        } catch (Exception e) {
            deviceId = buffer.toString();
            e.printStackTrace();
        }
        deviceId = UUID.nameUUIDFromBytes(buffer.toString().getBytes()).toString().replaceAll("-", "");
        return deviceId;
    }


    /**
     * 获取Android ID
     *
     * @param context
     * @return
     */
    public static String getLocalAndroidId(Context context) {
        String androidID = "";
        try {
            androidID = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        } catch (Exception e) {
            System.out.println("dfp android id:" + e.getMessage());
        }
        if ("9774d56d682e549c".equals(androidID)) androidID = "";//部分机型BUG
        return androidID;
    }

    /**
     * 获取MAC地址
     *
     * @param context
     * @return
     */
    @SuppressLint("NewApi")
    public static String getLocalMacAddress(Context context) {
        String res = "";
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
            WifiManager wifi = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
            WifiInfo info = wifi.getConnectionInfo();
            res = info.getMacAddress();
        }
        if (("02:00:00:00:00:00".equals(res) || TextUtils.isEmpty(res)) && Build.VERSION.SDK_INT >= 9) {//android6.0返回假值
            try {
                Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
                while (interfaces.hasMoreElements()) {
                    NetworkInterface nif = interfaces.nextElement();

                    byte[] addr = nif.getHardwareAddress();
                    if (addr == null || addr.length == 0) {
                        continue;
                    }

                    StringBuilder buf = new StringBuilder();
                    for (byte b : addr) {
                        buf.append(String.format("%02X:", b));
                    }
                    if (buf.length() > 0) {
                        buf.deleteCharAt(buf.length() - 1);
                    }
                    String mac = buf.toString();

                    if ("wlan0".equals(nif.getName())) {
                        res = mac;
                        break;
                    }
                }
            } catch (SocketException e) {
                //e.printStackTrace();
            }
        }
//        Logger.e("----getLocalMacAddress--" + res == null ? "" : res.toLowerCase(Locale.US));
        return res == null ? "" : res.toLowerCase(Locale.US);
    }

    public static String getModel() {
        String value = Build.MODEL;
        for (int i = 0, length = value.length(); i < length; i++) {
            char c = value.charAt(i);
            if ((c <= '\u001f' && c != '\t') || c >= '\u007f') {
                return "Unknown";
            }
        }
        return value;
    }

    public static String getLang() {
        return Locale.getDefault().getLanguage() + "-" + Locale.getDefault().getCountry();
    }

}
