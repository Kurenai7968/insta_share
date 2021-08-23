# insta_share

A instagram share package

## Install

### Android Configuration

- Add provider into `manifest/application` in `android/app/src/main/AndroidManifest.xml`

```xml
<application>
    ...

    <provider
        android:name="androidx.core.content.FileProvider"
        android:authorities="${applicationId}.com.kurenai7968.insta_share.file_provider"
        android:exported="false"
        android:grantUriPermissions="true">
        <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_paths"/>
    </provider>
</application>
```

- Create a xml file named `file_paths.xml` in `android/app/src/main/xml` folder and paste this code in the file.

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
   <cache-path name="insta_share" path="/"/>
</paths>
```

### IOS Configuration

- Paster this code to `ios/Runner/Info.plist` file

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>instagram</string>
</array>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>$(PRODUCT_NAME) wants to save image or viedo to your photo library</string>
```

## Using

### Share image or video

```dart
InstaShare.share(path: path, type: FileType.image);
```

### Check instagram installed

```dart
bool installed = await InstaShare.installed;
```
