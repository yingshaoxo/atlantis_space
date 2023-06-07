package xyz.yingshaoxo.atlantisspace

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class My_Native_View_Factory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?

        val widget_type_id_string = creationParams?.get("widget_type_id_string")
        if (widget_type_id_string == "app_icon") {
            return App_Icon_Widget(context, viewId, creationParams)
        }

        return Default_Widget(context, viewId, creationParams);
    }
}

internal class App_Icon_Widget(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private var image_view: ImageView;

    private var app_icon_data: Drawable? = null
    private var packageManager: PackageManager? = null;

    override fun getView(): View {
        return image_view
    }

    override fun dispose() {
    }

    init {
        image_view = ImageView(context)

        var apk_path: String = creationParams?.get("apk_path") as String
        if (apk_path != null) {
            packageManager = Global_Variable.current_activity?.packageManager
            var package_info: PackageInfo? = packageManager?.getPackageArchiveInfo(apk_path, 0);

            if (package_info != null) {
                package_info.applicationInfo?.sourceDir       = apk_path;
                package_info.applicationInfo?.publicSourceDir = apk_path;

                app_icon_data = package_info.applicationInfo?.loadIcon(packageManager);

                if (app_icon_data != null) {
                    image_view.setImageDrawable(app_icon_data);
                }
            }
        }
    }
}

internal class Default_Widget(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val textView: TextView

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    init {
        textView = TextView(context)
        textView.textSize = 48f
        textView.setBackgroundColor(Color.rgb(255, 255, 255))
        textView.text = "This app was created by @yingshaoxo"
    }
}
