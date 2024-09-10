//import delle classi impiegate
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/HomeScreen.dart';
import 'package:libreria/UserCredentials.dart';

//classe che permette di effettuare il login all'applicazione.
//Quando viene effettuato il login, carica lo stato, se presente, salvato in locale
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //username
    final usernameController = TextEditingController();
    //password
    final passwordController = TextEditingController();

    void login() {
      final provider = ref.read(userProvider.notifier);
      provider.login(
        usernameController.text,
        passwordController.text,
      );

      // Controlla le credenziali inserite
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      if (provider.state?.validate() == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nome utente o password non validi')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            //ListView per permettere lo scorrimento su dispositivi con schermo piccolo o in orizzontale
            shrinkWrap: true, //adatta alla grandezza dei suoi contenuti
            children: [
              const Icon(Icons.lock, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              TextField(
                //campo di testo per l'inserimento del nome utente
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Nome utente',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                //campo di testo per l'inserimento della password
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true, // offuscamento della password digitata
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              //bottono per invocare il login effettivo
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
