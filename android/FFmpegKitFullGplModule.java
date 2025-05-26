package com.soundsnap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.arthenica.ffmpegkit.FFmpegKit;

public class FFmpegKitFullGplModule extends ReactContextBaseJavaModule {
  FFmpegKitFullGplModule(ReactApplicationContext context) {
    super(context);
  }

  @Override
  public String getName() {
    return "FfmpegKitFullGpl";
  }

  @ReactMethod
  public void execute(String command, Promise promise) {
    FFmpegKit.executeAsync(command, session -> {
      if (session.getReturnCode().isValueSuccess()) {
        promise.resolve("success");
      } else {
        promise.reject("FFMPEG_ERROR", "Android FFmpeg failed");
      }
    });
  }
}
