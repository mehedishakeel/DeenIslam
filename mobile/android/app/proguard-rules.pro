# DeenIslam R8 / ProGuard keep rules
-keep class com.mehedishakeel.deenislam.** { *; }
-keepclassmembers class com.mehedishakeel.deenislam.** { *; }

# Keep Flutter embedding & plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn javax.annotation.**
