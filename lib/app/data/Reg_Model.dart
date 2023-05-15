class Reg {
  String? blacklistRegex;
  String? minAppVersion;
  List<Rules>? rules;
  String? version;

  Reg({this.blacklistRegex, this.minAppVersion, this.rules, this.version});

  Reg.fromJson(Map<String, dynamic> json) {
    blacklistRegex = json['blacklist_regex'];
    minAppVersion = json['min_app_version'];
    if (json['rules'] != null) {
      rules = <Rules>[];
      json['rules'].forEach((v) {
        rules!.add(Rules.fromJson(v));
      });
    }
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blacklist_regex'] = blacklistRegex;
    data['min_app_version'] = minAppVersion;
    if (rules != null) {
      data['rules'] = rules!.map((v) => v.toJson()).toList();
    }
    data['version'] = version;
    return data;
  }
}

class Rules {
  String? fullName;
  String? name;
  List<Patterns>? patterns;
  String? senderUID;
  List<String>? senders;

  Rules({this.fullName, this.name, this.patterns, this.senderUID, this.senders});

  Rules.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    name = json['name'];
    if (json['patterns'] != null) {
      patterns = <Patterns>[];
      json['patterns'].forEach((v) {
        patterns!.add(Patterns.fromJson(v));
      });
    }
    senderUID = json['sender_UID'];
    senders = json['senders'] != null ? List<String>.from(json['senders'].map((x) => x)) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['name'] = name;
    if (patterns != null) {
      data['patterns'] = patterns!.map((v) => v.toJson()).toList();
    }
    data['sender_UID'] = senderUID;
    data['senders'] = senders;
    return data;
  }
}

class Patterns {
  String? regex;
  String? accountType;
  String? patternUID;
  String? sortUID;
  String? smsType;
  DataFields? dataFields;
  String? accountNameOverride;
  bool? setAccountAsExpense;

  Patterns(
      {this.regex,
        this.accountType,
        this.patternUID,
        this.sortUID,
        this.smsType,
        this.dataFields,
        this.accountNameOverride,
        this.setAccountAsExpense});

  Patterns.fromJson(Map<String, dynamic> json) {
    regex = json['regex'];
    accountType = json['account_type'];
    patternUID = json['pattern_UID'];
    sortUID = json['sort_UID'];
    smsType = json['sms_type'];
    dataFields = json['data_fields'] != null
        ? DataFields.fromJson(json['data_fields'])
        : null;
    accountNameOverride = json['account_name_override'];
    setAccountAsExpense = json['set_account_as_expense'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regex'] = regex;
    data['account_type'] = accountType;
    data['pattern_UID'] = patternUID;
    data['sort_UID'] = sortUID;
    data['sms_type'] = smsType;
    if (dataFields != null) {
      data['data_fields'] = dataFields!.toJson();
    }
    data['account_name_override'] = accountNameOverride;
    data['set_account_as_expense'] = setAccountAsExpense;
    return data;
  }
}

class DataFields {
  String? statementType;
  Pan? pan;
  Amount? amount;
  Date? date;
  CreateTxn? createTxn;
  bool? enableChaining;
  TransactionTypeRule? transactionTypeRule;
  Pos? pos;
  Amount? accountBalance;
  String? transactionType;
  Note? note;
  NetworkReferenceId? networkReferenceId;
  String? transactionCategory;
  Amount? currency;
  Amount? minDueAmount;
  PosTypeRules? posTypeRules;
  Amount? location;
  Amount? outstandingBalance;
  String? eventType;
  Pnr? pnr;
  Pan? eventInfo;
  Pan? name;
  Pnr? eventLocation;
  EventReminderSpan? eventReminderSpan;
  bool? deleted;
  bool? incomplete;
  Amount? time;
  Note? contact;
  bool? showNotification;
  Amount? otp;
  Amount? posInfo;

  DataFields(
      {this.statementType,
        this.pan,
        this.amount,
        this.date,
        this.createTxn,
        this.enableChaining,
        this.transactionTypeRule,
        this.pos,
        this.accountBalance,
        this.transactionType,
        this.note,
        this.networkReferenceId,
        this.transactionCategory,
        this.currency,
        this.minDueAmount,
        this.posTypeRules,
        this.location,
        this.outstandingBalance,
        this.eventType,
        this.pnr,
        this.eventInfo,
        this.name,
        this.eventLocation,
        this.eventReminderSpan,
        this.deleted,
        this.incomplete,
        this.time,
        this.contact,
        this.showNotification,
        this.otp,
        this.posInfo});

