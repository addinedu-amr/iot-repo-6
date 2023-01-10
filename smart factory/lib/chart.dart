import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LiveChartPage extends StatelessWidget {
  LiveChartPage({Key? key}) : super(key: key);
  final streamChart = FirebaseFirestore.instance
      .collection('product')
      .snapshots(includeMetadataChanges: true);

  final streamChart2 = FirebaseFirestore.instance
      .collection('err_rate')
      .orderBy("trial", descending: false)
      .snapshots(includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("데이터 대시보드"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('누적 생산 개수 (개)'),
            tileColor: Colors.grey[200],
          ),
          Container(
            height: 300,
            child: StreamBuilder(
              stream: streamChart,
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }

                if (snapshot.data == null) {
                  return const Text('Empty');
                }

                List listChart = snapshot.data!.docs.map((e) {
                  return {
                    'domain': e.data()['category'],
                    'measure': e.data()['count'],
                  };
                }).toList();

                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartBar(
                    data: [
                      {
                        'id': 'Bar',
                        'data': listChart,
                      }
                    ],
                    yAxisTitle: '개수',
                    xAxisTitle: '카테고리',
                    axisLineColor: Colors.black,
                    barColor: (barData, index, id) => Colors.blue,
                    showBarValue: true,
                    barValuePosition: BarValuePosition.auto,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ListTile(
            title: Text('5개당 불량률 (%)'),
            tileColor: Colors.grey[200],
          ),
          Container(
            height: 300,
            child: StreamBuilder(
              stream: streamChart2,
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }

                if (snapshot.data == null) {
                  return const Text('Empty');
                }

                List listChart2 = snapshot.data!.docs.map((e) {
                  return {
                    'domain': e.data()['trial'],
                    'measure': e.data()['rate'],
                  };
                }).toList();

                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartLine(
                    data: [
                      {
                        'id': 'Line',
                        'data': listChart2,
                      }
                    ],
                    includePoints: true,
                    lineColor: (lineData, index, id) => Colors.blue,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ListTile(
            title: Text('목표 생산량 달성률 (%)'),
            tileColor: Colors.grey[200],
          ),
          SizedBox(
            height: 30,
          ),
          Gauge(),
          SizedBox(
            height: 20,
          ),
          // ElevatedButton(
          //   child: const Text('값 바꾸기'),
          //   onPressed: () {

          //     print("눌려짐");
          //   },
          // ),
          SizedBox(
            height: 200,
          ),
        ],
      ),
    );
  }
}

class Gauge extends StatefulWidget {
  @override
  _Gauge createState() => _Gauge();
}

class _Gauge extends State<Gauge> {
  @override
  final Stream<QuerySnapshot> _gauge =
      FirebaseFirestore.instance.collection('product').snapshots();

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _gauge,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return data['category'] == '양품'
                ? CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 13.0,
                    animation: true,
                    animationDuration: 3000,
                    percent: data['count'] / 100, // 1000개가 목표 생산량
                    animateFromLastPercent: true,
                    center: Text(
                      (data['count'] * 100 / 100).toString() + '%',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    footer: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "목표량 달성률",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.blue,
                  )
                : Text('');
          }).toList(),
        );
      },
    );
  }
}
