IJKPlayer Building Script
----
這是降低編譯 IJKPlayer 複雜度的腳本，

以盡力減少編譯失敗的失落感為主。

### 使用方式：
1. 使用終端機執行`#> sh ./cloneAndBuilding.sh`
2. 泡杯咖啡
3. 懷抱不會出事的心等待它結束

### 手動編譯方式：
這是為了避免腳本意外出事而保留的手動流程。

1. `~$ git clone https://github.com/Bilibili/ijkplayer.git` 下載專案
2. 現在的 jikPlayer 的可用版本為 k0.8.8 (紀錄於 2018/4/25) 要切換到這個版本，
</br>`~$ git checkout -B latest k0.8.8`
	* *【選項】如果要支援 rtsp 的話要將 /config/module.sh 的內容置換成這個教學的
rtsp_module.sh*
	* *【選項】要使用更多的 codec 支援的話，要先 rm ./config/module.sh，再 
ln -s ./config/module-default.sh ./config/module.sh*
3. 執行以下命令初始化編譯環境，**./init-ios.sh** 下載 ffmpeg 的資料
4. 要使用 SSL 功能 **./init-ios-openssl.sh** 下載 openssl 的資料
5. `~$ cd ios` 切換到 ios 目錄
6. 用文字編輯器開啟 **compile-ffmpeg.sh** 這個檔案
7. 將 **FF_ALL_ARCHS_IOS8_SDK="armv7 arm64 i386 x86_64"** 的 **armv7** 移除
8. `~$ ./compile-ffmpeg.sh clean` 清除編譯的快取資料
9. `~$ ./compile-ffmpeg.sh all` 開始編譯 ffmpeg
10. 當有使用 SSL 的時候執行以下步驟
	1. `~$ ./compile-openssl.sh clean`  清除編譯的快取資料
	2. `~$ ./compile-openssl.sh all` 開始編譯 openssl
11. 完成後用 finder 進入 **./ios/build/universal/include/libavutil/** 資料夾下
12. 用文字編輯器開啟 **avconfig.h**
13. 將 **#           include "armv7/avconfig.h"** 這行註解
14. 之後到 **./ios/build/universal/include/libffmpeg/**
15. 用文字編輯器開啟 **config.h**
16. 將 **#           include "armv7/config.h"** 這行註解
17. 再到 **ios/IJKMediaPlayer** 資料夾，將 **buildFramework.sh** 這個複製到這底下
18. `~$ chmod +x buildFramework.sh` 之後 
19. `~$ ./buildFramework.sh` 編譯 framework
20. 完成編譯後在使用者桌面就能找到 **IJKMediaPlayer.framework** 這個檔案

### 相依的 Framework：
* libbz2.tbd
* libz.tbd
* AudioToolbox.framework
* AVFoundation.framework
* CoreGraphics.framework
* CoreMedia.framework
* CoreVideo.framework
* MediaPlayer.framework
* MobileCoreServices.framework
* OpenGLES.framework
* QuartzCore.framework
* UIKit.framework
* VideoToolbox.framework

### 常見問題：
1. 在 `~$ ./compile-ffmpeg.sh all` 編譯的時候遇到 **C compiler test failed.** 的時候，下 **sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer/** 這個命令就可以解決。
2. 在 **buildFramework.sh** 編譯 **IJKMediaFrameworkWithSSL** 的時候遇到 **ld: library not found for -lcrypto clang: error: linker command failed with exit code 1 (use -v to see invocation)** 的時候，這就是 openssl 沒有編譯，請先執行步驟 4～8。

### 編譯紀錄：
* 2018-12-21： 因為 Apple 不再支援 armv7，所以會導致編譯上的問題，因此移除 armv7 的支援，編譯完成的 Framwork 即無法在 armv7 的裝置上運行。

