package com.tc.kefan_flutter

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.tc.kefan_flutter.methodchannel.MethodChannelManger

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannelManger.getInstance().registerAllMethod(flutterEngine, this)
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
