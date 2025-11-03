/datum/interaction/lewd/bellyriding_intense
	name = "Bellyriding (Intense)"
	description = "A fast and intense bellyride."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED, ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	message = list(
		"You fuck the [TARGET] with intensity.",
		"The [USER] fucks you with intensity.",
	)
	user_pleasure = 8
	target_pleasure = 8
	user_arousal = 12
	target_arousal = 12

/datum/interaction/lewd/bellyriding_normal
	name = "Bellyriding (Normal)"
	description = "A normal paced bellyride."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED, ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	message = list(
		"You fuck the [TARGET] with a normal pace.",
		"The [USER] fucks you with a normal pace.",
	)
	user_pleasure = 4
	target_pleasure = 4
	user_arousal = 8
	target_arousal = 8

/datum/interaction/lewd/bellyriding_rythmic
	name = "Bellyriding (Rythmic)"
	description = "A slow and rythmic bellyride."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED, ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	message = list(
		"You slowly fuck the [TARGET] with a rythmic pace.",
		"The [USER] slowly fucks you with a rythmic pace.",
	)
	user_pleasure = 16
	target_pleasure = 16
	user_arousal = 16
	target_arousal = 16
