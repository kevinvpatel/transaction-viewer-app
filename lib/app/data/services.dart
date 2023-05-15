import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';

class SMSServices {
  static final SmsQuery query = SmsQuery();

  static Future<List<SmsMessage>> getSmsData({String? address, RxDouble? percentage}) async {
    return await query.querySms(
        kinds: [SmsQueryKind.inbox],
        address: address
    );
  }

}