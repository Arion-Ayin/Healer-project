import 'dart:async';
import 'package:flutter/material.dart';
import 'themes.dart';

/// 📌 AppSnackBar: 화면 아래에 잠깐 나타났다가 사라지는 예쁜 알림창(스낵바) 장난감이에요!
/// 배너 광고 영역(네비게이션 바 위)에서 위로 쏙 올라왔다가, 시간이 지나면 아래로 쏙 내려가며 사라져요.
class AppSnackBar {
  // 🎈 화면 위에 덧붙여 그릴 스낵바 조각이에요.
  static OverlayEntry? _entry;
  
  // 🎈 스낵바가 완전히 사라질 때까지 기다려주는 약속 상자(Completer)예요.
  static Completer<void>? _dismissCompleter;
  
  // 🎈 현재 화면에 살아있는 스낵바의 실제 상태(움직임 관리자)예요.
  static _SnackBarOverlayState? _activeState;

  // 📐 _bottomInset: 스낵바가 화면 맨 아래에 딱 붙지 않도록, 
  // 핸드폰 아래쪽 여백(홈 버튼 영역 등)과 하단 메뉴 바, 그리고 배너 광고의 높이를 더해서 
  // 알맞은 높이만큼 띄워주는 계산기예요.
  static double _bottomInset(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom; // 핸드폰 자체의 아래쪽 안전 여백
    const navBarHeight = kBottomNavigationBarHeight; // 하단 메뉴 바 높이
    const bannerHeight = 45.0; // 배너 광고 높이
    return bottomSafe + navBarHeight + bannerHeight + 10; // 다 더하고 10만큼 더 위로 띄워요!
  }

  // 🎨 _colorsForTheme: 앱의 테마(밝은 모드인지, 어두운 모드인지)에 따라서
  // 스낵바의 배경색과 글자색을 알맞게 골라주는 도구예요.
  static ({Color background, Color text}) _colorsForTheme(
    Brightness brightness,
  ) {
    // 🌙 어두운 밤 모드일 때: 배경은 밝은 아이보리색, 글자는 어두운 남색
    if (brightness == Brightness.dark) {
      return (background: const Color(0xFFF0EDE5), text: Themes.midnightBlue);
    }
    // ☀️ 밝은 낮 모드일 때: 배경은 깊은 남색, 글자는 하얀색
    return (background: const Color(0xFF1A1A2E), text: Colors.white);
  }

  // 🚀 show: 스낵바를 화면에 짠! 하고 보여주는 마법이에요.
  static Future<void> show(
    BuildContext context, {
    required String message, // 💬 보여줄 메시지 내용
    // ⏰ 스낵바가 화면에 머무르는 기본 시간은 2초예요.
    Duration duration = const Duration(seconds: 2),
  }) async {
    // 화면이 다 그려지기 전에 부르면 펑 터지니까, 화면이 무사히 준비되었는지 확인해요.
    if (!context.mounted) return;

    // 🧹 이미 화면에 켜져 있는 스낵바가 있다면, 새 스낵바를 보여주기 전에 먼저 깔끔히 지워줘요.
    await dismiss();

    // 지우는 동안 화면이 사라졌을 수도 있으니 한 번 더 확인해요.
    if (!context.mounted) return;

    // 🗺️ 화면 위에 물건을 올려놓는 큰 투명 도화지(Overlay)를 찾아와요.
    final overlay = Overlay.of(context);
    final brightness = Theme.of(context).brightness; // 현재 앱이 낮 모드인지 밤 모드인지 알아내요.
    final colors = _colorsForTheme(brightness); // 색상을 정해요.
    final bottom = _bottomInset(context); // 띄울 높이를 계산해요.

    _dismissCompleter = Completer<void>(); // "이제 사라질 준비를 할 거야" 하고 약속 상자를 만들어요.

    late OverlayEntry entry;
    // 🛠️ 도화지에 붙일 스낵바 그림 조각을 만듭니다.
    entry = OverlayEntry(
      builder: (overlayContext) {
        return _SnackBarOverlay(
          message: message,
          bottom: bottom,
          backgroundColor: colors.background,
          textColor: colors.text,
          displayDuration: duration, // 화면에 몇 초 동안 머무를지 알려줘요.
          onRemove: () {
            // 스낵바가 화면에서 완전히 떨어질 때 실행되는 약속이에요.
            if (_entry == entry) {
              _entry = null;
              _activeState = null;
            }
            entry.remove(); // 진짜로 도화지에서 스낵바를 떼어내요!
            if (_dismissCompleter != null && !_dismissCompleter!.isCompleted) {
              _dismissCompleter!.complete(); // "약속 지켰어! 스낵바 완전히 없어졌어!"
            }
          },
          // 스낵바가 태어날 때, 이 스낵바의 움직임 관리자(state)를 등록해둬요.
          onStateCreated: (state) => _activeState = state,
        );
      },
    );

    _entry = entry; // 현재 떠 있는 스낵바를 기록해둬요.
    overlay.insert(entry); // 도화지에 스낵바를 붙여서 화면에 보여줍니다!
    await _dismissCompleter!.future; // 스낵바가 완전히 사라질 때까지 얌전히 기다려요.
  }

