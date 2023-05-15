import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';

RxList<SmsMessage?> messageList = <SmsMessage?>[].obs;
RxMap<String, List<SmsMessage>> mapMessageList = <String, List<SmsMessage>>{}.obs;