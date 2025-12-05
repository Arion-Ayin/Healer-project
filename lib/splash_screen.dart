import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      } else {
        _loadInterstitialAd();
        _navigateToHome();
      }
    } catch (e) {
      print('Failed to check for update: $e');
      _loadInterstitialAd();
      _navigateToHome();
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Sample Ad Unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _navigateToHome() {
    Timer(Duration(seconds: 3), () {
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            _goToHomePage();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            _goToHomePage();
          },
        );
        _interstitialAd!.show();
      } else {
        _goToHomePage();
      }
    });
  }

  void _goToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}