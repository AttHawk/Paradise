/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "muzzle"
	flags_cover = MASKCOVERSMOUTH
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.90
	put_on_delay = 20
	var/resist_time = 0 //deciseconds of how long you need to gnaw to get rid of the gag, 0 to make it impossible to remove
	var/mute = MUZZLE_MUTE_ALL
	var/security_lock = FALSE // Requires brig access to remove 0 - Remove as normal
	var/locked = FALSE //Indicates if a mask is locked, should always start as 0.

	sprite_sheets = list(
		"Vox" = 'icons/mob/clothing/species/vox/mask.dmi',
		"Monkey" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Farwa" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Wolpin" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Neara" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Stok" = 'icons/mob/clothing/species/monkey/mask.dmi'
	)

// Clumsy folks can't take the mask off themselves.
/obj/item/clothing/mask/muzzle/attack_hand(mob/user as mob)
	if(user.wear_mask == src && !user.IsAdvancedToolUser())
		return 0
	else if(security_lock && locked)
		if(do_unlock(user))
			visible_message("<span class='danger'>[user] unlocks [user.p_their()] [src.name].</span>", \
								"<span class='userdanger'>[user] unlocks [user.p_their()] [src.name].</span>")
	..()
	return 1

/obj/item/clothing/mask/muzzle/proc/do_break()
	if(security_lock)
		security_lock = FALSE
		locked = FALSE
		flags &= ~NODROP
		desc += " This one appears to be broken."
		return TRUE
	else
		return FALSE

/obj/item/clothing/mask/muzzle/proc/do_unlock(mob/living/carbon/human/user)
	if(istype(user.get_inactive_hand(), /obj/item/card/emag))
		to_chat(user, "<span class='warning'>The lock vibrates as the card forces its locking system open.</span>")
		do_break()
		return TRUE
	else if(ACCESS_BRIG in user.get_access())
		to_chat(user, "<span class='warning'>The muzzle unlocks with a click.</span>")
		locked = FALSE
		flags &= ~NODROP
		return TRUE

	to_chat(user, "<span class='warning'>You must be wearing a security ID card or have one in your inactive hand to remove the muzzle.</span>")
	return FALSE

/obj/item/clothing/mask/muzzle/proc/do_lock(mob/living/carbon/human/user)
	if(security_lock)
		locked = TRUE
		flags |= NODROP
		return TRUE
	return FALSE

/obj/item/clothing/mask/muzzle/Topic(href, href_list)
	..()
	if(href_list["locked"])
		var/mob/living/carbon/wearer = locate(href_list["locked"])
		var/success = 0
		if(ishuman(usr))
			visible_message("<span class='danger'>[usr] tries to [locked ? "unlock" : "lock"] [wearer]'s [name].</span>", \
							"<span class='userdanger'>[usr] tries to [locked ? "unlock" : "lock"] [wearer]'s [name].</span>")
			if(do_mob(usr, wearer, POCKET_STRIP_DELAY))
				if(locked)
					success = do_unlock(usr)
				else
					success = do_lock(usr)
			if(success)
				visible_message("<span class='danger'>[usr] [locked ? "locks" : "unlocks"] [wearer]'s [name].</span>", \
									"<span class='userdanger'>[usr] [locked ? "locks" : "unlocks"] [wearer]'s [name].</span>")
				if(usr.machine == wearer && in_range(src, usr))
					wearer.show_inv(usr)
		else
			to_chat(usr, "You lack the ability to manipulate the lock.")


/obj/item/clothing/mask/muzzle/tapegag
	name = "tape gag"
	desc = "MHPMHHH!"
	icon_state = "tapegag"
	item_state = null
	w_class = WEIGHT_CLASS_TINY
	resist_time = 150
	mute = MUZZLE_MUTE_MUFFLE
	flags = DROPDEL

	sprite_sheets = list(
		"Vox" = 'icons/mob/clothing/species/vox/mask.dmi',
		"Unathi" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker Shaman" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Draconid" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Tajaran" = 'icons/mob/clothing/species/tajaran/mask.dmi',
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/mask.dmi',
		"Grey" = 'icons/mob/clothing/species/grey/mask.dmi',
		"Monkey" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Farwa" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Wolpin" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Neara" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Stok" = 'icons/mob/clothing/species/monkey/mask.dmi'
		)

