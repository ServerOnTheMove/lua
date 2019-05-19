# LUA for ESP8266, ESP32 and NodeMCU
Sample and internal modules and scripts for LUA on ESP8266 or NodeMCU

## Getting Started
It will really depend on what you are picking.
Some are designed as modules, some as scripts to be called dofile()

Make sure to read inline comments.

### Wifi Module
[sotm_wifi.lua](sotm_wifi.lua)

Designed as a module, it provides basic functionality to connect to a wifi AP allowing to configure callback functions.

````
w = require("sotm_wifi")
w.setupWifiMonitor()
w.connectWIFI("TPPW4G_5F57","idolovej9",true, true)
````
 
 ### MQTT on ubeac.io
 [sotm_mqtt_ubeac.lua](sotm_mqtt_ubeac.lua)
 
 Desgined as a module to simplify integration with ubeac.io IoT Platform
 Functions for
 * Single Device, Single Sensor (in development)
 * Single Device, Multiple Sensor (TBA)
 * Multiple Device, Multiple Sensor (TBA)
 
 ````
 m = require("sotm_mqtt_ubeac")
 m.createClient("<gatwayid>", 120, "<usenname>", "<password>", 1, 1024, true)
 m.connect(nil, "mqtt://hub.ubeac.io", 1883, 0)
 m.publishSingleSensor(nil, "defTopic", "SOTM-NodeMCU001-TEMP001", 4, 1, 0, 20)
 ````