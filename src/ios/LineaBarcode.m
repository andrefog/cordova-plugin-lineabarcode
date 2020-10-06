#import "LineaBarcode.h"

@interface LineaBarcode()

+ (NSString*) getPDF417ValueByCode: (NSArray*) codesArr code:(NSString*)code;

@end

@implementation LineaBarcode

-(void) scannerConect:(NSString*)num {
    
    NSString *jsStatement = [NSString stringWithFormat:@"reportConnectionStatus('%@');", num];
    if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
        // Cordova-iOS pre-4
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsStatement waitUntilDone:NO];
    } else {
        // Cordova-iOS 4+
        [self.webView performSelectorOnMainThread:@selector(evaluateJavaScript:completionHandler:) withObject:jsStatement waitUntilDone:NO];
    }
}

-(void) scannerBattery:(NSString*)num {
    
    int percent;
    float voltage;
    
    if([dtdev getBatteryCapacity:&percent voltage:&voltage error:nil])
    {
        NSString *status = [NSString stringWithFormat:@"Bat: %.2fv, %d%%",voltage,percent];
        
        // send to web view
        NSString *jsStatement = [NSString stringWithFormat:@"reportBatteryStatus('%@');", status];
        if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
            // Cordova-iOS pre-4
            [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsStatement waitUntilDone:NO];
        } else {
            // Cordova-iOS 4+
            [self.webView performSelectorOnMainThread:@selector(evaluateJavaScript:completionHandler:) withObject:jsStatement waitUntilDone:NO];
        }
    }
}

