// IUriOpener.aidl
package xyz.yingshaoxo.atlantisspace.utilities;

import android.os.ParcelFileDescriptor;

interface IUriOpener {
    ParcelFileDescriptor openFile(in String mode);
}
