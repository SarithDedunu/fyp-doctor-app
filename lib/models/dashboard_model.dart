class DashboardStats {
  final int todayAppointments;
  final int pendingRequests;
  final int activePatients;
  final int urgentCases;

  DashboardStats({
    required this.todayAppointments,
    required this.pendingRequests,
    required this.activePatients,
    required this.urgentCases,
  });
}

class Appointment {
  final String id;
  final String patientName;
  final String patientImage;
  final DateTime appointmentTime;
  final String sessionType;
  final String status; // 'pending', 'confirmed', 'completed'
  final String mentalState; // 'stable', 'moderate', 'concerning', 'critical'

  Appointment({
    required this.id,
    required this.patientName,
    required this.patientImage,
    required this.appointmentTime,
    required this.sessionType,
    required this.status,
    required this.mentalState,
  });
}

class Patient {
  final String id;
  final String name;
  final String image;
  final String mentalState;
  final DateTime lastSession;
  final String lastNote;

  Patient({
    required this.id,
    required this.name,
    required this.image,
    required this.mentalState,
    required this.lastSession,
    required this.lastNote,
  });
}