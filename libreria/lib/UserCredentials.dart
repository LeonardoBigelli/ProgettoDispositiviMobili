class UserCredentials {
  String username;
  String password;

  UserCredentials({required this.username, required this.password});

  bool validate() {
    //per ora è presente solamente l'utente admin
    return username == "admin" && password == "admin";
  }
}