/obj/item/clothing/mask/muzzle/tapegag/dropped(mob/user)
	var/obj/item/trash/tapetrash/TT = new
	transfer_fingerprints_to(TT)
	user.transfer_fingerprints_to(TT)
	user.put_in_active_hand(TT)
	playsound(src, 'sound/items/poster_ripped.ogg', 40, 1)
	user.emote("scream")
	..()

/obj/item/clothing/mask/muzzle/safety
	name = "safety muzzle"
	desc = "A muzzle designed to prevent biting."
	icon_state = "muzzle_secure"
	item_state = "muzzle_secure"
	resist_time = 0
	mute = MUZZLE_MUTE_NONE
	security_lock = TRUE
	locked = FALSE
	materials = list(MAT_METAL=500, MAT_GLASS=50)

	sprite_sheets = list(
		"Vox" = 'icons/mob/clothing/species/vox/mask.dmi',
		"Unathi" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker Shaman" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Draconid" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Tajaran" = 'icons/mob/clothing/species/tajaran/mask.dmi',
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/mask.dmi',
		"Grey" = 'icons/mob/clothing/species/grey/mask.dmi',
		"Drask" = 'icons/mob/clothing/species/drask/mask.dmi',
		"Monkey" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Farwa" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Wolpin" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Neara" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Stok" = 'icons/mob/clothing/species/monkey/mask.dmi'
		)

/obj/item/clothing/mask/muzzle/safety/shock
	name = "shock muzzle"
	desc = "A muzzle designed to prevent biting.  This one is fitted with a behavior correction system."
	var/obj/item/assembly/trigger = null
	origin_tech = "materials=1;engineering=1"
	materials = list(MAT_METAL=500, MAT_GLASS=50)

/obj/item/clothing/mask/muzzle/safety/shock/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/assembly/signaler) || istype(W, /obj/item/assembly/voice))
		if(istype(trigger, /obj/item/assembly/signaler) || istype(trigger, /obj/item/assembly/voice))
			to_chat(user, "<span class='notice'>Something is already attached to [src].</span>")
			return FALSE
		if(!user.drop_transfer_item_to_loc(W, src))
			to_chat(user, "<span class='warning'>You are unable to insert [W] into [src].</span>")
			return FALSE
		trigger = W
		trigger.master = src
		trigger.holder = src
		AddComponent(/datum/component/proximity_monitor)
		to_chat(user, "<span class='notice'>You attach the [W] to [src].</span>")
		return TRUE
	else if(istype(W, /obj/item/assembly))
		to_chat(user, "<span class='notice'>That won't fit in [src]. Perhaps a signaler or voice analyzer would?</span>")
		return FALSE

	return ..()

/obj/item/clothing/mask/muzzle/safety/shock/screwdriver_act(mob/user, obj/item/I)
	if(!trigger)
		return
	. = TRUE
	if(!I.use_tool(src, user, 0, volume = I.tool_volume))
		return
	to_chat(user, "<span class='notice'>You remove [trigger] from [src].</span>")
	trigger.forceMove(get_turf(user))
	trigger.master = null
	trigger.holder = null
	trigger = null
	qdel(GetComponent(/datum/component/proximity_monitor))

/obj/item/clothing/mask/muzzle/safety/shock/proc/can_shock(obj/item/clothing/C)
	if(istype(C))
		if(isliving(C.loc))
			return C.loc
	else if(isliving(loc))
		return loc
	return FALSE

/obj/item/clothing/mask/muzzle/safety/shock/proc/process_activation(var/obj/D, var/normal = 1, var/special = 1)
	visible_message("[bicon(src)] *beep* *beep*", "*beep* *beep*")
	var/mob/living/L = can_shock(loc)
	if(!L)
		return
	to_chat(L, "<span class='danger'>You feel a sharp shock!</span>")
	do_sparks(3, 1, L)

	L.Weaken(10 SECONDS)
	L.Stuttering(2 SECONDS)
	L.Jitter(40 SECONDS)

/obj/item/clothing/mask/muzzle/safety/shock/HasProximity(atom/movable/AM)
	if(trigger)
		trigger.HasProximity(AM)


/obj/item/clothing/mask/muzzle/safety/shock/hear_talk(mob/living/M as mob, list/message_pieces)
	if(trigger)
		trigger.hear_talk(M, message_pieces)

