import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromARGB(255, 53, 105, 165);
const kPrimaryLightColor = Color.fromARGB(255, 230, 244, 255);

const double defaultPadding = 16.0;

const String host = "192.168.13.117:8000";

String getmonth(month) {
  var monthString = '';
  switch (month) {
    case 1:
      monthString = 'Januari';
      break;
    case 2:
      monthString = 'Februari';
      break;
    case 3:
      monthString = 'Maret';
      break;
    case 4:
      monthString = 'April';
      break;
    case 5:
      monthString = 'Mei';
      break;
    case 6:
      monthString = 'Juni';
      break;
    case 7:
      monthString = 'Juli';
      break;
    case 8:
      monthString = 'Agustus';
      break;
    case 9:
      monthString = 'September';
      break;
    case 10:
      monthString = 'Oktober';
      break;
    case 11:
      monthString = 'November';
      break;
    case 12:
      monthString = 'Desember';
      break;
  }
  return monthString;
}
String getProdi(digit) {
  var prodi = '';
  switch(digit.substring(2, 4)){
    case '01':
      prodi = 'Arsitektur';
      break;
    case '02':
      prodi = 'Teknik Sipil';
      break;
    case '03':
      prodi = 'Manajemen';
      break;
    case '04':
      prodi = 'Akuntansi';
      break;
    case '05':
      prodi = 'Hukum';
      break;
    case '06':
      prodi = 'Teknik Industri';
      break;
    case '07':
      prodi = 'Informatika';
      break;
    case '08':
      prodi = 'Biologi';
      break;
    case '09':
      prodi = 'Ilmu Komunikasi';
      break;
    case '10':
      prodi = 'Sosiologi';
      break;
    case '11':
      prodi = 'Ekonomi Pembangunan';
      break;
    case '12':
      prodi = 'Manajemen Internasional';
      break;
    case '13':
      prodi = 'Teknik Sipil Internasional';
      break;
    case '14':
      prodi = 'Teknik Industri Internasional';
      break;
    case '15':
      prodi = 'Akuntansi Internasional';
      break;
    case '17':
      prodi = 'Sistem Informasi';
      break;
    case '18':
      prodi = 'Ilmu Komunikasi Internasional';
      break;
  }
  return prodi;
}
String checkMonth(digit) {
  if (digit.substring(0, 1) == '0') {
    digit = digit.substring(1, 2);
  }
  return digit;
}
extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (length <= maxLength) ? this : '${substring(0, maxLength)}...';
}