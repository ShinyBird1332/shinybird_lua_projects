local component = require("component")
local event = require("event")
local unicode = require("unicode")
local term = require("term")
local sides = require("sides")
local gpu = component.gpu
local me_exportbus = component.me_exportbus
local me_interface = component.me_interface
local database = component.database
local trans = component.transposer

local side_trans = sides.north
local side_me_bus = sides.west 
local db_slot = 1 
local me_bus_slot = 1 

