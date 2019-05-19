# LUA for ESP8266, ESP32 and NodeMCU
Sample and internal modules and scripts for LUA on ESP8266 or NodeMCU

## Getting Started
It will really depend on what you are picking.
Some are designed as modules, some as scripts to be called dofile()

Make sure to read inline comments.

### Wifi Module
[sotm_wifi.lua](https://github.com/ServerOnTheMove/lua/blob/master/esp8266/src/sotm_wifi.lua)

Designed as a module, it provides basic functionality to connect to a wifi AP allowing to configure callback functions.

````
w = require("sotm_wifi")
w.setupWifiMonitor()
w.connectWIFI("TPPW4G_5F57","idolovej9",true, true)
````
 