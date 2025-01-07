local backend = dofile("backend.lua")

components = {
    "EEPROM (Lua BIOS)",
    "Graphics Card (Tier 1)",
    "Screen (Tier 1)", 
    "Disk Drive", 
    "Keyboard", 
    "Inventory Upgrade",

    "Computer Case (Tier 3)",
    "Memory (Tier 2)",
    "Hard Disk Drive (Tier 2) (2MB)",
    "Central Processing Unit (CPU) (Tier 3)",
    "Inventory Controller Upgrade",
    "Tractor Beam Upgrade",

    "Experience Upgrade",
    "Battery Upgrade (Tier 3)"
}

backend.start_assembling(components)