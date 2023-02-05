import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class LoginController {
  login(String npm, String password) async {
    var url = Uri.https("sikma.uajy.ac.id", "/Account/Login");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var cj=CookieJar();
    var dio = Dio();
    dio.interceptors.add(CookieManager(cj));
    dio.options.followRedirects = false;
    var response = await dio.get(url.toString());
    await cj.loadForRequest(url);
    var soup = BeautifulSoup(response.data);
    var token = soup.find('input', attrs: {'name': '__RequestVerificationToken'})?['value'];
    var data = {
      'username': npm,
      'password': password,
      'returnUrl': '/',
      '__RequestVerificationToken': token,
    };
    var responseRes = await dio.post(url.toString(), data: data, options: Options(headers: headers,
    followRedirects: false,
    validateStatus: (status) { return status! < 500; }
    ));
    if(responseRes.statusCode==302){
      var redirectResponse = await dio.get('https://sikma.uajy.ac.id/Home/IndexMahasiswa');
      var soup = BeautifulSoup(redirectResponse.data);
      var nama = soup.find("div", attrs: {"class": "box-body box-profile"})?.find("h3")?.text;
      Map<String, dynamic> data = {
        "nama": nama,
        "email": "$npm@students.uajy.ac.id",
        "npm": npm,
        "status": true,
      };
      return data;
    }
  }
}