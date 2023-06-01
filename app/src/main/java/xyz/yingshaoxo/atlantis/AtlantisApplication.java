package xyz.yingshaoxo.atlantis;

import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;

import xyz.yingshaoxo.atlantis.services.FileShuttleService;
import xyz.yingshaoxo.atlantis.services.AtlantisService;
import xyz.yingshaoxo.atlantis.utilities.LocalStorageManager;
import xyz.yingshaoxo.atlantis.utilities.SettingsManager;

public class AtlantisApplication extends Application {
    private ServiceConnection mAtlantisServiceConnection = null;
    private ServiceConnection mFileShuttleServiceConnection = null;

    @Override
    public void onCreate() {
        super.onCreate();
        LocalStorageManager.initialize(this);
        SettingsManager.initialize(this);
    }

    public void bindAtlantisService(ServiceConnection conn, boolean foreground) {
        unbindAtlantisService();
        Intent intent = new Intent(getApplicationContext(), AtlantisService.class);
        intent.putExtra("foreground", foreground);
        bindService(intent, conn, Context.BIND_AUTO_CREATE);
        mAtlantisServiceConnection = conn;
    }

    public void bindFileShuttleService(ServiceConnection conn) {
        unbindFileShuttleService();;
        Intent intent = new Intent(getApplicationContext(), FileShuttleService.class);
        bindService(intent, conn, Context.BIND_AUTO_CREATE);
        mFileShuttleServiceConnection = conn;
    }

    public void unbindAtlantisService() {
        if (mAtlantisServiceConnection != null) {
            try {
                unbindService(mAtlantisServiceConnection);
            } catch (Exception e) {
                // This method call might fail if the service is already unbound
                // just ignore anything that might happen.
                // We will be stopping already if this would ever happen.
            }
        }

        mAtlantisServiceConnection = null;
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
