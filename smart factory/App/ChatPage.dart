import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'chart.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  String recv_msg = 'stop';
  bool status_ul = true;
  bool _canVibrate = true;
  int op_time = 0;
  int numGood = 0;
  int numBad = 0;
  final Iterable<Duration> pauses = [
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 500),
  ];
  static final clientID = 0;

  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
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
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  Future<void> _init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate
          ? debugPrint('This device can vibrate')
          : debugPrint('This device cannot vibrate');
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  recv_msg = _message.text.trim();
                  if (recv_msg == 'choumpa_stop') {
                    status_ul = false;
                    _canVibrate = true;
                  } else {
                    _canVibrate = false;
                    status_ul = true;
                  }
                  recv_msg == 'stop' || status_ul == false || recv_msg == '0'
                      ? FirebaseFirestore.instance
                          .collection('op_status')
                          .doc('getState')
                          .update({'state': false})
                      : FirebaseFirestore.instance
                          .collection('op_status')
                          .doc('getState')
                          .update({'state': true});

                  return text == '/shrug' ? '??\\_(???)_/??' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Color.fromARGB(255, 82, 216, 88))),
          ),
        ],
      );
    }).toList();

    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 20),
            //   child: Text(
            //     recv_msg,
            //     style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (isConnecting
                      ? Text('????????? ' + serverName)
                      : isConnected
                          ? Text(
                              '???????????? ??????',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            )
                          : Text(
                              '????????????!' + serverName,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )),
                  IconButton(
                    icon: Image.asset('./assets/user.png'),
                    iconSize: 20,
                    onPressed: () {
                      FlutterDialog();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    "Welcome to Smart Control.",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child:
                  Text("?????? ?????????", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            FireStoreText(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 320,
                  child: ElevatedButton(
                    child: const Text('????????? ????????? ??????'),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return LiveChartPage();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text("Smart Control",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 150, // ???
                    height: 200, // ??????
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          './assets/power.png',
                          height: 50,
                          color: Colors.grey[800],
                        ),
                        Text("???????????? ??????"),
                        Container(
                          height: 80,
                          width: 110,
                          margin: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                            onPressed: status_ul == false
                                ? null
                                : () {
                                    if ((recv_msg == 'move') && isConnected) {
                                      _sendMessage("0"); // ?????? ?????? ??????

                                    } else if ((recv_msg == 'stop') &&
                                        isConnected) {
                                      _sendMessage("1"); // ?????? ?????? ??????
                                    }
                                  },
                            child: recv_msg == 'move'
                                ? Text(
                                    'OFF',
                                  )
                                : Text(
                                    'ON',
                                  ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 150, // ???
                  height: 200, // ??????
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        './assets/safe.png',
                        height: 50,
                        color: Colors.grey[800],
                      ),
                      Text("???????????? ?????? ??????"),
                      Container(
                        height: 80,
                        width: 110,
                        margin: const EdgeInsets.only(top: 8),
                        child: status_ul == false
                            ? Text(
                                '????????? ?????????????????????.',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                '????????? ????????? ????????????.',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text("???????????? ??????",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 350, // ???
                    height: 50, // ??????
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("?????? ?????? ?????? : "),
                        recv_msg == 'stop' || status_ul == false
                            ? Text(
                                '?????? ??????',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                '?????? ??????',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 350, // ???
                    height: 50, // ??????
                    margin: EdgeInsets.only(left: 0, right: 0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("?????? ?????? ?????? : "), Text(op_time.toString())],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void FlutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog??? ????????? ?????? ?????? ?????? x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog ?????? ????????? ????????? ??????
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("????????? ??????"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/isak.png'), width: 200),
                Text(
                  "????????? ??????",
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("??????"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

class FireStoreText extends StatefulWidget {
  @override
  _FireStoreText createState() => _FireStoreText();
}

class _FireStoreText extends State<FireStoreText> {
  @override
  final Stream<QuerySnapshot> _firestoretext =
      FirebaseFirestore.instance.collection('product').snapshots();

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoretext,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Row(children: [
              data['category'] == '??????'
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 150, // ???
                      height: 50, // ??????
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        "?????? : " + data['count'].toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Text(''),
              data['category'] == '?????????'
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 150, // ???
                      height: 50, // ??????
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        "????????? : " + data['count'].toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Text('')
            ]);
          }).toList(),
        );
      },
    );
  }
}
