# MediaPipe
-keep class com.google.mediapipe.** { *; }
-dontwarn com.google.mediapipe.**

# Protobuf
-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

# Tensorflow
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

-keepattributes *Annotation*