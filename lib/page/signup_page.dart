import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tugas_akhirr/models/user_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userBox = Hive.box<UserModel>('users');

  // Asynchronous username availability check
  Future<bool> _isUsernameAvailable(String username) async {
    final users = _userBox.values.toList();
    return !users.any((user) => user.username == username);
  }

  // Asynchronous email availability check
  Future<bool> _isEmailAvailable(String email) async {
    final users = _userBox.values.toList();
    return !users.any((user) => user.email == email);
  }

  // Create new user account
  Future<void> _createAccount() async {
    final newUser = UserModel(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    await _userBox.add(newUser);
  }

  // Function to handle form submission with async validation
  Future<void> _submitForm() async {
    // Check if form is valid before proceeding
    if (_formKey.currentState!.validate()) {
      // Asynchronously validate username and email
      final isUsernameAvailable = await _isUsernameAvailable(_usernameController.text);
      final isEmailAvailable = await _isEmailAvailable(_emailController.text);

      // Check if the username and email are available
      if (!isUsernameAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username already exists')),
        );
        return;
      }
      if (!isEmailAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already exists')),
        );
        return;
      }

      // If everything is fine, create the account
      await _createAccount();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back after account creation
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username field
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null; // We check username availability in the submitForm method
                },
              ),
              const SizedBox(height: 16),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null; // We check email availability in the submitForm method
                },
              ),
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm password field
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton.icon(
                onPressed: _submitForm, // Call _submitForm on button press
                icon: const Icon(Icons.person_add),
                label: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:tugas_akhirr/models/user_model.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _userBox = Hive.box<UserModel>('users');
  
//   // Tambahkan variabel untuk tracking validasi
//   bool _isValidating = false;

//   Future<bool> _isUsernameAvailable(String username) async {
//     final users = _userBox.values.toList();
//     return !users.any((user) => user.username == username);
//   }

//   Future<bool> _isEmailAvailable(String email) async {
//     final users = _userBox.values.toList();
//     return !users.any((user) => user.email == email);
//   }

//   Future<void> _validateForm() async {
//     if (_isValidating) return;
    
//     setState(() {
//       _isValidating = true;
//     });

//     final username = _usernameController.text;
//     final email = _emailController.text;

//     if (username.isEmpty) {
//       _formKey.currentState?.validate();
//       setState(() {
//         _isValidating = false;
//       });
//       return;
//     }

//     if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
//       _formKey.currentState?.validate();
//       setState(() {
//         _isValidating = false;
//       });
//       return;
//     }

//     final isUsernameAvailable = await _isUsernameAvailable(username);
//     final isEmailAvailable = await _isEmailAvailable(email);

//     if (!isUsernameAvailable || !isEmailAvailable) {
//       _formKey.currentState?.validate();
//     }

//     setState(() {
//       _isValidating = false;
//     });
//   }

//     Future<void> _createAccount() async {
//     final newUser = UserModel(
//       username: _usernameController.text,
//       email: _emailController.text,
//       password: _passwordController.text,
//     );
//     await _userBox.add(newUser);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 onChanged: (_) {
//                   if (_formKey.currentState != null) {
//                     _validateForm();
//                   }
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a username';
//                   }
                  
//                   // Menggunakan variabel untuk menyimpan hasil pengecekan username
//                   if (_isValidating) {
//                     return 'Checking username availability...';
//                   }
                  
//                   final users = _userBox.values.toList();
//                   if (users.any((user) => user.username == value)) {
//                     return 'Username already exists';
//                   }
                  
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 onChanged: (_) {
//                   if (_formKey.currentState != null) {
//                     _validateForm();
//                   }
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an email';
//                   }
//                   if (!value.contains('@') || !value.contains('.')) {
//                     return 'Please enter a valid email';
//                   }
                  
//                   // Menggunakan variabel untuk menyimpan hasil pengecekan email
//                   if (_isValidating) {
//                     return 'Checking email availability...';
//                   }
                  
//                   final users = _userBox.values.toList();
//                   if (users.any((user) => user.email == value)) {
//                     return 'Email already exists';
//                   }
                  
//                   return null;
//                 },
//               ),
//               // ... rest of the form fields ...
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   await _validateForm();  // Validate form before submission
//                   if (_formKey.currentState!.validate()) {
//                     await _createAccount();
//                     if (!mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Account created successfully'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                     Navigator.pop(context);
//                   }
//                 },
//                 icon: const Icon(Icons.person_add),
//                 label: const Text('Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }