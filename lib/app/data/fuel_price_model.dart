class Price {
  String? cityId;
  String? cityName;
  String? stateId;
  String? stateName;
  String? countryId;
  String? countryName;
  String? applicableOn;
  Fuel? fuel;

  Price({this.cityId, this.cityName, this.stateId, this.stateName, this.countryId, this.countryName, this.applicableOn, this.fuel});

  Price.fromJson(Map<String, dynamic> json) {
    cityId = json['cityId'];
    cityName = json['cityName'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    countryId = json['countryId'];
    countryName = json['countryName'];
    applicableOn = json['applicableOn'];
    fuel = (json['fuel'] != null ? Fuel.fromJson(json['fuel']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cityId'] = cityId;
    data['cityName'] = cityName;
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['countryId'] = countryId;
    data['countryName'] = countryName;
    data['applicableOn'] = applicableOn;
    if (fuel != null) {
      data['fuel'] = fuel?.toJson();
    }
    return data;
  }
}

class Fuel {

  Retail? petrol;
  Retail? diesel;

  Fuel({this.petrol, this.diesel});

  Fuel.fromJson(Map<String, dynamic> json) {
    petrol = (json['petrol'] != null ? Retail.fromJson(json['petrol']) : null)!;
    diesel = (json['diesel'] != null ? Retail.fromJson(json['diesel']) : null)!;
    // petrol = json['petrol'];
    // diesel = json['diesel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (petrol != null) {
      data['petrol'] = petrol?.toJson();
    }
    if (diesel != null) {
      data['diesel'] = diesel?.toJson();
    }
    // data['petrol'] = petrol;
    // data['diesel'] = diesel;
    return data;
  }

}

class Retail {
  double? retailPrice;
  int? retailPriceChange;
  String? retailUnit;
  String? currency;
  String? retailPriceChangeInterval;

  Retail({this.retailPrice, this.retailPriceChange, this.retailUnit, this.currency, this.retailPriceChangeInterval});

  Retail.fromJson(Map<String, dynamic> json) {
    retailPrice = json['retailPrice'];
    retailPriceChange = json['retailPriceChange'];
    retailUnit = json['retailUnit'];
    currency = json['currency'];
    retailPriceChangeInterval = json['retailPriceChangeInterval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['retailPrice'] = retailPrice;
    data['retailPriceChange'] = retailPriceChange;
    data['retailUnit'] = retailUnit;
    data['currency'] = currency;
    data['retailPriceChangeInterval'] = retailPriceChangeInterval;
    return data;
  }
}