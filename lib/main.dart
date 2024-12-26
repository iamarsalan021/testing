import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ProxyProvider<UserProvider, GreetingProvider>(
          update: (_, userProvider, __) => GreetingProvider(userProvider.age),
        ),
      ],
      child: MaterialApp(
        home: UserInputScreen(),
      ),
    );
  }
}

class UserProvider extends ChangeNotifier {
  String _name = '';
  int _age = 0;

  String get name => _name;
  int get age => _age;

  void updateUser(String name, int age) {
    _name = name;
    _age = age;
    notifyListeners();
  }
}

class GreetingProvider {
  final int age;
  String get greeting {
    if (age < 12) return 'Child';
    if (age < 20) return 'Teenager';
    return 'Adult';
  }

  GreetingProvider(this.age);
}

class UserInputScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final age = int.tryParse(_ageController.text) ?? 0;
                Provider.of<UserProvider>(context, listen: false).updateUser(name, age);
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            UserDetails(),
          ],
        ),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final greetingProvider = Provider.of<GreetingProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${userProvider.name}', style: TextStyle(fontSize: 18)),
        Text('Age: ${userProvider.age}', style: TextStyle(fontSize: 18)),
        Text('Greeting: ${greetingProvider.greeting}', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}