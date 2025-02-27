/datum/species/monkey
	name = "Monkey"
	name_plural = "Monkeys"
	blurb = "Ook."

	icobase = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	deform = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_monkey.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_monkey.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_monkey.dmi'
	language = "Galactic Common"
	default_language = "Chimpanzee"
	species_traits = list(NO_EXAMINE)
	skinned_type = /obj/item/stack/sheet/animalhide/monkey
	greater_form = /datum/species/human
	no_equip = list(slot_belt, slot_gloves)	//Риги и ЕВА тоже нельзя носить, но это размечено отдельно в одежде
	can_craft = FALSE
	is_small = 1
	has_fine_manipulation = 0
	ventcrawler = VENTCRAWLER_NUDE
	show_ssd = 0
	eyes = "blank_eyes"
	death_message = "издает слабое чириканье, дрогнув и перестает двигаться..." //да. Официально шимпанзе именно чирикают.

	scream_verb = "визжит"
	male_scream_sound = list('sound/goonstation/voice/monkey_scream.ogg')
	female_scream_sound = list('sound/goonstation/voice/monkey_scream.ogg')
	male_dying_gasp_sounds = list('sound/goonstation/voice/male_dying_gasp_1.ogg', 'sound/goonstation/voice/male_dying_gasp_2.ogg', 'sound/goonstation/voice/male_dying_gasp_3.ogg', 'sound/goonstation/voice/male_dying_gasp_4.ogg', 'sound/goonstation/voice/male_dying_gasp_5.ogg')
	female_dying_gasp_sounds = list('sound/goonstation/voice/female_dying_gasp_1.ogg', 'sound/goonstation/voice/female_dying_gasp_2.ogg', 'sound/goonstation/voice/female_dying_gasp_3.ogg', 'sound/goonstation/voice/female_dying_gasp_4.ogg', 'sound/goonstation/voice/female_dying_gasp_5.ogg')

	blood_species = "Human"
	tail = "chimptail"
	bodyflags = HAS_TAIL
	reagent_tag = PROCESS_ORG
	//Has standard darksight of 2.

	unarmed_type = /datum/unarmed_attack/bite

	total_health = 75
	brute_mod = 1.5
	burn_mod = 1.5

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin),
		"head" =   list("path" = /obj/item/organ/external/head),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right),
		"l_foot" = list("path" = /obj/item/organ/external/foot),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right),
		"tail" =   list("path" = /obj/item/organ/external/tail/monkey))

/datum/species/monkey/handle_npc(mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return
	if(prob(33) && H.canmove && isturf(H.loc) && !H.pulledby) //won't move if being pulled
		step(H, pick(GLOB.cardinal))
	if(prob(1))
		H.emote(pick("scratch","jump","roll","tail"))

/datum/species/monkey/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

/datum/species/monkey/on_species_gain(mob/living/carbon/human/H)
	..()
	H.real_name = "[lowertext(name)] ([rand(100,999)])"
	H.name = H.real_name
	H.butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/monkey = 5)

/datum/species/monkey/handle_dna(mob/living/carbon/human/H, remove)
	..()
	if(!remove)
		H.dna.SetSEState(GLOB.monkeyblock, TRUE)
		genemutcheck(H, GLOB.monkeyblock, null, MUTCHK_FORCED)

/datum/species/monkey/tajaran
	name = "Farwa"
	name_plural = "Farwa"

	icobase = 'icons/mob/human_races/monkeys/r_farwa.dmi'
	deform = 'icons/mob/human_races/monkeys/r_farwa.dmi'

	greater_form = /datum/species/tajaran
	default_language = "Farwa"
	blood_species = "Tajaran"
	flesh_color = "#AFA59E"
	base_color = "#000000"
	tail = "farwatail"
	reagent_tag = PROCESS_ORG
	has_organ = list(
		"heart" =    /obj/item/organ/internal/heart/tajaran,
		"lungs" =    /obj/item/organ/internal/lungs/tajaran,
		"liver" =    /obj/item/organ/internal/liver/tajaran,
		"kidneys" =  /obj/item/organ/internal/kidneys/tajaran,
		"brain" =    /obj/item/organ/internal/brain/tajaran,
		"appendix" = /obj/item/organ/internal/appendix,
		"eyes" =     /obj/item/organ/internal/eyes/tajaran/farwa //Tajara monkey-forms are uniquely colourblind and have excellent darksight, which is why they need a subtype of their greater-form's organ..
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin),
		"head" =   list("path" = /obj/item/organ/external/head),
		"tail" =   list("path" = /obj/item/organ/external/tail/monkey/tajaran),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right),
		"l_foot" = list("path" = /obj/item/organ/external/foot),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right))


