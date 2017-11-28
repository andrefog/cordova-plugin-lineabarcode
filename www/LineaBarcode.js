var argscheck = require('cordova/argscheck'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');
              
 function LineaBarcode() {
    this.results = [];
    this.connCallback = null;
    this.errorCallback = null;
    this.cancelCallback = null;
    this.cardDataCallback = null;
    this.barcodeCallback = null;    
}

LineaBarcode.prototype.initLinea = function(connectionCallback, cardCallback, barcCallback, cancelCallback, errorCallback) {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        this.results = [];
        this.connCallback = connectionCallback;
        this.cardDataCallback = cardCallback;
        this.barcodeCallback = barcCallback;
        exec(null, errorCallback, "LineaBarcode", "initDT", []);    
    }
};
           
BarcodeScanner.prototype.barcodeSetChargeDeviceOn = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "barcodeSetChargeDeviceOn", []);
    }
};

BarcodeScanner.prototype.barcodeSetChargeDeviceOff = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "barcodeSetChargeDeviceOff", []);
    }
};

BarcodeScanner.prototype.barcodeSetPassThroughSyncOn = function () { //Used for syncing, barcode scanner wont work
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "barcodeSetPassThroughSyncOn", []);
    }
};

BarcodeScanner.prototype.barcodeSetPassThroughSyncOff = function () { //Used for scanning, Lightning sync wont work
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "barcodeSetPassThroughSyncOff", []);
    }
};

BarcodeScanner.prototype.barcodeSetScanBeepOff = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        this.hasScanBeepOn = false;
        exec(function(success) { console.log(success);  }, function(error) { console.error(error);  }, "LineaBarcode", "barcodeSetScanBeepOff", []);
    }
};

BarcodeScanner.prototype.barcodeSetScanBeepOn = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        this.hasScanBeepOn = true;
        exec(function(success) { console.log(success);  }, function(error) { console.error(error);  }, "LineaBarcode", "barcodeSetScanBeepOn", []);
    }
};

BarcodeScanner.prototype.barcodeButtonEnable = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "enableBarcodeButton", []);
    }
};

BarcodeScanner.prototype.barcodeButtonDisable = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "disableBarcodeButton", []);
    }
};

BarcodeScanner.prototype.barcodeStart = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "startBarcode", []);
    }
};

BarcodeScanner.prototype.barcodeStop = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {        
        exec(null, null, "LineaBarcode", "stopBarcode", []);
    }
};

BarcodeScanner.prototype.connectionChanged = function (state) {    
    this.connCallback(state);
};

BarcodeScanner.prototype.onMagneticCardData = function (track1, track2, track3) {
    this.cardDataCallback(track1 + track2 + track3);
};

BarcodeScanner.prototype.onBarcodeData = function (rawCodesArr, type) {
    var data = processLinea(rawCodesArr, type);
    
    var result = {
        text: String(rawCodesArr),
        format: type,
        cancelled: false
    };
    
    this.barcodeCallback(result);
};  
              
module.exports = new LineaBarcode();