-(void) scanPaymentCard:(NSString*)num {
    NSString *jsStatement = [NSString stringWithFormat:@"onSuccessScanPaymentCard('%@');", num];
    if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
        // Cordova-iOS pre-4
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsStatement waitUntilDone:NO];
    } else {
        // Cordova-iOS 4+
        [self.webView performSelectorOnMainThread:@selector(evaluateJavaScript:completionHandler:) withObject:jsStatement waitUntilDone:NO];
    }    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)initLinea:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    if (!dtdev) {
        dtdev = [DTDevices sharedDevice];
        [dtdev addDelegate:self];
        [dtdev connect];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getConnectionStatus:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)barcodeSetChargeDeviceOff:(CDVInvokedUrlCommand *)command
{
    [dtdev setCharging:0 error:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)barcodeSetChargeDeviceOn:(CDVInvokedUrlCommand *)command
{
    [dtdev setCharging:1 error:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)barcodeSetScanBeepOff:(CDVInvokedUrlCommand *)command
{
    [dtdev barcodeSetScanBeep:0 volume: 0 beepData:nil length:0 error:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)barcodeSetScanBeepOn:(CDVInvokedUrlCommand *)command
{
    int beep[]={2730,100};
    int beep2[]={523,200,523,200,784,200,784,200,880,200,880,200,784,200,698,200,698,200,659,200,659,200,587,200,587,200,523,200};
    int val = 1 + arc4random() % (1500 - 1);

    if(val == 1337){
        [dtdev barcodeSetScanBeep:1 volume: 100 beepData:beep2 length:sizeof(beep2) error:nil];
    }else{
        [dtdev barcodeSetScanBeep:1 volume: 100 beepData:beep length:sizeof(beep) error:nil];
    }
        
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)barcodeSetPassThroughSyncOff:(CDVInvokedUrlCommand *)command
{
    [dtdev setPassThroughSync:0 error:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)barcodeSetPassThroughSyncOn:(CDVInvokedUrlCommand *)command
{
    [dtdev setPassThroughSync:1 error:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)enableBarcodeButton:(CDVInvokedUrlCommand *)command
{
    [dtdev barcodeSetScanButtonMode:1 error:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)disableBarcodeButton:(CDVInvokedUrlCommand *)command
{
    [dtdev barcodeSetScanButtonMode:0 error:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startBarcode:(CDVInvokedUrlCommand *)command
{
    [dtdev barcodeStartScan:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stopBarcode:(CDVInvokedUrlCommand *)command
{
    [dtdev barcodeStopScan:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)connectionState: (int)state {
    NSLog(@"connectionState: %d", state);
    
    switch (state) {
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
                break;
        case CONN_CONNECTED:
        {
            NSLog(@"PPad connected!\nSDK version: %d.%d\nHardware revision: %@\nFirmware revision: %@\nSerial number: %@", dtdev.sdkVersion/100,dtdev.sdkVersion%100,dtdev.hardwareRevision,dtdev.firmwareRevision,dtdev.serialNumber);
            break;
        }
    }
    
    NSString* retStr = [ NSString stringWithFormat:@"LineaBarcode.connectionChanged(%d);", state];
    //[[super webView] stringByEvaluatingJavaScriptFromString:retStr];
    if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
        // Cordova-iOS pre-4
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:retStr waitUntilDone:NO];
    } else {
        // Cordova-iOS 4+
//        [self.webView performSelectorOnMainThread:@selector(evaluateJavaScript:completionHandler:) withObject:retStr waitUntilDone:NO];
        [self.commandDelegate evalJs:retStr];
    }
}

- (void) deviceButtonPressed: (int) which {
    NSLog(@"deviceButtonPressed: %d", which);
}

- (void) deviceButtonReleased: (int) which {
    NSLog(@"deviceButtonReleased: %d", which);
}

- (void) deviceFeatureSupported: (int) feature value:(int) value {
    NSLog(@"deviceFeatureSupported: feature - %d, value - %d", feature, value);
}

- (void) firmwareUpdateProgress: (int) phase percent:(int) percent {
    NSLog(@"firmwareUpdateProgress: phase - %d, percent - %d", phase, percent);
}

- (void) magneticCardData: (NSString *) track1 track2:(NSString *) track2 track3:(NSString *) track3 {
    NSLog(@"magneticCardData: track1 - %@, track2 - %@, track3 - %@", track1, track2, track3);
    NSDictionary *card = [dtdev msProcessFinancialCard:track1 track2:track2];
    if(card && [card objectForKey:@"accountNumber"]!=nil && [[card objectForKey:@"expirationYear"] intValue]!=0)
    {
        NSLog(@"magneticCardData (full info): accountNumber - %@, cardholderName - %@, expirationYear - %@, expirationMonth - %@, serviceCode - %@, discretionaryData - %@, firstName - %@, lastName - %@", [card objectForKey:@"accountNumber"], [card objectForKey:@"cardholderName"], [card objectForKey:@"expirationYear"], [card objectForKey:@"expirationMonth"], [card objectForKey:@"serviceCode"], [card objectForKey:@"discretionaryData"], [card objectForKey:@"firstName"], [card objectForKey:@"lastName"]);
    }
    NSString* retStr = [ NSString stringWithFormat:@"LineaBarcode.onMagneticCardData('%@', '%@', '%@');", track1, track2, track3];
    if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
        // Cordova-iOS pre-4
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:retStr waitUntilDone:NO];
    } else {
        // Cordova-iOS 4+
        //[self.webView performSelectorOnMainThread:@selector(evaluateJavaScript:completionHandler:) withObject:retStr waitUntilDone:NO];
        [self.commandDelegate evalJs:retStr];
    }
}

- (void) magneticCardEncryptedData: (int) encryption tracks:(int) tracks data:(NSData *) data {
    NSLog(@"magneticCardEncryptedData: encryption - %d, tracks - %d, data - %@", encryption, tracks, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void) magneticCardEncryptedData: (int) encryption tracks:(int) tracks data:(NSData *) data track1masked:(NSString *) track1masked track2masked:(NSString *) track2masked track3:(NSString *) track3 {
    NSLog(@"magneticCardEncryptedData: encryption - %d, tracks - %d, track3 - %@, track1masked - %@, track2masked - %@, track3 - %@", encryption, tracks, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], track1masked, track2masked, track3);
}

- (void) magneticCardEncryptedRawData: (int) encryption data:(NSData *) data {
    NSLog(@"magneticCardEncryptedRawData: encryption - %d, data - %@", encryption, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void) magneticCardRawData: (NSData *) tracks {
    NSLog(@"magneticCardRawData: data - %@", [[NSString alloc] initWithData:tracks encoding:NSUTF8StringEncoding]);
}

- (void) magneticJISCardData: (NSString *) data {
    NSLog(@"magneticJISCardData: data - %@", data);
}

- (void) paperStatus: (BOOL) present {
    NSLog(@"paperStatus: present - %d", present);
}

- (void) PINEntryCompleteWithError: (NSError *) error {
    NSLog(@"PINEntryCompleteWithError: error - %@", [error localizedDescription]);
}

- (void) rfCardDetected: (int) cardIndex info:(DTRFCardInfo *) info {
    NSLog(@"rfCardDetected (debug): cardIndex - %d, info - %@", cardIndex, [info description]);
    NSLog(@"rfCardDetected (debug): cardIndex - %d, info - %@", cardIndex, [info debugDescription]);
}

- (void) rfCardRemoved: (int) cardIndex {
    NSLog(@"rfCardRemoved: cardIndex - %d", cardIndex);
}

- (void) sdkDebug: (NSString *) logText source:(int) source {
    NSLog(@"sdkDebug: logText - %@, source - %d", logText, source);
}

- (void) smartCardInserted: (SC_SLOTS) slot {
    NSLog(@"smartCardInserted: slot - %d", slot);
}

- (void) smartCardRemoved: (SC_SLOTS) slot {
    NSLog(@"smartCardRemoved: slot - %d", slot);
}

- (void) barcodeData: (NSString *) barcode type:(int) type {
    NSLog(@"barcodeData: barcode - %@, type - %@", barcode, [dtdev barcodeType2Text:type]);
    NSString* retStr = [ NSString stringWithFormat:@"LineaBarcode.onBarcodeData('%@', '%@');", barcode, [dtdev barcodeType2Text:type]];
    if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
        // Cordova-iOS pre-4
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:retStr waitUntilDone:NO];
    } else {
        // Cordova-iOS 4+
        //[self.webView performSelectorOnMainThread:@selector(evaluateJavaScript:completionHandler:) withObject:retStr waitUntilDone:NO];
        [self.commandDelegate evalJs:retStr];
    }
}

- (void) barcodeNSData: (NSData *) barcode isotype:(NSString *) isotype {
    NSLog(@"barcodeNSData: barcode - %@, type - %@", [[NSString alloc] initWithData:barcode encoding:NSUTF8StringEncoding], isotype);
    NSString* retStr = [ NSString stringWithFormat:@"LineaBarcode.onBarcodeData('%@', '%@');", [[NSString alloc] initWithData:barcode encoding:NSUTF8StringEncoding], isotype];
    if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
        // Cordova-iOS pre-4
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:retStr waitUntilDone:NO];
    } else {
        // Cordova-iOS 4+
        //[self.webView performSelectorOnMainThread:@selector(evaluateJavaScript:completionHandler:) withObject:retStr waitUntilDone:NO];
        [self.commandDelegate evalJs:retStr];
    }
}

+ (NSString*) getPDF417ValueByCode: (NSArray*) codesArr code:(NSString*)code {
    for (NSString* currStr in codesArr) {
        // do something with object
        NSRange range = [currStr rangeOfString:code];
        if (range.length == 0) continue;
        NSString *substring = [[currStr substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return substring;
    }
    return NULL;
}

+ (NSString*) generateStringForArrayEvaluationInJS: (NSArray*) stringsArray {
    NSString* arrayJSString = [NSString stringWithFormat:@"["];
    BOOL isFirst = TRUE;
    for (int i = 0; i < stringsArray.count; ++i) {
        NSString* currString = [stringsArray objectAtIndex:i];
        if (currString.length <= 1) continue;
        arrayJSString = [NSString stringWithFormat:@"%@%@\"%@\"", arrayJSString, isFirst ? @"" : @",", currString];
        isFirst = FALSE;
    }
    arrayJSString = [NSString stringWithFormat:@"%@]", arrayJSString];
    return arrayJSString;
}

- (void) barcodeNSData: (NSData *) barcode type:(int) type {
    NSArray *codesArr = [[[NSString alloc] initWithData:barcode encoding:NSUTF8StringEncoding] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\r"]];
    NSString* rawCodesArrJSString = [LineaBarcode generateStringForArrayEvaluationInJS:codesArr];
    //LineaBarcode.onBarcodeData(rawCode, type)
    NSString* retStr = [ NSString stringWithFormat:@"var rawCodesArr = %@; LineaBarcode.onBarcodeData(rawCodesArr, '%@');", rawCodesArrJSString, [dtdev barcodeType2Text:type]];
    if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
        // Cordova-iOS pre-4
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:retStr waitUntilDone:NO];
    } else {
        // Cordova-iOS 4+
        //[self.webView performSelectorOnMainThread:@selector(evaluateJavaScript:completionHandler:) withObject:retStr waitUntilDone:NO];
        [self.commandDelegate evalJs:retStr];
    }
}

- (void) bluetoothDeviceConnected: (NSString *) address {
    NSLog(@"bluetoothDeviceConnected: address - %@", address);
}

- (void) bluetoothDeviceDisconnected: (NSString *) address {
    NSLog(@"bluetoothDeviceDisconnected: address - %@", address);
}

- (void) bluetoothDeviceDiscovered: (NSString *) address name:(NSString *) name {
    NSLog(@"bluetoothDeviceDiscovered: address - %@, name - @name", name);
}
- (NSString *) bluetoothDevicePINCodeRequired: (NSString *) address name:(NSString *) name {
    NSLog(@"bluetoothDevicePINCodeRequired: address - %@, name - @name", name);
    return address;
}

- (BOOL) bluetoothDeviceRequestedConnection: (NSString *) address name:(NSString *) name {
    NSLog(@"bluetoothDeviceRequestedConnection: address - %@, name - @name", name);
    return TRUE;
}

- (void) bluetoothDiscoverComplete: (BOOL) success {
    NSLog(@"bluetoothDiscoverComplete: success - %d", success);
}



@end
