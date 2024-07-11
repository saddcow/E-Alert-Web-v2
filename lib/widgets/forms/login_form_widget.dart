import 'package:e_alert/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController emailCon = TextEditingController(),
      passwordCon = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onChanged: (_) {
              if (formKey.currentState != null) {
                formKey.currentState!.validate();
              }
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email, color: Colors.black, size: 20),
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.black, fontSize: 12),
              floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 16),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passwordCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters long";
              }
              return null;
            },
            onChanged: (_) {
              if (formKey.currentState != null) {
                formKey.currentState!.validate();
              }
            },
            onFieldSubmitted: (_) => AuthService().signIn(
              emailCon.text, passwordCon.text, context
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            obscuringCharacter: '•',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock, color: Colors.black, size: 20),
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.black, fontSize: 12),
              floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 16),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () => AuthService().signIn(emailCon.text, passwordCon.text, context),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: const Color(0xFF1E88E5),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
