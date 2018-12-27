/mob/var/oxyloss = 0.0
/mob/var/toxloss = 0.0
/mob/var/brainloss = 0.0
/mob/var/ear_deaf = null
/mob/var/face_dmg = 0
/mob/var/halloss = 0
/mob/var/hallucination = 0
/mob/var/list/atom/hallucinations = list()
/mob/var/health = 100

/mob/proc/updatehealth()
	if(src.nodamage)
		src.health = 100
		src.stat = 0
		return
	if(cloth == null || cloth.space_suit == 0)
		if(istype(src.loc, /turf/simulated/floor))
			var/turf/simulated/floor/F = src.loc
			var/datum/gas_mixture/G = F.return_air()
			if(lungs)
				if(G.oxygen - (lungs.my_func()/5 + rand(1,10)) < HUMAN_NEEDED_OXYGEN + heart.pumppower/1000)
					Emote(pick("gasps", "cough"))
					oxyloss += 1
				else
					if(oxyloss > 1)
						oxyloss -= 1
			else
				oxyloss += 2

		else if(istype(src.loc, /obj) && !istype(src.loc, /obj/structure/disposalholder))
			var/obj/O = src.loc
			var/turf/simulated/floor/F = O.loc
			var/datum/gas_mixture/G = F.return_air()
			if(lungs)
				if(G.oxygen - (lungs.my_func()/5 + rand(1,10)) < HUMAN_NEEDED_OXYGEN + heart.pumppower/1000)
					Emote(pick("gasps", "cough"))
					oxyloss += 1
				else
					if(oxyloss > 1)
						oxyloss -= 1
			else
				oxyloss += 2

		else
			Emote(pick("gasps", "cough"))
			oxyloss += 1
	if(oxyloss > 75)
		sleeping()

	src.health = 100 - src.getOxyLoss() - src.getToxLoss() - src.getFireLoss() - src.getBruteLoss()
	if(health > 100)
		health = 100
	if(src.health < 0)
		src.health = 0
		death()

/mob/proc/getOxyLoss()
	return oxyloss

/mob/proc/adjustOxyLoss(var/amount)
	oxyloss = max(oxyloss + amount, 0)

/mob/proc/getToxLoss()
	return toxloss

/mob/proc/adjustToxLoss(var/amount)
	toxloss = max(toxloss + amount, 0)

/mob
	var/bruteloss = 0.0//Living
	var/fireloss = 0.0//Living

	bullet_act(var/obj/item/projectile/Proj)
		if(Proj.firer != src)
			if(Proj.damage > 0)
				rand_damage(Proj.damage - rand(1,4), Proj.damage)
			else
				stunned += Proj.stun
			del(Proj)
			return 0

	proc/switch_intent()
		if(intent)
			intent = 0
			return
		else
			intent = 1
			return

	proc/heal_burn(var/vol)
		if(chest.brute_dam >= vol)
			chest.burn_dam -= vol

		if(head.brute_dam >= vol)
			head.burn_dam -= vol

		if(r_arm.brute_dam >= vol)
			r_arm.burn_dam -= vol

		if(l_arm.brute_dam >= vol)
			l_arm.burn_dam -= vol

		if(r_leg.brute_dam >= vol)
			r_leg.burn_dam -= vol

		if(l_leg.brute_dam >= vol)
			l_leg.burn_dam -= vol

		if(chest.brute_dam < vol)
			chest.burn_dam = vol

		if(head.brute_dam < vol)
			head.burn_dam = 0

		if(r_arm.brute_dam < vol)
			r_arm.burn_dam = 0

		if(l_arm.brute_dam < vol)
			l_arm.burn_dam = 0

		if(r_leg.brute_dam  < vol)
			r_leg.burn_dam = 0

		if(l_leg.brute_dam < vol)
			l_leg.burn_dam = 0

	proc/heal_brute(var/vol)
		if(chest.brute_dam >= vol)
			chest.brute_dam -= vol

		if(head.brute_dam >= vol)
			head.brute_dam -= vol

		if(r_arm.brute_dam >= vol)
			r_arm.brute_dam -= vol

		if(l_arm.brute_dam >= vol)
			l_arm.brute_dam -= vol

		if(r_leg.brute_dam >= vol)
			r_leg.brute_dam -= vol

		if(l_leg.brute_dam >= vol)
			l_leg.brute_dam -= vol

		if(chest.brute_dam < vol)
			chest.brute_dam = vol

		if(head.brute_dam < vol)
			head.brute_dam = 0

		if(r_arm.brute_dam < vol)
			r_arm.brute_dam = 0

		if(l_arm.brute_dam < vol)
			l_arm.brute_dam = 0

		if(r_leg.brute_dam  < vol)
			r_leg.brute_dam = 0

		if(l_leg.brute_dam < vol)
			l_leg.brute_dam = 0

	proc/blood_flow()

		heart.my_func()
		switch(heart.pumppower)
			if (80 to 90)
				if(prob(rand(2,5)))
					src << heart.pain_internal()
			if (50 to 80)
				if(prob(rand(5,15)))
					src << heart.pain_internal()
			if (30 to 50)
				if(prob(rand(10,15)))
					src << heart.pain_internal()
				if(sleeping == 0)
					sleeping()
			if (5 to 30)
				if(prob(rand(10,25)))
					src << heart.pain_internal()
					chest.brute_dam += rand(2,4)
					head.brute_dam += rand(2,4)
			if(0 to 5)
				death()

		var/obj/blood/BD

		if(H)
			H.clear_overlay()
			H.temppixels(round(H.cur_tnum))
			H.oxypixels(round(100 - oxyloss))
			H.healthpixels(round(health))

		if(prob(25))
			if(!reagents.has_reagent("blood", 280))
				reagents.add_reagent("blood", 20)

		if(prob(25))
			if(chest.brute_dam > 80)
				reagents.remove_reagent("blood", 20 + heart.pumppower / 10)
				src << select_lang("\red �� ���&#255;��� ������� �����", "You have the blood loss") //��� ����� ��� ��� ���������! ����, ����
				BD = new(src.loc)

			if(head.brute_dam > 80)
				reagents.remove_reagent("blood", 18  + heart.pumppower / 10)
				src << select_lang("\red �� ���&#255;��� ������� �����", "You have the blood loss") //��� ����� ��� ��� ���������! ����, ����
				BD = new(src.loc)

			if(r_leg.brute_dam > 80)
				reagents.remove_reagent("blood", 14  + heart.pumppower / 10)
				src << select_lang("\red �� ���&#255;��� ������� �����", "You have the blood loss") //��� ����� ��� ��� ���������! ����, ����
				BD = new(src.loc)

			if(l_leg.brute_dam > 80)
				reagents.remove_reagent("blood", 14  + heart.pumppower / 10)
				src << select_lang("\red �� ���&#255;��� ������� �����", "You have the blood loss") //��� ����� ��� ��� ���������! ����, ����
				BD = new(src.loc)

			if(r_arm.brute_dam > 80)
				reagents.remove_reagent("blood", 8  + heart.pumppower / 10)
				src << select_lang("\red �� ���&#255;��� ������� �����", "You have the blood loss") //��� ����� ��� ��� ���������! ����, ����
				BD = new(src.loc)

			if(l_arm.brute_dam > 80)
				reagents.remove_reagent("blood", 8  + heart.pumppower / 10)
				src << select_lang("\red �� ���&#255;��� ������� �����", "You have the blood loss") //��� ����� ��� ��� ���������! ����, ��
				BD = new(src.loc)

		if(!reagents.has_reagent("blood", 50))
			death()
			return
