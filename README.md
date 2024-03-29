#  UWB-based precision ranging 

## Introduction

Refer to my medium post for complete details and demo video: 

https://medium.com/@JayMuthialu/uwb-based-hands-free-technology-basics-to-advanced-part-2-612f3b5d7fb8

## Video Demo



https://github.com/jmuthialu/UWBPrecisionRanging/assets/10758530/b304c419-2651-418f-8a68-78789661bd1c



## How does this work?

### 1 - Establish BLE data link
- Scan for peripherals and connect to UWB using its UDID. This is advertised by the beacon.
- Connect to this peripheral and set notification for `tx Characterisrics`.
- Publish `accessoryReadyPublisher` event.

### 2 - Establish connection with UWB
- Subscriber to `accessoryReadyPublisher` will send `initialize` command to accessory.
- Accessory sends configuration data and sends `accessoryConfigurationData` command.
- Device (iPhone) receives config data and creates NISession.
- Runs NISession with `accessoryConfigurationData` and this generates shared config data.
- Send shared config data in delegate method `didGenerateShareableConfigurationData`.
- On receipt of shared config data, accessory will update its configuration.
- Accessory starts sending distance information to device. 
- Device gets the distance through delegete method `didUpdate nearbyObjects`.






