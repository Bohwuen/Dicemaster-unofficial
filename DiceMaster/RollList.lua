-------------------------------------------------------------------------------
-- Dice Master (C) 2019 <The League of Lordaeron> - Moon Guard
-------------------------------------------------------------------------------
--

--
-- The roll options list
-- name			Name of the roll option
-- subName		Pattern for subbing text in description tooltips
-- wheelName	Name to display on the Roll Wheel
-- desc			Description of the roll option
-- stat			Statistic used as a modifier
--

DiceMaster4.RollList = {
	["Hab. Mágicas"] = {
		{
			name = "Taumaturgia",
			subName = "Taumaturgia",
			wheelName = "Taumaturgia",
			desc = "Un usuario de magia manifiesta el poder de dominar las energías sobrenaturales de la creación cuando comienza a comprenderlas, cuanto más lo comprenda mejor le saldrá sus conjuros y más efectivos serán.", 
														  
			stat = "Inteligencia",
		},
		{
			name = "Fe",
			subName = "Fe",
			wheelName = "Fe",
			desc = "Un creyente que abraza una entidad y busca su favor es bendecido por aquello por lo que siente devoción.", 
														   
			stat = "Voluntad",
		},
		{
			name = "Espiritualidad",
			subName = "Espiritualidad",
			wheelName = "Espiritualidad",
			desc = "La conexión del usuario con los planos espirituales y los seres vinculados a ellas mediante pactos con los propios espíritus.", 
												 
			stat = "Voluntad",
		},
		{
			name = "Naturaleza",
			subName = "Naturaleza",
			wheelName = "Naturaleza",
			desc = "Aquel que estudie a la naturaleza y establezca vínculos con la misma podrá despertar el poder de la vida misma.", 
			stat = "Voluntad",
		},
		{
			name = "Caos",
			subName = "Caos",
			wheelName = "Caos",
			desc = "Aquellos que dominan las artes oscuras alterando los poderes primordiales corrompiendolos y deformándolos para crear nuevas ramas mágicas se nutres de la corrupción misma.", 
			stat = "Inteligencia",
		},
	},
	["Hab. Armas"] = {
		{
			name = "Espadas de una mano",
			subName = "Espadas de una mano",
			wheelName = "Espada 1M",
			desc = "Atacar con espada de 1 mano.", 
																						 
			stat = "Destreza",
		},
		{
			name = "Espadas de dos manos",
			subName = "Espadas de una mano",
			wheelName = "Espada 2M",
			desc = "Atacar con espada de 2 manos.", 
																
			stat = "Destreza",
		},
		{
			name = "Mazas de una mano",
			subName = "Mazas de una mano",
			wheelName = "Maza 1M",
			desc = "Atacar con maza de 1 mano.", 
			stat = "Destreza",
		},
		{
			name = "Mazas de dos manos",
			subName = "Mazas de dos manos",
			wheelName = "Maza 2M",
			desc = "Atacar con maza de 2 manos.", 
														  
			stat = "Destreza",
		},
		{
			name = "Hachas de una mano",
			subName = "hachas de una mano",
			wheelName = "Hachas 1M",
			  
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Hachas de dos manos",
			subName = "hachas de dos manos",
			wheelName = "Hachas 2M",
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Arcos",
			subName = "Arcos",
			wheelName = "Arcos",
			   
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Armas de Fuego",
			subName = "Armas de fuego",
			wheelName = "Armas de fuego",
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Armas Arrojadizas",
			subName = "Armas arrojadizas",
			wheelName = "A. Arrojadizas",
			   
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Ballestas",
			subName = "Ballestas",
			wheelName = "Ballestas",
			   
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Bastones",
			subName = "Bastones",
			wheelName = "Bastones",
			   
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Varitas",
			subName = "Varitas",
			wheelName = "Varitas",
			desc = "", 
			stat = "Inteligencia",
		},
		{
			name = "Dagas",
			subName = "Dagas",
			wheelName = "Dagas",
			  
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Armas de Puño",
			subName = "Armas de puño",
			wheelName = "A. Puño",
			   
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Armas de Asta",
			subName = "Armas de Asta",
			wheelName = "A. Asta",
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Gujas de Guerra",
			subName = "Gujas de Guerra",
			wheelName = "Gujas",
			   
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Escudo",
			subName = "Escudo",
			wheelName = "Escudo",
			   
			desc = "", 
			stat = "Vigor",
		},
		{
			name = "Sin Armas",
			subName = "Sin Armas",
			wheelName = "Sin Armas",
			   
			desc = "", 
			stat = "Destreza",
		},
	},
	["Defensas"] = {
		{
			name = "Parada",
			subName = "Parada",
			wheelName = "Parada",
			   
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Esquivar",
			subName = "Esquivar",
			wheelName = "Esquivar",
			desc = "La habilidad de esquivar del personaje.", 
															
			stat = "Destreza",
		},
		{
			name = "Bloqueo",
			subName = "Bloqueo",
			wheelName = "Bloqueo",
			   
			desc = "", 
			stat = "Vigor",
		},	
		{
			name = "Abjuración",
			subName = "Abjuración",
			wheelName = "Abjuración",
			desc = "Abjuración o Metamagia", 
			stat = "Inteligencia",
		},
	},
	["Hab. Físicas"] = {
		{
			name = "Atletismo",
			subName = "Atletismo",
			wheelName = "Atletismo",
			desc = "", 
			stat = "Vigor",
		},
		{
			name = "Robo",
			subName = "Robo",
			wheelName = "Robo",
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Sigilo",
			subName = "Sigilo",
			wheelName = "Sigilo",
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Forzar cerraduras",
			subName = "Forzar cerraduras",
			wheelName = "Forzar Cerr.",
			desc = "", 
			stat = "Destreza",
		},
		{
			name = "Supervivencia",
			subName = "Supervivencia",
			wheelName = "Supervivencia",
			desc = "", 
			stat = "Vigor",
		},
		{
			name = "Trepar",
			subName = "Trepar",
			wheelName = "Trepar",
			desc = "Trepar o escalar", 
			stat = "Destreza",
		},
		{
			name = "Buscar",
			subName = "Buscar",
			wheelName = "Buscar",
			desc = "", 
			stat = "Percepción",
		},
	},
	["Hab. Mentales"] = {
		{
			name = "Alerta",
			subName = "Alerta",
			wheelName = "Alerta",
			desc = "", 
			stat = "Percepción",
		},
		{
			name = "Aprendizaje",
			subName = "Aprendizaje",
			wheelName = "Aprendizaje",
			desc = "", 
			stat = "Inteligencia",
		},
		{
			name = "Interpretación",
			subName = "Interpretación",
			wheelName = "Interpretación",
			desc = "", 
			stat = "Inteligencia",
		},
	},
	["Hab. Sociales"] = {
		{
			name = "Subterfugio",
			subName = "Subterfugio",
			wheelName = "Subterfugio",
			desc = "Mentir o ocultar la verdad.", 
			stat = "Inteligencia",
		},
		{
			name = "Trato con animales",
			subName = "Trato con animales",
			wheelName = "T. Animales",
			desc = "", 
			stat = "Inteligencia",
		},
		{
			name = "Intimidación",
			subName = "Intimidación",
			wheelName = "Intimidación",
			desc = "", 
			stat = "Vigor",
		},
		{
			name = "Carisma",
			subName = "Carisma",
			wheelName = "Carisma",
			desc = "", 
			stat = "Inteligencia",
		},
	},
}

