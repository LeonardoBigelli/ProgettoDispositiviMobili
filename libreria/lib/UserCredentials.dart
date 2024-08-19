import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCredentials {
  final String username;
  final String password;
  List<Map<String, String>> favoriteBooks; //provare una mappa di mappe

  UserCredentials({
    required this.username,
    required this.password,
    this.favoriteBooks = const [],
  });

  bool validate() {
    return username.isNotEmpty && password.isNotEmpty;
  }

  void addFavoriteBook(String title, String author, String coverUrl) {
    favoriteBooks.add({
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
    });
  }

  void removeFavoriteBook(String title) {
    favoriteBooks.removeWhere((book) => book['title'] == title);
  }
}

class UserProvider extends StateNotifier<UserCredentials?> {
  UserProvider() : super(null);

  void login(String username, String password) {
    state = UserCredentials(username: username, password: password);
  }

  void addFavoriteBook(String title, String author, String coverUrl) {
    if (state != null) {
      state!.addFavoriteBook(title, author, coverUrl);
      state = UserCredentials(
        username: state!.username,
        password: state!.password,
        favoriteBooks: List.from(state!
            .favoriteBooks), // Create a new list to trigger change notification
      );
    }
  }

  void removeFavoriteBook(String title) {
    if (state != null) {
      state!.removeFavoriteBook(title);
      state = UserCredentials(
        username: state!.username,
        password: state!.password,
        favoriteBooks: List.from(state!
            .favoriteBooks), // Create a new list to trigger change notification
      );
    }
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, UserCredentials?>((ref) {
  return UserProvider();
});
