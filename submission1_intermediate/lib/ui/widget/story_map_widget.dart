import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../../l10n/app_localizations.dart';

class StoryMapWidget extends StatelessWidget {
  final double lat;
  final double lon;
  final String storyName;

  const StoryMapWidget({
    super.key,
    required this.lat,
    required this.lon,
    required this.storyName,
  });

  Future<String> _getAddress(BuildContext context) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.subLocality}, ${place.locality}';
      }
      return AppLocalizations.of(context)!.addressUnknown;
    } catch (e) {
      return AppLocalizations.of(context)!.addressNotFound;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.storyLocation,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FutureBuilder<String>(
                future: _getAddress(context),
                builder: (context, snapshot) {
                  final addressSnippet = snapshot.connectionState == ConnectionState.waiting
                      ? AppLocalizations.of(context)!.loadingAddress
                      : (snapshot.data ?? AppLocalizations.of(context)!.addressNotAvailable);

                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat, lon),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('story_location'),
                        position: LatLng(lat, lon),
                        infoWindow: InfoWindow(
                          title: storyName,
                          snippet: addressSnippet,
                        ),
                      ),
                    },
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}