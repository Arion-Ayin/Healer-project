// ✅ Flutter 기본 UI 도구들을 불러옵니다. (버튼, 텍스트, 색상 등)
import 'package:flutter/material.dart';

// ✅ 구글 광고 도구를 불러옵니다. (배너 광고, 네이티브 광고 등)
// google_mobile_ads 버전: 5.3.1
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ✅ dart:io: 앱이 실행 중인 운영체제(Android, iOS)를 알거나
// 프로세스를 직접 종료(exit)할 때 필요합니다.
import 'dart:io';

// ✅ URL을 열거나 전화 걸기, 이메일 보내기 등을 할 수 있게 해주는 패키지입니다.
// url_launcher 버전: 6.x (최신 방식: launchUrl, canLaunchUrl 사용)
import 'package:url_launcher/url_launcher.dart';

import 'package:basic/app_snackbar.dart';

// ✅ HomeScreen: 앱의 메인 홈 탭에서 보여줄 화면입니다.
// StatefulWidget = 카운터처럼 화면이 바뀌는 데이터가 있으므로 StatefulWidget 사용
class HomeScreen extends StatefulWidget {
  // title: 외부에서 화면 제목을 전달받습니다. (예: '홈')
  // required: 반드시 값을 넣어줘야 한다는 뜻이에요!
  const HomeScreen({super.key, required this.title});

  final String title; // 앱바(상단 제목 바)에 표시될 텍스트

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ✅ HomeScreen의 실제 동작 로직을 담당하는 상태 클래스입니다.
class _HomeScreenState extends State<HomeScreen> {
  // 버튼을 누를 때마다 증가하는 카운터 변수입니다.
  int _counter = 0;

  // 화면 아래에 보여줄 배너 광고를 저장하는 변수입니다.
  // ?가 붙으면 "없을 수도 있다"는 뜻 (광고 로딩 전 = null)
  BannerAd? _bannerAd;

  // 다이얼로그(팝업) 안에 보여줄 네이티브 광고를 저장하는 변수입니다.
  NativeAd? _nativeAd;

  // 네이티브 광고가 로딩됐는지 여부를 저장합니다.
  // false = 아직 안 됨, true = 로딩 완료!
  bool _isNativeAdLoaded = false;

  // ✅ initState: 이 화면이 처음 만들어질 때 딱 한 번 실행됩니다.
  @override
  void initState() {
    super.initState(); // 부모의 initState를 먼저 실행 (필수!)
    _loadBannerAd();   // 배너 광고 로드 시작
    _loadNativeAd();   // 네이티브 광고 로드 시작
  }

  // ✅ 배너 광고(화면 아래 띠 모양 광고)를 불러오는 함수입니다.
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // 테스트용 광고 ID (배포 시 실제 ID로 변경!)
      request: const AdRequest(), // ✅ const: 변하지 않는 요청이므로 const 사용
      size: AdSize.banner,        // 광고 크기: 표준 배너 (가로 320 x 세로 50)
      listener: BannerAdListener(
        // 광고 로딩 성공 시: 화면을 다시 그려서 광고를 표시합니다.
        onAdLoaded: (ad) {
          setState(() {}); // setState 안에 빈 코드여도 화면이 새로 그려져요!
        },
        // 광고 로딩 실패 시: 광고 객체를 메모리에서 제거합니다. (메모리 절약)
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load(); // ..은 "같은 객체에 연속으로 작업"할 때 씁니다. BannerAd를 만들자마자 바로 로드!
  }

  // ✅ 네이티브 광고(앱 디자인에 자연스럽게 녹아드는 광고)를 불러오는 함수입니다.
  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110', // 테스트용 광고 ID
      request: const AdRequest(), // ✅ const 사용으로 성능 최적화
      // 네이티브 광고의 디자인 스타일을 설정합니다.
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium, // 중간 크기 템플릿 사용
      ),
      listener: NativeAdListener(
        // 광고 로딩 성공 시: _isNativeAdLoaded를 true로 바꿔 광고를 표시 준비합니다.
        onAdLoaded: (ad) {
          setState(() {
            _isNativeAdLoaded = true; // "광고 준비 완료!"
          });
        },
        // 광고 로딩 실패 시: 광고 객체를 메모리에서 제거합니다.
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _nativeAd?.load(); // ?. 은 _nativeAd가 null이 아닐 때만 load()를 실행합니다.
  }

  // ✅ + 버튼을 눌렀을 때 카운터를 1 증가시키는 함수입니다.
  void _incrementCounter() {
    setState(() {
      _counter++; // 카운터를 1 올립니다
    });
    
    // ✅ 커스텀 스낵바(AppSnackBar) 띄우기
    AppSnackBar.show(
      context,
      message: '카운터가 $_counter 증가했습니다.',
      duration: const Duration(seconds: 1),
    );
  }

  // ✅ 외부 URL(웹사이트)을 열어주는 함수입니다.
  // ✅ 최신 방식: 예전 canLaunch/launch 대신 canLaunchUrl/launchUrl 사용
  // (canLaunch, launch는 Flutter 3.x에서 deprecated(사용 중단 예정)됨)
  Future<void> _launchURL(String url) async {
    // String으로 받은 주소를 Uri 객체로 변환합니다. (새 방식에서 필수!)
    final uri = Uri.parse(url);
    // 이 주소를 열 수 있는지 먼저 확인합니다.
    if (await canLaunchUrl(uri)) {
      // externalApplication: 앱 내부가 아닌 기본 브라우저(크롬 등)로 열기
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url'; // 열 수 없으면 오류를 발생시킵니다.
    }
  }

