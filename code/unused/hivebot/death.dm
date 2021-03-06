/mob/living/silicon/hivebot/death(gibbed)
	if(src.mainframe)
		src.mainframe.return_to(src)
	src.stat = 2
	src.canmove = 0

	if(src.blind)
		src.blind.invisibility = 101
	src.sight |= SEE_TURFS
	src.sight |= SEE_MOBS
	src.sight |= SEE_OBJS

	src.see_in_dark = 8
	src.see_invisible = 2
	src.updateicon()

	var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch
	store_memory("Time of death: [tod]", 0)

	if (src.key)
		spawn(50)
			if(src.key && src.stat == 2)
				src.verbs += /mob/proc/ghost
	return ..(gibbed)