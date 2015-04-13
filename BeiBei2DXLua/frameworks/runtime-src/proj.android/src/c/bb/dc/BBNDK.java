package c.bb.dc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Environment;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;
import c.bb.dc.sns.CXTencentSDKCall;

import com.avos.avoscloud.AVAnalytics;
import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVQuery;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.FindCallback;
import com.avos.avoscloud.FunctionCallback;
import com.avos.avoscloud.GetCallback;
import com.avos.avoscloud.GetDataCallback;
import com.avos.avoscloud.GetFileCallback;
import com.avos.avoscloud.LogInCallback;
import com.avos.avoscloud.ProgressCallback;
import com.avos.avoscloud.SaveCallback;
import com.avos.avoscloud.SignUpCallback;
import com.avos.sns.SNS;
import com.avos.sns.SNSType;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.umeng.analytics.MobclickAgent;

public class BBNDK {
	private static String _hostIPAdress = "0.0.0.0";
	private static Context _context = null;
	private static Activity _instance = null;
	private static PendingIntent _pendingIntent = null;
	
	public static IWXAPI wxapi;
	
	public static Context getContext() {
		return _context;
	}

	public static void setup(Context context, Activity instance, String weixinAppId) {
		_context = context;
		_instance = instance;
		
		wxapi = WXAPIFactory.createWXAPI(_instance, weixinAppId, true);
		wxapi.registerApp(weixinAppId);
	}
	
	// ***************************************************************************************************************************
	// cocos2d-x runtime
	// ***************************************************************************************************************************
	
	public static void setHostIPAdress(String hostIPAdress) {
		_hostIPAdress = hostIPAdress;
	}
	
	public static String getLocalIpAddress() {
		return _hostIPAdress;
	}
	
