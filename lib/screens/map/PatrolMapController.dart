import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:patrullaje_serenazgo_cusco/utils/MapStyle.dart';

class HomeController {
  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
  }
}