/obj/item/clothing/mask/muzzle/safety/shock/hear_message(mob/living/M as mob, msg)
	if(trigger)
		trigger.hear_message(M, msg)



/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = WEIGHT_CLASS_TINY
	flags_cover = MASKCOVERSMOUTH
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 25, "rad" = 0, "fire" = 0, "acid" = 0)
	actions_types = list(/datum/action/item_action/adjust)

	sprite_sheets = list(
		"Vox" = 'icons/mob/clothing/species/vox/mask.dmi',
		"Unathi" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker Shaman" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Draconid" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Tajaran" = 'icons/mob/clothing/species/tajaran/mask.dmi',
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/mask.dmi',
		"Grey" = 'icons/mob/clothing/species/grey/mask.dmi',
		"Drask" = 'icons/mob/clothing/species/drask/mask.dmi',
		"Monkey" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Farwa" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Wolpin" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Neara" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Stok" = 'icons/mob/clothing/species/monkey/mask.dmi'
		)


/obj/item/clothing/mask/surgical/attack_self(var/mob/user)
	adjustmask(user)

/obj/item/clothing/mask/fakemoustache
	name = "completely real moustache"
	desc = "moustache is totally real."
	icon_state = "fake-moustache"
	flags_inv = HIDENAME
	actions_types = list(/datum/action/item_action/pontificate)
	dog_fashion = /datum/dog_fashion/head/not_ian

	sprite_sheets = list(
		"Vox" = 'icons/mob/clothing/species/vox/mask.dmi',
		"Unathi" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker Shaman" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Draconid" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Tajaran" = 'icons/mob/clothing/species/tajaran/mask.dmi',
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/mask.dmi',
		"Grey" = 'icons/mob/clothing/species/grey/mask.dmi',
		"Drask" = 'icons/mob/clothing/species/drask/mask.dmi',
		"Monkey" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Farwa" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Wolpin" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Neara" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Stok" = 'icons/mob/clothing/species/monkey/mask.dmi'
		)

/obj/item/clothing/mask/fakemoustache/attack_self(mob/user)
	pontificate(user)

/obj/item/clothing/mask/fakemoustache/item_action_slot_check(slot)
	if(slot == slot_wear_mask)
		return 1

/obj/item/clothing/mask/fakemoustache/proc/pontificate(mob/user)
	user.visible_message("<span class='danger'>\ [user] twirls [user.p_their()] moustache and laughs [pick("fiendishly","maniacally","diabolically","evilly")]!</span>")

//scarves (fit in in mask slot)

/obj/item/clothing/mask/bluescarf
	name = "blue neck scarf"
	desc = "A blue neck scarf."
	icon_state = "blueneckscarf"
	item_state = "blueneckscarf"
	flags_cover = MASKCOVERSMOUTH
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.90


/obj/item/clothing/mask/redscarf
	name = "red scarf"
	desc = "A red and white checkered neck scarf."
	icon_state = "redwhite_scarf"
	item_state = "redwhite_scarf"
	flags_cover = MASKCOVERSMOUTH
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/greenscarf
	name = "green scarf"
	desc = "A green neck scarf."
	icon_state = "green_scarf"
	item_state = "green_scarf"
	flags_cover = MASKCOVERSMOUTH
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.90

/* --------------------------------
 * Хрен знает зачем у нас тут шарф у которого даже спрайта нет. И который ещё и маска...
 * Я пожалуй оставлю, но закоменчу этот код.
/obj/item/clothing/mask/ninjascarf
	name = "ninja scarf"
	desc = "A stealthy, dark scarf."
	icon_state = "ninja_scarf"
	item_state = "ninja_scarf"
	flags_cover = MASKCOVERSMOUTH
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.90
*/

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags = BLOCKHAIR
	flags_inv = HIDENAME
	flags_cover = MASKCOVERSMOUTH|MASKCOVERSEYES
	w_class = WEIGHT_CLASS_SMALL


/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags = BLOCKHAIR
	flags_inv = HIDENAME
	w_class = WEIGHT_CLASS_SMALL
	var/voicechange = FALSE
	var/temporaryname = " the Horse"
	var/originalname = ""

	sprite_sheets = list(
		"Grey" = 'icons/mob/clothing/species/grey/mask.dmi',
		"Drask" = 'icons/mob/clothing/species/drask/mask.dmi',
		"Monkey" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Farwa" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Wolpin" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Neara" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Stok" = 'icons/mob/clothing/species/monkey/mask.dmi'
	)

