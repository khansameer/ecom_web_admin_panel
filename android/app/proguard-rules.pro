####################################
# Flutter / General
####################################
# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Parcelable CREATOR
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

####################################
# Kotlin Parcelize
####################################
-keep class kotlinx.parcelize.** { *; }
-dontwarn kotlinx.parcelize.**
-keep @kotlinx.parcelize.Parcelize class * { *; }

####################################
# Stripe SDK
####################################
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**

# Push Provisioning (optional, only if using Google Pay / Wallet)
-dontwarn com.stripe.android.pushProvisioning.**

####################################
# Firebase
####################################
# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

####################################
# Desugaring / Java 11+
####################################
-dontwarn j$.**
