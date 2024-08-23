import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

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

  // Funzione per ottenere il file in cui salvare i dati utente
  Future<File> _getUserFile() async {
    final directory = await getApplicationDocumentsDirectory();
    print("salvataggio in: ${directory.path}");
    return File('${directory.path}/user_data.json');
  }

  // Funzione per salvare i dati utente nel file JSON
  Future<void> _saveUser() async {
    if (state != null) {
      try {
        final file = await _getUserFile();
        final userJson = jsonEncode(state!.toJson());
        await file.writeAsString(userJson);
        print('User data saved: $userJson'); // Debug
      } catch (e) {
        print('Failed to save user data: $e');
      }
    }
  }

  // Funzione per caricare i dati utente dal file JSON
  Future<void> _loadUser() async {
    try {
      final file = await _getUserFile();
      if (await file.exists()) {
        final userJson = await file.readAsString();
        state = UserCredentials.fromJson(jsonDecode(userJson));
        print('User data loaded: $userJson'); // Debug
      } else {
        print('User data file not found');
      }
    } catch (e) {
      print('Failed to load user data: $e');
    }
  }

  void login(String username, String password) {
    state = UserCredentials(username: username, password: password);
    //  _saveUser(); // Salva l'utente subito dopo il login
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

  void logout() async {
    state = null;
    try {
      final file = await _getUserFile();
      if (await file.exists()) {
        await file.delete();
        print('User data file deleted');
      }
    } catch (e) {
      print('Failed to delete user data file: $e');
    }
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, UserCredentials?>((ref) {
  return UserProvider();
});