/obj/item/clothing/mask/horsehead/equipped(mob/user, slot, initial)
	. = ..()

	if(flags & NODROP)	//cursed masks only
		originalname = user.real_name
		if(!user.real_name || user.real_name == "Unknown")
			user.real_name = "A Horse With No Name" //it felt good to be out of the rain
		else
			user.real_name = "[user.name][temporaryname]"

/obj/item/clothing/mask/horsehead/dropped() //this really shouldn't happen, but call it extreme caution
	if(flags & NODROP)
		goodbye_horses(loc)
	..()

/obj/item/clothing/mask/horsehead/Destroy()
	if(flags & NODROP)
		goodbye_horses(loc)
	return ..()

/obj/item/clothing/mask/horsehead/proc/goodbye_horses(mob/user) //I'm flying over you
	if(!ismob(user))
		return
	if(user.real_name == "[originalname][temporaryname]" || user.real_name == "A Horse With No Name") //if it's somehow changed while the mask is on it doesn't revert
		user.real_name = originalname

/obj/item/clothing/mask/horsehead/change_speech_verb()
	if(voicechange)
		return pick("whinnies", "neighs", "says")

/obj/item/clothing/mask/face
	flags_inv = HIDENAME
	flags_cover = MASKCOVERSMOUTH

/obj/item/clothing/mask/face/rat
	name = "rat mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a rat."
	icon_state = "rat"
	item_state = "rat"
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

/obj/item/clothing/mask/face/fox
	name = "fox mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a fox."
	icon_state = "fox"
	item_state = "fox"
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

/obj/item/clothing/mask/face/bee
	name = "bee mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a bee."
	icon_state = "bee"
	item_state = "bee"
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

/obj/item/clothing/mask/face/bear
	name = "bear mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a bear."
	icon_state = "bear"
	item_state = "bear"
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

/obj/item/clothing/mask/face/bat
	name = "bat mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a bat."
	icon_state = "bat"
	item_state = "bat"
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

/obj/item/clothing/mask/face/raven
	name = "raven mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a raven."
	icon_state = "raven"
	item_state = "raven"
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

/obj/item/clothing/mask/face/jackal
	name = "jackal mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a jackal."
	icon_state = "jackal"
	item_state = "jackal"
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

/obj/item/clothing/mask/face/tribal
	name = "tribal mask"
	desc = "A mask carved out of wood, detailed carefully by hand."
	icon_state = "bumba"
	item_state = "bumba"
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

/obj/item/clothing/mask/face/fawkes
	name = "Guy Fawkes mask"
	desc = "A mask designed to help you remember a specific date."
	icon_state = "fawkes"
	item_state = "fawkes"
	w_class = WEIGHT_CLASS_SMALL
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

/obj/item/clothing/mask/gas/pennywise
	name = "Pennywise Mask"
	desc = "It's the eater of worlds, and of children."
	icon_state = "pennywise_mask"
	item_state = "pennywise_mask"
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/head.dmi'
	)

	flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | BLOCKHAIR

/obj/item/clothing/mask/gas/rockso
	name = "Rockso Mask"
	desc = "THE ROCK AND ROLL CLOWN!"
	icon_state = "rocksomask"
	item_state = "rocksomask"
	sprite_sheets = list(
		"Unathi" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Tajaran" = 'icons/mob/clothing/species/tajaran/mask.dmi',
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/mask.dmi',
		"Vox" = 'icons/mob/clothing/species/vox/mask.dmi',
		"Monkey" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Drask" = 'icons/mob/clothing/species/drask/mask.dmi',
		"Grey" = 'icons/mob/clothing/species/grey/mask.dmi',
		"Kidan" = 'icons/mob/clothing/species/kidan/mask.dmi',
		"Wryn" = 'icons/mob/clothing/species/wryn/mask.dmi'
	)

	flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | BLOCKHAIR