	public static String getSDCardPath() {
		if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
			String strSDCardPathString = Environment.getExternalStorageDirectory().getPath();
           return  strSDCardPathString;
		}
		return null;
	} 
	
	// ***************************************************************************************************************************
	// feedback
	// ***************************************************************************************************************************
	
	public static void showMail(String mailTitle, String username) {
		Intent intent = new Intent(Intent.ACTION_SENDTO);
		intent.setData(Uri.parse("mailto:beibeidanci@qq.com"));
//		intent.setType("message/rfc822");
//		intent.putExtra(Intent.EXTRA_EMAIL  , new String[]{"beibeidanci@qq.com"});
		intent.putExtra(Intent.EXTRA_SUBJECT, mailTitle + ":" + username);
		intent.putExtra(Intent.EXTRA_TEXT   , "这是我的反馈，贝贝请认真看哦!\n");
		try {
			_instance.startActivity(Intent.createChooser(intent, "发送反馈邮件"));
		} catch (android.content.ActivityNotFoundException ex) {
		    Toast.makeText(_instance, "There are no email clients installed.", Toast.LENGTH_SHORT).show();
		}
	}
	
	// ***************************************************************************************************************************
	// LeanCloud AVAnalytics
	// ***************************************************************************************************************************
	
	private static HashMap<String, AVObject> daMap = new HashMap<String, AVObject>();
	
	private static void _save(final String deviceId, final String cls, final String tag) {
		AVObject dataAnalytics = daMap.get(cls);
		if (dataAnalytics == null) {
			dataAnalytics = AVObject.create(cls);
			daMap.put(cls, dataAnalytics);
		}
		if (dataAnalytics.containsKey("DA_DEVICE_ID") == false) {
			dataAnalytics.put("DA_DEVICE_ID", deviceId);
		}
		if (dataAnalytics.containsKey(tag) == false) {
			dataAnalytics.put(tag, 1);
		} else {
			dataAnalytics.increment(tag);
		}
		try {
			dataAnalytics.saveEventually(new SaveCallback() {
			    public void done(AVException e) {
			        if (e == null) {
			        	Log.d("saveDataAnalytics", "1 T: " + deviceId + ", " + cls + ", " + tag);
			        } else {
			        	Log.d("saveDataAnalytics", "1 F: " + deviceId + ", " + cls + ", " + tag + ", " + e.getMessage());
			        }
			    }
			});
		} catch (Exception e) {
			Log.d("saveDataAnalytics: 2 保存失败", "_save: " + e.getMessage());
		}
	}
	private static void saveDataAnalytics(final String eventName, final String tag) {
		final String cls = "Z_" + eventName;
		final String deviceId = getDeviceUDID();
		
		if (getConnectedType() == getConnectedType_MOBILE() || getConnectedType() == getConnectedType_WIFI()) {
		
			if (daMap.get(cls) == null) {
				AVQuery<AVObject> query = new AVQuery<AVObject>(cls);
				query.whereEqualTo("DA_DEVICE_ID", deviceId);
				query.findInBackground(new FindCallback<AVObject>() {
				    public void done(List<AVObject> avObjects, AVException e) {
				        if (e == null) {
				            if (avObjects.size() > 0) {
				            	daMap.put(cls, avObjects.get(0));
				            }
				        } else {
				            Log.d("saveDataAnalytics", "query err: " + e.getMessage());
				        }
				        
				        if (daMap.get(cls) == null) {
				        	daMap.put(cls, AVObject.create(cls));
				        }
				        _save(deviceId, cls, tag);
				    }
				});
			} else {
				_save(deviceId, cls, tag);
			}
		
		} else {
			if (daMap.get(cls) == null) {
	        	daMap.put(cls, AVObject.create(cls));
	        }
	        _save(deviceId, cls, tag);
		}
	}
	
	public static void onEvent(String eventName, String  tag) {  
		if (_context != null) {
			AVAnalytics.onEvent(_context, eventName, tag);
			HashMap<String,String> map = new HashMap<String,String>();
			map.put("tag", tag);
			MobclickAgent.onEvent(_context, eventName, map); 
		}
		saveDataAnalytics(eventName, tag);
	}
	
	// ***************************************************************************************************************************
	// LeanCloud download
	// ***************************************************************************************************************************
	
	public static void downloadFile(final String objectId, final String savepath) {
		AVFile.withObjectIdInBackground(objectId, new GetFileCallback<AVFile>() {
			@Override
			public void done(final AVFile file, AVException e) {
				if (file == null || e != null) {
					onDownloadFile(objectId, file != null ? file.getOriginalName() : "", e != null ? e.getLocalizedMessage() : "get file object error", 0);
				} else {
					file.getDataInBackground(new GetDataCallback() {
						@Override
						public void done(byte[] data, AVException arg1) {
							if (arg1 != null) {
								onDownloadFile(objectId, file != null ? file.getOriginalName() : "", arg1.getLocalizedMessage(), 0);
							} else {
								if (data != null && data.length > 0 && BBUtils.saveFile(savepath, file.getOriginalName(), data)) {
									onDownloadFile(objectId, file.getOriginalName(), "save file succeed", 1);
								} else {
									onDownloadFile(objectId, file.getOriginalName(), "save file error", 0);
								}
							}
						}
					}, new ProgressCallback() {
						@Override
						public void done(Integer arg0) {
						}						
					});
				}
			}
		});
	}
	
	private static void onDownloadFile(final String objectId, final String filename, final String error, final int isSaved) {
		((Cocos2dxActivity)(_instance)).runOnGLThread(new Runnable() {

			@Override
			public void run() {
				invokeLuaCallbackFunctionDL(objectId, filename, error, isSaved);
			}
			
		});
	}
	
	public static void downloadWordSoundFiles(final String prefix, final String wordsList, final String subfix, final String path) {
		String[] words = wordsList.split("\\|");
		BBWordSoundFileDownloader first = new BBWordSoundFileDownloader(words, 0, words.length, prefix, subfix, path);
		first.start();
	}
	
	public static void downloadConfigFiles(final String objectIds, final String path) {
		String[] ids = objectIds.split("\\|");
		BBConfigsDownloader o = new BBConfigsDownloader(ids, 0, ids.length, path);
		o.start();
	}
	
	// ***************************************************************************************************************************
	// download
	// ***************************************************************************************************************************
	
	public static void download(final String url, final String savePath, final String filename) {
		StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy); 
        
        String[] urls = {url, savePath, filename}; 
        new DownloadFileFromURL().execute(urls);
	}
	
	// ***************************************************************************************************************************
	// LeanCloud sign up, log in, log out
	// ***************************************************************************************************************************
	
	public static String AVUserToJsonStr(AVUser user) {
		org.json.JSONObject json = user.toJSONObject();
		return json.toString();
		
//		return user.getSessionToken();
	}
	
	public static void signUp(String username, String password) {
		final AVUser user = new AVUser();
		user.setUsername(username);
		user.setPassword(password);
		user.signUpInBackground(new SignUpCallback() {
		    public void done(AVException e) {
		        if (e == null) {
		        	onSignUp(AVUserToJsonStr(user), null, 0);
		        } else {
		        	onSignUp(null, e.getLocalizedMessage(), e.getCode());
		        }
		    }
		});
	}
	
	private static void onSignUp(final String objectjson, final String error, final int errorcode) {
		((Cocos2dxActivity)(_instance)).runOnGLThread(new Runnable() {

			@Override
			public void run() {
				invokeLuaCallbackFunctionSU(objectjson, error, errorcode);
			}
			
		});
	}
	
	public static void logIn(String username, String password) {
		AVUser.logInInBackground(username, password, new LogInCallback<AVUser>() {
			public void done(AVUser user, AVException e) {
		        if (e == null) {
		        	onLogIn(AVUserToJsonStr(user), null, 0);
		        } else {
		        	onLogIn(null, e.getLocalizedMessage(), e.getCode());
		        }
		    }
		});
	}
	
	private static void onLogIn(final String objectjson, final String error, final int errorcode) {
		((Cocos2dxActivity)(_instance)).runOnGLThread(new Runnable() {

			@Override
			public void run() {
				invokeLuaCallbackFunctionLI(objectjson, error, errorcode);
			}
			
		});
	}
	
	public static void initTencentQQ(String appId, String appKey) {
		CXTencentSDKCall.getInstance().init(appId, _instance);
        try {
            SNS.setupPlatform(SNSType.AVOSCloudSNSQQ, appId, appKey, null);
        } catch (AVException e) {
            e.printStackTrace();
        }
	}
		
	public static void logInByQQ() {
		_instance.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				CXTencentSDKCall.getInstance().logIn();
			}
			
		});
	}
	
	public static void logInByQQAuthData(final String openid, final String access_token, final String expires_in) {
		_instance.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				CXTencentSDKCall.getInstance().logInByAuthData(openid, access_token, expires_in, null);
			}
		});
	}
	
	public static void onLogInByQQ(final String objectjson, final String qqjson, final String authjson, final String error, final int errorcode) {
		((Cocos2dxActivity)(_instance)).runOnGLThread(new Runnable() {

			@Override
			public void run() {
				invokeLuaCallbackFunctionLIQQ(objectjson, qqjson, authjson, error, errorcode);
			}
			
		});
	}
	
	public static void logOut() {
		AVUser.logOut();
	}
	
	public static HashMap<String, String> jsonToMap(String t) throws JSONException {
        HashMap<String, String> map = new HashMap<String, String>();
        JSONObject jObject = new JSONObject(t);
        Iterator<?> keys = jObject.keys();

        while ( keys.hasNext() ) {
            String key = (String)keys.next();
            String value = jObject.getString(key); 
            map.put(key, value);
        }

        return map;
    }
	
	public static void testNDK(String func) {
		
	}
	
	public static void callAVCloudFunc(String func, String parameters, final long cppObjPtr) {
		Map<String, String> para = null;
		try {
			para = jsonToMap(parameters);
		} catch (JSONException e) {
			String errorjson = "{\"code\":" + e.hashCode() + ",\"message\":\"" + e.getMessage() + "\",\"description\":\"" + e.getLocalizedMessage() + "\"}";
			invokeLuaCallbackFunctionCallAVCloudFunction(cppObjPtr, null, errorjson);
			return;
		}
		
		AVCloud.callFunctionInBackground(func, para, new FunctionCallback<Object>() {
			public void done(final Object object, final AVException e) {
				
				((Cocos2dxActivity)(_instance)).runOnGLThread(new Runnable() {
					@Override
					public void run() {
						if (e == null) {
							@SuppressWarnings("unchecked")
							JSONObject json = new JSONObject((Map<String, String>)(object));
							String objectjson = json.toString();
							invokeLuaCallbackFunctionCallAVCloudFunction(cppObjPtr, objectjson, null);
						} else {
							String errorjson = "{\"code\":" + e.hashCode() + ",\"message\":\"" + e.getMessage() + "\",\"description\":\"" + e.getLocalizedMessage() + "\"}";
							invokeLuaCallbackFunctionCallAVCloudFunction(cppObjPtr, null, errorjson);
						}
					}
				});
				
			}
		});
	}
	
	public static void searchUser(String username, String nickName, final long cppObjPtr) {
		boolean bu = username != null && username.length() > 0;
		AVQuery<AVUser> query_username = null;
		if (bu) {
			query_username = AVUser.getQuery();
			query_username.whereEqualTo("username", username);
		}
		
		boolean bn = nickName != null && nickName.length() > 0;
		AVQuery<AVUser> query_nickName = null;
		if (bn) {
			query_nickName = AVUser.getQuery();
			query_nickName.whereEqualTo("nickName", nickName);
		}

		AVQuery<AVUser> mainQuery = null;
		if (bu && bn) {
			List<AVQuery<AVUser>> queries = new ArrayList<AVQuery<AVUser>>();
			queries.add(query_username);
			queries.add(query_nickName);
			mainQuery = AVQuery.or(queries);
		} else if (bu) {
			mainQuery = query_username;
		} else if (bn) {
			mainQuery = query_nickName;
		}

		if (mainQuery != null) {
			mainQuery.findInBackground(new FindCallback<AVUser>() {
				public void done(final List<AVUser> results, final AVException e) {
					((Cocos2dxActivity)(_instance)).runOnGLThread(new Runnable() {
						@Override
						public void run() {
							if (e == null) {
								String jsons = "";
								for (AVUser u : results) {
									if (jsons.length() == 0) {
										jsons += "{\"results\":[";
										jsons += AVUserToJsonStr(u);
									} else {
										jsons += "," + AVUserToJsonStr(u);
									}
								}
								if (jsons.length() > 0) {
									jsons += "]}";
								} else {
									jsons = "{\"results\":[]}";
								}
								invokeLuaCallbackFunctionCallAVCloudFunction(cppObjPtr, jsons, null);
							} else {
								String errorjson = "{\"code\":" + e.hashCode() + ",\"message\":\"" + e.getMessage() + "\",\"description\":\"" + e.getLocalizedMessage() + "\"}";
								invokeLuaCallbackFunctionCallAVCloudFunction(cppObjPtr, null, errorjson);
							}
						}
					});
				}
			});
		} else {
			String errorjson = "{\"code\":-1" + ",\"message\":\"CXAVCloud-searchUser query\",\"description\":\"CXAVCloud-searchUser query\"}";
			invokeLuaCallbackFunctionCallAVCloudFunction(cppObjPtr, null, errorjson);
		}
	}
	
	public static void getBulletinBoard(final long cppObjPtr) {
		AVQuery<AVObject> query = AVQuery.getQuery("DataBulletinBoard");
		query.getFirstInBackground(new GetCallback<AVObject>() {
	        public void done(final AVObject object, final AVException e) {
	        	
	        	((Cocos2dxActivity)(_instance)).runOnGLThread(new Runnable() {
					@Override
					public void run() {
						if (object != null) {
							Number index = object.getNumber("index");
							String content_top = object.getString("content_top");
							String content = object.getString("content");
							invokeLuaCallbackFunctionGetBulletinBoard(cppObjPtr, index != null ? index.intValue() : -1, content_top != null ? content_top : "", content != null ? content : "", null);
			            } else {
			            	String errorjson = e != null ? "{\"code\":" + e.hashCode() + ",\"message\":\"" + e.getMessage() + "\",\"description\":\"" + e.getLocalizedMessage() + "\"}" : null;
			        		invokeLuaCallbackFunctionGetBulletinBoard(cppObjPtr, -1, "", "", errorjson);
			            }
			        }
					
	        	});
	        }
		});
	}
	
	// ***************************************************************************************************************************
	// share
	// ***************************************************************************************************************************
	
	public static void shareImageToQQFriend(String path, String title, String desc) {
		CXTencentSDKCall.getInstance().shareImageToQQFriend(path, title, desc);
	}
	
	public static void shareImageToWeiXin(String path, String title, String desc) {
		CXTencentSDKCall.getInstance().shareImageToWeiXin(path, title, desc);
	}
	
	public static void addImageToGallery(final String filePath) {

		String s = CXTencentSDKCall.getInstance().addImageToGallery(filePath);
		if (s == null) return;
		
	    ContentValues values = new ContentValues();

	    values.put(Images.Media.DATE_TAKEN, System.currentTimeMillis());
	    values.put(Images.Media.MIME_TYPE, "image/jpeg");
	    values.put(MediaStore.MediaColumns.DATA, s);
	    values.put(MediaStore.MediaColumns.DISPLAY_NAME, "beibeidanci" + System.currentTimeMillis());
        values.put(MediaStore.MediaColumns.TITLE, "beibeidanci" + System.currentTimeMillis());

	    _context.getContentResolver().insert(Images.Media.EXTERNAL_CONTENT_URI, values);
	    
	}
	
	// ***************************************************************************************************************************
	// loading circle
	// ***************************************************************************************************************************
	
