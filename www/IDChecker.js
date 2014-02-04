/*
 *
*/

var argscheck = require('cordova/argscheck'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');

/**
  * pass in required arguments for the client
 */
function IDChecker(agent, apiToken, clientRef, password, userId, cameraHelpText) {
  var me = this;
  var callback = function() {};
  exec(callback, callback, 'CDVIDChecker', 'initializeClientCredentials', [ agent, apiToken, clientRef, password, userId, cameraHelpText ]); 
};

/**
  * Get the scanned document. 
  * type must be one of "Passport", "DriversLicense", or "2DBarCode".  Country is a 2 letter country code
 */
IDChecker.prototype.captureCredentials: function(success, failure, country, type) {
    exec(success, failure, 'CDVIDChecker', 'captureCredentials', [country, type]);
};

module.exports = IDChecker;

