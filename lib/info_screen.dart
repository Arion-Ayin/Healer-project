// ✅ Flutter 기본 UI 도구들을 불러옵니다.
import 'package:flutter/material.dart';

// ✅ InfoScreen: 하단 탭의 "정보" 탭을 눌렀을 때 보이는 화면입니다.
// StatelessWidget = 화면 내용이 바뀌지 않으므로 StatelessWidget 사용
// (설정·정보 화면처럼 내용이 고정된 경우에는 StatelessWidget이 더 좋아요!)
class InfoScreen extends StatelessWidget {
  // ✅ 최신 방식: const 생성자 + super.key 사용 (Flutter 3.x 권장)
  // super.key: Flutter가 이 위젯을 효율적으로 관리하기 위한 고유 번호표입니다.
  const InfoScreen({super.key});

  // ✅ build: 이 화면에 보여줄 UI를 만드는 함수입니다.
  @override
  Widget build(BuildContext context) {
    // Scaffold: 앱바(상단 제목)와 바디(내용)를 갖춘 기본 화면 틀입니다.
    return Scaffold(
      // AppBar: 화면 상단의 제목 막대입니다.
      appBar: AppBar(
        // ✅ const Text: 내용이 고정이므로 const 사용 (메모리 절약, 성능 향상)
        title: const Text('정보'), // 앱바에 '정보'라고 표시
      ),

      // body: 화면의 주요 내용 영역입니다.
      // ✅ const Center: 내용이 고정이므로 const 사용
      body: const Center(
        // Center: 자식 위젯을 화면 정가운데에 배치합니다.
        child: Text(
          '정보 화면', // 화면 가운데에 '정보 화면' 글씨를 표시합니다.
          style: TextStyle(fontSize: 24), // 글씨 크기 24 (조금 크게)
        ),
      ),
    );
  }
}
