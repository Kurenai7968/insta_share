package com.kurenai7968.insta_share

import android.content.Context
import android.content.Intent
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
  private val CHANNEL: String = "com.kurenai7968.insta_share."
  private val INSTAGRAM_PACKAGE_NAME = "com.instagram.android"
  private lateinit var context: Context
  private lateinit var channel:MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL + "method")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "shareToFeed") {
      val path: String = call.argument("path")!!
      val type: String = call.argument("type")!!
      val intentType: String = if (type == "image") "image/*" else "video/*"

      createInstagramIntent(intentType, path)
    } else {
      result.notImplemented()
    }
  }

  private fun createInstagramIntent(type: String, path: String) {
    val shareIntent = Intent()
    val file = File(path)
    val builder = VmPolicy.Builder()
    StrictMode.setVmPolicy(builder.build());
    val uri: Uri = getUriForFile(context, "com.kurenai7968.insta_share.file_provider", file)

    shareIntent.action = Intent.ACTION_SEND
    shareIntent.type = type
    shareIntent.`package` = INSTAGRAM_PACKAGE_NAME
    shareIntent.putExtra(Intent.EXTRA_STREAM, uri)
    shareIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
    context.startActivity(shareIntent)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
