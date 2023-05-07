import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_basics/provider/auth_provider.dart';
import 'package:google_maps_basics/pages/transport_owner_dashboard_page.dart';
import 'package:google_maps_basics/pages/vehicle_list_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? _email;
  String? _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _email?.isEmpty == true || _password?.isEmpty == true
                    ? null
                    : () async {
                  if (_formKey.currentState?.validate() == true) {
                    _formKey.currentState?.save();
                    // Perform login action
                    final userRole = await authProvider.loginWithEmailAndPassword(
                        _email!, _password!);

                    if (userRole == "transport_owner") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransportOwnerDashboardPage(),
                        ),
                      );
                    }
                    else if (userRole == "regular_user") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleListPage(),
                        ),
                      );
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid email or password')),
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to sign up page
                },
                child: Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
