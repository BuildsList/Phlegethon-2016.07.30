/obj/item/clothing/head/helmet/space/engineer
	name = "environment suit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding and a visor that can be toggled on and off."
	flags = FPRINT | TABLEPASS | HEADSPACE | HEADCOVERSEYES | BLOCKHAIR
	see_face = 0.0
	flags_inv = HIDEEARS
	icon_state = "engspace_helmet"
	item_state = "engspace_helmet"
	protective_temperature = 5000
	armor = list(melee = 20, bullet = 5, laser = 10,energy = 5, bomb = 15, bio = 100, rad = 75)
	var/up = 0

/obj/item/clothing/head/helmet/space/engineer/ce
	name = "chief engineer's environment suit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding and a visor that can be toggled on and off."
	icon_state = "cespace_helmet"
	item_state = "cespace_helmet"

/obj/item/clothing/suit/space/engineer
	name = "environment suit"
	desc = "An environment suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "engspace_suit"
	item_state = "engspace_suit"
	protective_temperature = 5000 //For not dieing near a fire, but still not being great in a full inferno
	slowdown = 2
	armor = list(melee = 20, bullet = 5, laser = 10,energy = 5, bomb = 15, bio = 100, rad = 75)
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank, /obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer)
	//yes, you can fit everything and your dog in it.
	//i figure this might mitigate some of the inevitable bitching about it being a downgrade from the rig.

/obj/item/clothing/suit/space/engineer/ce
	name = "chief engineer's environment suit"
	desc = "An environment suit that protects against hazardous, low pressure environments. Has radiation shielding and Chief Engineer colours."
	icon_state = "cespace_suit"
	item_state = "cespace_suit"

/obj/item/clothing/head/helmet/space/minerplate
	name = "battle environment helmet"
	desc = "A special battle helmet designed for fight in a hazardous, low-pressure environment"
	flags = FPRINT | TABLEPASS | HEADSPACE | HEADCOVERSEYES | BLOCKHAIR
	flags_inv = HIDEEARS
	icon_state = "minerplate"
	item_state = "minerplate"
	protective_temperature = 5000
	armor = list(melee = 50, bullet = 70, laser = 60,energy = 60, bomb = 50, bio = 20, rad = 60)

/obj/item/clothing/suit/space/minercoat
	name = "battle environment coat"
	desc = "An battle environment coat that protects against hazardous, low pressure environments. Has antiradiation liner."
	icon_state = "minercoat"
	item_state = "minercoat"
	protective_temperature = 5000 //For not dieing near a fire, but still not being great in a full inferno
	armor = list(melee = 20, bullet = 10, laser = 5,energy = 5, bomb = 15, bio = 100, rad = 75)
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy, /obj/item/weapon/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs)