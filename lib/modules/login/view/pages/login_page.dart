import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:psyra/core/common_blocs/auth_bloc/auth_bloc.dart';
import 'package:psyra/core/navigation/navigation_routes.dart';
import 'package:psyra/modules/login/controller/login_bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Set default credentials
    _emailController.text = 'rafnaspaaap4@gmail.co';
    _passwordController.text = 'Raf';
    // Update login bloc with default values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginBloc>().add(LoginEmailChanged(_emailController.text));
      context.read<LoginBloc>().add(LoginPasswordChanged(_passwordController.text));
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    print('🔵 ========================================');
    print('🔵 LOGIN BUTTON CLICKED');
    print('🔵 ========================================');
    print('🔵 Email: ${_emailController.text.trim()}');
    print('🔵 Password: ${_passwordController.text}');
    
    if (_formKey.currentState!.validate()) {
      print('✅ Form validation passed');
      context.read<LoginBloc>().add(const LoginSubmitted());
      // Trigger auth login
      print('🔵 Dispatching AuthLoginRequested event...');
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    } else {
      print('❌ Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, authState) {
            print('🔵 ========================================');
            print('🔵 AUTH STATE CHANGED');
            print('🔵 ========================================');
            print('🔵 State type: ${authState.runtimeType}');
            
            if (authState is AuthAuthenticated) {
              print('✅ User authenticated successfully!');
              print('🔵 User: ${authState.user.name} (${authState.user.email})');
              print('🔵 Navigating to dashboard...');
              context.go(NavigationRoutes.dashboard);
            } else if (authState is AuthError) {
              print('❌ Authentication error: ${authState.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authState.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (authState is AuthLoading) {
              print('⏳ Authentication in progress...');
            } else {
              print('🔵 Auth state: $authState');
            }
            print('🔵 ========================================');
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, loginState) {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final isLoading = authState is AuthLoading;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 60),
                          // Logo/Title
                          const Icon(
                            Icons.lock_outline,
                            size: 80,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Welcome Back',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@') || !value.contains('.')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              context.read<LoginBloc>().add(
                                    LoginEmailChanged(value),
                                  );
                            },
                          ),
                          const SizedBox(height: 20),
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 3) {
                                return 'Password must be at least 3 characters';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              context.read<LoginBloc>().add(
                                    LoginPasswordChanged(value),
                                  );
                            },
                          ),
                          const SizedBox(height: 32),
                          // Login Button
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go(NavigationRoutes.signup);
                                },
                                child: const Text('Sign Up'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

