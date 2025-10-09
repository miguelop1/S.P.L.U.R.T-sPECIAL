// Permite cambiar el modo de bellyriding si el usuario está llevando a alguien
/mob/living/carbon/proc/change_bellyriding_mode()
    if(!src.jacket_bellyrider)
        to_chat(src, "You cannot change bellyriding mode if you're not bellyriding someone.")
        return
    if(src.handcuffed || src.legcuffed)
        to_chat(src, "How will you change your possition while being cuffed?")
        return
    var/choice = input(src, "Change bellyriding style:", "Rythmic", null) as null|anything in list("Rythmic", "Normal", "Intenso")
    if(isnull(choice))
        to_chat(src, "No seleccionaste ningún ritmo.")
        return
    src.bellyriding_mode = choice
    to_chat(src, "Has cambiado el ritmo de bellyriding a [choice].")
// Bellyriding: permite que un carbon "use" a otro como bellyrider
// Modular para zzplurt

/mob/living/carbon/proc/bellyride(target)
    if(!istype(target, /mob/living/carbon))
        return FALSE
    if(src.is_limbless)
        to_chat(src, "Cant bellyride while being limbless.")
        return FALSE
    if(!(target.is_limbless || (target.handcuffed && target.legcuffed)))
        to_chat(src, "Cant bellyride someone who isnt limbless or fully bound.")
        return FALSE
    // Verificar pene expuesto en el usuario
    if(!src.has_penis(REQUIRE_GENITAL_EXPOSED))
        to_chat(src, "You must pull your cock out for bellyriding.")
        return FALSE
    // Verificar vagina o ano expuesto en el receptor
    var/has_vag = target.has_vagina(REQUIRE_GENITAL_EXPOSED)
    var/has_anus = target.has_anus(REQUIRE_GENITAL_EXPOSED)
    if(!(has_vag || has_anus))
        to_chat(src, "Expose your victim's bottom first.")
        return FALSE
    if(src.get_item_by_slot(ITEM_SLOT_JACKET))
        to_chat(src, "You need your jacket slot to be free to commit this action.")
        return FALSE
    // Selección de objetivo (ano o vagina)
    var/list/targets = list()
    if(has_vag)
        targets += "Vagina"
    if(has_anus)
        targets += "Ass"
    var/target_choice = input(src, "Choose where to bellyride:", "Target", null) as null|anything in targets
    if(isnull(target_choice))
        to_chat(src, "No target selected.")
        return FALSE
    src.bellyriding_target_zone = target_choice // Guardar selección
    // Mostrar panel de ritmo
    var/choice = input(src, "Choose the kind of bellyriding you want to do", "Ritmo", null) as null|anything in list("Rítmico", "Normal", "Intenso")
    if(isnull(choice))
        to_chat(src, "No seleccionaste ningún ritmo.")
        return FALSE
    src.bellyriding_mode = choice
    src.equip_bellyrider(target)
    if(!src.is_taur)
        src.add_movespeed_modifier(/datum/movespeed_modifier/bellyriding)
    src.add_armor_cover("chest", target)
    to_chat(src, "omgsexyuser") // Mensaje explícito
    to_chat(target, "omgsexyreceiver") // Mensaje explícito
    src.bellyriding_steps = 0
    src.bellyriding_next_msg = rand(2,4)
    return TRUE

// Realiza los efectos de un "paso" de bellyriding: invoca el verbo apropiado según el modo, aplica reseteos.
/mob/living/carbon/proc/bellyriding_perform_step()
    if(!src.jacket_bellyrider)
        return
    var/limite = src.bellyriding_next_msg
    if(isnull(limite))
        limite = rand(2,4)
        src.bellyriding_next_msg = limite
    var/frecuencia = limite
    var/lewdverb_type = null
    switch(src.bellyriding_mode)
        if("Intenso")
            lewdverb_type = /datum/interaction/lewd/bellyriding_intense
            frecuencia = 1
        if("Normal")
            lewdverb_type = /datum/interaction/lewd/bellyriding_normal
            frecuencia = 2
        if("Rítmico")
            lewdverb_type = /datum/interaction/lewd/bellyriding_rythmic
            frecuencia = 4
    if(isnull(src.bellyriding_steps))
        src.bellyriding_steps = 0
    if(src.bellyriding_steps >= frecuencia)
        if(!isnull(lewdverb_type))
            var/datum/interaction/lewd/verb = new lewdverb_type
            // Ejecuta el verbo como si el usuario lo hubiera usado
            verb.execute(src, src.jacket_bellyrider, src.bellyriding_target)
        // Resetear contadores y preparar próximo mensaje
        src.bellyriding_steps = 0
        src.bellyriding_next_msg = rand(2,4)

// Hook para contar pasos y enviar mensajes cercanos
/mob/living/carbon/proc/on_bellyriding_step()
    if(src.jacket_bellyrider)
        if(isnull(src.bellyriding_steps))
            src.bellyriding_steps = 0
        src.bellyriding_steps++
        // Delegar la lógica real del "paso" al proc reutilizable
        src.bellyriding_perform_step()

/mob/living/carbon/proc/equip_bellyrider(target)
    target.loc = src
    src.jacket_bellyrider = target
    // Actualizar iconos, overlays, etc. (placeholder)

/mob/living/carbon/proc/apply_damage_with_bellyrider(damage, damagetype, def_zone, ...)
    if(def_zone == BODY_ZONE_CHEST && src.jacket_bellyrider)
        var/absorbed = min(damage, 20) // placeholder: absorbe hasta 20
        src.jacket_bellyrider.apply_damage(absorbed, damagetype, def_zone)
        damage -= absorbed
        if(damage > 0 || damagetype == BOMB)
            return ..(damage, damagetype, def_zone, ...)
        return TRUE
    return ..(damage, damagetype, def_zone, ...)
