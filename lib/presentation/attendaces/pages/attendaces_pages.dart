import 'dart:async';

import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:absensi_alma/injection_container.dart';
import 'package:absensi_alma/presentation/attendaces/bloc/attendance_bloc.dart';
import 'package:absensi_alma/presentation/attendaces/bloc/attendance_event.dart';
import 'package:absensi_alma/presentation/attendaces/bloc/attendance_state.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendancePage extends StatelessWidget {
  final UserEntity user;
  const AttendancePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AttendanceBloc>()..add(FetchAttendanceData()),
      child: _AttendanceView(user: user),
    );
  }
}

class _AttendanceView extends StatefulWidget {
  final UserEntity user;
  const _AttendanceView({required this.user});

  @override
  State<_AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<_AttendanceView> {
  // Controllers
  CameraController? _cameraController;
  final Completer<GoogleMapController> _mapController = Completer();
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    // Gunakan kamera depan
    final frontCamera = _cameras?.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras!.first,
    );
    if (frontCamera != null) {
      _cameraController =
          CameraController(frontCamera, ResolutionPreset.medium);
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _onClockInPressed(AttendanceReady state) async {
    // Bagian 1: Penanganan Error yang Lebih Spesifik
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Kamera belum siap.")));
      return;
    }
    // Mencegah double-tap saat proses sedang berjalan
    if (context.read<AttendanceBloc>().state is AttendanceSubmitting) return;

    try {
      final image = await _cameraController!.takePicture();
      context.read<AttendanceBloc>().add(ClockInButtonPressed(photo: image));
    } on CameraException catch (e) {
      // Menangani error dari kamera dengan pesan yang lebih jelas
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Gagal kamera: ${e.description ?? 'Terjadi error'}"),
          backgroundColor: Colors.orange));
    } catch (e) {
      // Menangani error umum lainnya
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Terjadi kesalahan tidak terduga: $e"),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        // Bagian 2: Listener dengan Feedback yang Lebih Lengkap
        listener: (context, state) {
          // Sembunyikan snackbar sebelumnya untuk pesan baru
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (state is AttendanceSubmitting) {
            // Beri tahu pengguna bahwa data sedang dikirim
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Mengirim data absensi..."),
                  duration: Duration(seconds: 10)),
            );
          } else if (state is AttendanceSuccess) {
            // Feedback untuk keberhasilan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.green),
            );
            // Otomatis refresh data halaman setelah absensi berhasil
            context.read<AttendanceBloc>().add(FetchAttendanceData());
          } else if (state is AttendanceFailure) {
            // Feedback untuk kegagalan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is AttendanceInitial || state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AttendanceReady) {
            // Termasuk state 'AttendanceSubmitting' yang mungkin mewarisi dari 'AttendanceReady'
            return _buildReadyStateUI(state,
                isSubmitting: state is AttendanceSubmitting);
          }
          if (state is AttendanceFailure) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text("Gagal memuat data: ${state.message}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () => context
                          .read<AttendanceBloc>()
                          .add(FetchAttendanceData()),
                      child: const Text("Coba Lagi"))
                ]));
          }
          return const Center(
              child: Text("Gagal memuat data. Silakan coba lagi."));
        },
      ),
    );
  }

  Widget _buildReadyStateUI(AttendanceReady state,
      {bool isSubmitting = false}) {
    return Stack(
      children: [
        // Google Map View
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(target: state.officeLocation, zoom: 16),
          onMapCreated: (GoogleMapController controller) =>
              _mapController.complete(controller),
          markers: {
            Marker(
                markerId: const MarkerId('office'),
                position: state.officeLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
                infoWindow: const InfoWindow(title: 'Lokasi Kantor')),
            Marker(
                markerId: const MarkerId('user'),
                position: state.userLocation,
                infoWindow: const InfoWindow(title: 'Lokasi Anda')),
          },
          circles: {
            Circle(
                circleId: const CircleId('radius'),
                center: state.officeLocation,
                radius: state.officeRadius,
                strokeColor: Colors.red,
                fillColor: Colors.red.withOpacity(0.2),
                strokeWidth: 2),
          },
        ),
        // Camera Preview
        Positioned(
          top: 40,
          right: 16,
          child: Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (_cameraController != null &&
                      _cameraController!.value.isInitialized)
                  ? CameraPreview(_cameraController!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        // Back Button
        Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop()))),
        // Info Card
        DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.45,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24))),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16.0),
                children: [
                  // User Info
                  Text(widget.user.fullName.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(height: 24),
                  _buildInfoRow('Tanggal', state.todayDate),
                  _buildInfoRow('Waktu Server', state.serverTime),
                  _buildInfoRow('Jam Kerja', state.workSchedule),
                  _buildInfoRow('Akurasi GPS',
                      '${state.gpsAccuracy.toStringAsFixed(0)} meter'),
                  _buildInfoRow(
                      'Keterangan',
                      state.isInRadius
                          ? 'Di dalam radius kantor'
                          : 'Di luar radius kantor',
                      color: state.isInRadius ? Colors.green : Colors.red),
                  const SizedBox(height: 20),
                  // Attendance Info
                  if (state.clockInTime != null) ...[
                    _buildAttendanceDetail('Masuk WFO', state.clockInTime!,
                        'Terlambat', state.lateDuration),
                    const SizedBox(height: 16),
                  ],
                  if (state.clockOutTime != null) ...[
                    _buildAttendanceDetail('Pulang WFO', state.clockOutTime!,
                        'Mendahului', state.earlyLeaveDuration),
                  ],
                  const SizedBox(height: 20),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: const Text('MASUK'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                          onPressed: (state.canClockIn && !isSubmitting)
                              ? () => _onClockInPressed(state)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text('PULANG'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                          onPressed: (state.canClockOut && !isSubmitting)
                              ? () => context
                                  .read<AttendanceBloc>()
                                  .add(ClockOutButtonPressed())
                              : null,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildAttendanceDetail(
      String title, String time, String durationLabel, String duration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(time,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text('$durationLabel: $duration',
                style: const TextStyle(color: Colors.red)),
          ],
        )
      ],
    );
  }
}
