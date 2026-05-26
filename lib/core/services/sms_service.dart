import 'package:telephony_fix/telephony.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;

  Future<bool?> requestPermission() async {
    return await telephony.requestPhoneAndSmsPermissions;
  }

  Future<List<SmsMessage>> getInboxMessages() async {
    return await telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );
  }
}