

// Allows to change the bellyriding mode if the user is carrying someone
/mob/living/carbon/proc/change_bellyriding_mode()
    if(!src.jacket_bellyrider)
        to_chat(src, "You cannot change bellyriding mode if you're not bellyriding someone.")
        return
    if(src.handcuffed || src.legcuffed)
        to_chat(src, "How will you change your possition while being cuffed?")
        return
    var/choice = input(src, "Change bellyriding style:", "Rhythm", null) as null|anything in list("Rythmic", "Normal", "Intense")
    if(isnull(choice))
        to_chat(src, "You didn't select any rhythm.")
        return
    src.bellyriding_mode = choice
    to_chat(src, "You have changed the bellyriding rhythm to [choice].")
// Bellyriding: allows a carbon to "use" another as a bellyrider
// Modular for zzplurt

/mob/living/carbon/verb/bellyride_verb(mob/living/carbon/target as mob in view(1))
	set name = "Bellyride"
	set category = "IC"

	if(incapacitated())
		return

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(bellyride), target))


/mob/living/carbon/proc/bellyride(target)
    if(!istype(target, /mob/living/carbon))
        return FALSE
    if(src.is_limbless)
        to_chat(src, "Cant bellyride while being limbless.")
        return FALSE
    if(!(target.is_limbless || (target.handcuffed && target.legcuffed)))
        to_chat(src, "Cant bellyride someone who isnt limbless or fully bound.")
        return FALSE
    // Check for exposed penis on the user
    if(!src.has_penis(REQUIRE_GENITAL_EXPOSED))
        to_chat(src, "You must pull your cock out for bellyriding.")
        return FALSE
    // Check for exposed vagina or anus on the receiver
    var/has_vag = target.has_vagina(REQUIRE_GENITAL_EXPOSED)
    var/has_anus = target.has_anus(REQUIRE_GENITAL_EXPOSED)
    if(!(has_vag || has_anus))
        to_chat(src, "Expose your victim's bottom first.")
        return FALSE
    if(src.get_item_by_slot(ITEM_SLOT_JACKET))
        to_chat(src, "You need your jacket slot to be free to commit this action.")
        return FALSE
    // Target selection (anus or vagina)
    var/list/targets = list()
    if(has_vag)
        targets += "Vagina"
    if(has_anus)
        targets += "Ass"
    var/target_choice = input(src, "Choose where to bellyride:", "Target", null) as null|anything in targets
    if(isnull(target_choice))
        to_chat(src, "No target selected.")
        return FALSE
    src.bellyriding_target_zone = target_choice // Save selection
    // Show rhythm panel
    var/choice = input(src, "Choose the kind of bellyriding you want to do", "Rhythm", null) as null|anything in list("Rythmic", "Normal", "Intense")
    if(isnull(choice))
        to_chat(src, "You didn't select any rhythm.")
        return FALSE
    src.bellyriding_mode = choice
    src.equip_bellyrider(target)
    if(!src.is_taur)
        src.add_movespeed_modifier(/datum/movespeed_modifier/bellyriding)
    to_chat(src, "You start to bellyride [target].")
    to_chat(target, "[src] starts to bellyride you.")


// Performs the effects of a bellyriding "step": invokes the appropriate verb according to the mode, applies resets.
/mob/living/carbon/proc/bellyriding_perform_step()
    if(!src.jacket_bellyrider)
        return
    var/limit = src.bellyriding_next_msg
    if(isnull(limit))
        limit = rand(2,4)
        src.bellyriding_next_msg = limit
    var/frequency = limit
    var/lewdverb_type = null
    switch(src.bellyriding_mode)
        if("Intense")
            lewdverb_type = /datum/interaction/lewd/bellyriding_intense
            frequency = 1
        if("Normal")
            lewdverb_type = /datum/interaction/lewd/bellyriding_normal
            frequency = 2
        if("Rythmic")
            lewdverb_type = /datum/interaction/lewd/bellyriding_rythmic
            frequency = 4
    if(isnull(src.bellyriding_steps))
        src.bellyriding_steps = 0
    if(src.bellyriding_steps >= frequency)
        if(!isnull(lewdverb_type))
            var/datum/interaction/lewd/verb = new lewdverb_type
            // Executes the verb as if the user had used it
            verb.execute(src, src.jacket_bellyrider, src.bellyriding_target)
        // Reset counters and prepare next message
        src.bellyriding_steps = 0
        src.bellyriding_next_msg = rand(2,4)

// Hook to count steps and send nearby messages
/mob/living/carbon/proc/on_bellyriding_step()
    if(src.jacket_bellyrider)
        if(isnull(src.bellyriding_steps))
            src.bellyriding_steps = 0
        src.bellyriding_steps++
        // Delegate the actual "step" logic to the reusable proc
        src.bellyriding_perform_step()

// Equips the target to the user's jacket slot.
/mob/living/carbon/proc/equip_bellyrider(target)
    target.loc = src
    src.jacket_bellyrider = target
    // Update icons, overlays, etc.