/*
		if(H)
			if(reagents.has_reagent("blood", 300))
				src.H.icon_state = "health100"

			if(!reagents.has_reagent("blood", 270))
				src.H.icon_state = "health80"

			if(!reagents.has_reagent("blood", 180))
				src.H.icon_state = "health50"

			if(!reagents.has_reagent("blood", 140))
				src.H.icon_state = "health30"
				if(prob(35))
					if(!lying)
						resting()

			if(!reagents.has_reagent("blood", 80))
				src.H.icon_state = "health10"
				if(!lying)
					resting()
*/
		if(BD)
			BD.pixel_z = (ZLevel - 1) * 32

	proc/death()
		death = 1
		src << select_lang("\red �� ����. ���-���", "\red You are dead")
		if(client)
			client.screen.Cut()
		STOP_PROCESSING(SSmobs, src)
		rest()
		var/mob/ghost/zhmur = new()
		zhmur.key = key
		if(client)
			Login()
		zhmur.loc = loc
		return


/mob/proc/rand_damage(var/mind, var/maxd)
	var/MY_PAIN
	MY_PAIN = get_organ(pick("chest", "r_leg", "l_leg","r_arm", "l_arm"))
	apply_damage(rand(mind, maxd) - defense, "brute" , MY_PAIN, 0)

/mob/proc/rand_burn_damage(var/mind, var/maxd)
	var/MY_PAIN
	MY_PAIN = get_organ(pick("chest", "r_leg", "l_leg","r_arm", "l_arm"))
	apply_damage(rand(mind, maxd), "fire" , MY_PAIN, 0)

/mob/apply_damage(var/damage = 0, var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0)
	if((damagetype != BRUTE) && (damagetype != BURN))
		..(damage, damagetype, def_zone, blocked)
		return 1

	if(blocked >= 2)	return 0

	var/datum/organ/external/organ = null
	if(isorgan(def_zone))
		organ = def_zone
	else
		if(!def_zone)	def_zone = ran_zone(def_zone)
		organ = get_organ(check_zone(def_zone))
	if(!organ)	return 0
	if(blocked)
		damage = (damage/(blocked+1))

	switch(damagetype)
		if(BRUTE)
			organ.take_damage(damage, 0)
		if(BURN)
			organ.take_damage(damage, 0)
	UpdateDamageIcon()


	if(istype(def_zone, /datum/organ/external/chest))
		if(damage - blocked > 8)
			lungs.brute_dam += damage / 2
			heart.brute_dam += damage / 3

	return 1