  // 🧹 dismiss: 화면에 떠 있는 스낵바를 서둘러 없애주는 도구예요.
  static Future<void> dismiss() async {
    final state = _activeState;
    if (state != null && state.mounted) {
      // 움직임 관리자가 살아있다면, 스르륵 아래로 내려가는 애니메이션을 실행해요.
      await state.dismissAnimated();
      return;
    }
    // 애니메이션을 할 수 없는 상황이라면 그냥 즉시 떼어내요.
    _entry?.remove();
    _entry = null;
    _activeState = null;
    if (_dismissCompleter != null && !_dismissCompleter!.isCompleted) {
      _dismissCompleter!.complete();
    }
  }
}

/// 🎨 _SnackBarOverlay: 실제로 화면에 그릴 스낵바의 형태(틀)를 정하는 위젯이에요.
class _SnackBarOverlay extends StatefulWidget {
  final String message;
  final double bottom;
  final Color backgroundColor;
  final Color textColor;
  final Duration displayDuration; 
  final VoidCallback onRemove;
  final void Function(_SnackBarOverlayState state) onStateCreated;

  const _SnackBarOverlay({
    required this.message,
    required this.bottom,
    required this.backgroundColor,
    required this.textColor,
    required this.displayDuration,
    required this.onRemove,
    required this.onStateCreated,
  });

  @override
  State<_SnackBarOverlay> createState() => _SnackBarOverlayState();
}

