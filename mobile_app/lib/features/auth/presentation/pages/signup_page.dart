import 'package:flutter/material.dart';
import '../../../feed/presentation/pages/feed_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simüle edilmiş kayıt süreci (Burada authRepsitory signUp çağrılacak)
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      if (mounted) {
        // Başarılı kayıttan sonra FeedPage'e yönlendir (veya girişe yönlendir)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const FeedPage()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Yeni Bir Transfer',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ekipler seni bekliyor. Hemen kayıt ol ve analizlerini dünyaya duyur.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // İsim Alanı
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Analist (Kullanıcı) Adı',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Kullanıcı adı gerekli';
                    if (value.length < 3) return 'Kullanıcı adı en az 3 karakter olmalı';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // E-posta Alanı
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'E-posta boş bırakılamaz';
                    if (!value.contains('@')) return 'Geçerli bir e-posta girin';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Şifre Alanı
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Şifre boş bırakılamaz';
                    if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Kayıt Ol Butonu
                FilledButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Üye Ol ve Başla', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