// Bandanas
/obj/item/clothing/mask/bandana
	name = "bandana"
	desc = "A colorful bandana."
	flags_inv = HIDENAME
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_MASK
	adjusted_flags = SLOT_HEAD
	icon_state = "bandbotany"
	dyeable = TRUE

	sprite_sheets = list(
		"Vox" = 'icons/mob/clothing/species/vox/mask.dmi',
		"Unathi" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Ash Walker Shaman" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Draconid" = 'icons/mob/clothing/species/unathi/mask.dmi',
		"Tajaran" = 'icons/mob/clothing/species/tajaran/mask.dmi',
		"Vulpkanin" = 'icons/mob/clothing/species/vulpkanin/mask.dmi',
		"Grey" = 'icons/mob/clothing/species/grey/mask.dmi',
		"Drask" = 'icons/mob/clothing/species/drask/mask.dmi',
		"Monkey" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Farwa" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Wolpin" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Neara" = 'icons/mob/clothing/species/monkey/mask.dmi',
		"Stok" = 'icons/mob/clothing/species/monkey/mask.dmi'
		)
	actions_types = list(/datum/action/item_action/adjust)

/obj/item/clothing/mask/bandana/attack_self(var/mob/user)
	adjustmask(user)

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	icon_state = "bandred"
	item_color = "red"
	desc = "It's a red bandana."

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	icon_state = "bandblue"
	item_color = "blue"
	desc = "It's a blue bandana."

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	icon_state = "bandgold"
	item_color = "yellow"
	desc = "It's a gold bandana."

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	icon_state = "bandgreen"
	item_color = "green"
	desc = "It's a green bandana."

/obj/item/clothing/mask/bandana/orange
	name = "orange bandana"
	icon_state = "bandorange"
	item_color = "orange"
	desc = "It's an orange bandana."

/obj/item/clothing/mask/bandana/purple
	name = "purple bandana"
	icon_state = "bandpurple"
	item_color = "purple"
	desc = "It's a purple bandana."

/obj/item/clothing/mask/bandana/botany
	name = "botany bandana"
	desc = "It's a green bandana with some fine nanotech lining."
	icon_state = "bandbotany"

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	desc = "It's a black bandana with a skull pattern."
	icon_state = "bandskull"

/obj/item/clothing/mask/bandana/black
	name = "black bandana"
	icon_state = "bandblack"
	item_color = "black"
	desc = "It's a black bandana."

/obj/item/clothing/mask/bandana/durathread
	name = "durathread bandana"
	desc =  "A bandana made from durathread, you wish it would provide some protection to its wearer, but it's far too thin..."
	icon_state = "banddurathread"

/obj/item/clothing/mask/cursedclown
	name = "cursed clown mask"
	desc = "This is a very, very odd looking mask."
	icon = 'icons/goonstation/objects/clothing/mask.dmi'
	icon_state = "cursedclown"
	item_state = "cclown_hat"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	icon_override = 'icons/goonstation/mob/clothing/mask.dmi'
	lefthand_file = 'icons/goonstation/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/goonstation/mob/inhands/clothing_righthand.dmi'
	flags = NODROP | AIRTIGHT
	flags_cover = MASKCOVERSMOUTH

/obj/item/clothing/mask/cursedclown/equipped(mob/user, slot, initial)
	. = ..()

	var/mob/living/carbon/human/H = user
	if(istype(H) && slot == slot_wear_mask)
		to_chat(H, "<span class='danger'>[src] grips your face!</span>")
		if(H.mind && H.mind.assigned_role != "Cluwne")
			H.makeCluwne()

/obj/item/clothing/mask/cursedclown/suicide_act(mob/user)
	user.visible_message("<span class='danger'>[user] gazes into the eyes of [src]. [src] gazes back!</span>")
	spawn(10)
		if(user)
			user.gib()
	return OBLITERATION

//voice modulator

/obj/item/clothing/mask/gas/voice_modulator
	name = "modified gas mask"
	desc = "The usual gas mask for firefighters with attached voice change sensor."
	icon_state = "voice_modulator"
	item_state = "voice_modulator"

	var/obj/item/voice_changer/voice_modulator/voice_modulator

/obj/item/clothing/mask/gas/voice_modulator/Initialize(mapload)
	. = ..()
	voice_modulator = new(src)

/obj/item/clothing/mask/gas/voice_modulator/Destroy()
	QDEL_NULL(voice_modulator)
	return ..()

/obj/item/clothing/mask/gas/voice_modulator/change_speech_verb()
	if(voice_modulator.active)
		return pick("modulates", "drones", "hums", "buzzes")
