// IShelterService.aidl
package xyz.yingshaoxo.atlantis.services;

import android.content.pm.ApplicationInfo;

import xyz.yingshaoxo.atlantis.services.IAppInstallCallback;
import xyz.yingshaoxo.atlantis.services.IGetAppsCallback;
import xyz.yingshaoxo.atlantis.services.ILoadIconCallback;
import xyz.yingshaoxo.atlantis.services.IStartActivityProxy;
import xyz.yingshaoxo.atlantis.util.ApplicationInfoWrapper;
import xyz.yingshaoxo.atlantis.util.UriForwardProxy;

interface IShelterService {
    void ping();
    void stopShelterService(boolean kill);
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
