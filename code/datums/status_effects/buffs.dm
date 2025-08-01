//Largely beneficial effects go here, even if they have drawbacks. An example is provided in Shadow Mend.

/datum/status_effect/shadow_mend
	id = "shadow_mend"
	duration = 30
	alert_type = /atom/movable/screen/alert/status_effect/shadow_mend

/atom/movable/screen/alert/status_effect/shadow_mend
	name = "Shadow Mend"
	desc = ""
	icon_state = "shadow_mend"

/datum/status_effect/shadow_mend/on_apply()
	owner.visible_message("<span class='notice'>Violet light wraps around [owner]'s body!</span>", "<span class='notice'>Violet light wraps around my body!</span>")
	playsound(owner, 'sound/blank.ogg', 50, TRUE)
	return ..()

/datum/status_effect/shadow_mend/tick()
	owner.adjustBruteLoss(-15)
	owner.adjustFireLoss(-15)

/datum/status_effect/shadow_mend/on_remove()
	owner.visible_message("<span class='warning'>The violet light around [owner] glows black!</span>", "<span class='warning'>The tendrils around you cinch tightly and reap their toll...</span>")
	playsound(owner, 'sound/blank.ogg', 50, TRUE)
	owner.apply_status_effect(STATUS_EFFECT_VOID_PRICE)


/datum/status_effect/void_price
	id = "void_price"
	duration = 300
	tick_interval = 30
	alert_type = /atom/movable/screen/alert/status_effect/void_price

/atom/movable/screen/alert/status_effect/void_price
	name = "Void Price"
	desc = ""
	icon_state = "shadow_mend"

/datum/status_effect/void_price/tick()
	SEND_SOUND(owner, sound('sound/blank.ogg', volume = 25))
	owner.adjustBruteLoss(3)


/datum/status_effect/cyborg_power_regen
	id = "power_regen"
	duration = 100
	alert_type = /atom/movable/screen/alert/status_effect/power_regen
	var/power_to_give = 0 //how much power is gained each tick

/datum/status_effect/cyborg_power_regen/on_creation(mob/living/new_owner, new_power_per_tick)
	. = ..()
	if(. && isnum(new_power_per_tick))
		power_to_give = new_power_per_tick

/atom/movable/screen/alert/status_effect/power_regen
	name = "Power Regeneration"
	desc = ""
	icon_state = "power_regen"

/datum/status_effect/wish_granters_gift //Fully revives after ten seconds.
	id = "wish_granters_gift"
	duration = 50
	alert_type = /atom/movable/screen/alert/status_effect/wish_granters_gift

/datum/status_effect/wish_granters_gift/on_apply()
	to_chat(owner, "<span class='notice'>Death is not my end! The Wish Granter's energy suffuses you, and you begin to rise...</span>")
	return ..()

/datum/status_effect/wish_granters_gift/on_remove()
	owner.revive(full_heal = TRUE, admin_revive = TRUE)
	owner.visible_message("<span class='warning'>[owner] appears to wake from the dead, having healed all wounds!</span>", "<span class='notice'>I have regenerated.</span>")
	owner.update_mobility()

/atom/movable/screen/alert/status_effect/wish_granters_gift
	name = "Wish Granter's Immortality"
	desc = ""
	icon_state = "wish_granter"

/datum/status_effect/blooddrunk
	id = "blooddrunk"
	duration = 10
	tick_interval = 0
	alert_type = /atom/movable/screen/alert/status_effect/blooddrunk
	var/last_health = 0
	var/last_bruteloss = 0
	var/last_fireloss = 0
	var/last_toxloss = 0
	var/last_oxyloss = 0
	var/last_cloneloss = 0
	var/last_staminaloss = 0

/atom/movable/screen/alert/status_effect/blooddrunk
	name = "Blood-Drunk"
	desc = "" //not true, and the item description mentions its actual effect
	icon_state = "blooddrunk"