  DataFields.fromJson(Map<String, dynamic> json) {
    statementType = json['statement_type'];
    pan = json['pan'] != null ? Pan.fromJson(json['pan']) : null;
    amount =
    json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    createTxn = json['create_txn'] != null
        ? CreateTxn.fromJson(json['create_txn'])
        : null;
    enableChaining = json['enable_chaining'];
    transactionTypeRule = json['transaction_type_rule'] != null
        ? TransactionTypeRule.fromJson(json['transaction_type_rule'])
        : null;
    pos = json['pos'] != null ? Pos.fromJson(json['pos']) : null;
    accountBalance = json['account_balance'] != null
        ? Amount.fromJson(json['account_balance'])
        : null;
    transactionType = json['transaction_type'];
    note = json['note'] != null ? Note.fromJson(json['note']) : null;
    networkReferenceId = json['network_reference_id'] != null
        ? NetworkReferenceId.fromJson(json['network_reference_id'])
        : null;
    transactionCategory = json['transaction_category'];
    currency =
    json['currency'] != null ? Amount.fromJson(json['currency']) : null;
    minDueAmount = json['min_due_amount'] != null
        ? Amount.fromJson(json['min_due_amount'])
        : null;
    posTypeRules = json['pos_type_rules'] != null
        ? PosTypeRules.fromJson(json['pos_type_rules'])
        : null;
    location =
    json['location'] != null ? Amount.fromJson(json['location']) : null;
    outstandingBalance = json['outstanding_balance'] != null
        ? Amount.fromJson(json['outstanding_balance'])
        : null;
    eventType = json['event_type'];
    pnr = json['pnr'] != null ? Pnr.fromJson(json['pnr']) : null;
    eventInfo = json['event_info'] != null
        ? Pan.fromJson(json['event_info'])
        : null;
    name = json['name'] != null ? Pan.fromJson(json['name']) : null;
    eventLocation = json['event_location'] != null
        ? Pnr.fromJson(json['event_location'])
        : null;
    eventReminderSpan = json['event_reminder_span'] != null
        ? EventReminderSpan.fromJson(json['event_reminder_span'])
        : null;
    deleted = json['deleted'];
    incomplete = json['incomplete'];
    time = json['time'] != null ? Amount.fromJson(json['time']) : null;
    contact =
    json['contact'] != null ? Note.fromJson(json['contact']) : null;
    showNotification = json['show_notification'];
    otp = json['otp'] != null ? Amount.fromJson(json['otp']) : null;
    posInfo =
    json['pos_info'] != null ? Amount.fromJson(json['pos_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statement_type'] = statementType;
    if (pan != null) {
      data['pan'] = pan!.toJson();
    }
    if (amount != null) {
      data['amount'] = amount!.toJson();
    }
    if (date != null) {
      data['date'] = date!.toJson();
    }
    if (createTxn != null) {
      data['create_txn'] = createTxn!.toJson();
    }
    data['enable_chaining'] = enableChaining;
    if (transactionTypeRule != null) {
      data['transaction_type_rule'] = transactionTypeRule!.toJson();
    }
    if (pos != null) {
      data['pos'] = pos!.toJson();
    }
    if (accountBalance != null) {
      data['account_balance'] = accountBalance!.toJson();
    }
    data['transaction_type'] = transactionType;
    if (note != null) {
      data['note'] = note!.toJson();
    }
    if (networkReferenceId != null) {
      data['network_reference_id'] = networkReferenceId!.toJson();
    }
    data['transaction_category'] = transactionCategory;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    if (minDueAmount != null) {
      data['min_due_amount'] = minDueAmount!.toJson();
    }
    if (posTypeRules != null) {
      data['pos_type_rules'] = posTypeRules!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (outstandingBalance != null) {
      data['outstanding_balance'] = outstandingBalance!.toJson();
    }
    data['event_type'] = eventType;
    if (pnr != null) {
      data['pnr'] = pnr!.toJson();
    }
    if (eventInfo != null) {
      data['event_info'] = eventInfo!.toJson();
    }
    if (name != null) {
      data['name'] = name!.toJson();
    }
    if (eventLocation != null) {
      data['event_location'] = eventLocation!.toJson();
    }
    if (eventReminderSpan != null) {
      data['event_reminder_span'] = eventReminderSpan!.toJson();
    }
    data['deleted'] = deleted;
    data['incomplete'] = incomplete;
    if (time != null) {
      data['time'] = time!.toJson();
    }
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    data['show_notification'] = showNotification;
    if (otp != null) {
      data['otp'] = otp!.toJson();
    }
    if (posInfo != null) {
      data['pos_info'] = posInfo!.toJson();
    }
    return data;
  }
}

class Pan {
  int? groupId;
  String? value;

  Pan({this.groupId, this.value});

  Pan.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    data['value'] = value;
    return data;
  }
}

class PosRules {
  String? value;
  String? category;
  bool? incomeFlagOverride;

