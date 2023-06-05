package xyz.yingshaoxo.atlantisspace;

import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;

import xyz.yingshaoxo.atlantisspace.services.FileShuttleService;
import xyz.yingshaoxo.atlantisspace.services.AtlantisSpaceService;
import xyz.yingshaoxo.atlantisspace.utilities.LocalStorageManager;
import xyz.yingshaoxo.atlantisspace.utilities.SettingsManager;

public class AtlantisSpaceApplication extends Application {
    private ServiceConnection mAtlantisSpaceServiceConnection = null;
    private ServiceConnection mFileShuttleServiceConnection = null;

    @Override
    public void onCreate() {
        super.onCreate();
        LocalStorageManager.initialize(this);
        SettingsManager.initialize(this);
    }

    public void bindAtlantisSpaceService(ServiceConnection conn, boolean foreground) {
        unbindAtlantisSpaceService();
        Intent intent = new Intent(getApplicationContext(), AtlantisSpaceService.class);
        intent.putExtra("foreground", foreground);
        bindService(intent, conn, Context.BIND_AUTO_CREATE);
        mAtlantisSpaceServiceConnection = conn;
    }

    public void bindFileShuttleService(ServiceConnection conn) {
        unbindFileShuttleService();;
        Intent intent = new Intent(getApplicationContext(), FileShuttleService.class);
        bindService(intent, conn, Context.BIND_AUTO_CREATE);
        mFileShuttleServiceConnection = conn;
    }

    public void unbindAtlantisSpaceService() {
        if (mAtlantisSpaceServiceConnection != null) {
            try {
                unbindService(mAtlantisSpaceServiceConnection);
            } catch (Exception e) {
                // This method call might fail if the service is already unbound
                // just ignore anything that might happen.
                // We will be stopping already if this would ever happen.
            }
        }

        mAtlantisSpaceServiceConnection = null;
    }

    public void unbindFileShuttleService() {
        if (mFileShuttleServiceConnection != null) {
            try {
                unbindService(mFileShuttleServiceConnection);
            } catch (Exception e) {
                // ...
            }
        }

        mFileShuttleServiceConnection = null;
    }
}
