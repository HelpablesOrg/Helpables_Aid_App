import 'package:aid_app/Providers/login_and_signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EmailandPass extends StatefulWidget {
  EmailandPass({super.key, required this.formKey});

  GlobalKey<FormState> formKey;
  @override
  State<StatefulWidget> createState() => _EmailandPassState();
}

class _EmailandPassState extends State<EmailandPass> {
  bool _obscurePassword = true;
  final TextEditingController confirmPass = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginAndSignupProvider>(context, listen: true);
    bool isLogin = provider.isLogin;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        TextFormField(
          onChanged: (value) {
            Provider.of<LoginAndSignupProvider>(context, listen: false)
                .getPasswordandEmail(
                    passwordController.text, emailController.text);
          },
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter email";
            }
            final emailRegex =
                RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
            if (!emailRegex.hasMatch(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            widget.formKey.currentState!.validate();
          },
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              labelText: 'Enter your email'),
        ),
        SizedBox(height: 16),
        Text('Password',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        _buildPasswordField(
            controller: passwordController, isLogin: isLogin, isPass: true),
        SizedBox(height: 16),
        if (!isLogin)
          Text(
            'Confirm Password',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        if (!isLogin) SizedBox(height: 8),
        if (!isLogin)
          _buildPasswordField(
              controller: confirmPass, isLogin: isLogin, isPass: false)
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isLogin,
    required bool isPass,
  }) {
    return TextFormField(
      onFieldSubmitted: (value) => widget.formKey.currentState!.validate(),
      onChanged: (value) {
        Provider.of<LoginAndSignupProvider>(context, listen: false)
            .getPasswordandEmail(passwordController.text, emailController.text);
      },
      controller: isPass ? passwordController : confirmPass,
      obscureText: _obscurePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter password";
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value) && !isLogin) {
          return "Password must include at least one special character";
        }
        if (!RegExp(r'[0-9]').hasMatch(value) && !isLogin) {
          return "Password must include at least one number";
        }
        if (value != passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: isPass ? 'Enter your Password' : 'Confirm Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility))),
    );
  }
}
