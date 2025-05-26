Created by  MERT ALADAĞ
https://github.com/mertalada

# Getting Started

### For IOS
## Step 1: Podfile
/* Add this line above */
    pod 'ffmpeg-kit-ios-full-gpl', :podspec => './ffmpeg-kit-ios-full-gpl.podspec'

/* Already exists in the pod file -- Don't change anything */
    pod 'ffmpeg-kit-react-native', :subspecs => ['full-gpl'], :podspec => '../node_modules/ffmpeg-kit-react-native/ffmpeg-kit-react-native.podspec'


## Step 2: Create ffmpeg-kit-ios-full-gpl.podspec file in project's ios folder and add the following code in i

        Pod::Spec.new do |s|
            s.name             = 'ffmpeg-kit-ios-full-gpl'
            s.version          = '6.0'   # Must match what ffmpeg-kit-react-native expects.
            s.summary          = 'Custom full-gpl FFmpegKit iOS frameworks from NooruddinLakhani.'
            s.homepage         = 'https://github.com/NooruddinLakhani/ffmpeg-kit-ios-full-gpl'
            s.license          = { :type => 'LGPL' }
            s.author           = { 'NooruddinLakhani' => 'https://github.com/NooruddinLakhani' }
            s.platform         = :ios, '12.1'
            s.static_framework = true
          
            # Use the HTTP source to fetch the zipped package directly.
            s.source           = { :http => 'https://github.com/NooruddinLakhani/ffmpeg-kit-ios-full-gpl/archive/refs/tags/latest.zip' }
          
            # Because the frameworks are inside the extracted archive under:
            # ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc/
            # we list each of the needed frameworks with the full relative path.
            s.vendored_frameworks = [
              'ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc/libswscale.xcframework',
              'ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc/libswresample.xcframework',
              'ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc/libavutil.xcframework',
              'ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc/libavformat.xcframework',
              'ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc/libavfilter.xcframework',
              'ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc/libavdevice.xcframework',
              'ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc/libavcodec.xcframework',
              'ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc/ffmpegkit.xcframework'
            ]
          end
  
  ## Step 3: Run the following commands
        Remove Pods and Podfile.lock
            rm -rf ios/Pods
            rm -f ios/Podfile.lock

        Remove node_modules
            rm -rf node_modules

        Optional: Remove derived data (Xcode cache)
            rm -rf ~/Library/Developer/Xcode/DerivedData

        Reinstall everything
            npm install or yarn install
            cd ios
            pod install
            cd ..

### For Android
  ## Step 1: Modify android/app/build.gradle
    import java.net.URL // Add this line on top of the file

        android {
            .......

            // Add this code for accessing the file locally after downloading
            repositories {
                flatDir {
                    dirs "$rootDir/libs"
                }
            }
        }

        dependencies {

            // Add the following dependencies
            implementation(name: 'ffmpeg-kit-full-gpl', ext: 'aar')
            implementation 'com.arthenica:smart-exception-java:0.2.1'

            ........
        }

        // Add the following script to download the file from the cloud
        afterEvaluate {
            def aarUrl = 'https://github.com/NooruddinLakhani/ffmpeg-kit-full-gpl/releases/download/v1.0.0/ffmpeg-kit-full-gpl.aar'
            def aarFile = file("${rootDir}/libs/ffmpeg-kit-full-gpl.aar")

            tasks.register("downloadAar") {
                doLast {
                     if (!aarFile.parentFile.exists()) {
                        println "📁 Creating directory: ${aarFile.parentFile.absolutePath}"
                        aarFile.parentFile.mkdirs()
                    }
                    if (!aarFile.exists()) {
                        println "⏬ Downloading AAR from $aarUrl..."
                        new URL(aarUrl).withInputStream { i ->
                            aarFile.withOutputStream { it << i }
                        }
                        println "✅ AAR downloaded to ${aarFile.absolutePath}"
                    } else {
                        println "ℹ️ AAR already exists at ${aarFile.absolutePath}"
                    }
                }
            }

            // Make sure the AAR is downloaded before compilation begins
            preBuild.dependsOn("downloadAar")
        }
          
  ## Step 2: Modify android/build.gradle
    buildscript {
        ext {
            .....
            /* Remove the following line */
            ffmpegKitPackage = "full-gpl"
        }
        repositories {
            google()
            mavenCentral()
        }
        dependencies {
            ....

        }
    }

    allprojects {
        repositories {
            google()
            mavenCentral()
            flatDir {
                dirs "$rootDir/libs"
            }
        }
    }

    apply plugin: "com.facebook.react.rootproject"
    
  ## Step 3: Modify package.json and add the following script to download the file from the cloud after executing yarn install or npn install
  
            "scripts": {
            "postinstall": "cd android && ./gradlew :app:downloadAar"
          }
  
  ## Step 4:Modify ffmpeg-kit-react-native package’s android/build.gradle then update the dependency and make a patch
  
          android {
          ....

          defaultConfig {
            // minSdkVersion safeExtGet('ffmpegKitPackage', 'https').contains("-lts") ? 16 : 24
            minSdkVersion 24
            ....
          }
        }

        dependencies {
          ....

          /* Remove the following line */
          implementation 'com.arthenica:ffmpeg-kit-' + safePackageName(safeExtGet('ffmpegKitPackage', 'https')) + ':' + safePackageVersion(safeExtGet('ffmpegKitPackage', 'https'))
          
          /* Add this line */
          implementation(name: 'ffmpeg-kit-full-gpl', ext: 'aar')
        }
        
    ## Step 5: modify Mainapplication.kt  (yourappname/android/app/src/main/java/com/yourappname/MainApplication.kt)
    // change yourappname
        import com.yourappname.FFmpegKitFullGplPackage
        
        override fun getPackages(): List<ReactPackage> =
            PackageList(this).packages.apply {
                add(FFmpegKitFullGplPackage())
            }
        
        
