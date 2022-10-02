import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  List<ScanResult> scanResultList = [];

  bool _isScanning = false;

  @override
  initState() {
    super.initState();
    initBle();
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  scan() async {
    if (!_isScanning) {
      scanResultList.clear();

      flutterBlue.startScan(timeout: Duration(seconds: 4));

      flutterBlue.scanResults.listen((results) {
        scanResultList = results;

        setState(() {});
      });
    } else {
      flutterBlue.stopScan();
    }
  }

  Widget listItem(ScanResult r) {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.bluetooth)),
      title: Text(r.device.name.isNotEmpty ? r.device.name : "Not Visible"),
      subtitle: Text(r.device.id.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BLE Scan"),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: scanResultList.length,
          itemBuilder: (context, index) {
            return listItem(scanResultList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}
