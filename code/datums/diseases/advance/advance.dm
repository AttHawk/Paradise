/*

	Advance Disease is a system for Virologist to Engineer their own disease with symptoms that have effects and properties
	which add onto the overall disease.

	If you need help with creating new symptoms or expanding the advance disease, ask for Giacom on #coderbus.

*/

// The order goes from easy to cure to hard to cure.
GLOBAL_LIST_INIT(advance_cures, list(
									"sodiumchloride", "sugar", "orangejuice",
									"spaceacillin", "salglu_solution", "ethanol",
									"teporone", "diphenhydramine", "lipolicide",
									"silver", "gold"
))

GLOBAL_LIST_EMPTY(archive_diseases)

/*

	PROPERTIES

 */

/datum/disease/advance

	name = "Unknown" // We will always let our Virologist name our disease.
	desc = "Спроектированная болезнь, может содержать сразу несколько симптомов."
	form = "Улучшенная болезнь" // Will let med-scanners know that this disease was engineered.
	agent = "advance microbes"
	max_stages = 5
	spread_text = "Unknown"
	viable_mobtypes = list(/mob/living/carbon/human)

	// NEW VARS

	var/list/symptoms = list() // The symptoms of the disease.
	var/id = ""
	var/processing = 0

/datum/disease/advance/New()
	if(!symptoms || !symptoms.len)
		symptoms = GenerateSymptoms(0, 2)

	AssignProperties(GenerateProperties())
	id = GetDiseaseID()

/datum/disease/advance/Destroy()
	if(processing)
		for(var/datum/symptom/S in symptoms)
			S.End(src)
	return ..()

// Randomly pick a symptom to activate.
/datum/disease/advance/stage_act()
	if(!..())
		return FALSE
	if(symptoms && symptoms.len)

		if(!processing)
			processing = 1
			for(var/datum/symptom/S in symptoms)
				S.Start(src)

		for(var/datum/symptom/S in symptoms)
			S.Activate(src)
	else
		CRASH("We do not have any symptoms during stage_act()!")
	return TRUE

// Compares type then ID.
/datum/disease/advance/IsSame(datum/disease/advance/D)

	if(!(istype(D, /datum/disease/advance)))
		return FALSE

	if(GetDiseaseID() != D.GetDiseaseID())
		return FALSE
	return TRUE

// To add special resistances.
/datum/disease/advance/cure(resistance = TRUE)
	if(affected_mob)
		var/id = "[GetDiseaseID()]"
		if(resistance && !(id in affected_mob.resistances))
			affected_mob.resistances[id] = id
		remove_virus()
	qdel(src)	//delete the datum to stop it processing

// Returns the advance disease with a different reference memory.
/datum/disease/advance/Copy()
	var/datum/disease/advance/copy = new
	var/list/skipped = list("symptoms","affected_mob","holder","carrier","stage","type","parent_type","vars","transformed")
	for(var/V in vars - skipped)
		if(istype(vars[V], /list))
			var/list/L = vars[V]
			copy.vars[V] = L.Copy()
		else
			copy.vars[V] = vars[V]
	copy.symptoms = list()
	for(var/datum/symptom/S in symptoms)
		copy.symptoms += new S.type
	return copy

// Mix the symptoms of two diseases (the src and the argument)
/datum/disease/advance/proc/Mix(datum/disease/advance/D)
	if(!(IsSame(D)))
		var/list/possible_symptoms = shuffle(D.symptoms)
		for(var/datum/symptom/S in possible_symptoms)
			AddSymptom(new S.type)

/datum/disease/advance/proc/HasSymptom(datum/symptom/S)
	for(var/datum/symptom/symp in symptoms)
		if(symp.id == S.id)
			return 1
	return 0

// Will generate new unique symptoms, use this if there are none. Returns a list of symptoms that were generated.
/datum/disease/advance/proc/GenerateSymptoms(level_min, level_max, amount_get = 0)

	var/list/generated = list() // Symptoms we generated.

	// Generate symptoms. By default, we only choose non-deadly symptoms.
	var/list/possible_symptoms = list()
	for(var/symp in GLOB.list_symptoms)
		var/datum/symptom/S = new symp
		if(S.level >= level_min && S.level <= level_max)
			if(!HasSymptom(S))
				possible_symptoms += S

	if(!possible_symptoms.len)
		return generated

	// Random chance to get more than one symptom
	var/number_of = amount_get
	if(!amount_get)
		number_of = 1
		while(prob(20))
			number_of += 1

	for(var/i = 1; number_of >= i && possible_symptoms.len; i++)
		generated += pick_n_take(possible_symptoms)

	return generated