-------------------------------------------------------
-ios
    -ffmpeg-kit-ios-full-gpl.podspec
    -FFmpegKitIosFullGpl.mm
    -FFmpegKitIosFullGpl.swift
    
-android
    -app/src/main/java/com/yourappname
                                    -FFmpegKitFullGplModule.java
                                    -FFmpegKitFullGplPackage.java

-utils
      -ffmpeg-wrapper.js
--------------------------------------------------------------------

## Frontend import and use package

import { executeFFmpegCommand } from '../../utils/ffmpeg-wrapper';
import Video from 'react-native-video';
import RNFS from 'react-native-fs';
import axios from 'axios';
import { Buffer } from 'buffer';

const replaceAudioAndMux = async (videoPath, selectedClone) => {
  const outputDir = RNFS.ExternalDirectoryPath;

  const mutedVideoPath = `${outputDir}/muted_video.mp4`;
  const originalAudioPath = `${outputDir}/extracted_audio.wav`;
  const newAudioPath = `${outputDir}/new_audio.mp3`;
  const finalVideoPath = `${outputDir}/final_video.mp4`;

  const extractAudioCommand = `-y -i "${videoPath}" -vn -acodec pcm_s16le -ar 44100 -ac 1 "${originalAudioPath}"`;
  const removeAudioCommand = `-y -i "${videoPath}" -c:v copy -an "${mutedVideoPath}"`;
  const muxCommand = `-y -i "${mutedVideoPath}" -i "${newAudioPath}" -c:v copy -c:a aac -shortest "${finalVideoPath}"`;

  try {
    console.log(`🔊 [1/6] Sesi çıkarma başlıyor...`);
    await executeFFmpegCommand(extractAudioCommand);
    console.log(`✅ [1/6] Ses çıkarıldı: ${originalAudioPath}`);

    console.log(`🔇 [2/6] Sessiz video oluşturuluyor...`);
    await executeFFmpegCommand(removeAudioCommand);
    console.log(`✅ [2/6] Sessiz video: ${mutedVideoPath}`);

    console.log(`⬆️ [3/6] apiye ses gönderiliyor...`);
    const formData = new FormData();
    formData.append('audio', {
      uri: `file://${originalAudioPath}`,
      name: 'input_audio.wav',
      type: 'audio/wav',
    });
    formData.append('API dependencies', 'API dependencies');

    const response = await axios.post(
      `API URL`,
      formData,
      {
        headers: {
          'xi-api-key': 'API_KEY',
          'Content-Type': 'multipart/form-data',
        },
        responseType: 'arraybuffer',
      }
    );

    console.log(`💾 [4/6] Yeni ses dosyası kaydediliyor...`);
    await RNFS.writeFile(
      newAudioPath,
      Buffer.from(response.data).toString('base64'),
      'base64'
    );
    console.log(`✅ [4/6] Yeni ses başarıyla kaydedildi.`);

    console.log(`🎬 [5/6] Video ve ses birleştiriliyor...`);
    await executeFFmpegCommand(muxCommand);
    console.log(`✅ [6/6] Final video oluşturuldu: ${finalVideoPath}`);

    return finalVideoPath;
  } catch (error) {
    console.error('❌ [!] Hata oluştu:', error);
    return null;
  }
};



-----------------------------------------------------------
