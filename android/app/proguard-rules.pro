# Gson (used by flutter_local_notifications to persist scheduled
# notifications for reboot-rescheduling) relies on generic type information
# via TypeToken reflection. R8 strips this by default, which crashes
# ScheduledNotificationBootReceiver with "Missing type parameter" as soon as
# a notification has actually been scheduled. Keep what Gson needs.
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken

-keep class com.dexterous.flutterlocalnotifications.** { *; }
