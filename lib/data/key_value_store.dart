import 'package:shared_preferences/shared_preferences.dart';

/// Abstração mínima de armazenamento chave/valor.
///
/// O app depende desta interface (e não diretamente do SharedPreferences),
/// então nos testes injetamos uma implementação em memória — sem precisar de
/// plugins nem de canais de plataforma. É o que mantém os testes rápidos.
abstract interface class KeyValueStore {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);
}

/// Implementação em memória, ideal para testes.
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _data;

  InMemoryKeyValueStore([Map<String, String>? seed]) : _data = {...?seed};

  @override
  Future<String?> getString(String key) async => _data[key];

  @override
  Future<void> setString(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }
}

/// Implementação real, sobre o SharedPreferences (usada no app).
class SharedPrefsStore implements KeyValueStore {
  final SharedPreferences _prefs;

  SharedPrefsStore(this._prefs);

  static Future<SharedPrefsStore> create() async =>
      SharedPrefsStore(await SharedPreferences.getInstance());

  @override
  Future<String?> getString(String key) async => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
