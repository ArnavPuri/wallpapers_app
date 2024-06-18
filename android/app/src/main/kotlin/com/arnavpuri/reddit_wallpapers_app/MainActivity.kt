package com.arnavpuri.reddit_wallpapers_app

import android.app.WallpaperManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.arnavpuri.reddit_wallpapers_app/setWallpaper"

    @OptIn(DelicateCoroutinesApi::class)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "setWallpaper") {
                val bytes = call.arguments<ByteArray>()
                GlobalScope.launch(Dispatchers.Main) {
                    val bitmap: Bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes?.size ?: 0)
                    val wallpaperManager = WallpaperManager.getInstance(applicationContext)
                    try {
                        wallpaperManager.setBitmap(bitmap)
                        result.success("Wallpaper set successfully")
                    } catch (e: IOException) {
                        result.error("UNAVAILABLE", "Failed to set wallpaper", e)
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
