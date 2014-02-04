/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */


var app = {
  // Application Constructor
  initialize: function() {
    this.bindEvents();
  },
  // Bind Event Listeners
  //
  // Bind any events that are required on startup. Common events are:
  // 'load', 'deviceready', 'offline', and 'online'.
  bindEvents: function() {
    document.addEventListener('deviceready', this.onDeviceReady, false);
  },
  // deviceready Event Handler
  //
  // The scope of 'this' is the event. In order to call the 'receivedEvent'
  // function, we must explicity call 'app.receivedEvent(...);'
  onDeviceReady: function() {
    app.receivedEvent('deviceready');
      var x = document.getElementById('firstName');
      x.innerHTML = 'FOO BAR FOO';
  
    cordova.exec(function(){}, function() {}, 'CDVIDChecker', 'initializeClientCredentials',
                 ['HelloBit', 'YU6R6-JTFPX-HBPAB', 'HelloBit', 'B8it6Wi2s2e', '2286', 'Place ID Here']);
    
    cordova.exec(
      // Register the callback handler
      function callback(data) {
        //alert('got data ' + Object.keys(data));
        //alert(data.origPhoto);
                   
        var nameElement = document.getElementById('firstName');
        var originalImageElement = document.getElementById('originalImage');
        var processedImageElement = document.getElementById('processedImage');
        nameElement.innerHTML = data.firstName;
        originalImageElement.setAttribute('src', 'data:image/png;base64,' + data.origPhoto);
        processedImageElement.setAttribute('src', 'data:image/png;base64,' + data.processedPhoto);
      },
      // Register the errorHandler
      function errorHandler(err) {
        alert('Error: ' + err);
      },
      // Define what class to route messages to
      'CDVIDChecker',
      // Execute this method on the above class
      'captureCredentials',
      // An array containing one String (our newly created Date String).
      [ "US", "DriversLicense" ]
    );
    
  },
  // Update DOM on a Received Event
  receivedEvent: function(id) {
    var parentElement = document.getElementById(id);
    var listeningElement = parentElement.querySelector('.listening');
    var receivedElement = parentElement.querySelector('.received');

    listeningElement.setAttribute('style', 'display:none;');
    receivedElement.setAttribute('style', 'display:block;');

    console.log('Received Event: ' + id);
  }
};
