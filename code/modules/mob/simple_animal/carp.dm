#define CARP_STANCE_IDLE 1
#define CARP_STANCE_ATTACK 2
#define CARP_STANCE_ATTACKING 3

/mob/living/simple_animal/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon = 'critter.dmi'
	icon_state = "spesscarp"
	icon_living = "spesscarp"
	icon_dead = "spesscarp_dead"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	maxHealth = 25
	health = 25

	harm_intent_damage = 8
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "bites"
	attack_sound = 'bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0		//so they don't freeze in space
	maxbodytemp = 295	//if it's just 25 degrees, they start to burn up

	var/stance = CARP_STANCE_IDLE	//Used to determine behavior
	var/stance_step = 0				//Used to delay checks depending on what stance the bear is in
	var/mob/living/target_mob		//Once the bear enters attack stance, it will try to chase this mob. This it to prevent it changing it's mind between multiple mobs.

/mob/living/simple_animal/carp/elite
	desc = "A ferocious, fang-bearing creature that resembles a fish. It has an evil gleam in its eye."
	maxHealth = 50
	health = 50
	melee_damage_lower = 10
	melee_damage_upper = 20

/proc/iscarp(var/mob/M)
	return istype(M, /mob/living/simple_animal/carp)

/mob/living/simple_animal/carp/Life()
	..()

	if(!stat)
		switch(stance)
			if(CARP_STANCE_IDLE)
				stop_automated_movement = 0
				stance_step++
				if(stance_step > 5)
					stance_step = 0
					for( var/mob/living/L in viewers(7,src) )
						if(iscarp(L)) continue
						if(!L.stat)
							emote("gnashes at [L]")
							stance = CARP_STANCE_ATTACK
							target_mob = L
							break

			if(CARP_STANCE_ATTACK)	//This one should only be active for one tick
				stop_automated_movement = 1
				if(!target_mob || target_mob.stat)
					stance = CARP_STANCE_IDLE
					stance_step = 5 //Make it very alert, so it quickly attacks again if a mob returns
				if(target_mob in viewers(7,src))
					walk_to(src, target_mob, 1, 3)
					stance = CARP_STANCE_ATTACKING
					stance_step = 0

			if(CARP_STANCE_ATTACKING)
				stop_automated_movement = 1
				stance_step++
				if(!target_mob || target_mob.stat)
					stance = CARP_STANCE_IDLE
					stance_step = 3 //Make it very alert, so it quickly attacks again if a mob returns
					target_mob = null
					walk(src,0)
					return
				if(!(target_mob in viewers(7,src)))
					stance = CARP_STANCE_IDLE
					stance_step = 1
					target_mob = null
					walk(src,0)
					return
				if(get_dist(src, target_mob) <= 1)	//Attacking
					if(isliving(target_mob))
						var/mob/living/L = target_mob
						L.attack_animal(src)
						if(prob(10))
							L.Weaken(5)
							L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")


/mob/living/simple_animal/carp/Die()
	..()
	target_mob = null
	stance = CARP_STANCE_IDLE
	walk(src,0)

/mob/living/simple_animal/carp/Process_Spacemove(var/check_drift = 0)
	return	//No drifting in space for space carp!	//original comments do not steal





/mob/living/simple_animal/carp/wolf
	name = "Hound"
	desc = "A big and powerful dog."
	icon = 'critter.dmi'
	icon_state = "wolf"
	icon_living = "wolf"
	icon_dead = "wolf-dead"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/sliceable/meat/corgi
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	maxHealth = 80
	health = 80

	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "bites"
	attack_sound = 'doggrowl.ogg'