//	private static ProgressDialog _loadingView = null;
	private static MyProgressDialog _loadingView = null;
	
	public static void showCXProgressHUD(final String content) {
		_instance.runOnUiThread(new Runnable() {

			@Override
			public void run() {
//				_hideCXProgressHUD();
				if (_loadingView == null) {
//					_loadingView = ProgressDialog.show(_instance, "", content, true);
					_loadingView = MyProgressDialog.show(_instance, content, "");
				} else {
//					_loadingView.setMessage(content);
					_loadingView.setTitle(content);
				}
			}
			
		});
	}
	
	private static void _hideCXProgressHUD() {
		if (_loadingView != null && _loadingView.isShowing()) {
			_loadingView.dismiss();
		}
		_loadingView = null;
	}
	
	public static void hideCXProgressHUD() {
		_instance.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				_hideCXProgressHUD();
			}
			
		});
	}
	
	// ***************************************************************************************************************************
	// network state
	// ***************************************************************************************************************************	
		
	public static boolean isNetworkConnected() {  
		if (_context != null) {  
			ConnectivityManager connectivityManager = (ConnectivityManager) _context.getSystemService(Context.CONNECTIVITY_SERVICE);  
			NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();  
		    if (networkInfo != null) {  
		    	return networkInfo.isAvailable();  
		    }  
		}  
		return false;  
	}  
	
	// ConnectivityManager.TYPE_WIFI
	// ConnectivityManager.TYPE_MOBILE
	public static boolean isNetworkConnectedWithConnectType(int type) {  
	    if (_context != null) {  
	        ConnectivityManager connectivityManager = (ConnectivityManager) _context.getSystemService(Context.CONNECTIVITY_SERVICE);  
	        NetworkInfo networkInfo = connectivityManager.getNetworkInfo(type);  
	        if (networkInfo != null) {  
	            return networkInfo.isAvailable();  
	        }  
	    }  
	    return false;  
	}
	
	public static int getConnectedType() {  
	    if (_context != null) {  
	        ConnectivityManager connectivityManager = (ConnectivityManager) _context.getSystemService(Context.CONNECTIVITY_SERVICE);  
	        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();  
	        if (networkInfo != null && networkInfo.isAvailable()) {  
	            return networkInfo.getType();  
	        }  
	    }  
	    return getConnectedType_NONE();  
	}
	
	public static int getConnectedType_WIFI() {
		return ConnectivityManager.TYPE_WIFI;
	}
	
	public static int getConnectedType_MOBILE() {
		return ConnectivityManager.TYPE_MOBILE;
	}
	
	public static int getConnectedType_NONE() {
		return -1;
	}
	
	public static String getDeviceUDID() {
		if (_context != null) {
			return Settings.Secure.getString(_context.getContentResolver(), Settings.Secure.ANDROID_ID);
		} else {
			long currentTimeMillis = System.currentTimeMillis();
			return String.valueOf(currentTimeMillis);
		}
	}
	
	public static long getCurrentTimeMillis() {
		long currentTimeMillis = System.currentTimeMillis();
		return currentTimeMillis;
	}
	
	// ***************************************************************************************************************************
	// native
	// ***************************************************************************************************************************
	
	public static native boolean nativeIsLandScape();
	public static native boolean nativeIsDebug();
	public static native void invokeLuaCallbackFunctionDL(String objectId, String filename, String error, int isSaved);
	public static native void invokeLuaCallbackFunctionSU(String objectjson, String error, int errorcode);
	public static native void invokeLuaCallbackFunctionLI(String objectjson, String error, int errorcode);
	public static native void invokeLuaCallbackFunctionLIQQ(String objectjson, String qqjson, String authjson, String error, int errorcode);
	public static native void invokeLuaCallbackFunctionCallAVCloudFunction(long cppObjPtr, String jsons, String errorjson);
	public static native void invokeLuaCallbackFunctionGetBulletinBoard(long cppObjPtr, int index, String content_top, String content, String error);
}
