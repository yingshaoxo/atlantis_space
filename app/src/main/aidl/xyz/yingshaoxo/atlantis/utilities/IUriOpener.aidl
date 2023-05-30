// IUriOpener.aidl
package xyz.yingshaoxo.atlantis.utilities;

import android.os.ParcelFileDescriptor;

interface IUriOpener {
    ParcelFileDescriptor openFile(in String mode);
}
