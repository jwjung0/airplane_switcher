package com.example.airplane_switcher

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager
import android.provider.Settings
import androidx.annotation.NonNull
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.airplane_switcher"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "getAirplaneMode") {
                val mode = isAirplaneModeOn()
                result.success(mode)
            } else if (call.method == "getNetworkState") {
                var cellStatus = getNetworkState(this)
                result.success(cellStatus)
            } else if (call.method == "getWifiState") {
                var wifiStatus = getWifiStatus(this)
                result.success(wifiStatus)
            } else if (call.method == "toggleWifiMode") {
                val airplaneMode = isAirplaneModeOn()
                var onOff = airplaneMode
                toggleWifiMode(onOff)
            } else if (call.method == "turnOffWifi") {
                offWifi()
            } else if (call.method == "turnOnWifi") {
                onWifi()
            } else if (call.method == "setMobileData0") {
                setMobileData0()
            } else if (call.method == "setMobileData1") {
                setMobileData1()
            } else if (call.method == "toggleAirplaneMode") {
                val checkAirplaneMode = isAirplaneModeOn()
                var onOff: Int = if (checkAirplaneMode == 0) {
                    1
                } else {
                    0
                }
                toggleAirplaneMode(onOff)
                toggleWifiMode(onOff)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun isAirplaneModeOn(): Int {
        return Settings.Global.getInt(getContentResolver(),
                Settings.Global.AIRPLANE_MODE_ON)
    }

    private fun toggleAirplaneMode(value: Int) {
        Settings.Global.putInt(getContentResolver(), Settings.Global.AIRPLANE_MODE_ON, value)
    }

    private fun toggleWifiMode(value: Int) {
        if (value == 0) {
            onWifi()
        } else {
            offWifi()
        }
    }

    private fun onWifi() {
        val wifi = this.getApplicationContext().getSystemService(Context.WIFI_SERVICE) as WifiManager
        wifi.setWifiEnabled(true);
    }
    private fun offWifi() {
        val wifi = this.getApplicationContext().getSystemService(Context.WIFI_SERVICE) as WifiManager
        wifi.setWifiEnabled(false);
    }

    private fun setMobileData0() {
        val intent = Intent(Settings.ACTION_DATA_ROAMING_SETTINGS)
        startActivityForResult(intent, 0)
    }
    private fun setMobileData1() {
        val intent = Intent(Settings.ACTION_DATA_ROAMING_SETTINGS)
        startActivityForResult(intent, 1)
    }

    private fun getNetworkState(context: Context): Boolean {
        val connectivityManager =
            context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (connectivityManager != null) {
            val capabilities =
                connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
            if (capabilities != null) {
                if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
                    return true
                }
            }
        }
        return false
    }

    private fun getWifiStatus(context: Context): Boolean {
        val connectivityManager =
            context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (connectivityManager != null) {
            val capabilities =
                connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
            if (capabilities != null) {
                if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                    return true
                }
            }
        }
        return false
    }

}
