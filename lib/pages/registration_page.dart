import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_basics/provider/auth_provider.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? _email;
  String? _password;
  bool _isTransportOwner = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (value) => value?.isEmpty == true ? 'Please enter your email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                validator: (value) => value?.isEmpty == true ? 'Please enter your password' : null,
                obscureText: true,
              ),
              SwitchListTile(
                title: Text('Register as a Transport Owner'),
                value: _isTransportOwner,
                onChanged: (value) {
                  setState(() {
                    _isTransportOwner = value;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _email?.isEmpty == true || _password?.isEmpty == true
                    ? null
                    : () {
                  if (_formKey.currentState?.validate() == true) {
                    _formKey.currentState?.save();
                    authProvider.registerWithEmailAndPassword(
                        _email!, _password!, _isTransportOwner);
                  }
                },
                child: Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to login page
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
