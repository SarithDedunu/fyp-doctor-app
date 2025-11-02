import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Submit doctor registration request
  Future<Map<String, dynamic>> submitDoctorRegistration({
    required String email,
    required String password,
    required String fullName,
    required String specialization,
    required int yearsExperience,
    required String licenseNumber,
    required String? licenseDocumentUrl,
    required String? qualificationDocumentUrl,
    required String? phoneNumber,
    required String? addressLine1,
    required String? addressLine2,
    required String? city,
    required String? postalCode,
    required String country,
  }) async {
    try {
      print('🟡 Starting registration for: $email');
      
      // First, check if email already exists in registration requests
      print('🔍 Checking if email already exists...');
      final existingRequest = await _supabase
          .from('doctor_registration_requests')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      print('📧 Email check result: $existingRequest');
      
      if (existingRequest != null) {
        print('❌ Email already exists in registration requests');
        return {
          'success': false,
          'message': 'Registration already submitted for this email. Please wait for admin approval.',
        };
      }

      // Check if email already exists in approved doctors
      final existingDoctor = await _supabase
          .from('doctor_profiles')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (existingDoctor != null) {
        print('❌ Email already exists in approved doctors');
        return {
          'success': false,
          'message': 'Email already registered. Please login instead.',
        };
      }

      // Prepare data for insertion
      final registrationData = {
        'email': email,
        'password': password,
        'full_name': fullName,
        'specialization': specialization,
        'years_experience': yearsExperience,
        'license_number': licenseNumber,
        'license_document_url': licenseDocumentUrl,
        'qualification_document_url': qualificationDocumentUrl,
        'phone_number': phoneNumber,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'postal_code': postalCode,
        'country': country,
        'status': 'pending',
      };

      print('📝 Registration data to insert: $registrationData');

      // Insert registration request
      print('🚀 Inserting into doctor_registration_requests table...');
      final response = await _supabase
          .from('doctor_registration_requests')
          .insert(registrationData)
          .select();

      print('✅ Insert successful! Response: $response');

      return {
        'success': true,
        'message': 'Registration submitted successfully. Waiting for admin approval. You will be notified via email once approved.',
        'data': response,
      };
    } catch (e) {
      print('❌ Registration error: $e');
      print('📋 Error type: ${e.runtimeType}');
      return {
        'success': false,
        'message': 'Registration failed: ${e.toString()}',
      };
    }
  }

  // Check if user is approved doctor
  Future<bool> isDoctorApproved(String email) async {
    try {
      final response = await _supabase
          .from('doctor_profiles')
          .select('id, is_approved')
          .eq('email', email)
          .eq('is_approved', true)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking doctor approval: $e');
      return false;
    }
  }

  // Check registration status
  Future<Map<String, dynamic>> checkRegistrationStatus(String email) async {
    try {
      final response = await _supabase
          .from('doctor_registration_requests')
          .select('status, rejection_reason, submitted_at')
          .eq('email', email)
          .maybeSingle();

      if (response == null) {
        return {
          'exists': false,
          'message': 'No registration found for this email',
        };
      }

      return {
        'exists': true,
        'status': response['status'],
        'rejection_reason': response['rejection_reason'],
        'submitted_at': response['submitted_at'],
        'message': 'Registration ${response['status']}',
      };
    } catch (e) {
      print('Error checking registration status: $e');
      return {
        'exists': false,
        'message': 'Error checking status: ${e.toString()}',
      };
    }
  }

  // Login for approved doctors only
  Future<Map<String, dynamic>> loginDoctor({
    required String email,
    required String password,
  }) async {
    try {
      // First check if doctor is approved
      final isApproved = await isDoctorApproved(email);
      if (!isApproved) {
        // Check if registration is pending
        final status = await checkRegistrationStatus(email);
        if (status['exists'] == true && status['status'] == 'pending') {
          return {
            'success': false,
            'message': 'Your registration is pending admin approval. Please wait for approval email.',
          };
        } else if (status['exists'] == true && status['status'] == 'rejected') {
          return {
            'success': false,
            'message': 'Your registration was rejected. Reason: ${status['rejection_reason'] ?? "No reason provided"}',
          };
        } else {
          return {
            'success': false,
            'message': 'No approved registration found. Please register first.',
          };
        }
      }

      // If approved, proceed with authentication
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user != null) {
        return {
          'success': true,
          'message': 'Login successful',
          'user': authResponse.user,
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Login failed: ${e.toString()}',
      };
    }
  }

  // Test Supabase connection
  Future<Map<String, dynamic>> testSupabaseConnection() async {
    try {
      print('🧪 Testing Supabase connection...');
      
      // Try a simple insert
      final testData = {
        'email': 'test${DateTime.now().millisecondsSinceEpoch}@test.com',
        'password': 'test123',
        'full_name': 'Test Doctor',
        'specialization': 'Psychologist',
        'years_experience': 5,
        'license_number': 'TEST123',
        'status': 'pending',
      };

      final response = await _supabase
          .from('doctor_registration_requests')
          .insert(testData)
          .select();

      print('✅ Test insert successful: $response');
      
      return {
        'success': true,
        'message': 'Supabase connection test successful',
        'data': response,
      };
    } catch (e) {
      print('❌ Supabase connection test failed: $e');
      return {
        'success': false,
        'message': 'Supabase connection test failed: $e',
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _supabase.auth.currentUser != null;

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