/datum/status_effect/blooddrunk/on_apply()
	. = ..()
	if(.)
		ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, "blooddrunk")
		owner.maxHealth *= 10
		owner.bruteloss *= 10
		owner.fireloss *= 10
		if(iscarbon(owner))
			var/mob/living/carbon/C = owner
			for(var/X in C.bodyparts)
				var/obj/item/bodypart/BP = X
				BP.max_damage *= 10
				BP.brute_dam *= 10
				BP.burn_dam *= 10
		owner.toxloss *= 10
		owner.oxyloss *= 10
		owner.cloneloss *= 10
		owner.staminaloss *= 10
		owner.updatehealth()
		last_health = owner.health
		last_bruteloss = owner.getBruteLoss()
		last_fireloss = owner.getFireLoss()
		last_toxloss = owner.getToxLoss()
		last_oxyloss = owner.getOxyLoss()
		last_cloneloss = owner.getCloneLoss()
		last_staminaloss = owner.getStaminaLoss()
		owner.log_message("gained blood-drunk stun immunity", LOG_ATTACK)
		owner.add_stun_absorption("blooddrunk", INFINITY, 4)
		owner.playsound_local(get_turf(owner), 'sound/blank.ogg', 40, 1)

/datum/status_effect/blooddrunk/tick() //multiply the effect of healing by 10
	if(owner.health > last_health)
		var/needs_health_update = FALSE
		var/new_bruteloss = owner.getBruteLoss()
		if(new_bruteloss < last_bruteloss)
			var/heal_amount = (new_bruteloss - last_bruteloss) * 10
			owner.adjustBruteLoss(heal_amount, updating_health = FALSE)
			new_bruteloss = owner.getBruteLoss()
			needs_health_update = TRUE
		last_bruteloss = new_bruteloss

		var/new_fireloss = owner.getFireLoss()
		if(new_fireloss < last_fireloss)
			var/heal_amount = (new_fireloss - last_fireloss) * 10
			owner.adjustFireLoss(heal_amount, updating_health = FALSE)
			new_fireloss = owner.getFireLoss()
			needs_health_update = TRUE
		last_fireloss = new_fireloss

		var/new_toxloss = owner.getToxLoss()
		if(new_toxloss < last_toxloss)
			var/heal_amount = (new_toxloss - last_toxloss) * 10
			owner.adjustToxLoss(heal_amount, updating_health = FALSE)
			new_toxloss = owner.getToxLoss()
			needs_health_update = TRUE
		last_toxloss = new_toxloss

		var/new_oxyloss = owner.getOxyLoss()
		if(new_oxyloss < last_oxyloss)
			var/heal_amount = (new_oxyloss - last_oxyloss) * 10
			owner.adjustOxyLoss(heal_amount, updating_health = FALSE)
			new_oxyloss = owner.getOxyLoss()
			needs_health_update = TRUE
		last_oxyloss = new_oxyloss

		var/new_cloneloss = owner.getCloneLoss()
		if(new_cloneloss < last_cloneloss)
			var/heal_amount = (new_cloneloss - last_cloneloss) * 10
			owner.adjustCloneLoss(heal_amount, updating_health = FALSE)
			new_cloneloss = owner.getCloneLoss()
			needs_health_update = TRUE
		last_cloneloss = new_cloneloss

		var/new_staminaloss = owner.getStaminaLoss()
		if(new_staminaloss < last_staminaloss)
			var/heal_amount = (new_staminaloss - last_staminaloss) * 10
			owner.adjustStaminaLoss(heal_amount, updating_health = FALSE)
			new_staminaloss = owner.getStaminaLoss()
			needs_health_update = TRUE
		last_staminaloss = new_staminaloss

		if(needs_health_update)
			owner.updatehealth()
			owner.playsound_local(get_turf(owner), 'sound/blank.ogg', 40, 1)
	last_health = owner.health

/datum/status_effect/blooddrunk/on_remove()
	tick()
	owner.maxHealth *= 0.1
	owner.bruteloss *= 0.1
	owner.fireloss *= 0.1
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		for(var/X in C.bodyparts)
			var/obj/item/bodypart/BP = X
			BP.brute_dam *= 0.1
			BP.burn_dam *= 0.1
			BP.max_damage /= 10
	owner.toxloss *= 0.1
	owner.oxyloss *= 0.1
	owner.cloneloss *= 0.1
	owner.staminaloss *= 0.1
	owner.updatehealth()
	owner.log_message("lost blood-drunk stun immunity", LOG_ATTACK)
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, "blooddrunk");
	if(islist(owner.stun_absorption) && owner.stun_absorption["blooddrunk"])
		owner.stun_absorption -= "blooddrunk"

