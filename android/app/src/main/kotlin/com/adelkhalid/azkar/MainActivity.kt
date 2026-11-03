package com.adelkhalid.azkar

import android.content.ActivityNotFoundException
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
                    // تشغيل النسخ في خلفية سريعة لعدم تجميد الشاشة
                    thread {
                        try {
                            val appInfo = packageManager.getApplicationInfo(packageName, 0)
                            val apkSource = File(appInfo.publicSourceDir)

                            val cacheDir = File(cacheDir, "shared_apk")
                            if (!cacheDir.exists()) {
                                cacheDir.mkdirs()
                            }
                            val apkCopy = File(cacheDir, "azkar.apk")

                            // نسخ الملف فقط إذا لم يكن موجوداً أو تغير حجمه
                            if (!apkCopy.exists() || apkCopy.length() != apkSource.length()) {
                                FileInputStream(apkSource).use { input ->
                                    FileOutputStream(apkCopy).use { output ->
                                        input.copyTo(output)
                                    }
                                }
                            }

                            val apkUri: Uri = FileProvider.getUriForFile(
                                this,
                                "${packageName}.fileprovider",
                                apkCopy
                            )

                            val shareIntent = Intent(Intent.ACTION_SEND).apply {
                                type = "application/vnd.android.package-archive"
                                putExtra(Intent.EXTRA_STREAM, apkUri)
                                putExtra(Intent.EXTRA_TEXT, "🌙 تطبيق أذكاري — تطبيق إسلامي متكامل\nصنع بكل حب — عادل خالد ❤️")
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            }

                            runOnUiThread {
                                var launched = false
                                for (waPkg in listOf("com.whatsapp", "com.whatsapp.w4b")) {
                                    try {
                                        val intent = Intent(shareIntent).apply {
                                            setPackage(waPkg)
                                        }
                                        startActivity(intent)
                                        launched = true
                                        break
                                    } catch (_: ActivityNotFoundException) {
                                        // جرب النسخة التالية
                                    }
                                }

                                if (!launched) {
                                    val chooser = Intent.createChooser(shareIntent, "مشاركة ملف التطبيق (APK)")
                                    startActivity(chooser)
                                }

                                result.success(true)
                            }
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("SHARE_ERROR", e.message, null)
                            }
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
