/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"


	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, 1, 1)
		return 1


/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	flag = "bullet"
	New()
		damage = roll("6d20")

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"
	var/temperature = 300


	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = temperature
		return 1

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/M = target
		if(istype(target, /mob/living) && M:mutantrace == "plant") //Plantmen possibly get mutated and damaged by the rays.
			var/mob/living/L as mob
			if(prob(15))
				L.apply_effect((rand(30,80)),IRRADIATE)
				L.Weaken(5)
				for (var/mob/V in viewers(src))
					V.show_message("\red [M] writhes in pain as \his vacuoles boil.", 3, "\red You hear the crunching of leaves.", 2)
			if(prob(35))
			//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
			//		V.show_message("\red [M] is mutated by the radiation beam.", 3, "\red You hear the snapping of twigs.", 2)
				if(prob(80))
					randmutb(M)
					domutcheck(M,null)
				else
					randmutg(M)
					domutcheck(M,null)
			else
				M.adjustFireLoss(rand(5,15))
				M.show_message("\red The radiation beam singes you!")
			//	for (var/mob/V in viewers(src))
			//		V.show_message("\red [M] is singed by the radiation beam.", 3, "\red You hear the crackle of burning leaves.", 2)
		else if(istype(target, /mob/living/carbon/))
		//	for (var/mob/V in viewers(src))
		//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
			M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
		else
			return 1

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/M = target
		if(istype(target, /mob/living/carbon/human) && M:mutantrace == "plant") //These rays make plantmen fat.
			if(M.nutrition < 500) //sanity check
				M.nutrition += 30
		else if (istype(target, /mob/living/carbon/))
			M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
		else
			return 1

/obj/item/projectile/energy/plasma
	name ="unstable plasma clot"
	icon_state= "plasma"
	damage = 50
	damage_type = BURN
	flag = "energy"


	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1


/obj/item/projectile/bullet/lead
	name ="lead"
	icon_state= "lead"
	damage_type = BRUTE
	nodamage = 0
	flag = "bullet"
	New()
		damage = roll("4d10")
	on_hit(var/mob/living/carbon/human/H, var/blocked = 0)
		if(istype(H, /mob/living/carbon/human))
			var/damage = roll("2d6")
			H.apply_damage(damage, BRUTE, pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm"))
			H.apply_damage(damage, BRUTE, pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm"))
			H.apply_damage(damage, BRUTE, pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm"))
			H.apply_damage(damage, BRUTE, pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm"))
			H.apply_damage(damage, BRUTE, pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm"))
			H.apply_damage(damage, BRUTE, pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm"))

			var/datum/organ/external/EO1 = H.organs[pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm")]
			EO1.btrauma += rand(1,4)

			var/datum/organ/external/EO2 = H.organs[pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm")]
			EO2.btrauma += rand(1,4)

			var/datum/organ/external/EO3 = H.organs[pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm")]
			EO3.btrauma += rand(1,4)

		return 1
