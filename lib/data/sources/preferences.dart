import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesSource {
  late SharedPreferences _preferences;

  SharedPreferences get instance => _preferences;

  Future<void> initialize() async =>
      _preferences = await SharedPreferences.getInstance();
}

// provider
final preferencesSourceProvider = Provider<PreferencesSource>((ref) {
  return PreferencesSource();
});
