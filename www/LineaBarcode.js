var argscheck = require('cordova/argscheck'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');
              
function LineaBarcode() {
    this.results = [];
    this.connCallback = null;
    this.errorCallback = null;
    this.cardDataCallback = null;
    this.barcodeCallback = null;    
}

LineaBarcode.prototype.initLinea = function (connectionCallback, cardCallback, barcCallback, cancelCallback, successCallback, errorCallback) {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        this.results = [];
        this.connCallback = connectionCallback;
        this.cardDataCallback = cardCallback;
        this.barcodeCallback = barcCallback;
        exec(successCallback, errorCallback, "LineaBarcode", "initLinea", []);        
    }    
};
           
LineaBarcode.prototype.barcodeSetChargeDeviceOn = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "barcodeSetChargeDeviceOn", []);
    }
};

LineaBarcode.prototype.barcodeSetChargeDeviceOff = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "barcodeSetChargeDeviceOff", []);
    }
};

LineaBarcode.prototype.barcodeSetPassThroughSyncOn = function () { //Used for syncing, barcode scanner wont work
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "barcodeSetPassThroughSyncOn", []);
    }
};

LineaBarcode.prototype.barcodeSetPassThroughSyncOff = function () { //Used for scanning, Lightning sync wont work
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "barcodeSetPassThroughSyncOff", []);
    }
};

LineaBarcode.prototype.barcodeSetScanBeepOff = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        this.hasScanBeepOn = false;
        exec(function(success) { console.log(success);  }, function(error) { console.error(error);  }, "LineaBarcode", "barcodeSetScanBeepOff", []);
    }
};

LineaBarcode.prototype.barcodeSetScanBeepOn = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        this.hasScanBeepOn = true;
        exec(function(success) { console.log(success);  }, function(error) { console.error(error);  }, "LineaBarcode", "barcodeSetScanBeepOn", []);
    }
};

LineaBarcode.prototype.barcodeButtonEnable = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "enableBarcodeButton", []);
    }
};

LineaBarcode.prototype.barcodeButtonDisable = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "disableBarcodeButton", []);
    }
};

LineaBarcode.prototype.barcodeStart = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {
        exec(null, null, "LineaBarcode", "startBarcode", []);
    }
};

LineaBarcode.prototype.barcodeStop = function () {
    if (cordova.platformId.toUpperCase() === 'IOS') {        
        exec(null, null, "LineaBarcode", "stopBarcode", []);
    }
};

LineaBarcode.prototype.connectionChanged = function (state) {    
    this.connCallback(state);
};

LineaBarcode.prototype.onMagneticCardData = function (track1, track2, track3) {
    this.cardDataCallback(track1 + track2 + track3);
};

LineaBarcode.prototype.onBarcodeData = function (rawCodesArr, type) {
    var data = processLinea(rawCodesArr, type);
    
    var result = {
        text: String(rawCodesArr),
        format: type,
        cancelled: false
    };
    
    this.barcodeCallback(result);
};  
              
module.exports = new LineaBarcode();
