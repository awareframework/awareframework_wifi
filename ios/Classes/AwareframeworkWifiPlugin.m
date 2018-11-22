#import "AwareframeworkWifiPlugin.h"
#import <awareframework_wifi/awareframework_wifi-Swift.h>

@implementation AwareframeworkWifiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkWifiPlugin registerWithRegistrar:registrar];
}
@end
