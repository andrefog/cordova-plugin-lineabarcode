#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

#import "DTDevices.h"

@interface LineaBarcode : CDVPlugin
{
    DTDevices *dtdev;
}

- (void)initLinea:(CDVInvokedUrlCommand*)command;
- (void)getConnectionStatus:(CDVInvokedUrlCommand*)command;
- (void)startBarcode:(CDVInvokedUrlCommand*)command;
- (void)stopBarcode:(CDVInvokedUrlCommand*)command;
- (void)enableBarcodeButton:(CDVInvokedUrlCommand*)command;
- (void)disableBarcodeButton:(CDVInvokedUrlCommand*)command;
- (void)barcodeSetChargeDeviceOff:(CDVInvokedUrlCommand*)command;
- (void)barcodeSetChargeDeviceOn:(CDVInvokedUrlCommand*)command;
- (void)barcodeSetScanBeepOff:(CDVInvokedUrlCommand*)command;
- (void)barcodeSetScanBeepOn:(CDVInvokedUrlCommand*)command;
- (void)barcodeSetPassThroughSyncOff:(CDVInvokedUrlCommand*)command;
- (void)barcodeSetPassThroughSyncOn:(CDVInvokedUrlCommand*)command;

@end
