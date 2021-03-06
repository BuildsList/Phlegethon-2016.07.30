/obj/item/weapon/secstorage/ssafe
	name = "secure safe"
	icon = 'storage.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	flags = FPRINT | TABLEPASS
	force = 8.0
	w_class = 8.0
	internalstorage = 8
	anchored = 1.0
	density = 0

/obj/item/weapon/secstorage/ssafe/New()
	..()
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/pen(src)

/obj/item/weapon/secstorage/ssafe/HoS/New()
	..()
	new /obj/item/weapon/storage/lockbox/clusterbang(src)

/obj/item/weapon/secstorage/ssafe/Sheriff/New()

	src.l_code = num2text(rand(10,99))
	src.l_set = 1
	src.locked = 1

	..()
	new /obj/item/weapon/gun/projectile/handy(src)
	new /obj/item/ammo_magazine/c45s_handy_mag(src)

/obj/item/weapon/secstorage/ssafe/attack_hand(mob/user as mob)
	return attack_self(user)