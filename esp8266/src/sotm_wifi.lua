--[[
    sotm Wifi module for internal projects
    18 May 2019 
    Author: dante@serveronthemove.com.au
    Version: 1.0

    Implementation:
        We recommend to compile the code where credentials are used - either as default or as arguments in functions

    Hardware:
        nodeMCU ESP8266(EX) Devkit V3
    ESP8266 Modules:
        net,node,wifi,tls

    nodeMCU Firmware Build
        built against the Lua 5.1.4 on SDK 2.2.1
        includes the following modules: net,node,wifi,tls
    
    License (MIT License)
        Copyright (C) 2019 Server On The Move 

        This module is free software distributed under the terms of the MIT license reproduced here.
        Permission is hereby granted, free of charge, to any person obtaining a copy of this software
         and associated documentation files (the "Software"), to deal in the Software without restriction,
         including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
         and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
         subject to the following conditions:

            The above copyright notice and this permission notice shall be included in all copies or substantial
            portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
        LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
        WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
        SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- define module
local sotmWifi = {}

--[[ Constant Setup ]]--
local AP_SSID = "YOUR_WIFI_SSID"    -- WIFI SSID
local AP_PWD = "YOUR_WIFI_PASSWORD" -- WIFI Pasword

print( "WiFi Connect/Lua Simple on ESP2886 by SOTM 1.0" )

--[[  Function Setup ]]
--// Setup Wifi Monitoring events
--//    call this function as early in your init.lua to ensure events are not missed
--//    pCBConnect  CallBack function once connceted to AP
--//    pCBGotIP    CallBack function once got an IP
--//
--//    Note: CB do not take arguments in this version
--//    2DO: Add Monitoring events for other wifi.eventmon events
--//
function sotmWifi.setupWifiMonitor(pCBConnect, pCBGotIP)
    print( "Setting up WIFI Monitoring events - start" )

    -- register events
    wifi.eventmon.register(
        wifi.eventmon.STA_CONNECTED,
        function(T)
            print("\n\tAP - CONNECTED" .. "\n\tSSID: " .. T.SSID .. "\n\tBSSID: " .. T.BSSID .. "\n\tChannel: " .. T.channel)
            if ( pCBConnect ~= nil ) then pCBConnect() end
        end
    )

    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,
        function(T)
            print("\n\tAP - IP ASSIGNED" .. "\n\tIP: " .. T.IP .. "\n\tNetmask: " .. T.netmask .. "\n\tGateway: " .. T.gateway)
            if ( pCBGotIP ~= nil ) then pCBGotIP() end
        end
    )
    print( "Setting up WIFI Monitoring events - end" )
end

--// Setup Wifi Connectivity
--//    will not try to connect (does not have an IP) if already connected.
--//    pSSID       SSID to connect to, if nil or not provided, default to local
--//    pPWD        PWD to use for connection, if null or not provided, default to lcoal
--//    pSave       Save config for next reboot, default = false
--//    pAuto       Automatically reconnect on next reboot
--//
function sotmWifi.connectWIFI( pSSID, pPWD, pSave, pAuto)
    print( "Connecting WIFI - begin" )
    -- setup defaults from this module
    pSSID = pSSID or AP_SSID
    pPWD  = pPWD or AP_PWD

    -- when not connected setup WIFI
    if ( wifi.sta.status() ~= wifi.STA_GOTIP ) then
        -- not an IP, assume not connected, connect
        print( "Configuring WIFI" )
        wifi.setmode( wifi.STATION, true )
        -- setup event for when connected and has IP
    end

    -- setup configuration for connect
    local ap_cfg = {}
    ap_cfg.ssid = pSSID
    ap_cfg.pwd = pPWD
    ap_cfg.save = pSave
    ap_cfg.auto = pAuto

    wifi.sta.config( ap_cfg )

    print( "Connecting WIFI - end .. wait for connection to complete\nConsider setting using setupWifiMonitor" )
end

return sotmWifi