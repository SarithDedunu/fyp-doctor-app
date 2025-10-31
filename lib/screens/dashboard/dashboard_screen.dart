import 'package:flutter/material.dart';
import 'package:doctor_app/models/dashboard_model.dart';
import 'package:doctor_app/services/dashboard_service.dart';
import 'package:doctor_app/widgets/stat_card.dart';
import 'package:doctor_app/widgets/appointment_card.dart';
import 'package:doctor_app/widgets/patient_card.dart';
import 'package:doctor_app/screens/appointments/appointments_screen.dart';
import 'package:doctor_app/screens/patients/patients_screen.dart';
import 'package:doctor_app/screens/profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  late Future<DashboardStats> _statsFuture;
  late Future<List<Appointment>> _appointmentsFuture;
  late Future<List<Patient>> _patientsFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _statsFuture = _dashboardService.getDashboardStats();
    _appointmentsFuture = _dashboardService.getTodayAppointments();
    _patientsFuture = _dashboardService.getRecentPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _currentIndex == 0 ? _buildAppBar() : null,
      body: _getCurrentScreen(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Dashboard',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal[700],
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadData,
        ),
      ],
    );
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const AppointmentsScreen();
      case 2:
        return const PatientsScreen();
      case 3:
        return const ProfileScreen();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(),
          const SizedBox(height: 24),
          
          // Statistics Section
          _buildStatsSection(),
          const SizedBox(height: 24),
          
          // Today's Appointments Section
          _buildAppointmentsSection(),
          const SizedBox(height: 24),
          
          // Recent Patients Section
          _buildPatientsSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal[700]!, Colors.teal[500]!],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Good Morning, Dr. Smith!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<DashboardStats>(
            future: _statsFuture,
            builder: (context, snapshot) {
              final count = snapshot.hasData ? snapshot.data!.todayAppointments : 0;
              return Text(
                'You have $count appointments today',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<DashboardStats>(
          future: _statsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            
            final stats = snapshot.data!;
            
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                StatCard(
                  title: "Today's Appointments",
                  value: stats.todayAppointments.toString(),
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                ),
                StatCard(
                  title: "Pending Requests",
                  value: stats.pendingRequests.toString(),
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),
                StatCard(
                  title: "Active Patients",
                  value: stats.activePatients.toString(),
                  icon: Icons.people,
                  color: Colors.green,
                ),
                StatCard(
                  title: "Urgent Cases",
                  value: stats.urgentCases.toString(),
                  icon: Icons.warning,
                  color: Colors.red,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Appointments",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 1; // Navigate to appointments
                });
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: Colors.teal[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Appointment>>(
          future: _appointmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            
            final appointments = snapshot.data!;
            
            if (appointments.isEmpty) {
              return const Center(child: Text('No appointments today'));
            }
            
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appointments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return AppointmentCard(
                  appointment: appointments[index],
                  onAccept: () => _handleAppointmentAction(appointments[index], 'accepted'),
                  onReject: () => _handleAppointmentAction(appointments[index], 'rejected'),
                  onStartSession: () => _startSession(appointments[index]),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPatientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Patients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 2; // Navigate to patients
                });
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: Colors.teal[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Patient>>(
          future: _patientsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            
            final patients = snapshot.data!;
            
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: patients.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return PatientCard(patient: patients[index]);
              },
            );
          },
        ),
      ],
    );
  }

  void _handleAppointmentAction(Appointment appointment, String action) {
    // TODO: Implement accept/reject logic
    print('Appointment ${appointment.id} $action');
  }

  void _startSession(Appointment appointment) {
    // TODO: Implement start session logic
    print('Starting session with ${appointment.patientName}');
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal[700],
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Patients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}