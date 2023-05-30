// ILoadIconCallback.aidl
package xyz.yingshaoxo.atlantis.services;

import android.graphics.Bitmap;

interface ILoadIconCallback {
    void callback(in Bitmap icon);
}
