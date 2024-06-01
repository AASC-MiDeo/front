import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: CameraDataScreen(),
    );
  }
}

class CameraDataScreen extends StatefulWidget {
  @override
  _CameraDataScreenState createState() => _CameraDataScreenState();
}

class _CameraDataScreenState extends State<CameraDataScreen> {
  bool isHelmetDetected = false;
  bool isGasDetected = false;
  bool isNoiseDetected = false;
  double temperature = 0.0;
  double humidity = 0.0;

  // 플라스크 API 서버의 주소 (변경 필요)
  final String apiUrl = 'YOUR_FLASK_API_URL';

  @override
  void initState() {
    super.initState();
    // 초기화 시 한 번 데이터 가져오기
    fetchCameraData();
    // 주기적으로 데이터 가져오기
    Timer.periodic(Duration(seconds: 10), (timer) => fetchCameraData());
  }

  // 플라스크 API에서 데이터 가져오는 함수
  Future<void> fetchCameraData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isHelmetDetected = data['isHelmetDetected'];
          isGasDetected = data['isGasDetected'];
          isNoiseDetected = data['isNoiseDetected'];
          temperature = data['temperature'];
          humidity = data['humidity'];
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로고 색상 설정
    Color helmetColor = isHelmetDetected ? Colors.red : Colors.blue;
    Color gasColor = isGasDetected ? Colors.red : Colors.blue;
    Color noiseColor = isNoiseDetected ? Colors.red : Colors.blue;
    // 온도가 40도 이상인 경우 붉은색으로 설정
    Color temperatureColor = temperature >= 40 ? Colors.red : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('미더!_AASC'),
      ),
      body: Center(
        child: Text(
          '카메라 정보 라이브 영상',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.security,
                size: 30,
                color: helmetColor,
              ),
              onPressed: () {
                // 예상되는 동작 추가
              },
            ),
            IconButton(
              icon: Icon(
                Icons.warning,
                size: 30,
                color: gasColor,
              ),
              onPressed: () {
                // 예상되는 동작 추가
              },
            ),
            IconButton(
              icon: Icon(
                Icons.volume_up,
                size: 30,
                color: noiseColor,
              ),
              onPressed: () {
                // 예상되는 동작 추가
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '온도',
                  style: TextStyle(fontSize: 12, color: temperatureColor),
                ),
                Text(
                  '$temperature°C',
                  style: TextStyle(fontSize: 16, color: temperatureColor),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '습도',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '$humidity%',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 30,
              ),
              onPressed: () {
                // 예상되는 동작 추가
              },
            ),
          ],
        ),
      ),
    );
  }
}
