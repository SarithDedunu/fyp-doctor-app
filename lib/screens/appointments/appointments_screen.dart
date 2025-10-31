import 'package:flutter/material.dart';
import 'package:doctor_app/models/dashboard_model.dart';
import 'package:doctor_app/services/dashboard_service.dart';
import 'package:doctor_app/widgets/appointment_card.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final DashboardService _dashboardService = DashboardService();
  late Future<List<Appointment>> _appointmentsFuture;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() {
    _appointmentsFuture = _dashboardService.getTodayAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAppointments,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          _buildFilterChips(),
          const SizedBox(height: 16),
          
          // Appointments List
          Expanded(
            child: FutureBuilder<List<Appointment>>(
              future: _appointmentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                
                final appointments = _filterAppointments(snapshot.data!);
                
                if (appointments.isEmpty) {
                  return const Center(
                    child: Text(
                      'No appointments found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'value': 'all', 'label': 'All'},
      {'value': 'pending', 'label': 'Pending'},
      {'value': 'confirmed', 'label': 'Confirmed'},
      {'value': 'completed', 'label': 'Completed'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter['label']!),
              selected: _selectedFilter == filter['value'],
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['value']!;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.teal[700],
              labelStyle: TextStyle(
                color: _selectedFilter == filter['value'] ? Colors.white : Colors.black87,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Appointment> _filterAppointments(List<Appointment> appointments) {
    if (_selectedFilter == 'all') {
      return appointments;
    }
    return appointments.where((appointment) => appointment.status == _selectedFilter).toList();
  }

  void _handleAppointmentAction(Appointment appointment, String action) {
    // TODO: Implement accept/reject logic
    print('Appointment ${appointment.id} $action');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment ${action == 'accepted' ? 'accepted' : 'rejected'}'),
        backgroundColor: action == 'accepted' ? Colors.green : Colors.red,
      ),
    );
    _loadAppointments(); // Refresh the list
  }

  void _startSession(Appointment appointment) {
    // TODO: Implement start session logic
    print('Starting session with ${appointment.patientName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting session with ${appointment.patientName}'),
        backgroundColor: Colors.teal[700],
      ),
    );
  }
}