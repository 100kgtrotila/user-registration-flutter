import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/validators.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _confirmEmailController = TextEditingController();

  String? _selectedCountry;
  final List<String> _countries = ['Ukraine', 'Poland', 'Germany', 'USA', 'UK'];
  String? _selectedGender;
  DateTime? _birthDate;
  bool _agreeToTerms = false;
  bool _subscribeToNewsletter = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() => _birthDate = picked);
    }
  }

  void _register() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Choose birth date')));
      return;
    }

    if (_selectedCountry == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Choose country')));
      return;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Choose gender')));
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Agree to terms')));
      return;
    }

    final user = User(
      fullName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      birthDate: _birthDate!,
      country: _selectedCountry!,
      gender: _selectedGender!,
      subscribeToNewsletter: _subscribeToNewsletter,
    );

    if (user.age < 18) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be 18 or older to register')),
      );
      return;
    }

    _showSuccessDialog(user);
  }

  void _showSuccessDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Registration Successful',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.fullName}!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Email: ${user.email}'),
            Text('Phone: ${user.phone}'),
            Text('Country: ${user.country}'),
            Text('Gender: ${user.gender}'),
            Text('Age: ${user.age} years'),
            const SizedBox(height: 16),
            Text(
              'Verification email sent to ${user.email}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.required(value, fieldName: 'Name'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.combine([
                  (value) => Validators.required(value, fieldName: 'Email'),
                  Validators.email,
                ]),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmEmailController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Email',
                  prefixIcon: Icon(Icons.mark_email_read),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm Email is required';
                  }
                  if (value != _emailController.text) {
                    return 'Email addresses do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: Validators.combine([
                  (value) => Validators.required(value, fieldName: 'Phone'),
                  Validators.phoneUA,
                ]),
              ),
              const SizedBox(height: 24),

              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                  _birthDate != null
                      ? 'Birth Date: ${_birthDate!.toLocal()}'.split(' ')[0]
                      : 'Select Birth Date',
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _selectDate,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Country',
                  prefixIcon: Icon(Icons.flag),
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedCountry,
                items: _countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCountry = value),
                validator: (value) => value == null ? 'Виберіть країну' : null,
              ),
              const SizedBox(height: 24),

              Text('Gender', style: TextStyle(fontSize: 16)),
              RadioGroup<String>(
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Male'),
                        value: 'Male',
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Female'),
                        value: 'Female',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Password', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
                validator: Validators.combine([
                  (value) => Validators.required(value, fieldName: 'Password'),
                  Validators.password,
                ]),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm Password is required';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              CheckboxListTile(
                title: Text('I agree to Terms and Conditions'),
                value: _agreeToTerms,
                onChanged: (value) =>
                    setState(() => _agreeToTerms = value ?? false),
              ),

              CheckboxListTile(
                title: Text('Subscribe to newsletter'),
                value: _subscribeToNewsletter,
                onChanged: (value) =>
                    setState(() => _subscribeToNewsletter = value ?? false),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('REGISTER', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
