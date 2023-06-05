// IAtlantisSpaceService.aidl
package xyz.yingshaoxo.atlantisspace.services;

import android.content.pm.ApplicationInfo;

import xyz.yingshaoxo.atlantisspace.services.IAppInstallCallback;
import xyz.yingshaoxo.atlantisspace.services.IGetAppsCallback;
import xyz.yingshaoxo.atlantisspace.services.ILoadIconCallback;
import xyz.yingshaoxo.atlantisspace.services.IStartActivityProxy;
import xyz.yingshaoxo.atlantisspace.utilities.ApplicationInfoWrapper;
import xyz.yingshaoxo.atlantisspace.utilities.UriForwardProxy;

interface IAtlantisSpaceService {
    void ping();
    void stopAtlantisSpaceService(boolean kill);
    void getApps(IGetAppsCallback callback, boolean showAll);
    void loadIcon(in ApplicationInfoWrapper info, ILoadIconCallback callback);
    void installApp(in ApplicationInfoWrapper app, IAppInstallCallback callback);
    void installApk(in UriForwardProxy uri, IAppInstallCallback callback);
    void uninstallApp(in ApplicationInfoWrapper app, IAppInstallCallback callback);
    void freezeApp(in ApplicationInfoWrapper app);
    void unfreezeApp(in ApplicationInfoWrapper app);
    boolean hasUsageStatsPermission();
    boolean hasSystemAlertPermission();
    boolean hasAllFileAccessPermission();
    List<String> getCrossProfileWidgetProviders();
    boolean setCrossProfileWidgetProviderEnabled(String pkgName, boolean enabled);
    void setStartActivityProxy(in IStartActivityProxy proxy);
}
