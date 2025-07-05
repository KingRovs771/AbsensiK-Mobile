import 'dart:async';

import 'package:absensi_alma/domain/entities/user_entity.dart';
import 'package:absensi_alma/injection_container.dart';
import 'package:absensi_alma/presentation/attendaces/bloc/attendance_bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatelessWidget {
  final UserEntity user;
  const AttendancePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Menyediakan BLoC dan langsung mengambil data awal saat halaman dibuka
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
  // Controllers untuk kamera dan peta
  CameraController? _cameraController;
  final Completer<GoogleMapController> _mapController = Completer();
  List<CameraDescription>? _cameras;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeCameraAndTimer();
  }

  Future<void> _initializeCameraAndTimer() async {
    // Inisialisasi Kamera depan
    try {
      _cameras = await availableCameras();
      final frontCamera = _cameras?.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );
      if (frontCamera != null) {
        _cameraController = CameraController(
            frontCamera, ResolutionPreset.medium,
            enableAudio: false);
        await _cameraController!.initialize();
      }
    } catch (e) {
      // Handle error jika kamera gagal diinisialisasi
    }

    // Timer untuk update waktu server di UI setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Mengirim event ke BLoC untuk memperbarui waktu
        context.read<AttendanceBloc>().add(UpdateServerTime());
      }
    });

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // Fungsi yang dipanggil saat tombol "MASUK" ditekan
  void _onClockInPressed() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Kamera belum siap.")));
      return;
    }
    if (context.read<AttendanceBloc>().state is AttendanceSubmitting) return;

    try {
      final image = await _cameraController!.takePicture();
      // Mengirim event ke BLoC dengan membawa data foto
      context.read<AttendanceBloc>().add(ClockInButtonPressed(photo: image));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal mengambil foto: $e")));
    }
  }

  // Fungsi yang dipanggil saat tombol "PULANG" ditekan
  void _onClockOutPressed() {
    if (context.read<AttendanceBloc>().state is AttendanceSubmitting) return;
    // Mengirim event ke BLoC
    context.read<AttendanceBloc>().add(ClockOutButtonPressed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        // Listener untuk menampilkan feedback seperti Snackbar
        listener: (context, state) {
          if (state is AttendanceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message), backgroundColor: Colors.green));
          } else if (state is AttendanceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        // Builder untuk membangun UI berdasarkan state
        builder: (context, state) {
          if (state is AttendanceLoading || state is AttendanceInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AttendanceReady) {
            // Jika data siap, bangun UI utama
            return _buildReadyStateUI(state);
          }
          if (state is AttendanceFailure) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text("Gagal memuat data: ${state.message}"),
                  ElevatedButton(
                      onPressed: () => context
                          .read<AttendanceBloc>()
                          .add(FetchAttendanceData()),
                      child: const Text("Coba Lagi"))
                ]));
          }
          return const Center(child: Text("Terjadi kesalahan tidak terduga."));
        },
      ),
    );
  }

  // Widget untuk membangun UI utama saat state adalah AttendanceReady
  Widget _buildReadyStateUI(AttendanceReady state) {
    final bool isSubmitting = state is AttendanceSubmitting;

    return Stack(
      children: [
        // Bagian Peta
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(target: state.data.officeLocation, zoom: 17),
          onMapCreated: (controller) => _mapController.complete(controller),
          markers: {
            Marker(
                markerId: const MarkerId('office'),
                position: state.data.officeLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                infoWindow: const InfoWindow(title: 'Lokasi Kantor')),
            if (state.data.userLocation != null)
              Marker(
                  markerId: const MarkerId('user'),
                  position: state.data.userLocation!,
                  infoWindow: const InfoWindow(title: 'Lokasi Anda')),
          },
          circles: {
            Circle(
                circleId: const CircleId('radius'),
                center: state.data.officeLocation,
                radius: state.data.officeRadius,
                strokeColor: Colors.red,
                fillColor: Colors.red.withOpacity(0.2),
                strokeWidth: 1),
          },
        ),
        // Pratinjau Kamera
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
                        : const Center(child: CircularProgressIndicator())))),
        // Tombol Kembali
        Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop()))),

        // Kartu Informasi yang bisa di-scroll
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
                  // Data pengguna dan absensi diambil dari 'state.data'
                  Text(widget.user.fullName.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(height: 24),
                  _buildInfoRow(
                      'Tanggal',
                      DateFormat('EEEE, dd MMM yyyy', 'id_ID')
                          .format(DateTime.now())),
                  _buildInfoRow('Waktu Server', state.serverTime),
                  _buildInfoRow('Jam Kerja', state.data.workSchedule),
                  _buildInfoRow('Akurasi GPS',
                      '${state.data.gpsAccuracy?.toStringAsFixed(0) ?? '-'} meter'),
                  _buildInfoRow(
                      'Keterangan',
                      state.data.isInRadius
                          ? 'Di dalam radius kantor'
                          : 'Di luar radius kantor',
                      color: state.data.isInRadius ? Colors.green : Colors.red),
                  const SizedBox(height: 20),
                  if (state.data.clockInTime != null)
                    _buildAttendanceDetail('Masuk WFO', state.data.clockInTime!,
                        'Terlambat', state.data.lateDuration),
                  if (state.data.clockOutTime != null) ...[
                    const SizedBox(height: 16),
                    _buildAttendanceDetail(
                        'Pulang WFO',
                        state.data.clockOutTime!,
                        'Mendahului',
                        state.data.earlyLeaveDuration)
                  ],
                  const SizedBox(height: 20),

                  // Tombol Aksi
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
                              onPressed:
                                  (state.data.canClockIn && !isSubmitting)
                                      ? _onClockInPressed
                                      : null)),
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
                              onPressed:
                                  (state.data.canClockOut && !isSubmitting)
                                      ? () => ClockOutButtonPressed()
                                      : null)),
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

  // Helper widget untuk baris info
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

  // Helper widget untuk detail absensi (masuk/pulang)
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
