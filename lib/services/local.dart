import 'dart:async';

import 'package:flutter/services.dart';

import '../model.dart';
import '../services/base.dart';

/// Geocoding and reverse geocoding through built-in local platform services.
class LocalGeocoding implements Geocoding {
  static const MethodChannel _channel = MethodChannel('flutter_geocoder_reborn');

  Future<List<Address>> findAddressesFromCoordinates(Coordinates coordinates) async {
    Iterable addresses = await _channel.invokeMethod('findAddressesFromCoordinates', coordinates.toMap());
    return addresses.map((x) => Address.fromMap(x)).toList();
  }

  Future<List<Address>> findAddressesFromQuery(String address) async {
    if (address.isEmpty) {
      return [];
    }

    Iterable coordinates = await _channel.invokeMethod('findAddressesFromQuery', {"address": address});
    return coordinates.map((x) => Address.fromMap(x)).toList();
  }
}
