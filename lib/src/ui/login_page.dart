import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment_task/src/blocs/login/login_bloc.dart';
import 'package:assignment_task/src/blocs/login/login_event.dart';
import 'package:assignment_task/src/blocs/login/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    context.read<LoginBloc>().add(LoginEmailChanged(_emailController.text));
  }

  void _onPasswordChanged() {
    context.read<LoginBloc>().add(LoginPasswordChanged(_passwordController.text));
  }

  void _onSubmitted() {
    context.read<LoginBloc>().add(LoginSubmitted(_emailController.text, _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<LoginBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: bloc.state.isEmailValid ? null : 'Enter a valid email',
                ),
                onChanged: (_) => _onEmailChanged(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: bloc.state.isPasswordValid
                      ? null
                      : 'Password must be 8+ chars with upper, lower, digit & symbol',
                ),
                onChanged: (_) => _onPasswordChanged(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: bloc.state.isSubmitting ? null : _onSubmitted,
                child: bloc.state.isSubmitting
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
