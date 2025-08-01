/mob/dead/new_player/Login()
//	winset(client, "outputwindow.output", "max-lines=1")
//	winset(client, "outputwindow.output", "max-lines=100")

	if(CONFIG_GET(flag/use_exp_tracking))
		client.set_exp_from_db()
		client.set_db_player_flags()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	..()

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)

	if(GLOB.rogue_round_id)
		to_chat(src, span_info("ROUND ID: [GLOB.rogue_round_id]"))

	if(client)
		if(client.is_new_player())
			to_chat(src, span_userdanger("Due to an invasion of goblins trying to play ROGUETOWN, you need to register your discord account or support us on patreon to join."))
			to_chat(src, span_info("We dislike discord too, but it's necessary. To register your discord or patreon, please click the 'Register' tab in the top right of the window, and then choose one of the options."))
		else
			var/shown_patreon_level = "" // Vrell - For some reason this was used both to "cache" client.patreonlevel() but also for the chat output, which is horrible practice. changing it.
			// V - Yeah idk when this was last updated but it wasn't what you need given how many patreon levels you have.
			if(client.patreonlevel() > 0)
				shown_patreon_level = "<font color='[GLOB.patreonlevelcolors[client.patreonlevel()]]'><b>[GLOB.patreonlevelnames[client.patreonlevel()]]</b></font>"
			else
				shown_patreon_level = "<font color='#808080'><b>None</b></font>"
			to_chat(src, span_info("Donator Level: [shown_patreon_level]"))
		client.recent_changelog()
/*
	if(CONFIG_GET(flag/usewhitelist))
		if(!client.whitelisted())
			to_chat(src, span_info("You are not on the whitelist."))
		else
			to_chat(src, span_info("You are on the whitelist."))
*/
//	if(motd)
//		to_chat(src, "<B>If this is your first time here,</B> <a href='byond://?src=[REF(src)];rpprompt=1'>read this lore primer.</a>", handle_whitespace=FALSE)

	if(GLOB.admin_notice)
		to_chat(src, span_notice("<b>Admin Notice:</b>\n \t [GLOB.admin_notice]"))

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, span_notice("<b>Server Notice:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]"))

	sight |= SEE_TURFS

	new_player_panel()
	if(client)
		client.playtitlemusic()
	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		var/postfix
		if(tl > 0)
			postfix = "in about [DisplayTimeText(tl)]"
		else
			postfix = "soon"
		to_chat(src, "The game will start [postfix].")
		if(client)
			SSvote.send_vote(client)
			var/usedkey = ckey(key)
			/*if(usedkey in GLOB.anonymize)
				usedkey = get_fake_key(usedkey)*/
			var/list/thinz = list("takes a seat.", "settles in.", "joins the session", "joins the table.", "becomes a player.")
			SEND_TEXT(world, span_notice("[usedkey] [pick(thinz)]"))
