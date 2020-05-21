#!/usr/bin/env bash

set -euxo pipefail

ANDROID_SDK_ROOT='C:\Program Files (x86)\Android\android-sdk'
# These registry entries are normally set through the GUI: Tools\Options\Xamarin\Android Settings
reg add 'HKCU\SOFTWARE\Xamarin\VisualStudio\15.0_e43b966e\Android' -v JavaSdkDirectory -t REG_SZ -d "C:\Program Files\AdoptOpenJDK\jdk-8.0.252.09-hotspot" -f
# Visual Studio Installer location for the Android SDK
reg add 'HKCU\SOFTWARE\Xamarin\VisualStudio\15.0_e43b966e\Android' -v AndroidSdkDirectory -t REG_SZ -d "$ANDROID_SDK_ROOT" -f
# Sometimes installed by Microsoft in C:\ProgramData\Microsoft\AndroidNDK64 but not present on CI
reg add 'HKCU\SOFTWARE\Xamarin\VisualStudio\15.0_e43b966e\Android' -v AndroidNdkDirectory -t REG_SZ -d "C:\android-ndk-r15c" -f
# Manually install Android NDK r15c, the most recent version that still works with Embeddinator 0.4.0
curl --retry 5 --connect-timeout 30 --location --remote-header-name --remote-name https://dl.google.com/android/repository/android-ndk-r15c-windows-x86_64.zip
echo "970bb2496de0eada74674bb1b06d79165f725696 *android-ndk-r15c-windows-x86_64.zip" | sha1sum -c && 7z x android-ndk-r15c-windows-x86_64.zip -o'C:'
# Manually install Android SDK Platform 24, the most recent version that still works with Embeddinator 0.4.0
"$ANDROID_SDK_ROOT/tools/bin/sdkmanager.bat" --sdk_root="$ANDROID_SDK_ROOT" "platforms;android-24"