/proc/parse_zone(zone)
	if(zone == "r_hand") return "right hand"
	else if (zone == "l_hand") return "left hand"
	else if (zone == "l_arm") return "left arm"
	else if (zone == "r_arm") return "right arm"
	else if (zone == "l_leg") return "left leg"
	else if (zone == "r_leg") return "right leg"
	else if (zone == "l_foot") return "left foot"
	else if (zone == "r_foot") return "right foot"
	else return zone

/mob/proc/attacked_by(var/obj/item/I, var/mob/user, var/def_zone)
	if((!I || !user) && istype(I, /obj/item/weapon/reagent_containers))	return 0

	if(istype(I, /obj/item/weapon/handcuffs))
		if(usr.do_after(25))
			usr.drop_item_v()
			I.Move(src)
			handcuffed = 1
			for(var/mob/M in range(5, src))
				M.playsoundforme('handcuffs.ogg')
			return

	var/datum/organ/external/defen_zone
	if(client)
		defen_zone = get_organ(ran_zone(DF_ZONE.selecting))

	var/datum/organ/external/affecting = get_organ(ran_zone(user.ZN_SEL.selecting))
	var/hit_area = parse_zone(affecting.name)
	var/def_area
	if(def_zone && client)
		def_area = parse_zone(defen_zone.name)

	usr << select_lang("\red <B>[src] ��������(�) [user] � [hit_area] � ������� [I.name] !</B>", "\red <B>[src] attacked [user] to [hit_area] by [I.name] !</B>")

	if((user != src))
		return 0

	if(istype(I, /obj/item/weapon/flasher))
		for(var/mob/M in range(3, src))
			M.playsoundforme('flash.ogg')
			M << "\red [user] blinds [src] with the flash!"
		rest()
		if(client)
			client.show_map = 0
			sleep(rand(3,9))
			client.show_map = 1
			sleep(rand(2,5))
			rest()
		run_intent()
	if(istype(I, /obj/item/weapon/fire_ext))
		for(var/mob/M in range(3, src))
			M.playsoundforme('smash2.ogg')

	if(!I.force)	return 0
	if(def_area)
		if(def_area == hit_area)
			I.force -= defense
			user << select_lang("\blue �� ���������� ����� �����!", "\blue You block damage partially")
			usr << select_lang("\red [src] ��������� ����� �����!", "\red [src] block damage partially!")
	apply_damage(I.force, I.damtype, affecting, 0)
	I.force = initial(I.force)

	stunned += I.stun

	src.UpdateDamageIcon()

/mob/proc/upd_status(var/datum/organ/external/O)
	var/return_color

	if(O.brute_dam + O.burn_dam < 20)
		return_color = "#00FF21" //good

	if(O.brute_dam + O.burn_dam > 20)
		return_color = "#FFD800" //bad

	if(O.brute_dam + O.burn_dam > 70)
		return_color = "#FF0000" //very bad

	if(O.brute_dam + O.burn_dam > 100)
		return_color = "#FF006E" //pizdec

	return return_color

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching

/mob/proc/getBruteLoss()
	bruteloss = 0
	for(var/datum/organ/external/E in organs)
		if(istype(E, /datum/organ/external/chest) || istype(E, /datum/organ/external/head) || istype(E, /datum/organ/external/groin))
			var/dam = E.get_brute()
			bruteloss += dam
		else
			var/dam = E.get_brute()
			bruteloss += round(dam / 4)
	return bruteloss

/mob/proc/adjustBruteLoss(var/amount)
	bruteloss = max(bruteloss + amount, 0)

/mob/proc/getFireLoss()
	fireloss = 0
	for(var/datum/organ/external/E in organs)
		if(istype(E, /datum/organ/external/chest) || istype(E, /datum/organ/external/head) || istype(E, /datum/organ/external/groin))
			var/dam = E.get_burn()
			fireloss += dam
		else
			var/dam = E.get_burn()
			fireloss += round(dam / 4)
	return fireloss

/mob/proc/adjustFireLoss(var/amount)
	fireloss = max(fireloss + amount, 0)

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/proc/UpdateDamageIcon()
	return

/mob/proc/HealDamage(zone, brute, burn)
	var/datum/organ/external/E = get_organ(zone)
	if(istype(E, /datum/organ/external))
		if (E.heal_damage(brute, burn))
			UpdateDamageIcon()
	else
		return 0
	return

// new damage icon system
// now constructs damage icon for each organ from mask * damage field

/mob/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0)
	if(!damage || (blocked >= 2))	return 0
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage/(blocked+1))
		if(BURN)
			adjustFireLoss(damage/(blocked+1))
	UpdateDamageIcon()
	return 1

/mob/UpdateDamageIcon()
	return

/mob/proc/get_organ(var/zone)
	if(!zone)	zone = "chest"
	for(var/datum/organ/external/O in organs)
		if(O.name == zone)
			return O
	return null