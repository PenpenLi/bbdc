package c.bb.dc.sns;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.widget.Toast;
import c.bb.dc.BBNDK;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.LogInCallback;
import com.tencent.connect.UserInfo;
import com.tencent.connect.common.Constants;
import com.tencent.connect.share.QQShare;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXImageObject;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXTextObject;
import com.tencent.mm.sdk.openapi.*;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

public class CXTencentSDKCall {
	public static String SNSTYPE = "qq";
	
	private static CXTencentSDKCall mInstance = null;
	
	private Tencent mTencent = null;
	private Activity mActivity = null;
	private JSONObject mAuthData = null;
	
	public static CXTencentSDKCall getInstance() {
		if (mInstance == null) {
			mInstance = new CXTencentSDKCall();
		}
		return mInstance;
	}
	
	public void init(String appId, Activity activity) {
		mActivity = activity;
		mTencent = Tencent.createInstance(appId, activity);
	}
	
	// ------------------------------------------------------------------------------
	
	public void logIn() {
		if (!mTencent.isSessionValid()) {
			mTencent.login(mActivity, "all", new LogInListener());
		}
	}
	
	public void logInByAuthData(String openid, String access_token, String expires_in, final Object response) {
		AVUser.AVThirdPartyUserAuth userAuth = new AVUser.AVThirdPartyUserAuth(access_token, expires_in, "qq", openid);
		AVUser.loginWithAuthData(userAuth, new LogInCallback<AVUser>() {
			public void done(AVUser user, AVException e) {
		        if (e == null) {
		        	BBNDK.onLogInByQQ(
		        			BBNDK.AVUserToJsonStr(user), 
		        			response != null ? response.toString() : null, 
		        			mAuthData != null ? mAuthData.toString() : null, 
		        			null, 
		        			0);
		        } else {
		        	BBNDK.onLogInByQQ(null, null, null, e.getLocalizedMessage(), e.getCode());
		        }
		    }
		});
	}
	
	// ------------------------------------------------------------------------------
	
	public boolean saveMyBitmap(String dst, String filename, Bitmap mBitmap) {
		File dir = new File(dst);
		dir.mkdirs();
		
		File f = new File(dir, filename);
		try {
			f.createNewFile();
		} catch (IOException e) {
			return false;
		}
		
		FileOutputStream fOut = null;
		try {
			fOut = new FileOutputStream(f);
		} catch (FileNotFoundException e) {
			return false;
		}
		mBitmap.compress(Bitmap.CompressFormat.PNG, 100, fOut);
		try {
			fOut.flush();
		} catch (IOException e) {
			return false;
		}
		try {
			fOut.close();
		} catch (IOException e) {
			return false;
		}
		return true;
	}
	
	public void shareImageToQQFriend(String path, String title, String desc) {
		File file = new File(path);
		if (!file.exists()) {
			Toast.makeText(mActivity, "no such image: path = " + path, Toast.LENGTH_LONG).show();
			return;
		}
		
		Bitmap rawbmp = BitmapFactory.decodeFile(path);
		String newpath = BBNDK.getSDCardPath() + "/beibeidanci/screenshot/";
		String tmpfilename = /*System.currentTimeMillis() + */"tmp.png";
		if (saveMyBitmap(newpath, tmpfilename, rawbmp) == false) return;
		
	    Bundle params = new Bundle();
	    
	    params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_IMAGE);
	    params.putString(QQShare.SHARE_TO_QQ_IMAGE_LOCAL_URL, newpath + tmpfilename);
		
	    params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
	    params.putString(QQShare.SHARE_TO_QQ_SUMMARY, desc);
		params.putString(QQShare.SHARE_TO_QQ_APP_NAME, "贝贝单词");
		
