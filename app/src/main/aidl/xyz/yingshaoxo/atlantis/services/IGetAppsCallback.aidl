// IGetAppsCallback.aidl
package xyz.yingshaoxo.atlantis.services;

import xyz.yingshaoxo.atlantis.utilities.ApplicationInfoWrapper;

interface IGetAppsCallback {
    void callback(in List<ApplicationInfoWrapper> apps);
}
