import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

// ===================================================================
// 1. KELAS PROVIDER KHUSUS UNTUK HALAMAN PETA
// ===================================================================
class PickLocationProvider extends ChangeNotifier {
  LatLng? selectedLocation;
  String? address;
  bool isLoadingAddress = false;

  Future<void> setLocationAndGetAddress(LatLng position, String notFoundText) async {
    selectedLocation = position;
    isLoadingAddress = true;
    address = null;
    notifyListeners();

    try {
      final placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address = '${place.street}, ${place.subLocality}, ${place.locality}';
      }
    } catch (e) {
      address = notFoundText;
    } finally {
      isLoadingAddress = false;
      notifyListeners();
    }
  }
}

// ===================================================================
// 2. KELAS UTAMA (BUNGKUSAN PROVIDER LOKAL)
// ===================================================================
class PickLocationScreen extends StatelessWidget {
  const PickLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus layar dengan Provider yang akan langsung hancur saat layar ditutup
    return ChangeNotifierProvider(
      create: (context) => PickLocationProvider(),
      child: const _PickLocationView(),
    );
  }
}

// ===================================================================
// 3. TAMPILAN UI (100% STATELESS WIDGET)
// ===================================================================
class _PickLocationView extends StatelessWidget {
  const _PickLocationView();

  final LatLng _initialPosition = const LatLng(-6.175392, 106.827153);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pickLocationTitle),
      ),
      // Menggunakan Consumer untuk mendengarkan perubahan dari PickLocationProvider
      body: Consumer<PickLocationProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onTap: (LatLng latLng) {
                  // Memanggil fungsi dari Provider
                  provider.setLocationAndGetAddress(
                    latLng,
                    AppLocalizations.of(context)!.addressNotFound,
                  );
                },
                markers: provider.selectedLocation == null
                    ? {}
                    : {
                  Marker(
                    markerId: const MarkerId('selected_location'),
                    position: provider.selectedLocation!,
                    infoWindow: InfoWindow(
                      title: AppLocalizations.of(context)!.selectedLocation,
                      snippet: provider.address ?? AppLocalizations.of(context)!.loadingAddress,
                    ),
                  ),
                },
              ),
              if (provider.selectedLocation != null)
                Positioned(
                  bottom: 32,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, color: Colors.red, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.addressText,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 4),
                          provider.isLoadingAddress
                              ? const LinearProgressIndicator()
                              : Text(
                            provider.address ?? AppLocalizations.of(context)!.addressUnknown,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: provider.isLoadingAddress
                                  ? null
                                  : () {
                                // Kembalikan data ke halaman Add Story
                                context.pop(provider.selectedLocation);
                              },
                              child: Text(AppLocalizations.of(context)!.useThisLocation),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}