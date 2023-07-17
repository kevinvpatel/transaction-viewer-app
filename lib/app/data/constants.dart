import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:transaction_viewer_app/app/data/constants/image_constants.dart';


Widget convertBankAddressToBankIcon({required String bankName, required Map<String, dynamic> bankBundleData, double? padding, double? height}) {
  String? imagePath;
  for(Map<String, dynamic> data in bankBundleData['rules']) {
    imagePath = '';
    // print('bankName ->> ${bankName}');
    // print('full_name ->> ${data['full_name']}');
    if(data['full_name'] == bankName.toUpperCase() || data['full_name'] == bankName.toLowerCase() || data['full_name'] == bankName) {
      imagePath = 'assets/bank icons/${data['image']}.png';
      break;
    }
  }
  // print('imagePath ->> ${imagePath}');
  if(imagePath == '') {
    return Padding(
      padding: EdgeInsets.all(padding ?? 0.0),
      child: Image.asset(ConstantsImage.bank_holiday_icon, height: 23.sp),
    );
  } else {
    return Image.asset(imagePath!, height: height ?? 27.sp);
  }
}

List<String> ifsc_list = ['Abhyudaya Co-op Bank.txt', 'Abu Dhabi Commercial Bank.txt', 'Akola District Central Co-op Bank.txt', 'Akola Janata Commercial Co-op Bank.txt', 'Allahabad Bank.txt',
  'Almora Urban Co-op Bank.txt', 'Andhra Bank.txt', 'Andhra Pragathi Grameena Bank.txt', 'Apna Sahakari Bank Ltd.txt', 'Australia & New Zealand Banking Group Ltd.txt', 'Axis Bank.txt',
  'Bandhan Bank Ltd.txt','Bank Internasional Indonesia.txt','Bank of America.txt','Bank of Bahrain & Kuwait.txt','Bank of Baroda.txt','Bank of Ceylon.txt', 'Bank of India.txt',
  'Bank of Maharashtra.txt', 'Bank of Tokyo-Mitsubishi Ufj Ltd.txt', 'Barclays Bank.txt', 'Bassein Catholic Co-op Bank.txt', 'Bharatiya Mahila Bank.txt', 'BNP Paribas.txt', 'Calyon Bank.txt',
  'Canara Bank.txt', 'Capital Local Area Bank.txt', 'Catholic Syrian Bank.txt', 'Central Bank of India.txt', 'Chinatrust Commercial Bank.txt', 'Citibank.txt', 'Citizencredit Co-op Bank.txt',
  'City Union Bank.txt', 'Commonwealth Bank of Australia.txt', 'Corporation Bank.txt', 'Credit Suisse.txt', 'DBS Bank.txt', 'Dena Bank.txt', 'Deutsche Bank.txt', 'Deutsche Securities India Pvt. Ltd.txt',
  'Development Credit Bank Ltd.txt', 'Dhanlaxmi Bank Ltd.txt', 'DICGC.txt', 'Doha Bank.txt', 'Dombivli Nagari Sahakari Bank Ltd.txt', 'Export Import Bank of India.txt', 'Firstrand Bank Ltd.txt',
  'Gurgaon Gramin Bank.txt', 'HDFC BANK.txt', 'HSBC.txt', 'ICICI Bank.txt', 'IDBI Bank.txt', 'IDFC Bank.txt', 'IDRBT.txt', 'Indian Bank.txt', 'Indian Overseas Bank.txt', 'Indusind Bank.txt',
  'Industrial & Commercial Bank of China Ltd.txt', 'Industrial Bank of Korea.txt', 'ING Vysya Bank.txt', 'Jalgaon Janata Sahkari Bank Ltd.txt', 'Janakalyan Sahakari Bank Ltd.txt',
  'Janaseva Sahakari Bank (Borivli) Ltd.txt', 'Janaseva Sahakari Bank Ltd (Pune).txt', 'Janata Sahakari Bank Ltd (Pune).txt', 'JPMorgan Chase.txt', 'Kallappanna Awade Ich Janata S Bank.txt',
  'Kapol Co-op Bank.txt', 'Karnataka Bank Ltd.txt', 'Karnataka Vikas Grameena Bank.txt', 'Karur Vysya Bank.txt', 'KEB Hana Bank.txt', 'Kerala Gramin Bank.txt', 'Kotak Mahindra Bank.txt',
  'Mahanagar Co-op Bank Ltd.txt', 'Maharashtra State Co-op Bank.txt', 'Mashreq Bank.txt', 'Mizuho Corporate Bank Ltd.txt', 'Nagar Urban Co-op Bank.txt', 'Nagpur Nagrik Sahakari Bank Ltd.txt',
  'National Australia Bank.txt', 'National Bank Of Abu Dhabi PJSC.txt', 'New India Co-op Bank Ltd.txt', 'NKGSB Co-op Bank Ltd.txt', 'North Malabar Gramin Bank.txt', 'Nutan Nagarik Sahakari Bank Ltd.txt',
  'Oman International Bank Saog.txt', 'Oriental Bank Of Commerce.txt', 'Parsik Janata Sahakari Bank Ltd.txt', 'Pragathi Krishna Gramin Bank.txt', 'Prathama Bank.txt', 'Prime Co-op Bank Ltd.txt',
  'Punjab & Maharashtra Co-op Bank Ltd.txt', 'Punjab & Sind Bank.txt', 'Punjab National Bank.txt', 'Rabobank International (ccrb).txt', 'Rajgurunagar Sahakari Bank Ltd.txt', 'Rajkot Nagarik Sahakari Bank Ltd.txt',
  'Reserve Bank of India.txt', 'Samarth Sahakari Bank Ltd.txt', 'SBER Bank.txt', 'Shikshak Sahakari Bank Ltd.txt', 'Shinhan Bank.txt', 'Shivalik Mercantile Co-op Bank Ltd.txt',
  'Shri Chhatrapati Rajashri Shahu Urban Co-op Bank Ltd.txt', 'Societe Generale.txt', 'Solapur Janata Sahkari Bank Ltd.Solapur.txt', 'South Indian Bank.txt', 'Standard Chartered Bank.txt',
  'State Bank of Bikaner & Jaipur.txt', 'State Bank of Hyderabad.txt', 'State Bank of India - SBI.txt', 'State Bank of Mauritius Ltd.txt', 'State Bank of Mysore.txt', 'State Bank of Patiala.txt',
  'State Bank of Travancore.txt', 'Sumitomo Mitsui Banking Corporation.txt', 'Surat National Co-op Bank Ltd.txt', 'Syndicate Bank.txt', 'Tamilnad Mercantile Bank Ltd.txt', 'The A P Mahesh Co-op Urban Bank Ltd.txt',
  'The Ahmedabad Mercantile Co-op Bank Ltd.txt', 'The Andhra Pradesh State Co-op Bank Ltd.txt', 'The Bank of Nova Scotia.txt', 'The Bank of Rajasthan Ltd.txt', 'The Bharat Co-op Bank (Mumbai) Ltd.txt',
  'The Cosmos Co-op Bank Ltd.txt', 'The Delhi State Co-op Bank Ltd.txt', 'The Federal Bank Ltd.txt', 'The Gadchiroli District Central Co-op Bank Ltd.txt', 'The Greater Bombay Co-op Bank Ltd.txt',
  'The Gujarat State Co-op Bank Ltd.txt', 'The Hasti Coop Bank Ltd.txt', 'The Jalgaon Peoples Co-op Bank.txt', 'The Jammu & Kashmir Bank Ltd.txt', 'The Kalupur Commercial Co-Op Bank Ltd.txt',
  'The Kalyan Janata Sahakari Bank Ltd.txt', 'The Kangra Central Co-op Bank Ltd.txt', 'The Kangra Co-op Bank Ltd.txt', 'The Karad Urban Co-op Bank Ltd.txt', 'The Karanataka State Co-op Apex Bank Ltd.txt',
  'The Kurmanchal Nagar Sahakari Bank Ltd.txt', 'The Lakshmi Vilas Bank Ltd.txt', 'The Mehsana Urban Co-op Bank Ltd.txt', 'The Mumbai District Central Co-op Bank Ltd.txt', 'The Municipal Co-op Bank Ltd Mumbai.txt',
  'The Nainital Bank Ltd.txt', 'The Nasik Merchants Co-op Bank Ltd (Nashik).txt', 'The Pandharpur Urban Co-op Bank Ltd (Pandharpur).txt', 'The Rajasthan State Co-op Bank Ltd.txt', 'The Ratnakar Bank Ltd.txt',
  'The Royal Bank of Scotland N.V.txt', 'The Sahebrao Deshmukh Co-op Bank Ltd.txt', 'The Saraswat Co-op Bank Ltd.txt', 'The Seva Vikas Co-op Bank Ltd (Svb).txt', 'The Shamrao Vithal Co-op Bank Ltd.txt',
  'The Surat District Co-op Bank Ltd.txt', 'The Surat Peoples Co-op Bank Ltd.txt', 'The Sutex Co-Op Bank Ltd.txt', 'The Tamilnadu State Apex Co-op Bank Ltd.txt', 'The Thane Bharat Sahakari Bank Ltd.txt',
  'The Thane District Central Co-op Bank Ltd.txt', 'The Varachha Co-op Bank Ltd.txt', 'The Vishweshwar Sahakari Bank Ltd (Pune).txt', 'The West Bengal State Co-op Bank Ltd.txt', 'The Zoroastrian Co-op Bank Ltd.txt',
  'TJSB Sahakari Bank Ltd.txt', 'Tumkur Grain Merchants Co-op Bank Ltd.txt', 'UBS AG.txt', 'UCO Bank.txt', 'Union Bank of India.txt', 'United Bank of India.txt', 'United Overseas Bank.txt',
  'Vasai Vikas Sahakari Bank Ltd.txt', 'Vijaya Bank.txt', 'Westpac Banking Corporation.txt', 'Woori Bank.txt', 'Yes Bank.txt', 'Zila Sahkari Bank Ltd Ghaziabad.txt'];