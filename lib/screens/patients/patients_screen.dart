import 'package:flutter/material.dart';
import 'package:doctor_app/models/dashboard_model.dart';
import 'package:doctor_app/services/dashboard_service.dart';
import 'package:doctor_app/widgets/patient_card.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final DashboardService _dashboardService = DashboardService();
  late Future<List<Patient>> _patientsFuture;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _loadPatients() {
    _patientsFuture = _dashboardService.getRecentPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPatients,
          ),
        ],
      ),
      body: Column(
        children: [
          // Mental State Filter
          _buildMentalStateFilter(),
          const SizedBox(height: 16),
          
          // Patients List
          Expanded(
            child: FutureBuilder<List<Patient>>(
              future: _patientsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                
                final patients = _filterPatients(snapshot.data!);
                
                if (patients.isEmpty) {
                  return const Center(
                    child: Text(
                      'No patients found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: patients.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return PatientCard(patient: patients[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentalStateFilter() {
    final List<Map<String, dynamic>> filters = [
      {'value': 'all', 'label': 'All', 'color': Colors.grey},
      {'value': 'stable', 'label': 'Stable', 'color': Colors.green},
      {'value': 'moderate', 'label': 'Moderate', 'color': Colors.orange},
      {'value': 'concerning', 'label': 'Concerning', 'color': Colors.red},
      {'value': 'critical', 'label': 'Critical', 'color': Colors.purple},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter['label'] as String),
              selected: _selectedFilter == filter['value'] as String,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['value'] as String;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: filter['color'] as Color,
              labelStyle: TextStyle(
                color: _selectedFilter == filter['value'] 
                    ? Colors.white 
                    : Colors.black87,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Patient> _filterPatients(List<Patient> patients) {
    if (_selectedFilter == 'all') {
      return patients;
    }
    return patients.where((patient) => patient.mentalState == _selectedFilter).toList();
  }
}