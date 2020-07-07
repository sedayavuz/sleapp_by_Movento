import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sleapp/hexcolor.dart';
import 'package:sleapp/videoplayers.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State {
  bool _lights = false;
  BluetoothConnection connection;
  bool _connected = false;
  BluetoothDevice _device;
  List<BluetoothDevice> _devicesList = [];
  int _deviceState;
  bool _isButtonUnavailable = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  double widths = 0;
  double heights = 0;
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  bool alarm = false;
  Color color = Colors.white;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollController3 = ScrollController();
  final ScrollController _scrollController4 = ScrollController();
  var classicalList = [
    ['assets/images/classicmusic1.png'],
    ['assets/images/classicmusic2.png'],
    ['assets/images/classicmusic3.png']
  ];
  var natureList = [
    ['assets/images/naturemusic1.png'],
    ['assets/images/naturemusic2.png'],
    ['assets/images/naturemusic3.png']
  ];
  var yogaList = [
    ['assets/images/yoga1.png', 'Lower Back'],
    ['assets/images/yoga2.png', 'Upper Back'],
    ['assets/images/yoga3.png', 'Neck']
  ];
  var exercisesList = [
    ['assets/images/exercises1.png', 'Stretching'],
    ['assets/images/exercises2.png', 'Core'],
    ['assets/images/exercises3.png', 'Thighs']
  ];

  void _sendOnMessageToBluetooth() async {
    connection.output.add(utf8.encode("1" + "\r\n"));
    await connection.output.allSent;
    // show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
    });
  }

  void _sendOffMessageToBluetooth() async {
    connection.output.add(utf8.encode("0" + "\r\n"));
    await connection.output.allSent;
    // show('Device Turned Off');
    setState(() {
      _deviceState = -1; // device off
    });
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    show('Device disconnected');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widths = MediaQuery.of(context).size.width;
    heights = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Android Mobile – 1.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Android Mobile – Login after Download.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Android Mobile – Register.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Android Mobile – Settings Alarm – 1.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Android Mobile – Settings Alarm.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/Android Mobile – Register – 2.png',
                    fit: BoxFit.fill,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: GestureDetector(
                        child: Material(
                          type: MaterialType
                              .transparency, //Makes it usable on any background color, thanks @IanSmith
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(color: color, width: 4.0),
                              color: Colors.indigo[900],
                              shape: BoxShape.circle,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: HexColor("#324678"), width: 5.0),
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                //This keeps the splash effect within the circle
                                borderRadius: BorderRadius.circular(
                                    1000.0), //Something large to ensure a circle

                                child: Padding(
                                    padding: EdgeInsets.all(15.0), child: null),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (!alarm)
                              alarm = true;
                            else
                              alarm = false;
                            color = alarm ? Colors.green : Colors.white;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )),
          Container(
              width: widths,
              height: heights,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _lights
                        ? 'assets/On-Off button – 1.png'
                        : 'assets/On-Off button.png',
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: 170.0,
                    width: widths,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Device:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Container(
                            color: Colors.white,
                            child: DropdownButton(
                              // iconEnabledColor: Colors.white,
                              // dropdownColor: Colors.white,
                              // focusColor: Colors.white,
                              items: _getDeviceItems(),
                              onChanged: (value) =>
                                  setState(() => _device = value),
                              value: _devicesList.isNotEmpty ? _device : null,
                            ),
                          ),
                          RaisedButton(
                            onPressed: _isButtonUnavailable
                                ? null
                                : _connected ? _disconnect : _connect,
                            child: Text(_connected ? 'Disconnect' : 'Connect'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Transform.scale(
                        scale: 1.2,
                        child: CupertinoSwitch(
                          value: _lights,
                          onChanged: (bool value) {
                            setState(() {
                              _lights = value;
                              if (_connected)
                                value
                                    ? _sendOnMessageToBluetooth()
                                    : _sendOffMessageToBluetooth();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Sleep tracker.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Sleep tracker – old.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Sleep tracker – new.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Sleep tracker – 2.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Sleep tracker – 5.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Sleep tracker – 6.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Diary_home.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Diary2.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Diary3.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Diary4.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Diary Stats.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Diary5.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Stats.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/Stats – 1.png',
              fit: BoxFit.fill,
            ),
          ),
          Stack(
            fit: StackFit.expand,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/Android Mobile – Settings Alarm – 2.png',
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: widths,
                height: heights,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 274.0,
                      width: widths - 20.0,
                      padding: EdgeInsets.only(left: 20.0, top: 70.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              'Classical Music',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24.0),
                            ),
                          ),
                          Container(
                            height: 156,
                            width: widths,
                            child: Scrollbar(
                              controller: _scrollController,
                              isAlwaysShown: true,
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: classicalList.length,
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? GestureDetector(
                                          onTap: () {
                                          
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 120.0,
                                                width: 135,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: index == 0
                                                          ? 0.0
                                                          : 10.0,
                                                      right: 5.0),
                                                  child: Image.asset(
                                                    classicalList[index][0],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: <Widget>[
                                            Container(
                                              height: 120.0,
                                              width: 135,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        index == 0 ? 0.0 : 10.0,
                                                    right: 5.0),
                                                child: Image.asset(
                                                  classicalList[index][0],
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 280.0,
                      width: widths - 20.0,
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              'Nature Sounds',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24.0),
                            ),
                          ),
                          Container(
                            height: 156,
                            width: widths,
                            child: Scrollbar(
                              controller: _scrollController2,
                              isAlwaysShown: true,
                              child: ListView.builder(
                                controller: _scrollController2,
                                itemCount: natureList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        height: 120.0,
                                        width: 135,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: index == 0 ? 0.0 : 10.0,
                                              right: 5.0),
                                          child: Image.asset(
                                            natureList[index][0],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            fit: StackFit.expand,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/Android Mobile – Settings Alarm – 2.png',
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: widths,
                height: heights,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 274.0,
                      width: widths - 20.0,
                      padding: EdgeInsets.only(left: 20.0, top: 70.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              'Yoga',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24.0),
                            ),
                          ),
                          Container(
                            height: 156,
                            width: widths,
                            child: Scrollbar(
                              controller: _scrollController3,
                              isAlwaysShown: true,
                              child: ListView.builder(
                                controller: _scrollController3,
                                itemCount: yogaList.length,
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoPlayers()));
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 120.0,
                                                width: 135,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: index == 0
                                                          ? 0.0
                                                          : 10.0,
                                                      right: 5.0),
                                                  child: Image.asset(
                                                    yogaList[index][0],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                yogaList[index][1],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: <Widget>[
                                            Container(
                                              height: 120.0,
                                              width: 135,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        index == 0 ? 0.0 : 10.0,
                                                    right: 5.0),
                                                child: Image.asset(
                                                  yogaList[index][0],
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              yogaList[index][1],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        );
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 280.0,
                      width: widths - 20.0,
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              'Exercises',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24.0),
                            ),
                          ),
                          Container(
                            height: 156,
                            width: widths,
                            child: Scrollbar(
                              controller: _scrollController4,
                              isAlwaysShown: true,
                              child: ListView.builder(
                                controller: _scrollController4,
                                itemCount: exercisesList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        height: 120.0,
                                        width: 135,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: index == 0 ? 0.0 : 10.0,
                                              right: 5.0),
                                          child: Image.asset(
                                            exercisesList[index][0],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        exercisesList[index][1],
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: widths - 20.0,
                      padding: EdgeInsets.only(left: 20.0, top: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 0.0),
                            child: Text(
                              'Meditation',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
