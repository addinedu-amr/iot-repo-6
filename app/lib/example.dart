import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({
    Key? key,
  }) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool isStop = false;
  int numGood = 0;
  int numBad = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // 이미지
          // Image.asset(
          //   "assets/graph.png",
          //   height: 250,
          //   width: double.infinity,
          //   //fit: BoxFit.cover,
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              "생산 현황",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
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
                  color: Colors.red,
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
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Defect Rate",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 200, // 폭
            height: 50, // 높이
            color: Colors.grey, // 박스 색상
            alignment: Alignment.center,
            child: Text(
              "1%",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ), // 자식 위젯
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              "작동 버튼",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // 세로 방향 정렬 : start(default)
            children: [
              Container(
                height: 80,
                width: 120,
                margin: const EdgeInsets.only(top: 8, right: 20),
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
              Container(
                height: 80,
                width: 120,
                margin: const EdgeInsets.only(top: 8, left: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      isStop = true;
                    });
                  },
                  child: Text(
                    '비상정지',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(isStop ? '현재 정지 상태' : '현재 운전 상태'),
        ],
      ),
    );
  }
}
