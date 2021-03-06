/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null)
	var/param = null

	if(!emote_allowed && usr == src)
		usr << "You are unable to emote."
		return

	if(mutantrace == "zombie")
		usr << "You are unable to emote."
		return

	if (findtext(act, " ", 1, null))
		var/t1 = findtext(act, " ", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	//var/m_type = 1

	for(var/named in organs)
		var/datum/organ/external/F = organs[named]
		for (var/obj/item/weapon/implant/I in F.implant)
			if (I.implanted)
				I.trigger(act, src)

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	if(src.stat != 2.0 && act == "deathgasp" && !src.mind.special_role == "Syndicate")
		src << "You are not dead.  No."
		return
	switch(act)
		if ("airguitar")
			if (!src.restrained())
				message = "<B>[src]</B> is strumming the air and headbanging like a safari chimp."
				m_type = 1

		if ("blink")
			message = "<B>[src]</B> blinks."
			m_type = 1

		if ("blink_r")
			message = "<B>[src]</B> blinks rapidly."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> bows to [param]."
				else
					message = "<B>[src]</B> bows."
			m_type = 1

		if ("custom")
			m_type = 0
			if(copytext(param,1,2) == "v")
				m_type = 1
			else if(copytext(param,1,2) == "h")
				m_type = 2
			else
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
			if(m_type)
				param = trim(copytext(param,2))
			else
				param = trim(param)
			var/input
			if(!param)
				input = copytext(sanitize(input("Choose an emote to display.") as text|null),1,MAX_MESSAGE_LEN)
			else
				input = param
			if(input)
				message = "<B>[src]</B> [input]"
			else
				return
		if ("me")
			if(silent)
				return
			if (src.client && (client.muted || client.muted_complete))
				src << "You are muted."
				return
			if (stat)
				return
			if(!(message))
				return
			else
				if(cmptext(copytext(message, 1, 3), "v "))
					message = "<B>[src]</B> [copytext(message, 3)]"
					m_type = 1
				else if(cmptext(copytext(message, 1, 3), "h "))
					message = "<B>[src]</B> [copytext(message, 3)]"
					m_type = 2
				else
					message = "<B>[src]</B> [message]"

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> salutes to [param]."
				else
					message = "<B>[src]</b> salutes."
			m_type = 1

		if ("choke")
			if (!muzzled)
				message = "<B>[src]</B> chokes!"
				m_type = 2
			else
				message = "<B>[src]</B> makes a strong noise."
				m_type = 2

		if ("clap")
			if (!src.restrained())
				playsound(usr.loc, pick('clap1.ogg','clap2.ogg'), 60, 1)
				message = "<B>[src]</B> claps."
				m_type = 2
				emote_allowed = 0
				sleep(10)
				emote_allowed = 1
		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps his wings."
				m_type = 2

		if ("aflap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps his wings ANGRILY!"
				m_type = 2

		if ("drool")
			message = "<B>[src]</B> drools."
			m_type = 1

		if ("eyebrow")
			message = "<B>[src]</B> raises an eyebrow."
			m_type = 1

		if ("chuckle")
			if (!muzzled)
				message = "<B>[src]</B> chuckles."
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("twitch")
			message = "<B>[src]</B> twitches violently."
			m_type = 1

		if ("twitch_s")
			message = "<B>[src]</B> twitches."
			m_type = 1

		if ("faint")
			message = "<B>[src]</B> faints."
			if(src.sleeping)
				return //Can't faint while asleep
			src.sleeping += 10 //Short-short nap
			m_type = 1

		if ("cough")
			if (!muzzled)
				message = "<B>[src]</B> coughs!"
				m_type = 2
				call_sound_emote("cough")
				emote_allowed = 0
				sleep(10)
				emote_allowed = 1
			else
				message = "<B>[src]</B> makes a strong noise."
				m_type = 2

		if ("frown")
			message = "<B>[src]</B> frowns."
			m_type = 1

		if ("nod")
			message = "<B>[src]</B> nods."
			m_type = 1

		if ("blush")
			message = "<B>[src]</B> blushes."
			m_type = 1

		if ("wave")
			message = "<B>[src]</B> waves."
			m_type = 1

		if ("gasp")
			if (!muzzled)
				message = "<B>[src]</B> gasps!"
				m_type = 2
			else
				message = "<B>[src]</B> makes a weak noise."
				m_type = 2

		if ("breathe")
			message = "<B>[src]</B> breathes."
			m_type = 1
			holdbreath = 0

		if ("stopbreath")
			message = "<B>[src]</B> stops breathing..."
			m_type = 1

		if ("holdbreath")
			message = "<B>[src]</B> stops breathing..."
			m_type = 1
			holdbreath = 1

		if ("deathgasp")
			message = "<B>[src]</B> seizes up and falls limp, \his eyes dead and lifeless..."
			m_type = 1

		if ("giggle")
			if (!muzzled)
				message = "<B>[src]</B> giggles."
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> glares at [param]."
			else
				message = "<B>[src]</B> glares."

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> stares at [param]."
			else
				message = "<B>[src]</B> stares."

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> look at [param]."
			else
				message = "<B>[src]</B> look."
			m_type = 1

		if ("grin")
			message = "<B>[src]</B> grins."
			m_type = 1

		if ("cry")
			if (!muzzled)
				message = "<B>[src]</B> cries."
				m_type = 2
				call_sound_emote("cry")
				emote_allowed = 0
				sleep(10)
				emote_allowed = 1
			else
				message = "<B>[src]</B> makes a weak noise. \He frowns."
				m_type = 2

		if ("sigh")
			if (!muzzled)
				message = "<B>[src]</B> sighs."
				m_type = 2
				call_sound_emote("sigh")
				emote_allowed = 0
				sleep(10)
				emote_allowed = 1
			else
				message = "<B>[src]</B> makes a weak noise."
				m_type = 2

		if ("laugh")
			if (!muzzled)
				message = "<B>[src]</B> laughs."
				m_type = 2
				call_sound_emote("laugh")
				emote_allowed = 0
				sleep(10)
				emote_allowed = 1
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("mumble")
			message = "<B>[src]</B> mumbles."
			m_type = 2

		if ("grumble")
			if (!muzzled)
				message = "<B>[src]</B> grumbles."
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("groan")
			if (!muzzled)
				message = "<B>[src]</B> groans!"
				m_type = 2
				call_sound_emote("groan")
				emote_allowed = 0
				sleep(10)
				emote_allowed = 1
			else
				message = "<B>[src]</B> makes a loud noise."
				m_type = 2

		if ("moan")
			message = "<B>[src]</B> moans!"
			m_type = 2

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param = null
			else
				message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows his name out in smoke."
				m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					message = "<B>[src]</B> points."
				else
					M.point()

				if (M)
					message = "<B>[src]</B> points to [M]."
				else
			m_type = 1
//phleg

		if ("raise")
			if (!src.restrained())
				message = "\red <B>[src]</B> raises a hand."
				usr.drop_from_slot(usr.r_hand)
				usr.drop_from_slot(usr.l_hand)		//		usr.drop_item()
			m_type = 1

//phleg
		if("shake")
			message = "<B>[src]</B> shakes \his head."
			m_type = 1

		if ("shrug")
			message = "<B>[src]</B> shrugs."
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/input = copytext(sanitize(input("how many fingers you want show?",,"")),1,MAX_NAME_LEN)
				var/fingers = input
			//	var/t1 = round(text2num(param))
				var/t1 = round(text2num(fingers))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("smile")
			message = "<B>[src]</B> smiles."
			m_type = 1

		if ("shiver")
			message = "<B>[src]</B> shivers."
			m_type = 2
//phleg
		if ("threat")
			if (!src.restrained())
				if (src.r_hand)
					message = "\red <B>[src]</B> threaten with a [src.r_hand.name]."   //	src.r_hand.name
				else if (src.l_hand)
					message = "\red <B>[src]</B> threaten with a [src.l_hand.name]."
				else
					src << "\blue you not wield weapon."
			else
				message = "<B>[src]</B> looks angry."

		if ("callout")
			if (!muzzled)
				message = "\red <B>[src]</B> loud call out."
				m_type = 2
				call_sound_emote("callout")
				emote_allowed = 0
				sleep(10)
				emote_allowed = 1
			else
				message = "<B>[src]</B> makes a strange noise."
				m_type = 2

//phleg
		if ("pale")
			message = "<B>[src]</B> goes pale for a second."
			m_type = 1

		if ("tremble")
			message = "<B>[src]</B> trembles in fear!"
			m_type = 1

		if ("sneeze")
			if (!muzzled)
				message = "<B>[src]</B> sneezes."
				m_type = 2
				call_sound_emote("sneeze")
			else
				message = "<B>[src]</B> makes a strange noise."
				m_type = 2

		if ("sniff")
			message = "<B>[src]</B> sniffs."
			m_type = 2

		if ("snore")
			if (!muzzled)
				message = "<B>[src]</B> snores."
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("whimper")
			if (!muzzled)
				message = "<B>[src]</B> whimpers."
				m_type = 2
			else
				message = "<B>[src]</B> makes a weak noise."
				m_type = 2

		if ("wink")
			message = "<B>[src]</B> winks."
			m_type = 1

		if ("yawn")
			if (!muzzled)
				message = "<B>[src]</B> yawns."
				m_type = 2

		if ("collapse")
			Paralyse(2)
			message = "<B>[src]</B> collapses!"
			m_type = 2

		if("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> hugs [M]."
				else
					message = "<B>[src]</B> hugs \himself."

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> shakes hands with [M]."
					else
						message = "<B>[src]</B> holds out \his hand to [M]."

		if("daps")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> gives daps to [M]."
				else
					message = "<B>[src]</B> sadly can't find anybody to give daps to, and daps \himself. Shameful."

		if ("scream")
			if (!muzzled)
				message = "<B>[src]</B> screams!"
				m_type = 2
				call_sound_emote("scream")
				emote_allowed = 0
				sleep(10)
				emote_allowed = 1
			else
				message = "<B>[src]</B> makes a very loud noise."
				m_type = 2

		if ("hungry")
			if(prob(1))
				message = "<B>Blue Elf</B> needs food Badly."
			else
				message = "<B>[src]'s</B> stomach growls."

		if ("thirsty")
			if(prob(1))
				message = "<B>[src]</B> cancels destory station: Drinking."
			else
				message = "<B>[src]</B> looks thirsty."

		if ("help")
			src << "blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough,\ncry, custom, deathgasp, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,\ngrin, laugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,\nsigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, twitch_s, whimper,\nwink, yawn"

		else
			src << "\blue Unusable emote '[act]'. Say *help for a list."





	if (message)
		log_emote("[name]/[key] : [message]")

//phleg
 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in world)
			if (!M.client)
				continue //skip monkeys and leavers
			if (istype(M, /mob/new_player))
				continue
			if(findtext(message," snores.")) //Because we have so many sleeping people.
				continue
			if(M.stat == 2 && M.client.ghost_sight && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			for (var/mob/O in viewers(src, null))
				if(istype(O,/mob/living/carbon/human))
					for(var/mob/living/parasite/P in O:parasites)
						P.show_message(message, m_type)
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in hearers(src.loc, null))
				if(istype(O,/mob/living/carbon/human))
					for(var/mob/living/parasite/P in O:parasites)
						P.show_message(message, m_type)
				O.show_message(message, m_type)

/mob/living/carbon/human/proc/call_sound_emote(var/E)
	switch(E)
		if("scream")
			for(var/mob/M in viewers(usr, null))
				if (src.gender == "male")
					M << sound(pick('Screams_Male_1.ogg','Screams_Male_2.ogg','Screams_Male_3.ogg'))
				else
					M << sound(pick('Screams_Woman_1.ogg','Screams_Woman_2.ogg','Screams_Woman_3.ogg'))

		if("cough")
			for(var/mob/M in viewers(usr, null))
				if (src.gender == "male")
					M << sound ('cough_m.ogg')
				else
					M << sound ('cough_f.ogg')

		if("sneeze")
			for(var/mob/M in viewers(usr, null))
				if (src.gender == "male")
					M << sound ('sneeze_m.ogg')
				else
					M << sound ('sneeze_f.ogg')

		if("callout")
			for(var/mob/M in viewers(usr, null))
				if (src.gender == "male")
					M << sound (pick('callout_m1.ogg','callout_m2.ogg','callout_m3.ogg','callout1.ogg'))
				else
					M << sound (pick('callout_f1.ogg','callout_f2.ogg','callout_f3.ogg','callout1.ogg'))

		if("groan")
			for(var/mob/M in viewers(usr, null))
				if (src.gender == "male")
					M << sound (pick('groan_m1.ogg','groan_m2.ogg','groan_m3.ogg'))
				else
					M << sound (pick('groan_f1.ogg','groan_f2.ogg','groan_f3.ogg'))

		if("laugh")
			for(var/mob/M in viewers(usr, null))
				if (src.gender == "male")
					M << sound (pick('laugh_m1.ogg','laugh_m2.ogg','laugh_m3.ogg'))
				else
					M << sound (pick('laugh_f1.ogg','laugh_f2.ogg','laugh_f3.ogg'))

		if("sigh")
			for(var/mob/M in viewers(usr, null))
				if (src.gender == "male")
					M << sound ('sigh_m.ogg')
				else
					M << sound ('sigh_f.ogg')

		if("cry")
			for(var/mob/M in viewers(usr, null))
				if (src.gender == "male")
					M << sound ('cry_m.ogg')
				else
					M << sound ('cry_f.ogg')
