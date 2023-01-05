import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'chart.dart';

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
  String recv_msg = '';
  int op_time = 0;
  bool isStop = false;
  int numGood = 0;
  int numBad = 0;
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
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
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
            Padding(
              padding: const EdgeInsets.only(right: 30, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    './assets/user.png',
                    height: 30,
                    color: Colors.grey[800],
                  )
                  // InkWell(
                  //   child: Image.asset('./assets/user.png', width: 30),
                  //   onTap: () => AlertDialog(
                  //     title: Text("이용자 정보"),
                  //     content: ListBody(
                  //       children: [
                  //         Text("조이삭 이사님"),
                  //         Text("안녕하세요"),
                  //       ],
                  //     ),
                  //     actions: <Widget>[
                  //       TextButton(
                  //         child: Text('닫기'),
                  //         onPressed: () {
                  //           Navigator.of(context).pop();
                  //         },
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text("작업전 안전점검"),
                  Text("작업후 정리정돈"),
                  Text(
                    "조이삭",
                    style: TextStyle(fontSize: 25),
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
                  Text("오늘 생산량", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 150, // 폭
                  height: 50, // 높이
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    "양품 : ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ), // 자식 위젯
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 150, // 폭
                  height: 50, // 높이
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    "불량품 : ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ), // 자식 위젯
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: ListTile(
                title: ElevatedButton(
                    child: const Text('실시간 데이터 확인'),
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return LiveChartPage();
                        },
                      ));
                    }),
              ),
            ),
            const SizedBox(
              height: 20,
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
                    width: 150, // 폭
                    height: 200, // 높이
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
                        Text("컨베이어 전원"),
                        Container(
                          height: 80,
                          width: 110,
                          margin: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isStop = false;
                              });
                            },
                            child: Text(
                              '작동',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
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
                  width: 150, // 폭
                  height: 200, // 높이
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
                      Text("안전장치 전원"),
                      Container(
                        height: 80,
                        width: 110,
                        margin: const EdgeInsets.only(top: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isStop = false;
                            });
                          },
                          child: Text(
                            '작동',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
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
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text("컨베이어 상태",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 350, // 폭
                height: 50, // 높이
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("현재 벨트 동작 : "),
                    recv_msg == 'stop'
                        ? Text(
                            '정지 상태',
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            '동작 상태',
                            style: TextStyle(color: Colors.green),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 350, // 폭
                height: 50, // 높이
                margin: EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("작업 경과 시간 : "), Text(op_time.toString())],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
