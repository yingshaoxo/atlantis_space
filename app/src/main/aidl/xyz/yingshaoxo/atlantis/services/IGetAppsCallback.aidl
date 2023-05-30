// IGetAppsCallback.aidl
package xyz.yingshaoxo.atlantis.services;

import xyz.yingshaoxo.atlantis.util.ApplicationInfoWrapper;

interface IGetAppsCallback {
    void callback(in List<ApplicationInfoWrapper> apps);
}
