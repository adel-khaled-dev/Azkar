package com.adelkhalid.azkar

import android.content.ClipData
import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.adelkhalid.azkar/app_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "shareApkViaWhatsApp" -> {
                    thread {
                        try {
                            val appInfo = packageManager.getApplicationInfo(packageName, 0)
                            val apkSource = File(appInfo.publicSourceDir)

                            val cacheFolder = File(this@MainActivity.cacheDir, "shared_apk")
                            if (!cacheFolder.exists()) {
                                cacheFolder.mkdirs()
                            }
                            val apkCopy = File(cacheFolder, "azkar.apk")

                            // نسخ فائق السرعة عبر قنوات الذاكرة
                            if (!apkCopy.exists() || apkCopy.length() != apkSource.length()) {
                                FileInputStream(apkSource).use { srcStream ->
                                    FileOutputStream(apkCopy).use { dstStream ->
                                        val inChannel = srcStream.channel
                                        val outChannel = dstStream.channel
                                        outChannel.transferFrom(inChannel, 0, inChannel.size())
                                    }
                                }
                            }

                            val apkUri: Uri = FileProvider.getUriForFile(
                                this@MainActivity,
                                "${packageName}.fileprovider",
                                apkCopy
                            )

                            val shareIntent = Intent(Intent.ACTION_SEND).apply {
                                type = "*/*"
                                putExtra(Intent.EXTRA_STREAM, apkUri)
                                clipData = ClipData.newRawUri("azkar.apk", apkUri)
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            }

                            val chooser = Intent.createChooser(shareIntent, "إرسال ملف التطبيق (APK)").apply {
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            }

                            runOnUiThread {
                                startActivity(chooser)
                                result.success(true)
                            }
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("SHARE_ERROR", e.localizedMessage ?: e.toString(), null)
                            }
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
