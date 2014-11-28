/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package com.beibei.wordmaster;

import java.util.ArrayList;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;  

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.provider.Settings;
import android.view.WindowManager;
import c.bb.dc.BBNDK;

import com.anysdk.framework.PluginWrapper;
import com.avos.avoscloud.AVAnalytics;
import com.avos.avoscloud.AVOSCloud;

// The name of .so is specified in AndroidMenifest.xml. NativityActivity will load it automatically for you.
// You can use "System.loadLibrary()" to load other .so files.

public class AppActivity extends Cocos2dxActivity {
	
	private static String LEAN_CLOUD_ID_TEST  =  "gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn";
	private static String LEAN_CLOUD_KEY_TEST =  "x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3";

	private static String LEAN_CLOUD_ID       =  "94uw2vbd553rx8fa6h5kt2y1w07p0x2ekwusf4w88epybnrp";
	private static String LEAN_CLOUD_KEY      =  "lqsgx6mtmj65sjgrekfn7e5c28xc7koptbk9mqag2oraagdz";
	
    public Cocos2dxGLSurfaceView onCreateView() {  
        Cocos2dxGLSurfaceView glSurfaceView = new Cocos2dxGLSurfaceView(this);  
        // TestCpp should create stencil buffer  
        glSurfaceView.setEGLConfigChooser(5, 6, 5, 0, 16, 8);  

        return glSurfaceView;  
    }  
    
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		BBNDK.setup(getApplicationContext(), this);
		
		if (BBNDK.nativeIsDebug()) {
			// test server
			AVOSCloud.initialize(this, LEAN_CLOUD_ID_TEST, LEAN_CLOUD_KEY_TEST);
			AVOSCloud.setDebugLogEnabled(true);
		} else {
			// server
			AVOSCloud.initialize(this, LEAN_CLOUD_ID, LEAN_CLOUD_KEY);
		}
		
		AVAnalytics.trackAppOpened(getIntent());
		AVAnalytics.enableCrashReport(this, true);
		
		PluginWrapper.init(this);
		
		if (BBNDK.nativeIsLandScape()) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
		} else {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
		}
		
		//2.Set the format of window
		
		// Check the wifi is opened when the native is debug.
		if (BBNDK.nativeIsDebug()) {
			getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
			if (!isNetworkConnected()) {
				AlertDialog.Builder builder=new AlertDialog.Builder(this);
				builder.setTitle("Warning");
				builder.setMessage("Open Wifi for debuging...");
				builder.setPositiveButton("OK",new DialogInterface.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
						finish();
						System.exit(0);
					}
				});
				builder.setCancelable(false);
				builder.show();
			}
		}
		BBNDK.setHostIPAdress( getHostIpAddress() );
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data){
		super.onActivityResult(requestCode, resultCode, data);
		PluginWrapper.onActivityResult(requestCode, resultCode, data);
	}
	
	@Override
	protected void onPause() {
		BBNDK.pushNotification();
		
		PluginWrapper.onPause();
		AVAnalytics.onPause(this);
        super.onPause();
    }

	@Override
    protected void onResume() {
		BBNDK.cancelNotification();
		
        super.onResume();
        AVAnalytics.onResume(this);
        PluginWrapper.onResume();
    }
    
    @Override
    protected void onNewIntent(Intent intent) {
        PluginWrapper.onNewIntent(intent);
        super.onNewIntent(intent);
    }
    
	private boolean isNetworkConnected() {
		ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cm != null) {
			NetworkInfo networkInfo = cm.getActiveNetworkInfo();
			ArrayList<Integer> networkTypes = new ArrayList<Integer>();
			networkTypes.add(ConnectivityManager.TYPE_WIFI);
			try {
				networkTypes.add(ConnectivityManager.class.getDeclaredField(
						"TYPE_ETHERNET").getInt(null));
			} catch (NoSuchFieldException nsfe) {
			} catch (IllegalAccessException iae) {
				throw new RuntimeException(iae);
			}
			if (networkInfo != null
					&& networkTypes.contains(networkInfo.getType())) {
				return true;
			}
		}
		return false;
	}
	 
	public String getHostIpAddress() {
		WifiManager wifiMgr = (WifiManager) getSystemService(WIFI_SERVICE);
		WifiInfo wifiInfo = wifiMgr.getConnectionInfo();
		int ip = wifiInfo.getIpAddress();
		return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
	}
}
