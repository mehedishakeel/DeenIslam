import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AudioService extends ChangeNotifier {
  static final AudioService instance = AudioService._internal();

  static const MethodChannel _channel =
      MethodChannel('com.mehedishakeel.deenislam/audio');

  String? _currentUrl;
  bool _isPlaying = false;
  bool _isLoading = false;
  VoidCallback? _onCompletedCallback;

  String? get currentUrl => _currentUrl;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;

  AudioService._internal() {
    _channel.setMethodCallHandler(_handleNativeCallback);
  }

  Future<void> _handleNativeCallback(MethodCall call) async {
    switch (call.method) {
      case 'onPrepared':
        _isLoading = false;
        _isPlaying = true;
        notifyListeners();
        break;
      case 'onCompleted':
        _isLoading = false;
        _isPlaying = false;
        final cb = _onCompletedCallback;
        notifyListeners();
        if (cb != null) {
          cb();
        }
        break;
      case 'onError':
        _isLoading = false;
        _isPlaying = false;
        notifyListeners();
        break;
    }
  }

  Future<void> playUrl(
    String url, {
    VoidCallback? onCompleted,
  }) async {
    _currentUrl = url;
    _isLoading = true;
    _isPlaying = false;
    _onCompletedCallback = onCompleted;
    notifyListeners();
    try {
      await _channel.invokeMethod('playUrl', {'url': url});
    } catch (_) {
      _isLoading = false;
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    try {
      await _channel.invokeMethod('pause');
      _isPlaying = false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> resume() async {
    try {
      await _channel.invokeMethod('resume');
      _isPlaying = true;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> stop() async {
    _onCompletedCallback = null;
    _isLoading = false;
    _isPlaying = false;
    _currentUrl = null;
    notifyListeners();
    try {
      await _channel.invokeMethod('stop');
    } catch (_) {}
  }
}
