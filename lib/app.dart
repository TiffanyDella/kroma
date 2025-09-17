import 'package:flutter/material.dart';

class KromaHome extends StatefulWidget{
  @override
  _KromaHomeState createState() => _KromaHomeState();
}

class _KromaHomeState extends State<KromaHome> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text('Kroma Home'),
      ),
      body: Center(
        child: Text('Welcome to Kroma Home'),
      ),
    );
  }
}