DiceMaster4.AttributeList = {
	["Aguante"] = {
		desc = "Capacidad máxima de salud del personaje (1p. de aguante = 5p. de salud).",
	},
	["Vigor"] = {
		desc = "El estado físico del personaje.",
	},
	["Energía"] = {
		desc = "Capacidad máxima de energía del personaje (1p. de Energía = 5p. de Energía).",
	},
	["Destreza"] = {
		desc = "La destreza del Personaje.",
	},
	["Voluntad"] = {
		desc = "La capacidad mental del personaje.",
	},
	["Percepción"] = {
		desc = "La percepción del Personaje.",
	},
	["Inteligencia"] = {
		desc = "La Inteligencia del personaje.",
	},
}

DiceMaster4.TermsList = {
	["Effects"] = {
		{
			name = "Advantage",
			subName = "Advantage",
			iconID = 38,
			desc = "Allows a character to roll the same dice twice, and take the greater of the two resulting numbers.",
		},
		{
			name = "Armour Penetration",
			subName = "Arm[ou]*r Penetration",
			iconID = 16,
			desc = "Allows a character's successful attack to bypass the target's Armour this turn.",
		},
		{
			name = "Cleave",
			subName = "Cleave[s]*",
			iconID = 30,
			desc = "Allows a character's successful attack to inflict damage to up to two additional targets.",
		},
		{
			name = "Control",
			subName = "Control[sleding]*",
			iconID = 47,
			desc = "Allows a character to take command of a target and control their actions until the effect ends.",
		},
		{
			name = "Counter",
			subName = "Counter[seding]*",
			iconID = 48,
			desc = "Allows a character to immediately attack the same target after a successful Defence roll.",
		},
		{
			name = "Disadvantage",
			subName = "Disadvantage",
			iconID = 39,
			desc = "Allows a character to roll the same dice twice, and take the lesser of the two resulting numbers.",
		},
		{
			name = "Disarm",
			subName = "Disarm[s]*",
			iconID = 31,
			desc = "Removes a target's weapons for one turn, preventing them from using them.",
		},
		{
			name = "Double or Nothing",
			subName = "Double or Nothing",
			iconID = 32,
			desc = "An unmodified D40 roll. If the roll succeeds, the character is rewarded with a critical success; however, if the roll fails, the character suffers a critical failure.",
		},
		{
			name = "Empower",
			subName = "Empower[seding]*",
			iconID = 45,
			desc = "Allows a character's successful Melee Attack or Ranged Attack to be considered a Spell Attack.",
		},
		{
			name = "Immunity",
			subName = "Immunity",
			iconID = 46,
			desc = "Prevents a character from suffering any damage from a failure this turn.",
		},
		{
			name = "Intercept",
			subName = "Intercept[edsing]*",
			iconID = 49,
			desc = "Intercepts another character's failure, taking the full amount of damage.",
		},
		{
			name = "Multistrike",
			subName = "Multistrike",
			iconID = 28,
			desc = "Allows a character to attack twice on their turn; however, their second attack only inflicts 1 damage (2 if critically successful).",
		},
		{
			name = "Natural 1",
			subName = "NAT1",
			iconID = 37,
			desc = "A roll of 1 that is achieved before dice modifiers are applied that results in critical failure.",
			altTerm = "NAT1",
		},
		{
			name = "Natural 20",
			subName = "NAT20",
			iconID = 36,
			desc = "A roll of 20 that is achieved before dice modifiers are applied that results in critical success.",
			altTerm = "NAT20",
		},
		{
			name = "Reflect",
			subName = "Reflect[edsing]*",
			iconID = 50,
			desc = "Causes damage intended for a character to reflect back at the attacker.",
		},
		{
			name = "Reload",
			subName = "Reload[edsing]*",
			iconID = 29,
			desc = "Grants the character's active-use trait another use.",
		},
		{
			name = "Revive",
			subName = "Reviv[desing]*",
			iconID = 34,
			desc = "Allows a character with |cFFFFFFFF0|r|TInterface/AddOns/DiceMaster/Texture/health-heart:12|t|cFFffd100 remaining to return to combat with |cFFFFFFFF3|r|TInterface/AddOns/DiceMaster/Texture/health-heart:12|t|cFFffd100.",
		},
	},
	["Conditions"] = {
		{
			name = "Blind",
			subName = "Blind[seding]*",
			iconID = 1,
			desc = "The target is unable to see and automatically fails any ability check that requires sight. Attack rolls against the target have Advantage, and the target's attack rolls have Disadvantage.",
			term = "Blind",
		},
		{
			name = "Charm",
			subName = "Charm[seding]*",
			iconID = 3,
			desc = "The target is entranced and unable to attack the charmer. The charmer has Advantage on any ability check to interact socially with the target.",
			term = "Charm",
		},
		{
			name = "Deafen",
			subName = "Deafen[seding]*",
			iconID = 5,
			desc = "The target is unable to hear and automatically fails any ability check that requires hearing.",
		},
		{
			name = "Fatigue",
			subName = "Fatigu[esding]*",
			iconID = 6,
			desc = "The target cannot run nor charge. The target has Disadvantage on Fortitude and Reflex Saves.",
		},
		{
			name = "Frighten",
			subName = "Frighten[seding]*",
			iconID = 9,
			desc = "The target has Disadvantage on ability checks and attack rolls while the source of its fear is within line of sight. The target cannot willingly move closer to the source of its fear.",
		},
		{
			name = "Grapple",
			subName = "Grappl[edsing]*",
			iconID = 10,
			desc = "The target is unable to move for the duration of the Grapple. The condition ends if the grappler is incapacitated.",
		},
		{
			name = "Incapacitate",
			subName = "Incapacitat[esding]*",
			iconID = 11,
			desc = "The target cannot take actions or reactions.",
		},
		{
			name = "Invisible",
			subName = "Invisib[ilitye]*",
			iconID = 12,
			desc = "The target is impossible to see without the aid of magic or a special sense. Attack rolls against the target have Disadvantage, and the target's attack rolls have Advantage.",
		},
		{
			name = "Paralyse",
			subName = "Paraly[sz]*[esding]*",
			iconID = 14,
			desc = "The target cannot take actions or reactions, move, or speak. The target automatically fails Fortitude and Reflex Saves. Attack rolls against the target have Advantage.",
		},
		{
			name = "Petrify",
			subName = "Petrif[iyesding]*",
			iconID = 15,
			desc = "The target is transformed into solid stone and cannot take actions or reactions, move, or speak. Attack rolls against the target have Advantage. The target is immune to poison and disease, but automatically fails Fortitude and Reflex Saves.",
		},
		{
			name = "Poison",
			subName = "Poison[seding]*",
			iconID = 18,
			desc = "The target has Disadvantage on attack rolls and ability checks.",
		},
		{
			name = "Prone",
			subName = "Prone",
			iconID = 19,
			desc = "The target's only movement option is to crawl, unless it stands up and ends the condition. The target has Disadvantage on attack rolls. Melee Attack rolls against the target have Advantage, but Ranged Attack rolls have Disadvantage.",
		},
		{
			name = "Restrain",
			subName = "Restrain[seding]*",
			iconID = 22,
			desc = "The target is unable to move and has Disadvantage on Reflex Saves. Attack rolls against the target have Advantage, and the target's attack rolls have Disadvantage.",
		},
		{
			name = "Silence",
			subName = "Silenc[esding]*",
			iconID = 33,
			desc = "Interrupts a target's spellcast and prevents them from casting spells on their next turn.",
		},
		{
			name = "Slow",
			subName = "Slow[seding]*",
			iconID = 35,
			desc = "Reduces a target's movement speed until the effect ends.",
		},
		{
			name = "Stun",
			subName = "Stun[sneding]*",
			iconID = 24,
			desc = "The target cannot take actions or reactions, cannot move, and can speak only falteringly. The target automatically fails Fortitude and Reflex Saves. Attack rolls against the target have Advantage.",
		},
		{
			name = "Unconscious",
			subName = "Unconscious",
			iconID = 26,
			desc = "The target cannot take actions or reactions, cannot move or speak, and drops whatever it is holding. The target automatically fails Fortitude and Reflex Saves and attack rolls against the target have Advantage.",
		},
	},
	["Other"] = {
		{
			name = "Armour",
			subName = "Armo[u]*r",
			desc = "Extends a character's Health beyond the maximum amount by a certain value. Damage taken will usually be deducted from Armour before Health unless otherwise specified.",
			altTerm = "AR",
		},
		{
			name = "Health",
			subName = "Health",
			desc = "A measure of a character's health or an object's integrity. Damage taken decreases Health, and healing restores Health.",
			altTerm = "HP",
		},
	},
}
