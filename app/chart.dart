import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

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
        title: Text("Data page"),
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
                    'measure': e.data()['err_rate'],
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
                    lineColor: (lineData, index, id) => Colors.amber,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
