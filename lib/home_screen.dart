import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

// Renamed from MyHomePage to HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Renamed from _MyHomePageState to _HomeScreenState
class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  BannerAd? _bannerAd;
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadNativeAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Sample Ad Unit ID
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void _loadNativeAd() {
     _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110', // Sample Ad Unit ID
      request: AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isNativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _nativeAd?.load();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('카운터가 1 증가했습니다.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('정말 나가시겠습니까?'),
            content: _isNativeAdLoaded && _nativeAd != null
                ? Container(
                    height: 200,
                    child: AdWidget(ad: _nativeAd!),
                  )
                : Text(''),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: Text('종료'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: 스토어 URL을 실제 앱의 URL로 바꾸세요.
                  _launchURL('https://play.google.com/store/apps/details?id=com.example.basic');
                },
                child: Text('리뷰하기'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: _bannerAd != null
            ? Container(
                alignment: Alignment.center,
                child: AdWidget(ad: _bannerAd!),
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }
}