  PosRules({this.value, this.category, this.incomeFlagOverride});

  PosRules.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    category = json['category'];
    incomeFlagOverride = json['income_flag_override'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['category'] = category;
    data['income_flag_override'] = incomeFlagOverride;
    return data;
  }
}

class PosTypeRules {
  List<PosRules>? rules;
  int? groupId;

  PosTypeRules({this.rules, this.groupId});

  PosTypeRules.fromJson(Map<String, dynamic> json) {
    if (json['rules'] != null) {
      rules = <PosRules>[];
      json['rules'].forEach((v) {
        rules?.add(PosRules.fromJson(v));
      });
    }
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rules != null) {
      data['rules'] = rules?.map((v) => v.toJson()).toList();
    }
    data['group_id'] = groupId;
    return data;
  }
}



class Amount {
  int? groupId;

  Amount({this.groupId});

  Amount.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    return data;
  }
}

class NetworkReferenceId {
  int? groupId;
  bool? isNeft;
  bool? isUpi;
  bool? isImps;
  int? typeGroupId;
  List<TypeRules>? typeRules;
  bool? isRtgs;

  NetworkReferenceId(
      {this.groupId,
        this.isNeft,
        this.isUpi,
        this.isImps,
        this.typeGroupId,
        this.typeRules,
        this.isRtgs});

  NetworkReferenceId.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    isNeft = json['is_neft'];
    isUpi = json['is_upi'];
    isImps = json['is_imps'];
    typeGroupId = json['type_group_id'];
    if (json['type_rules'] != null) {
      typeRules = <TypeRules>[];
      json['type_rules'].forEach((v) {
        typeRules!.add(TypeRules.fromJson(v));
      });
    }
    isRtgs = json['is_rtgs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    data['is_neft'] = isNeft;
    data['is_upi'] = isUpi;
    data['is_imps'] = isImps;
    data['type_group_id'] = typeGroupId;
    if (typeRules != null) {
      data['type_rules'] = typeRules!.map((v) => v.toJson()).toList();
    }
    data['is_rtgs'] = isRtgs;
    return data;
  }
}


class Acc {
  String? blacklistRegex;
  String? minAppVersion;
  List<Rules>? rules;
  String? version;

  Acc({this.blacklistRegex, this.minAppVersion, this.rules, this.version});

  Acc.fromJson(Map<String, dynamic> json) {
    blacklistRegex = json['blacklist_regex'];
    minAppVersion = json['min_app_version'];
    if (json['rules'] != null) {
      rules = <Rules>[];
      json['rules'].forEach((v) {
        rules!.add(Rules.fromJson(v));
      });
    }
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blacklist_regex'] = blacklistRegex;
    data['min_app_version'] = minAppVersion;
    if (rules != null) {
      data['rules'] = rules!.map((v) => v.toJson()).toList();
    }
    data['version'] = version;
    return data;
  }
}


class Date {
  int? groupId;
  List<Formats>? formats;
  bool? useSmsTime;
  List<int>? groupIds;

  Date({this.groupId, this.formats, this.useSmsTime, this.groupIds});

  Date.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    if (json['formats'] != null) {
      formats = <Formats>[];
      json['formats'].forEach((v) {
        formats!.add(Formats.fromJson(v));
      });
    }
    useSmsTime = json['use_sms_time'];
    groupIds = json['group_ids'] != null ? List<int>.from(json['group_ids'].map((x) => x)) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    if (formats != null) {
      data['formats'] = formats!.map((v) => v.toJson()).toList();
    }
    data['use_sms_time'] = useSmsTime;
    data['group_ids'] = groupIds;
    return data;
  }
}

