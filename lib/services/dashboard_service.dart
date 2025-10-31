import '../models/dashboard_model.dart';

class DashboardService {
  Future<DashboardStats> getDashboardStats() async {
    await Future.delayed(const Duration(seconds: 1));
    return DashboardStats(
      todayAppointments: 5,
      pendingRequests: 3,
      activePatients: 24,
      urgentCases: 1,
    );
  }

  Future<List<Appointment>> getTodayAppointments() async {
    await Future.delayed(const Duration(seconds: 1));
    
    final now = DateTime.now();
    return [
      Appointment(
        id: '1',
        patientName: 'John Doe',
        patientImage: '',
        appointmentTime: DateTime(now.year, now.month, now.day, 10, 0),
        sessionType: 'Therapy Session',
        status: 'confirmed',
        mentalState: 'moderate',
      ),
      Appointment(
        id: '2',
        patientName: 'Sarah Wilson',
        patientImage: '',
        appointmentTime: DateTime(now.year, now.month, now.day, 14, 30),
        sessionType: 'Consultation',
        status: 'pending',
        mentalState: 'stable',
      ),
      Appointment(
        id: '3',
        patientName: 'Mike Brown',
        patientImage: '',
        appointmentTime: DateTime(now.year, now.month, now.day, 16, 15),
        sessionType: 'Follow-up',
        status: 'confirmed',
        mentalState: 'concerning',
      ),
    ];
  }

  Future<List<Patient>> getRecentPatients() async {
    await Future.delayed(const Duration(seconds: 1));
    
    final now = DateTime.now();
    return [
      Patient(
        id: '1',
        name: 'John Doe',
        image: '',
        mentalState: 'moderate',
        lastSession: now.subtract(const Duration(days: 2)),
        lastNote: 'Showing improvement in anxiety management',
      ),
      Patient(
        id: '2',
        name: 'Sarah Wilson',
        image: '',
        mentalState: 'stable',
        lastSession: now.subtract(const Duration(days: 7)),
        lastNote: 'Maintaining good progress with coping strategies',
      ),
      Patient(
        id: '3',
        name: 'Mike Brown',
        image: '',
        mentalState: 'concerning',
        lastSession: now.subtract(const Duration(days: 3)),
        lastNote: 'Expressed increased stress levels, needs monitoring',
      ),
    ];
  }
}