import Flutter
import UIKit
import CoreLocation

public class SwiftFlutterGeocoderRebornPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_geocoder_reborn", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterGeocoderRebornPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion": result("iOS " + UIDevice.current.systemVersion)
        case "findAddressesFromCoordinates": self._findAddressesFromCoordinates(call, result)
        case "findAddressesFromQuery": self._findAddressesFromQuery(call, result)
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    var geocoder: CLGeocoder?
    
    private func _findAddressesFromCoordinates(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arguments = call.arguments,
              let args = arguments as? [String: Any] else { return }
        
        let lat = args["latitude"] as? Double
        let lng = args["longitude"] as? Double
        
        if (lat == nil || lng == nil) {
            result(FlutterError(code: "LatLngError", message: "Latitude and longitude cannot be null", details: nil))
        }
        
        let location = CLLocation(latitude: lat!, longitude: lng!)
        self.initializeGeocoder()
        self.geocoder!.reverseGeocodeLocation(location) { placemarks, error in
            if (error != nil) {
                result(FlutterError(code: "ReverseGeocodeError", message: "\(error!)", details: nil))
            }
            
            result(self.placemarksToDictionary(placemarks))
        }
    }
    
    private func _findAddressesFromQuery(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arguments = call.arguments,
              let args = arguments as? [String: Any] else { return }
        
        let address: String? = args["address"] as? String
        
        if (address == nil) {
            result(FlutterError(code: "AddressError", message: "Address cannot be null", details: nil))
        }
        
        self.initializeGeocoder()
        self.geocoder!.geocodeAddressString(address!, completionHandler: { placemarks, error in
            if (error != nil) {
                result(FlutterError(code: "GeocodeAddressError", message: "\(error!)", details: nil))
            }
            
            result(self.placemarksToDictionary(placemarks))
        })
    }

    private func initializeGeocoder() {
        if (geocoder == nil) {
            geocoder = CLGeocoder()
        }
        
        if (geocoder!.isGeocoding) {
            geocoder!.cancelGeocode()
        }
    }

    private func placemarksToDictionary(_ placemarks: [CLPlacemark]?) -> [[String: Any?]] {
        var results = [[String: Any?]]()
        
        if (placemarks == nil) {
            return results
        }
        
        placemarks?.forEach({ placemark in
            var coordinates: [String: Double?]? = [:]

            if(placemark.location != nil) {
                coordinates = [
                    "latitude": placemark.location?.coordinate.latitude,
                    "longitude": placemark.location?.coordinate.longitude,
                ]
            }

            let address: [String: Any?] = [
                "coordinates": coordinates,
                "featureName": placemark.name,
                "countryName": placemark.country,
                "countryCode": placemark.isoCountryCode,
                "locality": placemark.locality,
                "subLocality": placemark.subLocality,
                "thoroughfare": placemark.thoroughfare,
                "subThoroughfare": placemark.subThoroughfare,
                "postalCode": placemark.postalCode,
                "adminArea": placemark.administrativeArea,
                "subAdminArea": placemark.subAdministrativeArea,
                "addressLine": "\(placemark.subThoroughfare ?? ""), \(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
            ]
            
            results.append(address)
        })

        return results
    }
}



