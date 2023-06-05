// IGetAppsCallback.aidl
package xyz.yingshaoxo.atlantisspace.services;

import xyz.yingshaoxo.atlantisspace.utilities.ApplicationInfoWrapper;

interface IGetAppsCallback {
    void callback(in List<ApplicationInfoWrapper> apps);
}
