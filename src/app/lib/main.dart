import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_iot/wifi_iot.dart';
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

  void _createHotspot(String _ssid) async {
    try {
      await Wifi.createHotspot(
        ssid: _ssid,
        password: "abc123",
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hotspot created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create hotspot: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Networks List')),
      body: _networks.isEmpty
          ? Center(child: ElevatedButton(
                onPressed: _fetchNetworks,
                child: Text('Fetch networks'),
              ))
          : ListView.builder(
              itemCount: _networks.length,
              itemBuilder: (context, index) => ElevatedButton(
                onPressed: () => await _createHotspot(_networks[index].ssid),
                child: Text('Create Hotspot' + _networks[index].ssid),
              ),
          )
    );
  }
}