/datum/disease/advance/proc/Refresh(var/update_mutations = TRUE, var/reset_name = FALSE)
	AssignProperties(GenerateProperties())
	id = GetDiseaseID()

	var/datum/disease/advance/A = GLOB.archive_diseases[id]
	if(update_mutations)
		UpdateMutationsProps(A)

	if(A)
		name = A.name
	else
		if(reset_name)
			name = "Unknown"
		AddToArchive()

/datum/disease/advance/proc/AddToArchive()
	GLOB.archive_diseases[id] = Copy()

/datum/disease/advance/proc/UpdateMutationsProps(var/datum/disease/advance/A)
	var/datum/disease/advance/AA = A ? A : new

	mutation_reagents = AA.mutation_reagents.Copy()
	possible_mutations = AA.possible_mutations?.Copy()

//Generate disease properties based on the effects. Returns an associated list.
/datum/disease/advance/proc/GenerateProperties()

	if(!symptoms || !symptoms.len)
		CRASH("We did not have any symptoms before generating properties.")

	var/list/properties = list("resistance" = 1, "stealth" = 0, "stage_speed" = 1, "transmittable" = 1, "severity" = 0)

	for(var/datum/symptom/S in symptoms)

		properties["resistance"] += S.resistance
		properties["stealth"] += S.stealth
		properties["stage_speed"] += S.stage_speed
		properties["transmittable"] += S.transmittable
		properties["severity"] = max(properties["severity"], S.severity) // severity is based on the highest severity symptom

	return properties

// Assign the properties that are in the list.
/datum/disease/advance/proc/AssignProperties(list/properties = list())

	if(properties && properties.len)
		switch(properties["stealth"])
			if(2)
				visibility_flags = HIDDEN_SCANNER
			if(3 to INFINITY)
				visibility_flags = HIDDEN_SCANNER|HIDDEN_PANDEMIC
			else
				visibility_flags = VISIBLE

		// The more symptoms we have, the less transmittable it is but some symptoms can make up for it.
		SetSpread(clamp(2 ** (properties["transmittable"] - symptoms.len), BLOOD, AIRBORNE))
		permeability_mod = max(CEILING(0.4 * properties["transmittable"], 1), 1)
		cure_chance = 15 - clamp(properties["resistance"], -5, 5) // can be between 10 and 20
		stage_prob = max(properties["stage_speed"], 2)
		SetSeverity(properties["severity"])
		GenerateCure(properties)
	else
		CRASH("Our properties were empty or null!")


// Assign the spread type and give it the correct description.
/datum/disease/advance/proc/SetSpread(spread_id)
	switch(spread_id)
		if(NON_CONTAGIOUS)
			spread_text = "None"
		if(SPECIAL)
			spread_text = "None"
		if(CONTACT_GENERAL, CONTACT_HANDS, CONTACT_FEET)
			spread_text = "On contact"
		if(AIRBORNE)
			spread_text = "Airborne"
		if(BLOOD)
			spread_text = "Blood"

	spread_flags = spread_id

/datum/disease/advance/proc/SetSeverity(level_sev)

	switch(level_sev)

		if(-INFINITY to 0)
			severity = NONTHREAT
		if(1)
			severity = MINOR
		if(2)
			severity = MEDIUM
		if(3)
			severity = HARMFUL
		if(4)
			severity = DANGEROUS
		if(5 to INFINITY)
			severity = BIOHAZARD
		else
			severity = "Unknown"


// Will generate a random cure, the less resistance the symptoms have, the harder the cure.
/datum/disease/advance/proc/GenerateCure(list/properties = list())
	if(properties && properties.len)
		var/res = round(clamp(properties["resistance"] - (symptoms.len / 2), 1, GLOB.advance_cures.len))

		// Get the cure name from the cure_id
		var/datum/reagent/D = GLOB.chemical_reagents_list[GLOB.advance_cures[res]]
		cures = list(GLOB.advance_cures[res])
		cure_text = D.name

// Randomly generate a symptom, has a chance to lose or gain a symptom.
/datum/disease/advance/proc/Evolve(min_level, max_level)
	var/s = safepick(GenerateSymptoms(min_level, max_level, 1))
	if(s)
		AddSymptom(s)
		Refresh(reset_name = TRUE)
	return

// Randomly remove a symptom.
/datum/disease/advance/proc/Devolve()
	if(symptoms.len > 1)
		var/s = safepick(symptoms)
		if(s)
			RemoveSymptom(s)
			Refresh(reset_name = TRUE)
	return

// Name the disease.
/datum/disease/advance/proc/AssignName(name = "Unknown")
	src.name = name
	return

