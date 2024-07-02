package com.ailet_camra.ipdvonline.ailet_camera;

//import io.flutter.embedding.android.FlutterActivity;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterFragmentActivity;
//import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;


import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodChannel;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

public class MainActivity extends FlutterFragmentActivity {

   private static final String CHANNEL = "ailet_integration";
   private static final int ACTIVITY_RESULT_START_IR_VISIT = 1;
   private static final int ACTIVITY_RESULT_START_IR_REPORT = 2;
   private MethodChannel.Result pendingResult;

   @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
      super.configureFlutterEngine(flutterEngine);
      GeneratedPluginRegistrant.registerWith(flutterEngine);

      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
         (call, result) -> {
            if (call.method.equals("startVisit")) {
               pendingResult = result;
               startVisit(
                  call.argument("login"), 
                  call.argument("password"),
                  call.argument("userId"), 
                  call.argument("visitId"),
                  call.argument("storeId")
               );
            } else if (call.method.equals("getVisitReport")) {
               pendingResult = result;
               getVisitReport(
                  call.argument("login"), 
                  call.argument("password"),
                  call.argument("userId"), 
                  call.argument("visitId")
               );
            } else {
               result.notImplemented();
            }
         }
      );
   }

   private void startVisit(String login, String password, String userId, String visitId, String storeId) {
      Intent intent = new Intent();
      intent.setAction("com.ailet.ACTION_VISIT");
      intent.putExtra("login", login);
      intent.putExtra("password", password);
      intent.putExtra("id", userId);
      intent.putExtra("visit_id", visitId);
      intent.putExtra("store_id", storeId);
      startActivityForResult(intent, ACTIVITY_RESULT_START_IR_VISIT);
   }

   private void getVisitReport(String login, String password, String userId, String visitId) {
      Intent intent = new Intent();
      intent.setAction("com.ailet.ACTION_VISIT");
      intent.putExtra("login", login);
      intent.putExtra("password", password);
      intent.putExtra("id", userId);
      intent.putExtra("visit_id", visitId);
      startActivityForResult(intent, ACTIVITY_RESULT_START_IR_REPORT);
   }
   
   @Override
   protected void onActivityResult(int requestCode, int resultCode, Intent data) {
      super.onActivityResult(requestCode, resultCode, data);

      if (resultCode == RESULT_OK) {
         if (data != null && data.getData() != null) {
               String result = readFromUri(data.getData());
               try {
                  JSONObject json = new JSONObject(result);
                  if (requestCode == ACTIVITY_RESULT_START_IR_VISIT) {
                     pendingResult.success(json.toString());
                  } else if (requestCode == ACTIVITY_RESULT_START_IR_REPORT) {
                     pendingResult.success(json.toString());
                  }
               } catch (JSONException e) {
                  pendingResult.error("JSON_ERROR", "Error al parsear JSON", e);
               }
         } else {
               pendingResult.error("NO_DATA", "No se devolvieron datos", null);
         }
      } else {
         pendingResult.error("RESULT_ERROR", "La operación falló con resultCode: " + resultCode, null);
      }
   }

   private String readFromUri(Uri uri) {
      try {
         InputStream inputStream = getContentResolver().openInputStream(uri);
         InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
         BufferedReader reader = new BufferedReader(inputStreamReader);
         StringBuilder stringBuffer = new StringBuilder();
         String string;
         while ((string = reader.readLine()) != null) {
               stringBuffer.append(string);
         }
         reader.close();
         inputStreamReader.close();
         inputStream.close();
         return stringBuffer.toString();
      } catch (Exception e) {
         e.printStackTrace();
         return null;
      }
   }

}
