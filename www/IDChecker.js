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
};

/**
  * Get the scanned document. 
  * type must be one of "Passport", "DriversLicense", or "2DBarCode".  Country is a 2 letter country code
 */
IDChecker.prototype = {
  failure: function(msg) {
    console.log('IDChecker error: ' + msg);
  },

  call_native: function (callback, name, args) {
    if(arguments.length == 2) {
      args = []
    }
    ret = exec(
      callback, // called when signature capture is successful
      this.failure, // called when signature capture encounters an error
      'CDVIDChecker', // Tell cordova that we want to run "PushNotificationPlugin"
      name, // Tell the plugin the action we want to perform
      args); // List of arguments to the plugin

    return ret;
  },
  
  captureCredentials: function(successCallback, country, type) {
    this.call_native(successCallback, "captureCredentials", [country, type]);
  }
};

module.exports = new IDChecker();

