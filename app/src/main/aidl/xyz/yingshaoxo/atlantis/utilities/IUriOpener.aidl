// IUriOpener.aidl
package xyz.yingshaoxo.atlantis.util;

import android.os.ParcelFileDescriptor;

interface IUriOpener {
    ParcelFileDescriptor openFile(in String mode);
}