/datum/status_effect/sword_spin
	id = "Bastard Sword Spin"
	duration = 50
	tick_interval = 8
	alert_type = null


/datum/status_effect/sword_spin/on_apply()
	owner.visible_message("<span class='danger'>[owner] begins swinging the sword with inhuman strength!</span>")
	var/oldcolor = owner.color
	owner.color = "#ff0000"
	owner.add_stun_absorption("bloody bastard sword", duration, 2, "doesn't even flinch as the sword's power courses through them!", "You shrug off the stun!", " glowing with a blazing red aura!")
	owner.spin(duration,1)
	animate(owner, color = oldcolor, time = duration, easing = EASE_IN)
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/atom, update_atom_colour)), duration)
	playsound(owner, 'sound/blank.ogg', 75, FALSE)
	return ..()


/datum/status_effect/sword_spin/tick()
	playsound(owner, 'sound/blank.ogg', 75, FALSE)
	var/obj/item/slashy
	slashy = owner.get_active_held_item()
	for(var/mob/living/M in orange(1,owner))
		slashy.attack(M, owner)

/datum/status_effect/sword_spin/on_remove()
	owner.visible_message("<span class='warning'>[owner]'s inhuman strength dissipates and the sword's runes grow cold!</span>")


//Used by changelings to rapidly heal
//Heals 10 brute and oxygen damage every second, and 5 fire
//Being on fire will suppress this healing
/datum/status_effect/fleshmend
	id = "fleshmend"
	duration = 100
	alert_type = /atom/movable/screen/alert/status_effect/fleshmend

/datum/status_effect/fleshmend/tick()
	if(owner.on_fire)
		linked_alert.icon_state = "fleshmend_fire"
		return
	else
		linked_alert.icon_state = "fleshmend"
	owner.adjustBruteLoss(-10, FALSE)
	owner.adjustFireLoss(-5, FALSE)
	owner.adjustOxyLoss(-10)

/atom/movable/screen/alert/status_effect/fleshmend
	name = "Fleshmend"
	desc = ""
	icon_state = "fleshmend"

/datum/status_effect/exercised
	id = "Exercised"
	duration = 1200
	alert_type = null

/datum/status_effect/exercised/on_creation(mob/living/new_owner, ...)
	. = ..()
	STOP_PROCESSING(SSfastprocess, src)
	START_PROCESSING(SSprocessing, src) //this lasts 20 minutes, so SSfastprocess isn't needed.

/datum/status_effect/exercised/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/datum/status_effect/good_music
	id = "Good Music"
	alert_type = null
	duration = 6 SECONDS
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/good_music/tick()
	if(owner.can_hear())
		owner.dizziness = max(0, owner.dizziness - 2)
		owner.jitteriness = max(0, owner.jitteriness - 2)
		owner.confused = max(0, owner.confused - 1)
		SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "goodmusic", /datum/mood_event/goodmusic)

/atom/movable/screen/alert/status_effect/regenerative_core
	name = "Regenerative Core Tendrils"
	desc = ""
	icon_state = "regenerative_core"

/datum/status_effect/regenerative_core
	id = "Regenerative Core"
	duration = 1 MINUTES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/regenerative_core

/datum/status_effect/regenerative_core/on_apply()
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, id)
	owner.adjustBruteLoss(-25)
	owner.adjustFireLoss(-25)
	owner.remove_CC()
	owner.bodytemperature = BODYTEMP_NORMAL
	return TRUE

/datum/status_effect/regenerative_core/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, id)

/datum/status_effect/antimagic
	id = "antimagic"
	duration = 10 SECONDS
	examine_text = "<span class='notice'>They seem to be covered in a dull, grey aura.</span>"

/datum/status_effect/antimagic/on_apply()
	owner.visible_message("<span class='notice'>[owner] is coated with a dull aura!</span>")
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	//glowing wings overlay
	playsound(owner, 'sound/blank.ogg', 75, FALSE)
	return ..()

/datum/status_effect/antimagic/on_remove()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	owner.visible_message("<span class='warning'>[owner]'s dull aura fades away...</span>")

