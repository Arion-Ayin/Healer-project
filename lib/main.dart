// ✅ Flutter에서 화면을 그리는 데 필요한 기본 도구들을 불러옵니다.
// 버튼, 텍스트, 색상 같은 모든 UI 부품이 여기 들어있어요!
import 'package:flutter/material.dart';

// ✅ 핸드폰의 상태바(시계, 배터리 표시줄)나 화면 방향 등을
// 직접 조절할 수 있는 도구를 불러옵니다.
import 'package:flutter/services.dart';

// ✅ 구글 광고(배너 광고, 전면 광고 등)를 앱에 넣을 수 있게 해주는 도구입니다.
// google_mobile_ads 패키지 버전: 5.3.1
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ✅ 아래 4줄은 우리가 직접 만든 화면(파일)들을 불러오는 코드입니다.
// 마치 레고 블록을 가져오는 것처럼, 각각의 화면 파일을 가져와요.
import 'package:basic/splash_screen.dart'; // 앱을 켤 때 처음 보이는 로딩 화면
import 'package:basic/home_screen.dart'; // 메인 홈 화면
import 'package:basic/settings_screen.dart'; // 설정 화면
import 'package:basic/info_screen.dart'; // 정보 화면

// ✅ 앱이 시작될 때 제일 먼저 실행되는 함수입니다.
// 마치 컴퓨터를 켜면 바탕화면이 뜨는 것처럼, 앱이 켜지면 이 함수가 먼저 달립니다!
void main() {
  // Flutter 엔진이 완전히 준비될 때까지 기다립니다.
  // 이걸 안 하면 광고 같은 기능이 제대로 작동 안 할 수 있어요.
  WidgetsFlutterBinding.ensureInitialized();

  // 📱 화면을 "가장자리까지 꽉 채우는" 모드로 설정합니다.
  // 상태바나 내비게이션 바 뒤로도 앱 화면이 보이게 됩니다. (Android 15에서 권장)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 📱 상태바(시계·배터리 표시줄)와 내비게이션 바 색상을 투명하게 만듭니다.
  // 그래야 배경색이 자연스럽게 이어져 보여요.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // 아래 내비게이션 바: 투명
      statusBarColor: Colors.transparent, // 위 상태바: 투명
    ),
  );

  // 📢 구글 광고 SDK를 초기화(켜기)합니다.
  // 광고를 보여주려면 먼저 이걸 실행해야 해요!
  MobileAds.instance.initialize();

  // 🚀 MyApp 위젯을 화면에 띄웁니다. 여기서부터 앱이 시작돼요!
  runApp(const MyApp());
}

// ✅ 앱 전체를 감싸는 최상위 위젯입니다.
// StatelessWidget = 한번 그리면 바뀌지 않는 위젯이에요.
// (앱의 테마·제목 같은 기본 설정은 바뀌지 않으니까요)
class MyApp extends StatelessWidget {
  // super.key: 위젯을 구별하기 위한 고유 번호표입니다. Flutter가 요구해요.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: 구글 Material Design 스타일의 앱을 만드는 틀입니다.
    return MaterialApp(
      title: 'Flutter Demo', // 앱의 제목 (작업 관리자 같은 곳에서 보여요)
      // 🎨 앱 전체의 색상 테마를 설정합니다.
      theme: ThemeData(
        // 보라색(deepPurple)을 기준으로 어울리는 색상들을 자동 생성해줍니다.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Material 3: 구글이 만든 최신 디자인 규칙을 사용합니다. (2023년 이후 기본값)
        useMaterial3: true,
      ),

      // 🏠 앱을 켰을 때 가장 먼저 보여줄 화면 = 스플래시 화면(로딩 화면)
      // SplashScreen이 끝나면 알아서 MainScreen으로 이동합니다.
      home: SplashScreen(),
    );
  }
}

// ✅ 하단 탭바(홈·설정·정보)를 포함하는 메인 화면입니다.
// StatefulWidget = 상태(현재 선택된 탭)가 바뀔 수 있는 위젯이에요.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  // createState: 이 위젯의 "상태 관리자"를 만듭니다.
  @override
  State<MainScreen> createState() => _MainScreenState();
}

// ✅ MainScreen의 실제 동작(로직)을 담당하는 상태 클래스입니다.
// 언더바(_)로 시작하면 이 파일 안에서만 쓸 수 있다는 뜻이에요. (비공개)
class _MainScreenState extends State<MainScreen> {
  // 현재 몇 번째 탭이 선택되었는지 저장하는 변수입니다.
  // 0 = 홈, 1 = 설정, 2 = 정보
  int _selectedIndex = 0;

  // 탭마다 보여줄 화면 목록입니다.
  // static const: 절대 바뀌지 않는 고정된 목록이에요.
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(title: '홈'), // 0번: 홈 화면
    SettingsScreen(), // 1번: 설정 화면
    InfoScreen(), // 2번: 정보 화면
  ];

  // 탭을 눌렀을 때 호출되는 함수입니다.
  // index: 몇 번째 탭을 눌렀는지 번호가 전달돼요.
  void _onItemTapped(int index) {
    // setState: 화면을 다시 그려달라고 Flutter에게 알리는 함수입니다.
    // 이 안에서 변수를 바꿔야 화면이 업데이트돼요!
    setState(() {
      _selectedIndex = index; // 선택된 탭 번호를 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    //다크모드 여부 체크
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 📄 현재 선택된 탭에 맞는 화면을 중앙에 보여줍니다.
      // elementAt(_selectedIndex): 목록에서 _selectedIndex번째 항목을 꺼냅니다.
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      // 📍 화면 아래쪽에 탭 버튼들을 보여줍니다.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ), // 집 모양 아이콘
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ), // 톱니바퀴 아이콘
          BottomNavigationBarItem(icon: Icon(Icons.info), label: '정보'), // i 아이콘
        ],
        currentIndex: _selectedIndex, // 현재 선택된 탭을 강조 표시
        selectedItemColor: Colors.deepPurple, // 선택된 탭은 보라색으로
        onTap: _onItemTapped, // 탭을 누르면 _onItemTapped 함수 호출
      ),
    );
  }
}
