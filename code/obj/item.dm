/obj/item
	name = "item"
	var/icon_old = null//For when weapons get bloodied this saves their old icon.
	var/abstract = 0
	var/item_state = null
	var/damtype = "brute"
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	var/hitsound = null
	var/w_class = 3.0
	var/wielded = 0
	var/twohanded = 0 ///Two handed and wielded off by default, nyoro~n -Agouri
	var/force_unwielded = 0
	var/force_wielded = 0
	flags = FPRINT | TABLEPASS
	pass_flags = PASSTABLE
	pressure_resistance = 50
//	causeerrorheresoifixthis
	var/obj/item/master = null