// Return a unique ID of the disease.
/datum/disease/advance/GetDiseaseID()
	var/list/L = list()
	for(var/datum/symptom/S in symptoms)
		L += S.id
	L = sortList(L) // Sort the list so it doesn't matter which order the symptoms are in.
	return jointext(L, ":")

// Add a symptom, if it is over the limit (with a small chance to be able to go over)
// we take a random symptom away and add the new one.
/datum/disease/advance/proc/AddSymptom(datum/symptom/S)

	if(HasSymptom(S))
		return

	if(symptoms.len < (VIRUS_SYMPTOM_LIMIT - 1) + rand(-1, 1))
		symptoms += S
	else
		RemoveSymptom(pick(symptoms))
		symptoms += S
	return

// Simply removes the symptom.
/datum/disease/advance/proc/RemoveSymptom(datum/symptom/S)
	symptoms -= S
	return

/*

	Static Procs

*/

// Mix a list of advance diseases and return the mixed result.
/proc/Advance_Mix(var/list/D_list)

	var/list/diseases = list()

	for(var/datum/disease/advance/A in D_list)
		diseases += A.Copy()

	if(!diseases.len)
		return null
	if(diseases.len <= 1)
		return pick(diseases) // Just return the only entry.

	var/i = 0
	// Mix our diseases until we are left with only one result.
	while(i < 20 && diseases.len > 1)

		i++

		var/datum/disease/advance/D1 = pick(diseases)
		diseases -= D1

		var/datum/disease/advance/D2 = pick(diseases)
		D2.Mix(D1)

	 // Should be only 1 entry left, but if not let's only return a single entry
//	to_chat(world, "END MIXING!!!!!")
	var/datum/disease/advance/to_return = pick(diseases)
	to_return.Refresh(reset_name = TRUE)
	return to_return

/proc/SetViruses(datum/reagent/R, list/data)
	if(data)
		var/list/preserve = list()
		if(istype(data) && data["viruses"])
			for(var/datum/disease/A in data["viruses"])
				preserve += A.Copy()
			R.data = data.Copy()
		if(preserve.len)
			R.data["viruses"] = preserve

/proc/AdminCreateVirus(client/user)

	if(!user)
		return

	var/i = VIRUS_SYMPTOM_LIMIT

	var/datum/disease/advance/D = new
	D.Refresh()
	D.symptoms = list()

	var/list/symptoms = list()
	symptoms += "Done"
	symptoms += GLOB.list_symptoms.Copy()
	do
		if(user)
			var/symptom = input(user, "Choose a symptom to add ([i] remaining)", "Choose a Symptom") in symptoms
			if(isnull(symptom))
				return
			else if(istext(symptom))
				i = 0
			else if(ispath(symptom))
				var/datum/symptom/S = new symptom
				if(!D.HasSymptom(S))
					D.symptoms += S
					i -= 1
	while(i > 0)

	if(D.symptoms.len > 0)

		var/new_name = stripped_input(user, "Name your new disease.", "New Name")
		if(!new_name)
			return
		D.AssignName(new_name)
		D.Refresh()

		for(var/datum/disease/advance/AD in GLOB.active_diseases)
			AD.Refresh()

		for(var/thing in shuffle(GLOB.human_list))
			var/mob/living/carbon/human/H = thing
			if(H.stat == DEAD || !is_station_level(H.z))
				continue
			if(!H.HasDisease(D))
				H.ForceContractDisease(D)
				break

		var/list/name_symptoms = list()
		for(var/datum/symptom/S in D.symptoms)
			name_symptoms += S.name
		message_admins("[key_name_admin(user)] has triggered a custom virus outbreak of [D.name]! It has these symptoms: [english_list(name_symptoms)]")



/datum/disease/advance/proc/totalStageSpeed()
	var/total_stage_speed = 0
	for(var/i in symptoms)
		var/datum/symptom/S = i
		total_stage_speed += S.stage_speed
	return total_stage_speed

/datum/disease/advance/proc/totalStealth()
	var/total_stealth = 0
	for(var/i in symptoms)
		var/datum/symptom/S = i
		total_stealth += S.stealth
	return total_stealth

/datum/disease/advance/proc/totalResistance()
	var/total_resistance = 0
	for(var/i in symptoms)
		var/datum/symptom/S = i
		total_resistance += S.resistance
	return total_resistance

/datum/disease/advance/proc/totalTransmittable()
	var/total_transmittable = 0
	for(var/i in symptoms)
		var/datum/symptom/S = i
		total_transmittable += S.transmittable
	return total_transmittable
