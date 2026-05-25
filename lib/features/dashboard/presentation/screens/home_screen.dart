import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

import '../../../../core/services/sms_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  final SmsService smsService = SmsService();

  List<SmsMessage> messages = [];

@override
void initState() {
  super.initState();
  loadMessage();
}  

Future<void> loadMessage() async {
  bool? permissionGranted =
      await smsService.requestPermission();

  if (permissionGranted == true) {
    List<SmsMessage> smsList =
        await smsService.getInboxMessages();

    setState(() {
      messages = smsList;
    });
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Smart Split"),
    ),
    body: ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            messages[index].address ?? "Unknown",
          ),
          subtitle: Text(
            messages[index].body ?? "",
          ),
        );
      },
    ),
  );
}

}