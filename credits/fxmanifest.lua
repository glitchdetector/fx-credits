name "Credits System"
author "glitchdetector"
contact "glitchdetector@gmail.com"
version "1.0"

description "Allows detailed descriptions and credits for individual resources"
usage [[
    Add credit fields to your resource manifest
    Shows credits in the server console when resources are started
    Adds a /credits command for both clients and the console
    Adds an endpoint for the resource so credits can be viewed and fetched online
]]

fx_version 'common'
server_only 'yes'

server_script 'sv_credits.lua'
