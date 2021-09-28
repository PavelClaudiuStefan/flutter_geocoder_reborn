package com.pavelclaudiustefan.flutter_geocoder_reborn

import android.location.Address
import android.location.Geocoder
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.IOException

internal class NotAvailableException : Exception()

/** FlutterGeocoderRebornPlugin */
class FlutterGeocoderRebornPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel

  private lateinit var geocoder: Geocoder

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_geocoder_reborn")
    channel.setMethodCallHandler(this)

    geocoder = Geocoder(flutterPluginBinding.applicationContext)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "getPlatformVersion" -> {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }

        "findAddressesFromQuery" -> {
          val address = call.argument("address") as String?
          findAddressesFromQuery(address, result)
        }

        "findAddressesFromCoordinates" -> {
          val latitude: Double? = (call.argument("latitude") as Number?)?.toDouble()
          val longitude: Double? = (call.argument("longitude") as Number?)?.toDouble()
          findAddressesFromCoordinates(latitude, longitude, result)
        }

        else -> {
          result.notImplemented()
        }
    }
  }

//  private fun assertPresent() {
//    if (!this.geocoder.isPresent()) {
//      throw NotAvailableException()
//    }
//  }

  private fun findAddressesFromQuery(address: String?, result: Result) {

    if (address == null) {
      result.error("input_error", "address is null", null)
      return
    }

    try {
//      assertPresent()
      val addresses = geocoder.getFromLocationName(address, 20)

      if (addresses != null) {
        if (addresses.isEmpty()) {
          result.error("not_available", "Empty", null)
        }
        else {
          result.success(createAddressMapList(addresses))
        }
      } else {
        result.error("failed", "Failed", null)
      }

    } catch (ex: IOException) {
      result.error("failed", "Failed", null)
    } catch (ex: NotAvailableException) {
      result.error("not_available", "Empty", null)
    } catch (ex: java.lang.Exception) {
      result.error("unknown_exception", ex.toString(), null)
    }
  }

  private fun findAddressesFromCoordinates(latitude: Double?, longitude: Double?, result: Result) {

    if (latitude == null) {
      result.error("input_error", "latitude is null", null)
      return
    }

    if (longitude == null) {
      result.error("input_error", "longitude is null", null)
      return
    }

    try {
//      assertPresent()
      val addresses = geocoder.getFromLocation(latitude, longitude, 20)

      if (addresses != null) {
        if (addresses.isEmpty()) {
          result.error("not_available", "Empty", null)
        }
        else {
          result.success(createAddressMapList(addresses))
        }
      } else {
        result.error("failed", "Failed", null)
      }

    } catch (ex: IOException) {
      result.error("failed", "Failed", null)
    } catch (ex: NotAvailableException) {
      result.error("not_available", "Empty", null)
    } catch (ex: java.lang.Exception) {
      result.error("unknown_exception", ex.toString(), null)
    }
  }

  private fun createCoordinatesMap(address: Address?): Map<String, Any>? {
    if (address == null) return null
    val result = mutableMapOf<String, Any>()
    result["latitude"] = address.latitude
    result["longitude"] = address.longitude
    return result
  }

  private fun createAddressMap(address: Address?): Map<String, Any?>? {
    if (address == null) return null

    // Creating formatted address
    val sb = StringBuilder()
    for (i in 0..address.maxAddressLineIndex) {
      if (i > 0) {
        sb.append(", ")
      }
      sb.append(address.getAddressLine(i))
    }
    val result = mutableMapOf<String, Any?>()
    result["coordinates"] = createCoordinatesMap(address)
    result["featureName"] = address.featureName
    result["countryName"] = address.countryName
    result["countryCode"] = address.countryCode
    result["locality"] = address.locality
    result["subLocality"] = address.subLocality
    result["thoroughfare"] = address.thoroughfare
    result["subThoroughfare"] = address.subThoroughfare
    result["adminArea"] = address.adminArea
    result["subAdminArea"] = address.subAdminArea
    result["addressLine"] = sb.toString()
    result["postalCode"] = address.postalCode
    return result
  }

  private fun createAddressMapList(addresses: List<Address?>?): List<Map<String, Any?>?> {
    if (addresses == null) return ArrayList()

    val result: List<Map<String, Any?>?> = addresses.map {
      createAddressMap(it)
    }

    return result
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