  // ✅ 화면에 보여줄 UI를 그리는 함수입니다.
  @override
  Widget build(BuildContext context) {
    // ✅ 최신 방식: WillPopScope 대신 PopScope 사용
    // WillPopScope는 Flutter 3.12 이후 deprecated(사용 중단 예정)되었어요!
    // PopScope = 뒤로가기 버튼을 눌렀을 때의 동작을 제어합니다.
    return PopScope(
      // canPop: false = 뒤로가기 버튼을 눌러도 기본 동작(화면 닫기)을 막습니다.
      // 우리가 직접 다이얼로그를 띄우고 싶으니까요!
      canPop: false,

      // ✅ onPopInvokedWithResult: 뒤로가기가 시도됐을 때 호출되는 콜백입니다.
      // (구버전 WillPopScope의 onWillPop을 대체하는 최신 방식)
      // didPop: 실제로 화면이 닫혔는지 여부
      // result: 닫힌 이유/결과값 (여기서는 사용 안 함)
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // 이미 닫혔으면 아무것도 안 함

        // "나가시겠습니까?" 다이얼로그(팝업)를 보여줍니다.
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('정말 나가시겠습니까?'),

            // 네이티브 광고가 준비됐으면 팝업 안에 광고를 보여줍니다!
            content: _isNativeAdLoaded && _nativeAd != null
                // ✅ 최신 방식: 크기만 잡을 때는 Container 대신 SizedBox 사용
                // SizedBox가 더 가볍고 Flutter 린트 규칙에서 권장합니다.
                ? SizedBox(
                    height: 200,               // 광고 영역 높이 200픽셀
                    child: AdWidget(ad: _nativeAd!), // 광고를 보여주는 위젯
                  )
                : const SizedBox.shrink(), // 광고 없으면 아무것도 안 보임 (빈 공간 0픽셀)
            actions: <Widget>[
              // 취소 버튼: 팝업을 닫고 앱으로 돌아갑니다.
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              // 종료 버튼: 앱 프로세스를 완전히 종료합니다.
              TextButton(
                onPressed: () => exit(0), // exit(0): 앱을 강제 종료 (0 = 정상 종료)
                child: const Text('종료'),
              ),
              // 리뷰하기 버튼: 구글 플레이 스토어 페이지를 엽니다.
              TextButton(
                onPressed: () {
                  // TODO: 실제 앱 ID로 변경하세요! (com.example.basic → 실제 패키지명)
                  _launchURL(
                      'https://play.google.com/store/apps/details?id=com.example.basic');
                },
                child: const Text('리뷰하기'),
              ),
            ],
          ),
        );

        // 사용자가 "종료"를 눌렀을 때 (shouldPop == true)
        // context.mounted: 이 위젯이 아직 화면에 살아있는지 확인 (비동기 작업 후 필수 체크!)
        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop(); // 화면을 닫습니다.
        }
      },

      // 실제 앱 화면 구조
      child: Scaffold(
        // 📌 상단 앱바: 화면 제목을 표시합니다.
        appBar: AppBar(
          title: Text(widget.title), // widget.title: 부모에서 전달받은 제목 사용
        ),

        // 📌 화면 가운데에 카운터 텍스트를 보여줍니다.
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로 방향으로 가운데 정렬
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:', // 버튼을 누른 횟수를 보여줍니다
              ),
              Text(
                '$_counter', // 현재 카운터 값 ($ 기호로 변수 값을 텍스트에 넣을 수 있어요!)
                style: Theme.of(context).textTheme.headlineMedium, // 앱 테마의 중간 제목 스타일
              ),
            ],
          ),
        ),

        // 📌 오른쪽 아래의 동그란 + 버튼입니다.
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter, // 버튼을 누르면 _incrementCounter 함수 실행
          tooltip: 'Increment',         // 버튼 위에 마우스를 올리면 나오는 설명 텍스트
          child: const Icon(Icons.add), // + 아이콘
        ),

        // 📌 화면 아래쪽에 배너 광고를 보여줍니다.
        // 광고가 아직 로딩 안 됐으면 null (아무것도 안 보임)
        bottomNavigationBar: _bannerAd != null
            // ✅ 최신 방식: 크기만 지정할 때 Container 대신 SizedBox 사용
            // ✅ 최신 방식: child를 마지막 인수로 배치 (Flutter 린트 규칙)
            ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),   // 광고 원래 너비
                height: _bannerAd!.size.height.toDouble(), // 광고 원래 높이
                child: AdWidget(ad: _bannerAd!), // 배너 광고를 보여주는 위젯
              )
            : null, // 광고 없으면 하단 바 자체가 없음
      ),
    );
  }

  // ✅ dispose: 이 화면이 닫힐 때 자동으로 호출되는 함수입니다.
  // 광고 객체를 메모리에서 해제해서 메모리 낭비를 막아요!
  // (컵 다 마셨으면 씻어서 치워두는 것과 같아요)
  @override
  void dispose() {
    _bannerAd?.dispose(); // 배너 광고 메모리 해제
    _nativeAd?.dispose(); // 네이티브 광고 메모리 해제
    super.dispose();      // 부모의 dispose도 반드시 호출 (필수!)
  }
}
