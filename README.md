# cordova-plugin-lineabarcode
Cordova Barcode scanner plugin for Linea Pro devices (iOS only), modified from com.citronium.lineaprocdv.v2 0.1

Install with `cordova plugin add https://github.com/domisginger/cordova-plugin-lineabarcode`


Will add the following into info.plist:
* com.datecs.linea.pro.msr
* com.datecs.iserial.communication
* com.datecs.pinpad
* com.datecs.linea.pro.bar

## Init
Call on app start to connect device, every barcode scanned will trigger cardCallback();

```javascript
LineaBarcode.initLinea(
  connectionCallback => { }, //Connection Changed Callback (int) - 2 is connected
  cardCallback => { }, //Magnetic Card Reader Callback (Track1 + Track2 + Track3)
  barcodeCallback => { }, //Barcode Reader Callback ({format: string, cancelled: boolean, text: string})
  success => { },
  error => { }
);
```

## Barcode Beep On/Off
Turn on/off beep when barcode scanned (on by default, not persistant on app restart)

```javascript
LineaBarcode.barcodeSetScanBeepOff();
LineaBarcode.barcodeSetScanBeepOn();
```

## Scan Button On/Off
Turn on/off the physical button activating the barcode reader (on by default, not persistant on app restart)

```javascript
LineaBarcode.barcodeButtonDisable();
LineaBarcode.barcodeButtonEnable();
```

## Scan Start/Stop
Manually start or stop the barcode reader (turn on barcode light and attempt scanning without pressing physical button)

```javascript
LineaBarcode.barcodeStart();
LineaBarcode.barcodeStop();
```

## Pass-through Sync On/Off
Used for iOS device syncing, while on the barcode scanner wont work

```javascript
LineaBarcode.barcodeSetPassThroughSyncOn();
LineaBarcode.barcodeSetPassThroughSyncOff();
```

## Charge Device On/Off
Charge the iOS device from the Linea Device's battery pack

```javascript
LineaBarcode.barcodeSetChargeDeviceOn();
LineaBarcode.barcodeSetChargeDeviceOff();
```