/datum/species/monkey/vulpkanin
	name = "Wolpin"
	name_plural = "Wolpin"

	icobase = 'icons/mob/human_races/monkeys/r_wolpin.dmi'
	deform = 'icons/mob/human_races/monkeys/r_wolpin.dmi'

	greater_form = /datum/species/vulpkanin
	default_language = "Wolpin"
	blood_species = "Vulpkanin"
	flesh_color = "#966464"
	base_color = "#000000"
	tail = "wolpintail"
	reagent_tag = PROCESS_ORG
	has_organ = list(
		"heart" =    /obj/item/organ/internal/heart/vulpkanin,
		"lungs" =    /obj/item/organ/internal/lungs/vulpkanin,
		"liver" =    /obj/item/organ/internal/liver/vulpkanin,
		"kidneys" =  /obj/item/organ/internal/kidneys/vulpkanin,
		"brain" =    /obj/item/organ/internal/brain/vulpkanin,
		"appendix" = /obj/item/organ/internal/appendix,
		"eyes" =     /obj/item/organ/internal/eyes/vulpkanin/wolpin //Vulpkanin monkey-forms are uniquely colourblind and have excellent darksight, which is why they need a subtype of their greater-form's organ..
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin),
		"head" =   list("path" = /obj/item/organ/external/head/vulpkanin),
		"tail" =   list("path" = /obj/item/organ/external/tail/monkey/vulpkanin),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right),
		"l_foot" = list("path" = /obj/item/organ/external/foot),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right))

/datum/species/monkey/skrell
	name = "Neara"
	name_plural = "Neara"

	icobase = 'icons/mob/human_races/monkeys/r_neara.dmi'
	deform = 'icons/mob/human_races/monkeys/r_neara.dmi'

	greater_form = /datum/species/skrell
	default_language = "Neara"
	blood_species = "Skrell"
	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	reagent_tag = PROCESS_ORG
	tail = null

	has_organ = list(
		"heart" =    /obj/item/organ/internal/heart/skrell,
		"lungs" =    /obj/item/organ/internal/lungs/skrell,
		"liver" =    /obj/item/organ/internal/liver/skrell,
		"kidneys" =  /obj/item/organ/internal/kidneys/skrell,
		"brain" =    /obj/item/organ/internal/brain/skrell,
		"appendix" = /obj/item/organ/internal/appendix,
		"eyes" =     /obj/item/organ/internal/eyes/skrell //Tajara monkey-forms are uniquely colourblind and have excellent darksight, which is why they need a subtype of their greater-form's organ..
		)
/datum/species/monkey/skrell/on_species_gain(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_WATERBREATH, "species")

/datum/species/monkey/skrell/on_species_loss(mob/living/carbon/human/H)
	..()
	REMOVE_TRAIT(H, TRAIT_WATERBREATH, "species")

/datum/species/monkey/unathi
	name = "Stok"
	name_plural = "Stok"

	icobase = 'icons/mob/human_races/monkeys/r_stok.dmi'
	deform = 'icons/mob/human_races/monkeys/r_stok.dmi'

	tail = "stoktail"
	greater_form = /datum/species/unathi
	default_language = "Stok"
	blood_species = "Unathi"
	flesh_color = "#34AF10"
	base_color = "#000000"
	reagent_tag = PROCESS_ORG

	bodyflags = HAS_TAIL

	has_organ = list(
		"heart" =    /obj/item/organ/internal/heart/unathi,
		"lungs" =    /obj/item/organ/internal/lungs/unathi,
		"liver" =    /obj/item/organ/internal/liver/unathi,
		"kidneys" =  /obj/item/organ/internal/kidneys/unathi,
		"brain" =    /obj/item/organ/internal/brain/unathi,
		"appendix" = /obj/item/organ/internal/appendix,
		"eyes" =     /obj/item/organ/internal/eyes/unathi
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin),
		"head" =   list("path" = /obj/item/organ/external/head),
		"tail" =   list("path" = /obj/item/organ/external/tail/monkey/unathi),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right),
		"l_foot" = list("path" = /obj/item/organ/external/foot),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right))