	    mTencent.shareToQQ(mActivity, params, new ShareImageToQQFriendListener());
	}
	
	public void shareImageToWeiXin(final String path, final String title, final String desc) {

            	
				File file = new File(path);
				if (!file.exists()) {
					return;
				}
				
				Bitmap rawbmp = BitmapFactory.decodeFile(path);
				String newpath = BBNDK.getSDCardPath() + "/beibeidanci/screenshot/";
				String tmpfilename = /*System.currentTimeMillis() + */"tmp.png";
				if (saveMyBitmap(newpath, tmpfilename, rawbmp) == false) return;
				
				WXImageObject imgObj = new WXImageObject();
				imgObj.setImagePath(newpath + tmpfilename);
				
				WXMediaMessage msg = new WXMediaMessage();
				msg.mediaObject = imgObj;
				
				Bitmap bmp = BitmapFactory.decodeFile(newpath + tmpfilename);
				final int THUMB_SIZE = 128;
				Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE, THUMB_SIZE, true);
				bmp.recycle();
				msg.thumbData = Util.bmpToByteArray(thumbBmp, true);
				msg.title = title;
				msg.description = desc;
				
				SendMessageToWX.Req req = new SendMessageToWX.Req();
				req.transaction = buildTransaction("img");
				req.message = msg;
				req.scene = SendMessageToWX.Req.WXSceneTimeline;
				BBNDK.wxapi.sendReq(req);
				
		//		String text = "share our application";  
		//        WXTextObject textObj = new WXTextObject();  
		//        textObj.text = text;  
		//
		//        WXMediaMessage msg = new WXMediaMessage(textObj);  
		//        msg.mediaObject = textObj;  
		//        msg.description = text;  
		//          
		//        SendMessageToWX.Req req = new SendMessageToWX.Req();  
		//        req.transaction = String.valueOf(System.currentTimeMillis());  
		//        req.scene = SendMessageToWX.Req.WXSceneTimeline;
		//        req.message = msg;  
		//          
		//        BBNDK.wxapi.sendReq(req); 
				


	}
	
	private String buildTransaction(final String type) {
		return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
	}
	
	public String addImageToGallery(final String filePath) {
		File file = new File(filePath);
		if (!file.exists()) {
			return null;
		}
		
		Bitmap rawbmp = BitmapFactory.decodeFile(filePath);
		String newpath = BBNDK.getSDCardPath() + "/beibeidanci/screenshot/";
		String tmpfilename = System.currentTimeMillis() + "screenshot.png";
		if (saveMyBitmap(newpath, tmpfilename, rawbmp) == false) return null;
		
		return newpath + tmpfilename;
	}

	// ------------------------------------------------------------------------------
	class LogInListener implements IUiListener {

		@Override
		public void onCancel() {
			BBNDK.onLogInByQQ(null, null, null, "User cancels QQ log in", 0);
		}

		@Override
		public void onComplete(Object response) {
			mAuthData = (JSONObject)response;
			mActivity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					UserInfo info = new UserInfo(mActivity, mTencent.getQQToken());
					info.getUserInfo(new GetUserInfoListener());
				}
			});
		}

		@Override
		public void onError(UiError e) {
			BBNDK.onLogInByQQ(null, null, null, e.errorMessage, e.errorCode);
		}		
	}

	// ------------------------------------------------------------------------------
	class GetUserInfoListener implements IUiListener {

		@Override
		public void onCancel() {
			BBNDK.onLogInByQQ(null, null, null, "User cancels QQ log in", 0);
		}

		@Override
		public void onComplete(final Object response) {
			AVUser.AVThirdPartyUserAuth userAuth = new AVUser.AVThirdPartyUserAuth(
					mTencent.getQQToken().getAccessToken(), 
					String.valueOf(mTencent.getQQToken().getExpireTimeInSecond()), 
					SNSTYPE, 
					mTencent.getQQToken().getOpenId());
			AVUser.loginWithAuthData(userAuth, new LogInCallback<AVUser>() {
				public void done(AVUser user, AVException e) {
			        if (e == null) {
			        	BBNDK.onLogInByQQ(
			        			BBNDK.AVUserToJsonStr(user), 
			        			response != null ? response.toString() : null, 
			        			mAuthData != null ? mAuthData.toString() : null, 
			        			null, 
			        			0);
			        } else {
			        	BBNDK.onLogInByQQ(null, null, null, e.getLocalizedMessage(), e.getCode());
			        }
			    }
			});
		}

		@Override
		public void onError(UiError e) {
			BBNDK.onLogInByQQ(null, null, null, e.errorMessage, e.errorCode);
		}
	}
	
	// ------------------------------------------------------------------------------
	class ShareImageToQQFriendListener implements IUiListener {

		@Override
		public void onCancel() {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onComplete(Object arg0) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onError(final UiError error) {
			mActivity.runOnUiThread(new Runnable() {

				@Override
				public void run() {
					new AlertDialog.Builder(mActivity)							
							.setMessage(error.errorMessage)
							.setNegativeButton("CLOSE", null)
							.create()
							.show();
				}

			});
		}
			
	}
}
