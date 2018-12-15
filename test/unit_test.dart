import 'package:test/test.dart';
import 'package:awareframework_wifi/awareframework_wifi.dart';

void main(){
  test("test sensor config", (){
    var config = WiFiSensorConfig();
    expect(config.debug, false);
  });
}