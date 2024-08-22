import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCredentials {
  final String username;
  final String password;
  List<List<String>>
      favoriteBooks; //un elemento singolo e' [titolo, autore, img copertina]

  UserCredentials({
    required this.username,
    required this.password,
    List<List<String>>? favoriteBooks,
  }) : favoriteBooks = favoriteBooks ?? [];

  bool validate() {
    return username == "admin" && password == "admin";
  }

  void addFavoriteBook(String title, String author, String coverUrl) {
    favoriteBooks.add([title, author, coverUrl]);
  }

  void removeFavoriteBook(String title) {
    favoriteBooks.removeWhere((book) => book[0] == title);
  }

  // Converti l'oggetto in una mappa (che può essere convertita in JSON)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'favoriteBooks': favoriteBooks,
    };
  }

  // Crea un oggetto UserCredentials da una mappa JSON
  factory UserCredentials.fromJson(Map<String, dynamic> json) {
    return UserCredentials(
      username: json['username'],
      password: json['password'],
      favoriteBooks: List<List<String>>.from(
        (json['favoriteBooks'] as List).map(
          (book) => List<String>.from(book),
        ),
      ),
    );
  }
}

class UserProvider extends StateNotifier<UserCredentials?> {
  UserProvider() : super(null) {
    _loadUser(); // Carica l'utente all'inizializzazione
  }

  void login(String username, String password) {
    state = UserCredentials(username: username, password: password);
    _saveUser(); // Salva l'utente subito dopo il login
  }

  void addFavoriteBook(String title, String author, String coverUrl) {
    if (state != null) {
      state!.addFavoriteBook(title, author, coverUrl);
      _saveUser(); // Salva l'utente ogni volta che viene aggiunto un libro
    }
  }

  void removeFavoriteBook(String title) {
    if (state != null) {
      state!.removeFavoriteBook(title);
      _saveUser(); // Salva l'utente ogni volta che viene rimosso un libro
    }
  }

  // Metodo per salvare l'utente in locale
  void _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (state != null) {
      prefs.setString('user', jsonEncode(state!.toJson()));
    }
  }

  // Metodo per caricare l'utente da locale
  void _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      state = UserCredentials.fromJson(jsonDecode(userJson));
    }
  }

  // Metodo per il logout
  void logout() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, UserCredentials?>((ref) {
  return UserProvider();
});
