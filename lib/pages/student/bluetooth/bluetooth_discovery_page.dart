import 'dart:async';
import 'package:education_systems_mobile/bloc/student_sections/student_sections_bloc.dart';
import 'package:education_systems_mobile/core/http/response.dart';
import 'package:education_systems_mobile/core/security/auth_provider.dart';
import 'package:education_systems_mobile/core/security/base_auth.dart';
import 'package:education_systems_mobile/data/auth/user.dart';
import 'package:education_systems_mobile/data/lesson/lesson_sections_response.dart';
import 'package:education_systems_mobile/data/lesson/section_request.dart';
import 'package:education_systems_mobile/data/lesson/user_lesson_map_request.dart';
import 'package:education_systems_mobile/pages/student/bluetooth/bluetooth_device_list_entry.dart';
import 'package:education_systems_mobile/pages/student/student_lesson_sections_page.dart';
import 'package:education_systems_mobile/pages/widget/home_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BluetoothDiscoveryPage extends StatefulWidget {
  BluetoothDiscoveryPage({Key key, this.userLessonMapId, this.professorId, this.start = true, this.lessonCode})
      : super(key: key);
  final String routeName = "/bluetooth_discovery";
  final int userLessonMapId;
  final int professorId;
  final bool start;
  final String lessonCode;

  @override
  _BluetoothDiscoveryPageState createState() => _BluetoothDiscoveryPageState();
}

class _BluetoothDiscoveryPageState extends State<BluetoothDiscoveryPage> {
  BaseUser _user;
  User currentProfessor;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;
  FToast fToast;

  _BluetoothDiscoveryPageState();

  @override
  void initState() {
    super.initState();
    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
    fToast = FToast();
    fToast.init(context);
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0)
          results[existingIndex] = r;
        else
          results.add(r);
      });
    });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    AuthProvider.of(context).auth.currentUser().then((user) {
      setState(() {
        _user = user;
      });
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();
    super.dispose();
  }
  Future<void> _getUser(BuildContext buildContext, int userId) async{
    var auth = AuthProvider.of(context).auth;
    Response response = await auth.getUser(userId);
    if (response.success && response.result != null) {
      setState(() {
        currentProfessor = response.result;
      });
    }
  }

  Future<void> _updateAttendance(BuildContext buildContext) async{

    buildContext.read<StudentSectionsBloc>().repository.updateStudentAttendance(new UserLessonMapRequest(
        statusType: 2,
        userLessonMapId: widget.userLessonMapId
    )).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentLessonSectionsPage(
        sectionRequest: SectionRequest(
            userId: _user.id,
            lessonCode: widget.lessonCode
        ),
      )));
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: isDiscovering
            ? Text(
                'Discovering devices',
                style: TextStyle(color: Colors.white),
              )
            : Text(
                'Discovered devices',
                style: TextStyle(color: Colors.white),
              ),
        actions: <Widget>[
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: _dataWidget(context),
      bottomNavigationBar: HomeBottomNavigationBar(),
    );
  }

  _dataWidget(BuildContext buildContext) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, index) {
        BluetoothDiscoveryResult result = results[index];
        final device = result.device;
        final address = device.address;
        return BluetoothDeviceListEntry(
          device: device,
          rssi: result.rssi,
          onTap: () {
            Navigator.of(context).pop(result.device);
          },
          onLongPress: () async {
            _getUser(buildContext,widget.professorId).then((value)async{
              // if(currentProfessor.localAddress == device.address) {
                try {
                  bool bonded = false;
                  if (device.isBonded) {
                    print('Unbonding from ${device.address}...');
                    await FlutterBluetoothSerial.instance
                        .removeDeviceBondWithAddress(address);
                    print('Unbonding from ${device.address} has succed');
                  } else {
                    print('Bonding with ${device.address}...');
                    bonded = (await FlutterBluetoothSerial.instance
                        .bondDeviceAtAddress(address));
                    print(
                        'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                  }
                  if(mounted){
                    setState(() {
                      results[results.indexOf(result)] = BluetoothDiscoveryResult(
                          device: BluetoothDevice(
                            name: device.name ?? '',
                            address: address,
                            type: device.type,
                            bondState: bonded
                                ? BluetoothBondState.bonded
                                : BluetoothBondState.none,
                          ),
                          rssi: result.rssi);
                      _updateAttendance(buildContext);
                    });
                  }
                } catch (ex) {
                  showDialog(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return AlertDialog(
                        title: const Text('Error occured while bonding'),
                        content: Text("${ex.toString()}"),
                        actions: <Widget>[
                          new TextButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(buildContext).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              // }
              // else{
              //   fToast.showToast(
              //     child: toast,
              //     toastDuration: Duration(seconds: 3),
              //     fadeDuration: 2000,
              //   );
              // }
            });

          },
        );
      },
    );
  }
}

Widget toast = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Colors.red,
  ),
  child: Text("Sadece dersin hocasının cihazına bağlanabilirsiniz!", style: TextStyle(color: Colors.white),),
);
