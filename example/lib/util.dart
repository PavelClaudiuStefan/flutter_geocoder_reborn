import 'package:flutter/material.dart';
import 'package:flutter_geocoder_reborn/flutter_geocoder_reborn.dart';

class Utils {
  static Future<void> showAddresses(
      BuildContext context, String title, List<Address> addresses) async {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Text(title,
                          style: Theme.of(context).textTheme.headlineLarge)),
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: addresses
                            .asMap()
                            .entries
                            .map((entry) => buildAddressItem(context, entry))
                            .toList()),
                  ),
                ),
              ],
            ));
  }

  static Widget buildAddressItem(
      BuildContext context, MapEntry<int, Address> addressEntry) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Address #${addressEntry.key}",
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: addressEntry.value
                .toMap()
                .entries
                .map((e) => Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.key),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.value.toString(),
                                textAlign: TextAlign.end),
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
        Divider(thickness: 4.0),
      ],
    );
  }
}
