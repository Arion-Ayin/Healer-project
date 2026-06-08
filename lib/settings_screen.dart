// ✅ Flutter 기본 UI 도구들을 불러옵니다.
import 'package:flutter/material.dart';

// ✅ SettingsScreen: 하단 탭의 "설정" 탭을 눌렀을 때 보이는 화면입니다.
// StatelessWidget = 화면 내용이 바뀌지 않으므로 StatelessWidget 사용 (가장 단순한 형태)
// StatelessWidget은 StatefulWidget보다 가볍고 빠릅니다!
class SettingsScreen extends StatelessWidget {
  // ✅ 최신 방식: const 생성자 + super.key 사용 (Flutter 3.x 권장)
  // super.key: Flutter가 이 위젯을 효율적으로 관리하기 위한 고유 번호표입니다.
  const SettingsScreen({super.key});

  // ✅ build: 이 화면에 보여줄 UI를 만드는 함수입니다.
  // context: 이 위젯이 앱의 어디에 위치하는지 알 수 있는 정보가 담긴 객체입니다.
  @override
  Widget build(BuildContext context) {
    // Scaffold: 앱바(상단 제목)와 바디(내용)를 갖춘 기본 화면 틀입니다.
    // 마치 집의 뼈대(기둥, 지붕)같은 역할을 해요!
    return Scaffold(
      // AppBar: 화면 상단에 제목을 보여주는 막대입니다.
      appBar: AppBar(
        // ✅ const Text: 텍스트 내용이 바뀌지 않으므로 const를 사용해 성능을 높입니다.
        title: const Text('설정'), // 앱바에 '설정'이라고 표시
      ),

      // body: 화면의 주요 내용 영역입니다.
      // ✅ const Center: 내용이 고정이므로 const 사용 (성능 최적화)
      body: const Center(
        // Center: 자식 위젯을 화면 정가운데에 배치합니다.
        child: Text(
          '설정 화면',                    // 화면 가운데에 '설정 화면' 글씨를 표시합니다.
          style: TextStyle(fontSize: 24), // 글씨 크기를 24로 설정 (기본보다 조금 크게)
        ),
      ),
    );
  }
}
