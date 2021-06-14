import 'package:flutter/material.dart';
import 'package:flutter_geocoder_reborn/flutter_geocoder_reborn.dart';
import 'package:flutter_geocoder_reborn_example/util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildAppBar(),
          body: buildBody(),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Geocoder'),
      bottom: TabBar(
        tabs: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Query"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Coordinates"),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return TabBarView(
        children: [
          buildQuerySearchView(),
          buildCoordinatesInputView()
        ]
    );
  }

  Widget buildQuerySearchView() {
    return QuerySearchView();
  }

  Widget buildCoordinatesInputView() {
    return CoordinatesSearchView();
  }
}

class QuerySearchView extends StatefulWidget {
  const QuerySearchView({Key? key}) : super(key: key);

  @override
  _QuerySearchViewState createState() => _QuerySearchViewState();
}

class _QuerySearchViewState extends State<QuerySearchView> {

  final TextEditingController _queryEditingController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _queryEditingController,
            decoration: new InputDecoration(hintText: "Query..."),
          ),
          SizedBox(height: 24.0),
          OutlinedButton(
              child: Text(isLoading ? "Searching..." : "Search location"),
              onPressed: isLoading ? null : () async {
                setState(() {
                  isLoading = true;
                });

                final String query = _queryEditingController.value.text;

                try {
                  List<Address> addresses = await FlutterGeocoderReborn.local.findAddressesFromQuery(query);

                  Utils.showAddresses(context, query, addresses);
                } catch (e) {
                  print('ERROR (buildQueryInputView) > ${e.toString()}');
                }

                setState(() {
                  isLoading = false;
                });
              }
          )
        ],
      ),
    );
  }
}

class CoordinatesSearchView extends StatefulWidget {
  const CoordinatesSearchView({Key? key}) : super(key: key);

  @override
  _CoordinatesSearchViewState createState() => _CoordinatesSearchViewState();
}

class _CoordinatesSearchViewState extends State<CoordinatesSearchView> {

  final TextEditingController _latEditingController = TextEditingController();
  final TextEditingController _lngEditingController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _latEditingController,
            decoration: new InputDecoration(hintText: "Latitude..."),
          ),
          TextField(
            controller: _lngEditingController,
            decoration: new InputDecoration(hintText: "Longitude..."),
          ),
          SizedBox(height: 24.0),
          OutlinedButton(
              child: Text(isLoading ? "Searching..." : "Search location"),
              onPressed: isLoading ? null : () async {
                setState(() {
                  isLoading = true;
                });

                final String latStr = _latEditingController.value.text;
                final String lngStr = _lngEditingController.value.text;

                final double lat = double.tryParse(latStr) ?? 0;
                final double lng = double.tryParse(lngStr) ?? 0;

                try {
                  List<Address> addresses = await FlutterGeocoderReborn.local.findAddressesFromCoordinates(Coordinates(lat, lng));

                  Utils.showAddresses(context, '$lat, $lng', addresses);
                } catch (e) {
                  print('ERROR (buildQueryInputView) > ${e.toString()}');
                }

                setState(() {
                  isLoading = false;
                });
              }
          )
        ],
      ),
    );
  }
}