class Formats {
  bool? useSmsTime;
  String? format;

  Formats({this.useSmsTime, this.format});

  Formats.fromJson(Map<String, dynamic> json) {
    useSmsTime = json['use_sms_time'];
    format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['use_sms_time'] = useSmsTime;
    data['format'] = format;
    return data;
  }
}

class CreateTxn {
  Amount? amount;

  CreateTxn({this.amount});

  CreateTxn.fromJson(Map<String, dynamic> json) {
    amount =
    json['amount'] != null ? Amount.fromJson(json['amount']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (amount != null) {
      data['amount'] = amount!.toJson();
    }
    return data;
  }
}



class TransactionTypeRule {
  List<Rules>? rules;
  int? groupId;

  TransactionTypeRule({this.rules, this.groupId});

  TransactionTypeRule.fromJson(Map<String, dynamic> json) {
    if (json['rules'] != null) {
      rules = <Rules>[];
      json['rules'].forEach((v) {
        rules!.add(Rules.fromJson(v));
      });
    }
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rules != null) {
      data['rules'] = rules!.map((v) => v.toJson()).toList();
    }
    data['group_id'] = groupId;
    return data;
  }
}


class Pos {
  int? groupId;
  String? value;
  bool? setNoPos;
  List<int>? groupIds;

  Pos({this.groupId, this.value, this.setNoPos, this.groupIds});

  Pos.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    value = json['value'];
    setNoPos = json['set_no_pos'];
    groupIds = json['group_ids'] != null ? List<int>.from(json['group_ids'].map((x) => x)) : [];
  }

  Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    data['value'] = value;
    data['set_no_pos'] = setNoPos;
    data['group_ids'] = groupIds;
    return data;
  }
}

class Note {
  int? groupId;
  String? prefix;

  Note({this.groupId, this.prefix});

  Note.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    prefix = json['prefix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    data['prefix'] = prefix;
    return data;
  }
}

class TypeRules {
  String? value;
  bool? isNeft;
  bool? isRtgs;
  bool? isUpi;
  bool? isImps;

  TypeRules({this.value, this.isNeft, this.isRtgs, this.isUpi, this.isImps});

  TypeRules.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    isNeft = json['is_neft'];
    isRtgs = json['is_rtgs'];
    isUpi = json['is_upi'];
    isImps = json['is_imps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['is_neft'] = isNeft;
    data['is_rtgs'] = isRtgs;
    data['is_upi'] = isUpi;
    data['is_imps'] = isImps;
    return data;
  }
}


class Pnr {
  int? groupId;
  List<int>? groupIds;

  Pnr({this.groupId, this.groupIds});

  Pnr.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    groupIds = json['group_ids'] != null ? List<int>.from(json['group_ids'].map((x) => x)) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    data['group_ids'] = groupIds;
    return data;
  }
}

class EventReminderSpan {
  int? value;

  EventReminderSpan({this.value});

  EventReminderSpan.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}

class MiscInformation {
  List<GetBalance>? getBalance;

  MiscInformation({this.getBalance});

  MiscInformation.fromJson(Map<String, dynamic> json) {
    if (json['get_balance'] != null) {
      getBalance = <GetBalance>[];
      json['get_balance'].forEach((v) {
        getBalance!.add(GetBalance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getBalance != null) {
      data['get_balance'] = getBalance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetBalance {
  String? accountType;
  List<ContactInfo>? contactInfo;

  GetBalance({this.accountType, this.contactInfo});

  GetBalance.fromJson(Map<String, dynamic> json) {
    accountType = json['account_type'];
    if (json['contact_info'] != null) {
      contactInfo = <ContactInfo>[];
      json['contact_info'].forEach((v) {
        contactInfo!.add(ContactInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_type'] = accountType;
    if (contactInfo != null) {
      data['contact_info'] = contactInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContactInfo {
  String? type;
  List<String>? numbers;
  String? format;

  ContactInfo({this.type, this.numbers, this.format});

  ContactInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    numbers = json['numbers'] != null ? List<String>.from(json['numbers'].map((x) => x)) : [];
    format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['numbers'] = numbers;
    data['format'] = format;
    return data;
  }
}