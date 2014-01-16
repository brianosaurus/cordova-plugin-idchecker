/*
 *
*/

var argscheck = require('cordova/argscheck'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');

/**
 */
function IDChecker() {
  var me = this;
  this.serviceName = "IDCheckerSDK";
};

/**
  * Get the scanned document. 
  * type must be one of "Passport", "DriversLicense", or "2DBarCode".  Country is a 2 letter country code
 */
IDChecker.prototype.captureCredentials = function(successCallback, errorCallback, country, type) {
  exec(successCallback, errorCallback, "IDChecker", "captureCredentials", [country, type]);
};

module.exports = IDChecker;
