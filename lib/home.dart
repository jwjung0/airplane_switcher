import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const _channel = MethodChannel('com.example.airplane_switcher');
  bool _isAirplaneMode = false;
  bool _isMobileOn = false;
  String batteryLevel = 'unknown';
  String airplaneMode = 'unknown';
  String cellState = 'unknown';
  String wifiState = 'unknown';

  @override
  void initState() {
    super.initState();
    _initAirplaneMode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initAirplaneMode() async {
    int result = await _channel.invokeMethod('getAirplaneMode');
    if (result == 0) {
      airplaneMode = 'OFF';
    } else {
      airplaneMode = 'OFF';
    }
  }

  Future<String> getPlatformVersion() async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> getAirplaneMode() async {
    String output;
    try {
      int result = await _channel.invokeMethod('getAirplaneMode');
      if (result == 0) {
        output = 'OFF';
      } else {
        output = 'ON';
      }
    } on PlatformException catch (e) {
      output = "Failed to get airplane mode: ${e.message}";
    }
    return output;
  }

  Future<void> _toggleAirplaneMode() async {
    await _channel.invokeMethod('toggleAirplaneMode');
  }

  Future<bool> _getCellNetworkState() async {
    return await _channel.invokeMethod('getNetworkState');
  }

  Future<bool> _getWifiNetworkState() async {
    return await _channel.invokeMethod('getWifiState');
  }

  Future<bool> _setMobileData0() async {
    return await _channel.invokeMethod('setMobileData0');
  }
  Future<bool> _setMobileData1() async {
    return await _channel.invokeMethod('setMobileData1');
  }

  @override
  Widget build(BuildContext context) {
    Color colorText = Colors.green[700]!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Airplane Mode Switch', style: TextStyle(color: colorText),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => {},
              icon: Icon(Icons.menu_rounded, color: Colors.grey[800]!,)
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _airplaneModeSwitch(),
            const SizedBox(height: 10,),

            _switchMobile(),
            const SizedBox(height: 40,),
            _airplaneMode(),

            const SizedBox(height: 20,),
            _getNetworkStatus(),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _airplaneMode() {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              String result = await getAirplaneMode();
              setState(() {
                airplaneMode = result;
              });
            },
            child: const Text('get airplane mode')
        ),
        Text(airplaneMode, style: const TextStyle(fontSize: 20,
            color: Colors.blue, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _airplaneModeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Airplane mode', style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
        CupertinoSwitch(
          value: _isAirplaneMode,
          onChanged: (value) {
            _toggleAirplaneMode();
            _isAirplaneMode = !_isAirplaneMode;
            setState(() {});
          },
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }

  Widget _switchMobile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Mobile network', style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
        CupertinoSwitch(
          value: _isMobileOn,
          onChanged: (value) {
            if (value) {
              _setMobileData1();
            } else {
              _setMobileData0();
            }
            _isMobileOn = !_isMobileOn;
            setState(() {});
          },
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }

  Widget _getNetworkStatus() {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
              onPressed: () async {
                bool resCell = await _getCellNetworkState();
                bool resWifi = await _getWifiNetworkState();
                setState(() {
                  if (resCell == true) {
                    cellState = 'ON';
                  } else {
                    cellState = 'OFF';
                  }
                  if (resWifi) {
                    wifiState = 'ON';
                  } else {
                    wifiState = 'OFF';
                  }
                });
              },
              child: const Text('Check network Connection')
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cellular Network:  $cellState', style: const TextStyle(fontSize: 18,
                  color: Colors.blue, fontWeight: FontWeight.w400)
              ),
              const SizedBox(height: 5,),
              Text('WiFi Network:  $wifiState', style: const TextStyle(fontSize: 18,
                  color: Colors.blue, fontWeight: FontWeight.w400)
              ),
            ],
          )
        ],
      ),
    );
  }

}
