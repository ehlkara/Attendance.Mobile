

import 'dart:async';
import 'package:education_systems_mobile/bloc/professor_sections/professor_sections_bloc.dart';
import 'package:education_systems_mobile/data/auth/local_address_request.dart';
import 'package:education_systems_mobile/pages/professor/professor_lesson_attendance_list_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:education_systems_mobile/core/security/auth_provider.dart';
import 'package:education_systems_mobile/core/security/base_auth.dart';
import 'package:education_systems_mobile/pages/student/bluetooth/bluetooth_discovery_page.dart';
import 'package:education_systems_mobile/pages/constants.dart';
import 'package:education_systems_mobile/pages/widget/home_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfessorBluetoothMainPage extends StatefulWidget {
  ProfessorBluetoothMainPage({Key key, this.lessonId,this.lessonName, this.isActive}) : super(key: key);
  final String routeName = "/bluetooth_main";
  final int lessonId;
  final String lessonName;
  final bool isActive;

  @override
  _ProfessorBluetoothMainPageState createState() => _ProfessorBluetoothMainPageState();
}

class _ProfessorBluetoothMainPageState extends State<ProfessorBluetoothMainPage> {
  BaseUser _user;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";
  int _lessonId;
  String _lessonName;
  bool _isActive;

  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;
  bool _autoAcceptPairingRequests = false;
  @override
  void initState() {
    super.initState();
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        if(mounted)
          {
            setState(() {
              _address = address;
              context.read<ProfessorSectionsBloc>().repository.updateLocalAddress(new LocalAddressRequest(
                  userId: _user.id,
                  localAddress: _address
              ));
            });
          }
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void didChangeDependencies() {
    _lessonId = widget.lessonId;
    _lessonName = widget.lessonName;
    _isActive = widget.isActive;
    AuthProvider.of(context).auth.currentUser().then((user) {
      setState(() {
        _user = user;
      });
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Attandance',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16
          ),),
        actions: [
          Column(
            children: [
              SizedBox(height: 10,),
              Row(
                children: [
                  Text(_user == null ? '' : _user.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),),
                  SizedBox(
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.userCircle,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      body: _dataWidget(context),
      bottomNavigationBar: HomeBottomNavigationBar(),
    );
  }
  _dataWidget(BuildContext buildContext) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text(
              "Öğrencilerin derse katılabilmesi için lütfen bluetoothunuzu açınız!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16),
            ),
            SwitchListTile(
              title: const Text('Enable Bluetooth'),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value){
                    await FlutterBluetoothSerial.instance.requestEnable().then((value){
                      buildContext.read<ProfessorSectionsBloc>().repository.updateLocalAddress(new LocalAddressRequest(
                        userId: _user.id,
                        localAddress: _address
                      ));
                    });
                  }

                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              title: const Text('Bluetooth status'),
              subtitle: Text(_bluetoothState.toString()),
              trailing: ElevatedButton(
                child: const Text('Settings'),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
            ListTile(
              title: const Text('Local adapter address'),
              subtitle: Text(_address),
            ),
            ListTile(
              title: const Text('Local adapter name'),
              subtitle: Text(_name),
              onLongPress: null,
            ),

            ListTile(
              title: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Finish Lesson', style: TextStyle(fontSize: 16),),
                  onPressed: () async {
                    context.read<ProfessorSectionsBloc>().repository.finishLesson(_lessonId).then((value){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessorLessonAttendanceListPage(
                        lessonId: _lessonId,
                        lessonName: _lessonName,
                        lessonIsActive: _isActive = false
                      )));
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }


}