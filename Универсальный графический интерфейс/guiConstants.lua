local guiConstants = {}

guiConstants.comp = require("component")
guiConstants.event = require("event")
guiConstants.unicode = require("unicode")
guiConstants.term = require("term")
guiConstants.serialization = require("serialization")

guiConstants.gpu = guiConstants.comp.gpu

guiConstants.w, guiConstants.h = guiConstants.gpu.getResolution()

guiConstants.colors = {
    red = 0x940000,
    white = 0xFFFFFF,
    black = 0x000000,
    green = 0x086300,
    gray = 0x7a7a7a,
    yellow = 0xc29800
}

return guiConstants
