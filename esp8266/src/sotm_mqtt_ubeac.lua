--[[
    sotm mqtt module sample with ubeac.io
    18 May 2019
    Author: dante@serveronthemove.com.au
    Version: 0.1

    Implementation:
        This sample was implemented to integrate with ubeac.io
        Other IoT platforms can be used. Payload might need to be adapted.

        We recommend to compile the code where credentials are used - either as default or as arguments in functions

    IoT Plaform:
        https://ubeac.io

    Hardware:
        nodeMCU ESP8266(EX) Devkit V3

    ESP8266 Modules:
        net,node,wifi,tls

    nodeMCU Firmware Build
        built against the Lua 5.1.4 on SDK 2.2.1
        includes the following modules: net,node,wifi,tls,mqtt

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
local sotmMQTTubeac = {}

print( "MQTT Connect/Lua, ubeac.io on ESP2886 by SOTM 0.2" )

--[[ Constant Setup - Defaults ]]--
local defGatewayUID = "<GATEWAYUID>"        -- the UID of the gateway take from the Gateway URL: hub.ubeac.io/<GATEWAYUID>
local defDeviceUID  = "<DEVICEUID>"         -- the UID of your device, not the name
local defSensorUID  = "<SENSORUID>"         -- the UID of the sensor which reporting data, not the name
local defMQTTUserID = "<USERID>"            -- default default username
local defMQTTPass   = "<PASSWORD>"          -- default password
local defMQTTKeepA  = 120                   -- default keepalive is 2 minutes
local defMQTTTopic  = "myTopic"             -- default topic
local defCleanSess  = 1                     -- default - yes, clean session
local defTgtHost    = "mqtt://hub.ubeac.io" -- target host (broker)
local defTgtPort    = 1883			        -- target port (broker listening on)
local defMaxMsgLen  = 1024                  -- maximum message length

--[[ module variables and Setter/Getter Setup ]]--
local mqttClient = {}
function sotmMQTTubeac.setMQTTClient (pMQTTClient)
    mqttClient = pMQTTClient
end

function sotmMQTTubeac.getMQTTClient ()
    return mqttClient
end


--[[  Function Setup ]]
--// Make connection with MQTT endpoint
--//    will not try to connect if already connected
--//

function sotmMQTTubeac.createClient ( pGatewayUID, pMQTTKeepA, pMQTTUserID, pMQTTPass, pCleanSess, pMaxMesgLen, pSetupDefCB )

    -- defaults
    pGatewayUID = pGatewayUID or defGatewayUID
    pMQTTKeepA  = pMQTTKeepA or defMQTTKeepA
    pMQTTUserID = pMQTTUserID or defMQTTUserID
    pMQTTPass   = pMQTTPass or defMQTTPass
    pCleanSess  = pCleanSess or defCleanSess
    pMaxMesgLen = pMaxMesgLen or defMaxMsgLen

    -- Instantiate a global MQTT client object
    print( "Instantiating mqttBroker -- begin" )
    mqttClient = mqtt.Client( pGatewayUID, pMQTTKeepA, pMQTTUserID, pMQTTPass, pCleanSess, pMaxMesgLen )
    print( "Instantiating mqttBroker -- end" )

    -- Set up the event callbacks if requested
    if (pSetupDefCB) then
        print( "Setting up callbacks -- begin" )
        mqttClient:on( "connect",
                function(pClient, pTopic, pMessage)
                    print( "Client Connected - Topic: " .. pTopic .. " Mesg: " .. pMessage)
                end
        )
        mqttClient:on("offline",
                function(pClient, pTopic, pMessage)
                    print("Client offline - Topic: " .. pTopic .. " Mesg: " .. pMessage)
                end
        )
        mqttClient:on("message",
                function(pClient, pTopic, pMessage)
                    print("Message - Topic: " .. pTopic .. " Mesg: " .. pMessage)
                end
        )
        mqttClient:on("message",
                function(pClient, pTopic, pMessage)
                    print("Message - Topic: " .. pTopic .. " Mesg: " .. pMessage)
                end
        )
        mqttClient:on("overflow",
                function(pClient, pTopic, pMessage)
                    print("overflow - Topic: " .. pTopic .. " Mesg: " .. pMessage)
                end
        )
        print( "Setting up callbacks -- end" )
    end

    return mqttClient
end

--// Make connection with MQTT endpoint
--//    will not try to connect if already connected
--//

function sotmMQTTubeac.connect( pMQTTClient, pTgtHost, pTgtPort, pSecure, pCBConnect, pCBFail )
    print("Making connection to MQTT broker - begin")

    -- default
    pMQTTClient = pMQTTClient or mqttClient
    pTgtHost = pTgtHost or defTgtHost
    pTgtPort = pTgtPort or defTgtPort
    pSecure = pSecure or 0

    connectSuccess = pMQTTClient:connect(pTgtHost, pTgtPort, pSecure,
            function(pClient)
                print ("Client connected")
                if ( pCBConnect ~= nil ) then pCBConnect() end
            end,
            function(client, reason)
                print("failed reason: "..reason)
                if ( pCBFail ~= nil ) then pCBFail() end
            end
    )
    print("Making connection to MQTT broker - end. Wait until client is connected or use Callback")
end

--// Make connection with MQTT endpoint
--//    will not try to connect if already connected
--//

function sotmMQTTubeac.publishSingleSensor( pMQTTClient, pMQTTTopic, pSensorUID, pType, pUnit, pPrefix, pData)
    print("Publishing message - begin")

    -- default
    pMQTTClient = pMQTTClient or mqttClient
    pMQTTTopic  = pMQTTTopic or defMQTTTopic
    pSensorUID  = pSensorUID or defSensorUID

    local lJSON = "[{ \"uid\": \""  .. pSensorUID .. "\", \"Type\": " .. pType .. ", \"unit\": " ..
            pUnit .. ", \"prefix\": " .. pPrefix .. ", \"data\": " .. pData .. "}]"

    mqttClient:publish("myTopic", lJSON, 0, 0)	-- publish

    print("Publishing message - end")
end

return sotmMQTTubeac

