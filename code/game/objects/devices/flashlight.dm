/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon_state = "flight0"
	w_class = 2
	item_state = "flight"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	m_amt = 50
	g_amt = 20
	var/on = 0
	var/brightness_on = 4 //luminosity when on
	var/icon_on = "flight1"
	var/icon_off = "flight0"
	var/cell
	New()
		var/obj/item/weapon/battery/B = new /obj/item/weapon/battery(src)
		cell = B

	proc/Lighting()
		update_brightness(src.loc)
		if(cell:charge <= 0)
			usr << "Battery is out."
			on = 0
			update_brightness(src.loc)
			return
		spawn()
			while(src)
				cell:charge -= 50
				if(cell:charge <= 0)
					on = !on
					update_brightness(src.loc)
					return
				if(!on)
					return
				sleep(50)

/obj/item/device/flashlight/attackby(var/obj/B, var/mob/user)
	if(istype(B ,/obj/item/weapon/battery))
		if(cell)
			user << "Battery already inserted"
		else
			src.cell =  B
			user.drop_item()
			B.loc = src
			user << "You insert battery"
	else if (istype(B, /obj/item/weapon/storage/toolbox))
		user << "You are silly? You can't insert this massive toolbox into flashlight."
	return

/obj/item/device/flashlight/verb/remove_battery()
	if(cell)
		if(on)
			usr << "Switch off the light first"
		else
			var/obj/item/weapon/battery/B = src.cell
			B.loc = src.loc.loc
			src.cell = null
	return

/obj/item/device/flashlight/initialize()
	..()
	if (on)
		icon_state = icon_on
		src.ul_SetLuminosity(brightness_on, brightness_on, 0)
	else
		icon_state = icon_off
		src.ul_SetLuminosity(0)

/obj/item/device/flashlight/examine()
	set src in usr
	usr << text("\icon[src] A hand-held emergency light. [(cell) ? "[cell:charge]/[cell:maxcharge]" : "Without cell."]")
	return

/obj/item/device/flashlight/proc/update_brightness(var/mob/user)
	if (on)
		icon_state = icon_on
		if(src.loc == user)
			user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + brightness_on, user.LuminosityBlue)
		else if (isturf(src.loc))
			ul_SetLuminosity(brightness_on, brightness_on, 0)

	else
		icon_state = icon_off
		if(src.loc == user)
			user.ul_SetLuminosity(user.LuminosityRed - brightness_on, user.LuminosityGreen - brightness_on, user.LuminosityBlue)
		else if (isturf(src.loc))
			ul_SetLuminosity(0)


/obj/item/device/flashlight/attack_self(mob/user)
//	if(!isturf(user.loc))
//		user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
//		return
	if(!on)
		if(cell)
			on = !on
			Lighting()
		else
			user << "No power."
	else
		on = !on
		update_brightness(src.loc)
	return


