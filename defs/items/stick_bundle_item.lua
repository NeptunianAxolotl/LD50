local def = {
	image = "stick_bundle_item_inventory",
	dropAs = "stick",
	desc = "An extremely flammable bundle of sticks.",
	dropMult = Global.STICK_BUNDLE,
	burnValue = Global.STICK_FUEL * Global.STICK_BUNDLE * Global.RESOURCE_FUEL_MULT,
	boostValue = Global.STICK_FUEL_BOOST * Global.STICK_BUNDLE * Global.RESOURCE_BOOST_FUEL_MULT,
}

return def
