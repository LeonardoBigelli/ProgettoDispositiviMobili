class UserCredentials {
  String username;
  String password;
  List<Map<String, String>> favoriteBooks;

  UserCredentials(
      {required this.username,
      required this.password,
      this.favoriteBooks = const []});

  bool validate() {
    //per ora è presente solamente l'utente admin
    return username == "admin" && password == "admin";
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