/// 🏃‍♂️ _SnackBarOverlayState: 스낵바가 스르륵 올라왔다가 내려가는 역동적인 움직임을 직접 만드는 클래스예요!
/// SingleTickerProviderStateMixin: 매 초마다 화면을 새로 그리게 돕는 "시계 태엽" 역할을 해줍니다.
class _SnackBarOverlayState extends State<_SnackBarOverlay>
    with SingleTickerProviderStateMixin {
  
  late final AnimationController _controller; // ⏰ 애니메이션 시간을 조절하는 리모컨이에요.
  late final Animation<double> _fade;         // 👻 투명도 애니메이션 (스르륵 나타나기)
  late final Animation<Offset> _slide;        // 🛹 미끄러지는 애니메이션 (위아래로 움직이기)
  bool _isClosing = false;                     // 🛑 지금 닫히고 있는 중인지 체크하는 꼬리표예요.

  @override
  void initState() {
    super.initState();
    widget.onStateCreated(this); // 내가 태어났다고 대장(AppSnackBar)에게 알려요.

    // ⏱️ 애니메이션이 시작해서 끝날 때까지 0.25초(250밀리초) 동안 작동하도록 리모컨을 맞춰요.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // 📈 CurvedAnimation: 움직임을 자연스럽게 만들어주는 마법 곡선이에요.
    // 나타날 때는 끝이 부드럽게 멈추고(easeOutCubic), 사라질 때는 시작이 부드럽게(easeInCubic) 움직여요!
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _fade = curve; // 투명도 조절 마법을 곡선에 연결해요 (0 = 투명 -> 1 = 진함)
    
    // 🛹 Tween: 시작 위치와 끝 위치를 연결해주는 고무줄이에요.
    // 아래쪽으로 45%만큼 내려간 상태에서 제자리(Offset.zero)로 올라오게 만들어요.
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.45),
      end: Offset.zero,
    ).animate(curve);

    _runLifecycle(); // 스낵바의 일생을 시작합니다!
  }

  // 📅 _runLifecycle: 스낵바가 태어나서 사라질 때까지의 일생을 순서대로 적어둔 일기장이에요.
  Future<void> _runLifecycle() async {
    // 1단계: 0.25초 동안 스르륵 올라오면서 진해집니다.
    await _controller.forward();
    if (!mounted) return; // 중간에 화면이 터지면 취소해요.

    // 2단계: 사용자가 지정한 시간(기본 2초) 동안 가만히 멈춰서 글씨를 보여줘요.
    await Future.delayed(widget.displayDuration);
    if (!mounted) return;

    // 3단계: 시간이 다 되면 아래로 스르륵 내려가며 사라집니다!
    await dismissAnimated();
  }

  // 🏃‍♂️ dismissAnimated: 아래로 부드럽게 사라지는 애니메이션을 직접 시작하는 함수예요.
  Future<void> dismissAnimated() async {
    if (_isClosing || !mounted) return; // 이미 닫히고 있거나 죽었으면 또 닫지 않아요.
    _isClosing = true; // "나 지금 문 닫고 있어!" 표시

    // 만약 올라가는 중이었거나 다 올라온 상태라면, 리모컨을 거꾸로 돌려 내려가게 해요(reverse).
    if (_controller.status == AnimationStatus.forward ||
        _controller.value > 0) {
      await _controller.reverse(); // 리모컨 거꾸로 재생!
    }
    
    if (mounted) {
      widget.onRemove(); // 다 내려왔으면 진짜로 지워달라고 부모에게 요청해요.
    }
  }

  // 🗑️ 화면에서 사라질 때 리모컨을 부수고(해제) 깨끗하게 떠나요.
  @override
  void dispose() {
    _controller.dispose(); // 리모컨 배터리를 빼서 소멸시켜요. (메모리 절약)
    super.dispose();
  }

  // 📐 실제로 보이는 상자 디자인을 만드는 곳이에요.
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,  // 왼쪽에서 16만큼 띄우고
      right: 16, // 오른쪽에서도 16만큼 띄우고
      bottom: widget.bottom, // 계산된 높이만큼 띄워요.
      child: SlideTransition(
        position: _slide, // 위아래 미끄러지기 적용!
        child: FadeTransition(
          opacity: _fade, // 투명도 적용!
          child: Material(
            color: Colors.transparent, // 투명한 도화지 위에
            child: Container(
              // 안쪽 여백: 가로 16, 세로 14
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: widget.backgroundColor, // 테마에 맞는 배경색
                borderRadius: BorderRadius.circular(10), // 모서리를 둥글둥글 깎아요 (반지름 10)
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2), // 흐릿한 검정 그림자 효과
                    blurRadius: 12, // 그림자 번짐 정도
                    offset: const Offset(0, 4), // 그림자가 살짝 아래로 4만큼 치우침
                  ),
                ],
              ),
              child: Text(
                widget.message, // 전달받은 메시지 글씨
                style: TextStyle(color: widget.textColor, fontSize: 14), // 글씨색과 크기(14)
              ),
            ),
          ),
        ),
      ),
    );
  }
}