/obj/item/device/flashlight/attack(mob/M as mob, mob/user as mob)
	src.add_fingerprint(user)
	if(src.on && user.zone_sel.selecting == "eyes")
		if (((CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))//too dumb to use flashlight properly
			return ..()//just hit them in the head

		if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")//don't have dexterity
			usr.show_message("\red You don't have the dexterity to do this!",1)
			return

		var/mob/living/carbon/human/H = M//mob has protective eyewear
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			user << text("\blue You're going to need to remove that [] first.", ((H.head && H.head.flags & HEADCOVERSEYES) ? "helmet" : ((H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) ? "mask": "glasses")))
			return

		for(var/mob/O in viewers(M, null))//echo message
			if ((O.client && !(O.blinded )))
				O.show_message("\blue [(O==user?"You direct":"[user] directs")] [src] to [(M==user? "your":"[M]")] eyes", 1)

		if(istype(M, /mob/living/carbon/human) || istype(M, /mob/living/carbon/monkey))//robots and aliens are unaffected
			if(M.stat > 1 || M.disabilities & 128)//mob is dead or fully blind
				if(M!=user)
					user.show_message(text("\red [] pupils does not react to the light!", M),1)
			else if(XRAY in M.mutations)//mob has X-RAY vision
				if(M!=user)
					user.show_message(text("\red [] pupils give an eerie glow!", M),1)
			else //nothing wrong
				flick("flash", M.flash)//flash the affected mob
				if(M!=user)
					user.show_message(text("\blue [] pupils narrow", M),1)
	else
		return ..()


/obj/item/device/flashlight/pickup(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + brightness_on, user.LuminosityBlue)
		src.ul_SetLuminosity(0)


/obj/item/device/flashlight/dropped(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed - brightness_on, user.LuminosityGreen - brightness_on, user.LuminosityBlue)
		src.ul_SetLuminosity(src.LuminosityRed + brightness_on, src.LuminosityGreen + brightness_on, src.LuminosityBlue)


/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light. It shines as well as a flashlight."
	icon_state = "plight0"
	flags = FPRINT | TABLEPASS | CONDUCT
	item_state = ""
	icon_on = "plight1"
	icon_off = "plight0"
	brightness_on = 3
	w_class = 1



/obj/item/device/flashlight/pen/paralysis/attack(mob/M as mob, mob/user as mob)
	if(!ismob(M))
		return
	user << "\red You stab [M] with the pen."
//	M << "\red You feel a tiny prick!"
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stabbed with [src.name]  by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to stab [M.name] ([M.ckey])</font>")

	log_admin("ATTACK: [user] ([user.ckey]) stabbed [M] ([M.ckey]) with [src].")
	message_admins("ATTACK: [user] ([user.ckey])(<a href=\"byond://?src=%admin_ref%;teleto=\ref[user]\">Jump</a>) stabbed [M] ([M.ckey]) with [src].")
	log_attack("<font color='red'>[user.name] ([user.ckey]) Used the [src.name] to stab [M.name] ([M.ckey])</font>")


	..()
	return

/obj/item/device/flashlight/pen/paralysis/New()
	var/datum/reagents/R = new/datum/reagents(15)
	reagents = R
	R.my_atom = src
	R.add_reagent("zombiepowder", 15)
	..()
	return

/obj/item/device/flashlight/pen/paralysis/attack(mob/M as mob, mob/user as mob)
	if (!( istype(M, /mob) ))
		return
	..()
	if (reagents.total_volume)
		if(M.reagents) reagents.trans_to(M, 15)
	return


//Looks like most of the clothing lights are here
/obj/item/clothing/head/helmet/hardhat/attack_self(mob/user)
	if(!isturf(user.loc))
		user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
		return
	on = !on
	icon_state = "hardhat[on]_[color]"
	item_state = "hardhat[on]_[color]"

	if(on)
		user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + (brightness_on - 1), user.LuminosityBlue)
	else
		user.ul_SetLuminosity(user.LuminosityRed - brightness_on, user.LuminosityGreen - (brightness_on - 1), user.LuminosityBlue)

/obj/item/clothing/head/helmet/hardhat/pickup(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + (brightness_on - 1), user.LuminosityBlue)
		ul_SetLuminosity(0)

/obj/item/clothing/head/helmet/hardhat/dropped(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed - brightness_on, user.LuminosityGreen - (brightness_on - 1), user.LuminosityBlue)
		ul_SetLuminosity(brightness_on, brightness_on - 1, 0)

//RIG helmet light
/obj/item/clothing/head/helmet/space/rig/attack_self(mob/user)
	if(!isturf(user.loc))
		user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
		return
	on = !on
	icon_state = "rig[on]-[color]"
	item_state = "rig[on]-[color]"

	if(on)
		user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + (brightness_on - 1), user.LuminosityBlue)
	else
		user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + (brightness_on - 1), user.LuminosityBlue)

/obj/item/clothing/head/helmet/space/rig/pickup(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + (brightness_on - 1), user.LuminosityBlue)
		ul_SetLuminosity(0)

/obj/item/clothing/head/helmet/space/rig/dropped(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + (brightness_on - 1), user.LuminosityBlue)
		ul_SetLuminosity(brightness_on, brightness_on-1, 0)

// the desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp"
	icon = 'lighting.dmi'
	icon_state = "lamp0"
	brightness_on = 5
	icon_on = "lamp1"
	icon_off = "lamp0"
	w_class = 4
	flags = FPRINT | TABLEPASS | CONDUCT
	m_amt = 0
	g_amt = 0
	on = 1

// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	icon_state = "green0"
	icon_on = "green1"
	icon_off = "green0"
	desc = "A green-shaded desk lamp"

/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)


// FLARES

/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red Metropolis issued flare. There are instructions on the side, it reads 'pull cord, make light'."
	w_class = 2.0
	brightness_on = 7 // Pretty bright.
	icon_state = "flare"
	item_state = "pen"
//	action_button_name = null	//just pull it manually, neckbeard.
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500
	icon_on = "flare-on"
	icon_off = "flare-empty"

/obj/item/device/flashlight/flare/New()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	..()

/obj/item/device/flashlight/flare/process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		icon_state = "flare-empty"
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		processing_objects -= src

/obj/item/device/flashlight/flare/proc/turn_off()
	on = 0
	icon_state = "flare-empty"
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/device/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(!fuel)
		user << "<span class='notice'>It's out of fuel.</span>"
		return
	if(on)
		icon_state = "flare-on"
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message("<span class='notice'>[user] activates the flare.</span>", "<span class='notice'>You pull the cord on the flare, activating it!</span>")
		src.force = on_damage
		src.damtype = "fire"
		processing_objects += src