import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: NetworkListScreen());
}

class NetworkListScreen extends StatefulWidget {
  @override
  _NetworkListScreenState createState() => _NetworkListScreenState();
}

class _NetworkListScreenState extends State<NetworkListScreen> {
  List<WifiResult> _networks = [];

  @override
  void initState() {
    super.initState();
    _fetchNetworks();
  }

  Future<void> _fetchNetworks() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      List<WifiResult> networks = await Wifi.list('');
      setState(() { _networks = networks; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Networks List')),
      body: _networks.isEmpty
          ? Center(child: Text("none"))
          : ListView.builder(
              itemCount: _networks.length,
              itemBuilder: (context, index) => ListTile(title: Text(_networks[index].ssid))
            ),
    );
  }
}
