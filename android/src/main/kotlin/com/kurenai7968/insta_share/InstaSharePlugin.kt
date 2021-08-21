package com.kurenai7968.insta_share

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.StrictMode
import android.os.StrictMode.VmPolicy
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.FileProvider.getUriForFile
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File


/** InstaSharePlugin */
class InstaSharePlugin: FlutterPlugin, MethodCallHandler {
  private val CHANNEL: String = "com.kurenai7968.insta_share"
  private val INSTAGRAM_PACKAGE_ID: String = "com.instagram.android"
  private lateinit var context: Context
  private lateinit var channel:MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger,"$CHANNEL.method")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "share" -> {
        val path: String = call.argument("path")!!
        val type: String = call.argument("type")!!
        val intentType: String = if (type == "image") "image/*" else "video/*"
        instagramShare(path, intentType)
      }
      "installed" -> {
        result.success(instagramInstalled())
      }
    }
  }

  private fun instagramShare(path: String, type: String) {
    if (instagramInstalled()) {
      try{
        val shareIntent = Intent()
        val file = File(path)

        if (file.exists()) {
          val builder = VmPolicy.Builder()
          StrictMode.setVmPolicy(builder.build());
          val uri: Uri = getUriForFile(context, "com.kurenai7968.insta_share.file_provider", file)
          shareIntent.action = Intent.ACTION_SEND
          shareIntent.type = type
          shareIntent.`package` = INSTAGRAM_PACKAGE_ID
          shareIntent.putExtra(Intent.EXTRA_STREAM, uri)
          shareIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
          context.startActivity(shareIntent)
        } else {
          Log.e("InstaShare", "File is not exist.")
        }
      } catch (e: Error) {
        Log.e("InstaShare", e.toString())
      }
    } else {
      Log.e("InstaShare", "Instagram is not installed.")
      val intent = Intent()
      intent.action = Intent.ACTION_VIEW
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      try {
        intent.data = Uri.parse("market://details?id=$INSTAGRAM_PACKAGE_ID")
        context.startActivity(intent)
      } catch (e: Error) {
        intent.data = Uri.parse("https://play.google.com/store/apps/details?id=$INSTAGRAM_PACKAGE_ID")
        context.startActivity(intent)
      }
    }
  }

  private fun instagramInstalled(): Boolean {
    var installed: Boolean
    try {
      context.packageManager.getApplicationInfo(INSTAGRAM_PACKAGE_ID, PackageManager.GET_META_DATA)
      installed = true
    } catch (e: PackageManager.NameNotFoundException) {
      installed = false
    }
    return installed
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
