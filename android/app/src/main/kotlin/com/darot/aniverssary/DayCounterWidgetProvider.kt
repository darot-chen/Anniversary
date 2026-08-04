package com.darot.aniverssary

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.graphics.Rect
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home screen widget showing the relationship day count, both partners'
 * names and photos. Data is written by the Flutter app (see
 * lib/services/home_widget_service.dart) into the SharedPreferences file
 * the home_widget plugin reads from.
 */
class DayCounterWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.day_counter_widget).apply {
                val dayCountText = widgetData.getString("dayCountText", null) ?: "— Days"
                val sinceText = widgetData.getString("sinceText", null) ?: "Since —"
                setTextViewText(R.id.widget_day_count, dayCountText)
                setTextViewText(R.id.widget_since, sinceText)

                val userName = widgetData.getString("userName", null)?.trim().orEmpty()
                val partnerName = widgetData.getString("partnerName", null)?.trim().orEmpty()
                val namesText = listOf(userName, partnerName).filter { it.isNotEmpty() }
                    .joinToString(" ❤️ ")
                if (namesText.isNotEmpty()) {
                    setTextViewText(R.id.widget_names, namesText)
                    setViewVisibility(R.id.widget_names, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.widget_names, View.GONE)
                }

                setAvatar(this, R.id.widget_user_photo, widgetData.getString("userPhotoPath", null))
                setAvatar(this, R.id.widget_partner_photo, widgetData.getString("partnerPhotoPath", null))

                val pendingIntent =
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun setAvatar(views: RemoteViews, viewId: Int, path: String?) {
        if (path == null) return
        val bitmap = BitmapFactory.decodeFile(path) ?: return
        // The XML's 8dp padding insets the placeholder person icon; a real
        // photo should fill the whole circle instead.
        views.setViewPadding(viewId, 0, 0, 0, 0)
        views.setImageViewBitmap(viewId, circularBitmap(bitmap))
    }

    /** Crops [source] into a circle so it matches the round avatar placeholder. */
    private fun circularBitmap(source: Bitmap): Bitmap {
        val size = minOf(source.width, source.height)
        val x = (source.width - size) / 2
        val y = (source.height - size) / 2

        val output = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(output)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        val rect = Rect(0, 0, size, size)

        canvas.drawOval(rect.left.toFloat(), rect.top.toFloat(), rect.right.toFloat(), rect.bottom.toFloat(), paint)
        paint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_IN)
        canvas.drawBitmap(source, Rect(x, y, x + size, y + size), rect, paint)
        return output
    }
}
