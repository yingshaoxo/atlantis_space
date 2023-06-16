package xyz.yingshaoxo.atlantisspace

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import android.widget.Toast
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import xyz.yingshaoxo.atlantis_space.BuildConfig
import java.io.File
import java.nio.file.Path
import kotlin.io.path.Path
import kotlin.io.path.createDirectory
import kotlin.io.path.exists
import kotlin.io.path.listDirectoryEntries
import kotlin.io.path.pathString


class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Global_Variable.current_activity = this.activity;
        Global_Variable.application_content = this.applicationContext;

        /*
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("@views/my_native-views", My_Native_View_Factory())
         */

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "my_kotlin_functions").setMethodCallHandler { call, result ->
            if (call.method.contentEquals("install_apk_file")) {
                var apk_path = call.argument<String>("apk_path")
                if (apk_path != null) {
                    install_apk_file(apk_path)
                    result.success("Apk installed")
                } else {
                    result.error("error", "Something went wrong", null)
                }
            }

            if (call.method.contentEquals("get_all_installed_apps")) {
                var data_ = get_all_installed_apps()
                var data_string = JSONArray(data_).toString()
                result.success(data_string)
            }

            if (call.method.contentEquals("get_all_saved_apps")) {
                var data_ = get_all_saved_apps()
                var data_string = JSONArray(data_).toString()
                result.success(data_string)
            }

            if (call.method.contentEquals("open_a_folder")) {
                var path = call.argument<String>("path")
                if (path != null) {

                    val selectedUri = Uri.parse( path )
                    val intent = Intent("android.intent.action.VIEW")
                    intent.data = selectedUri // uri of directory from FileProvider, DocumentProvider or uri with file scheme, can be empty.
                    intent.putExtra("org.openintents.extra.ABSOLUTE_PATH", path) // String
                    startActivity(intent)

                    result.success("Folder opened")
                } else {
                    result.error("error", "Something went wrong", null)
                }
            }

            if (call.method.contentEquals("get_local_apk_parent_folder_path")) {
                var exported_apk_parent_folder = get_local_apk_parent_folder_path()
                if (exported_apk_parent_folder == null) {
                    result.success("")
                } else {
                    result.success(exported_apk_parent_folder.pathString)
                }
            }
        }
    }

    companion object {
        var author = "yingshaoxo"

        /*
        string apk_assets_path = 1;
        string app_id = 2;
        string app_name = 3;
        string app_name_end_with_dot_apk = 4;
        string app_icon_base64_string = 5;
        string source_apk_path = 6;
        string exported_apk_path = 7;
        */

        fun get_all_installed_apps(): MutableList<Map<String, String>> {
            var a_list: MutableList<ApplicationInfo> = mutableListOf()
            var packageManager = Global_Variable.current_activity?.packageManager
            a_list = packageManager?.getInstalledApplications(PackageManager.GET_META_DATA) as MutableList<ApplicationInfo>

            var result_list: MutableList<Map<String, String>> = mutableListOf()
            for (app in a_list) {
                var result = mutableMapOf<String, String>()

                result["apk_assets_path"] = ""
                result["app_id"] = app.packageName

                var app_name = app.loadLabel(packageManager).toString()
                result["app_name"] = app_name

                var app_name_end_with_dot_apk = app_name + ".apk"
                result["app_name_end_with_dot_apk"] = app_name_end_with_dot_apk

                val app_icon_data: Drawable = app.loadIcon(packageManager)
                result["app_icon_base64_string"] = Tools.convert_drawable_to_base64(app_icon_data)

                result["source_apk_path"] = app.publicSourceDir

                var exported_parent_path = get_local_apk_parent_folder_path()
                if (exported_parent_path != null) {
                    var exported_apk_path = Path(exported_parent_path.pathString, app_name_end_with_dot_apk)
                    result["exported_apk_path"] = exported_apk_path.pathString
                } else {
                    result["exported_apk_path"] = ""
                }

                result_list.add(result)
            }

            return result_list
        }

        fun get_all_saved_apps(): MutableList<Map<String, String>> {
            var result_list: MutableList<Map<String, String>> = mutableListOf()
            var exported_apk_parent_folder = get_local_apk_parent_folder_path()

            if (exported_apk_parent_folder == null) {
                return result_list
            }

            var packageManager = Global_Variable.current_activity?.packageManager!!

            val files: List<Path> = exported_apk_parent_folder.listDirectoryEntries("*.apk")
            for (file in files) {
                var app = get_application_info_from_apk_file(file)
                if (app == null) {
                    continue
                }

                var result = mutableMapOf<String, String>()

                result["apk_assets_path"] = ""
                result["app_id"] = app.packageName

                var app_name = app.loadLabel(packageManager).toString()
                result["app_name"] = app_name

                var app_name_end_with_dot_apk = file.pathString.split("/").last()
                result["app_name_end_with_dot_apk"] = app_name_end_with_dot_apk

                val app_icon_data: Drawable = app.loadIcon(packageManager)
                result["app_icon_base64_string"] = Tools.convert_drawable_to_base64(app_icon_data)

                result["source_apk_path"] = app.publicSourceDir

                var exported_parent_path = Global_Variable.current_activity?.getExternalFilesDir(null)?.path.toString()
                if (exported_parent_path != null && exported_parent_path != "") {
                    val parent_folder_path = Path(exported_parent_path, "apks")
                    if (!parent_folder_path.exists()) {
                        parent_folder_path.createDirectory()
                    }
                    exported_parent_path = Path(parent_folder_path.pathString, app_name_end_with_dot_apk).pathString
                    result["exported_apk_path"] = exported_parent_path
                } else {
                    result["exported_apk_path"] = ""
                }

                result_list.add(result)
            }

            return result_list
        }

        fun get_local_apk_parent_folder_path(): Path? {
            var exported_parent_path = Global_Variable.current_activity?.getExternalFilesDir(null)?.path.toString()
            if (exported_parent_path != null && exported_parent_path != "") {
                val parent_folder_path = Path(exported_parent_path, "apks")
                if (!parent_folder_path.exists()) {
                    parent_folder_path.createDirectory()
                }
                return parent_folder_path
            } else {
                return null
            }
        }

        fun get_application_info_from_apk_file(apk_file_path: Path) : ApplicationInfo? {
            var packageManager = Global_Variable.current_activity?.packageManager
            var package_info: PackageInfo? = packageManager?.getPackageArchiveInfo(apk_file_path.pathString, 0);

            if (package_info != null) {
                package_info.applicationInfo?.sourceDir       = apk_file_path.pathString;
                package_info.applicationInfo?.publicSourceDir = apk_file_path.pathString;
                //app_icon_data = package_info.applicationInfo?.loadIcon(packageManager);
                return package_info.applicationInfo
            } else {
                return null
            }
        }

        fun install_apk_file(file_path: String) {
            if (Global_Variable.application_content == null) {
                return
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                var has_install_permission = Global_Variable.current_activity?.packageManager?.canRequestPackageInstalls()
                if (has_install_permission == null) {
                    has_install_permission = false
                }
                if(!has_install_permission){
                    Global_Variable.current_activity?.startActivityForResult(
                        Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
                            .setData(Uri.parse(String.format("package:%s", Global_Variable?.current_activity?.packageName))), 1);
                }
            }

            val file = File(file_path)
            if (file.exists()) {
                val intent = Intent(Intent.ACTION_VIEW)
                //var the_file = File(file_path.removePrefix("/data/"))
                var the_file = File(file_path)
                val the_uri = get_uri_from_file(Global_Variable.current_activity?.applicationContext, the_file)
                intent.setDataAndType(
                    the_uri,
                    "application/vnd.android.package-archive"
                )
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                try {
                    Global_Variable.current_activity?.applicationContext?.startActivity(intent)
                } catch (e: ActivityNotFoundException) {
                    e.printStackTrace()
                    Log.e("TAG", "Error in opening the file!")
                }
            } else {
                Toast.makeText(Global_Variable.current_activity?.applicationContext, "installing", Toast.LENGTH_LONG).show()
            }
        }

        private fun get_uri_from_file(context: Context?, file: File?): Uri? {
            var result: Uri? = null
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                result = FileProvider.getUriForFile(
                    context!!, BuildConfig.APPLICATION_ID + ".provider",
                    file!!
                )
            } else {
                result = Uri.fromFile(file)
            }
            return result
        }
    }
}
