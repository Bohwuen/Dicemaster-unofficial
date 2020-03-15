-------------------------------------------------------------------------------
-- Dice Master (C) 2019 <The League of Lordaeron> - Moon Guard
-------------------------------------------------------------------------------

local Me = DiceMaster4

local AceConfig       = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local SharedMedia     = LibStub("LibSharedMedia-3.0")

local VERSION = 1

-------------------------------------------------------------------------------
local DB_DEFAULTS = {
	
	global = {
		version     = nil;
		hideInspect = false; -- hide inspect frame when panel is hidden
		hideStats   = false; -- hide stats button from inspect frame.
		hidePet   = false; -- hide pet portrait frame from inspect frame.
		hideTips	= true; -- turn enhanced tooltips on for newbies
		hideTracker = false; -- hide the roll tracker.
		trackerAnchor = "RIGHT";
		hideTypeTracker = false;
		enableRoundBanners = true;
		talkingHeads = true;
		soundEffects = true;
		allowAssistantTalkingHeads = true;
		allowBuffs = true;
		bloodEffects = true;
		miniFrames = false;
		snapping = false;
	};
	
	char = { 
		minimapicon = {
			hide = false;
		};
		hidepanel     = false;
		uiScale       = 0.75;
		trackerScale  = 0.6;
		trackerKeybind = nil;
		showRaidRolls = false;
		healthPos    = false;
		dm3Imported   = false;
		statusSerial  = 1;
		traitSerials  = {};
		unitframes = {
			enable  = true;
			scale   = 0.5;
		};
		rollOptions = {};
	};
	
	profile = {
		charges = {
			enable  = true;
			name    = "Cargas";
			color   = {1,1,1};
			count   = 0;
			max     = 3;
			tooltip = "Representa la cantidad de Cargas que ha acumulado para usar en los rasgos.";
			symbol	= "charge-orb";
			pos		= false;
		};
		morale = {
			enable  = false;
			name    = "Moral";
			count   = 100;
			step    = 5;
			tooltip = "Mide la condición mental y emocional general del grupo al enfrentar un desafío. La baja moral puede tener consecuencias negativas.";
			color   = {1,1,0};
			symbol  = "WoWUI";
			scale   = 0.75;
		};
		health       = 5;
		healthMax    = 5;
		armor        = 0;
		traits       = {};
		pet	= {
			enable  = false;
			name 	= "Nombre de mascota";
			type    = "Pet";
			icon 	= "Interface/Icons/inv_misc_questionmark";
			model 	= 0;
			health       = 5;
			healthMax    = 5;
			armor        = 0;
		};
		inventory	 = {};
		buffs		 = {};
		removebuffs  = {};
		setdice      = {};
		buffsActive  = {};
		stats = {
		};
		level        = 1;
		experience   = 0;
		dice 		 = "1D20+0";
	} 
}

-- Initialize traits.
do
	local numbers = { "Uno", "Dos", "Tres", "Cuatro", "Cinco" }
	for i = 1, 5 do
		 
		DB_DEFAULTS.profile.traits[i] = {
			name   = "Rasgo " .. numbers[i];                    -- name of trait
			usage  = Me.TRAIT_USAGE_MODES[1];                   -- usage, see USAGE_MODES
			range  = Me.TRAIT_RANGE_MODES[1];                   -- usage, see RANGE_MODES
			castTime = Me.TRAIT_CAST_TIME_MODES[1];				-- cast time, see CAST_TIME_MODES
			desc   = "Escribe una descripción para el rasgo aquí."; -- trait description
			approved = false;									-- trait approved
			officers = {};										-- approved by
			icon   = "Interface/Icons/inv_misc_questionmark";   -- trait icon texture path
		}
		
		DB_DEFAULTS.char.traitSerials[i] = 1 -- used to optimize out duplicate requests
	end
	DB_DEFAULTS.profile.traits[5].name = "Rasgo especial"
end

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
Me.configOptions = {
	type  = "group";
	order = 1;
	args = { 
		-----------------------------------------------------------------------
		header = {
			order = 0;
			name  = "Configurar los ajustes básicos para DiceMaster.";
			type  = "description";
		};
		
		mmicon = {
			order = 1;
			name  = "Icono de minimapa";
			desc  = "Ocultar o mostrar el minimapa.";
			type  = "toggle";
			set   = function( info, val ) Me.MinimapButton:Show( val ) end;
			get   = function( info ) return not Me.db.char.minimapicon.hide end;
		};
 
		uiScale = {
			order     = 5;
			name      = "Escala de interfaz";
			desc      = "El tamaño del interfaz de marcos de Dicemaster y editor de rasgos, Cargas, Inspección y barra de progreso.";
			type      = "range";
			min       = 0.25;
			max       = 10;
			softMax   = 4;
			isPercent = true;
			set = function( info, val ) 
				Me.db.char.uiScale = val;
				Me.ApplyUiScale()
			end;
			get = function( info ) return Me.db.char.uiScale end;
		};
		
		hideInspect = {
			order = 6;
			name  = "Ocultar marco de inspección";
			desc  = "Ocultar marco de inspección cuando el interfaz de dicemaster esté oculto.";
			type  = "toggle";
			width = "double";
			set = function( info, val )
				Me.db.global.hideInspect = val
				Me.Inspect_Open( Me.inspectName )
				-- refresh hidden status.
			end;
			get = function( info ) return Me.db.global.hideInspect end;
		};
		
		hideStats = {
			order = 7;
			name  = "Ocultar botón de estadisticas en marco de inspección.";
			desc  = "Ocultar el botón Estadísticas del marco Inspección.";
			type  = "toggle";
			width = "double";
			set = function( info, val )
				Me.db.global.hideStats = val
				Me.Inspect_Open( Me.inspectName )
				-- refresh hidden status.
			end;
			get = function( info ) return Me.db.global.hideStats end;
		};
		
		hidePet = {
			order = 8;
			name  = "Ocultar marco de mascota";
			desc  = "Ocultar marco de mascota.";
			type  = "toggle";
			width = "double";
			set = function( info, val )
				Me.db.global.hidePet = val
				Me.Inspect_Open( Me.inspectName )
				-- refresh hidden status.
			end;
			get = function( info ) return Me.db.global.hidePet end;
		};
		
		hideTips = {
			order = 9;
			name  = "Habilitar herramientas mejoradas";
			desc  = "Habilitar las definiciones de DiceMaster junto a la información sobre herramientas de rasgo.";
			type  = "toggle";
			width = "double";
			set = function( info, val )
				Me.db.global.hideTips = val
			end;
			get = function( info ) return Me.db.global.hideTips end;
		};
		
		hideTypeTracker = {
			order = 12;
			name  = "Habilitar seguimiento de escritura";
			desc  = "Habilitar el seguimiento de escritura para que le avise cuando los miembros del grupo escriben, por ejemplo, emoción, grupo y banda.";
			type  = "toggle";
			width = "double";
			set = function( info, val )
				Me.db.global.hideTypeTracker = val
			end;
			get = function( info ) return Me.db.global.hideTypeTracker end;
		};
		
		enableRoundBanners = {
			order = 13;
			name  = "Habilitar petición de tiradas";
			desc  = "Habilitar la capacidad de que el lider pueda enviarte peticiones de tiradas.";
			type  = "toggle";
			width = "double";
			set = function( info, val )
				Me.db.global.enableRoundBanners = val
			end;
			get = function( info ) return Me.db.global.enableRoundBanners end;
		};
				enableD10 = {
			order = 14;
			name  = "Habilitar modo D10";
			desc  = "Habilitar modo Dados 10.";
			type  = "toggle";
			width = "double";
			set = function( info, val )
				Me.db.global.enableD10 = val
			end;
			get = function( info ) return Me.db.global.enableD10 end;
		};
		headerFrames = {
			order = 15;
			name  = " ";
			type  = "description";
		};
		
		unlockFrames = {
			order = 17;
			name  = "Desbloquear marcos";
			desc  = "Desbloquea todos los marcos, permitiéndote hacer clic y arrastrarlos alrededor de tu interfaz de usuario.";
			type  = "execute";
			width = "normal";
			func  = function()
				InterfaceOptionsFrame_Show()
				Me.UnlockFrames()
			end;
		};
		
		lockFrames = {
			order = 18;
			name  = "Bloquear marcos";
			desc  = "Bloquea todos los marcos.";
			type  = "execute";
			width = "normal";
			func  = function()
				InterfaceOptionsFrame_Show()
				Me.LockFrames()
			end;
		};
		
		resetFrames = {
			order = 19;
			name  = "Restablecer posiciones de marcos";
			desc  = "Restablece todos los marcos a sus posiciones predeterminadas.";
			type  = "execute";
			width = "normal";
			func  = function()
				InterfaceOptionsFrame_Show()
				DiceMasterPostTrackerFrame:SetPoint("BOTTOMLEFT", "ChatFrame1Tab", "TOPLEFT", 0, -2)
				DiceMasterInspectFrame:SetPoint("CENTER", 0, 0)
				DiceMasterBuffFrame:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0)
				DiceMasterInspectBuffFrame:SetPoint("BOTTOM", DiceMasterInspectFrame, "TOP", 0, 0)
				DiceMasterInspectPetFrame:SetPoint("LEFT", DiceMasterInspectFrame, "RIGHT", 0, 0)
				DiceMasterChargesFrame:SetPoint("CENTER", 0, 0)
				DiceMasterPetChargesFrame:SetPoint("BOTTOM", DiceMasterChargesFrame, "TOP", 0, 0)
				DiceMasterMoraleBar:SetPoint("TOP", DiceMasterPanel, "BOTTOM", 0, -20)
				if IsAddOnLoaded("DiceMaster_UnitFrames") then
					DiceMasterUnitsPanel:SetPoint("TOP", 0, -200)
				end
			end;
		};
		
		curseLink = {
			order = 20;
			name  = "Curse Forge";
			type  = "input";
			width = "double";
			get   = function( info ) return "https://www.curseforge.com/wow/addons/dicemaster" end;
		};
		
		discordLink = {
			order = 21;
			name  = "Discord";
			type  = "input";
			width = "double";
			get   = function( info ) return "https://discord.gg/zCRJVQj" end;
		};
	};
}

Me.configOptionsCharges = {
	type  = "group";
	order = 1;
	args = { 
		-----------------------------------------------------------------------
		header = {
			order = 0;
			name  = "Configurar la barra de Salud y Cargas.";
			type  = "description";
		};
		
		healthGroup = {
			name     = "Salud";
			inline   = true;
			order    = 12;
			type     = "group";
			args = {
				healthCurrent = {
					order = 10;
					name  = "Salud actual";
					desc  = "La cantidad actual de Salud que tiene este personaje.";
					type  = "range"; 
					min   = 0;
					max   = 1000;
					step  = 1;
					set   = function( info, val ) 
						Me.db.profile.health = val
						Me.RefreshHealthbarFrame( DiceMasterChargesFrame.healthbar, Me.db.profile.health, Me.db.profile.healthMax, Me.db.profile.armor )
	
						Me.BumpSerial( Me.db.char, "statusSerial" )
						Me.Inspect_ShareStatusWithParty() 
					end;
					get   = function( info ) return Me.db.profile.health end;
				}; 
			  
				healthMax = {
					order = 20;
					name  = "Salud Máxima";
					desc  = "La cantidad máxima de salud que puede tener este personaje.";
					type  = "range"; 
					min   = 1;
					max   = 1000;
					step  = 1;
					set   = function( info, val ) 
						Me.db.profile.healthMax = val
						Me.configOptionsCharges.args.healthGroup.args.healthCurrent.max = val
						if Me.db.profile.health > Me.db.profile.healthMax then
							Me.db.profile.health = Me.db.profile.healthMax
						end
						Me.RefreshHealthbarFrame( DiceMasterChargesFrame.healthbar, Me.db.profile.health, Me.db.profile.healthMax, Me.db.profile.armor )
	
						Me.BumpSerial( Me.db.char, "statusSerial" )
						Me.Inspect_ShareStatusWithParty() 
					end;
					get   = function( info ) return Me.db.profile.healthMax end;
				}; 
				
				healthPos = {
					order = 30;
					name  = "Anclar barra de salud debajo del marco de inspección.";
					desc  = "Mover la barra de salud en el marco Inspección para que se coloque debajo de la barra de rasgos.";
					width = "full";
					type  = "toggle";
					set = function( info, val ) 
						Me.db.char.healthPos = val
						Me.Inspect_Open( UnitName( "target" ))
					end;
					get = function( info ) return Me.db.char.healthPos end;
				};
			};
		};
	
		enableCharges = {
			order = 13;
			name  = "Activar Cargas";
			desc  = "Habilitar el uso del sistema de cargos para este personaje.";
			width = "full";
			type  = "toggle";
			set = function( info, val ) 
				Me.db.profile.charges.enable = val 
				Me.configOptionsCharges.args.chargesGroup.hidden = not val
				Me.OnChargesChanged() 
			end;
			get = function( info ) return Me.db.profile.charges.enable end;
		};

		chargesGroup = {
			name     = "Cargas";
			inline   = true;
			order    = 14;
			type     = "group";
			hidden   = true;
			args = {
				chargesName = {
					order = 20;
					name  = "Nombre de Cargas";
					desc  = "Nombra el nombre de las cargas de este personaje. Ejemplos: Poder sagrado, Ira, Adrenalina, Maná, Energía ...etc.";
					type  = "input";
					set = function( info, val ) 
						Me.db.profile.charges.name = val
						Me.OnChargesChanged()
					end;
					get = function( info ) return Me.db.profile.charges.name end;
				};
				
				chargesColor = {
					order = 30;
					name  = "Color de Cargas";
					desc  = "Color de los iconos de las cargas del personaje.";
					type  = "color";
					set = function( info, r, g, b ) 
						Me.db.profile.charges.color = {r,g,b}
						Me.OnChargesChanged()
					end;
					get = function( info ) 
						return Me.db.profile.charges.color[1],
							   Me.db.profile.charges.color[2],
							   Me.db.profile.charges.color[3]
					end;
				};
			  
				chargesMax = {
					order = 40;
					name  = "Cargas Máximas";
					desc  = "El máximo de cargas que pueden ser acumuladas.";
					type  = "range"; 
					hidden = false;
					min   = 1;
					max   = 8;
					step  = 1;
					set   = function( info, val ) 
						Me.db.profile.charges.max = val
						Me.OnChargesChanged()
					end;
					get   = function( info ) return Me.db.profile.charges.max end;
				}; 
				
				chargesMaxTwo = {
					order = 40;
					name  = "Cargas Máximas";
					desc  = "El máximo de cargas que pueden ser acumuladas.";
					type  = "range";
					hidden = true;
					min   = 1;
					max   = 100;
					step  = 1;
					set   = function( info, val ) 
						Me.db.profile.charges.max = val
						Me.OnChargesChanged()
					end;
					get   = function( info ) return Me.db.profile.charges.max end;
				}; 
				
				chargesTooltip = {
					order = 50;
					name  = "Descripción de cargas";
					desc  = "La descripción de la barra de cargas.";
					type  = "input";
					multiline = 3;
					set = function( info, val ) 
						Me.db.profile.charges.tooltip = val
						Me.OnChargesChanged()
					end;
					get = function( info ) return Me.db.profile.charges.tooltip end;
				};
				
				chargesSymbol = {
					order = 60;
					name  = "Apariencia Cargas";
					desc  = "Apariencia personalizada para la barra de cargas del personaje.";
					type  = "select"; 
					style = "dropdown";
					values = {
						["charge-orb"] = "Charge Orbs",
						["charge-fire"] = "Burning Embers",
						["charge-rune"] = "Death Knight Runes",
						["charge-shadow"] = "Shadow Orbs",
						["charge-soulshards"] = "Soul Shards",
						["charge-hourglass"] = "Hourglasses",
						["morale-bar"] = "League of Lordaeron",
						["Air"] = "Aire",
						["Alliance"] = "Alliance",
						["Amber"] = "Amber",
						["Azerite"] = "Azerite",
						["Bamboo"] = "Bamboo",
						["BulletBar"] = "Bullets",
						["Chogall"] = "Cho'gall",
						["Darkmoon"] = "Darkmoon",
						["Druid"] = "Druid",
						["FancyPanda"] = "Fancy Pandaren",
						["FelCorruption"] = "Fel Corruption",
						["Fire"] = "Fire",
						["FuelGauge"] = "Fuel Gauge",
						["Horde"] = "Horde",
						["Ice"] = "Ice",
						["InquisitionTorment"] = "Inquisitor",
						["Jaina"] = "Jaina",
						["KargathRoarCrowd"] = "Ogre",
						["Map"] = "Map",
						["Meat"] = "Meat",
						["Mechanical"] = "Mechanical",
						["Meditation"] = "Meditation",
						["MoltenRock"] = "Molten Rock",
						["Murozond"] = "Murozond Hourglass",
						["NZoth"] = "N'zoth",
						["NaaruCharge"] = "Naaru",
						["Onyxia"] = "Onyxia",
						["Pride"] = "Pride",
						["Rhyolith"] = "Rhyolith",
						["Rock"] = "Rock",
						["ShadowPaladinBar"] = "Shadow Paladin",
						["StoneDesign"] = "Stone Design",
						["UndeadMeat"] = "Undead Meat",
						["Water"] = "Water",
						["WoodPlank"] = "Wood Plank",
						["WoodWithMetal"] = "Wood with Metal",
						["WoWUI"] = "Generico",
						["Xavius"] = "Xavius Nightmare",
					};
					set   = function( info, val ) 
						Me.db.profile.charges.symbol = val
						if val:find("charge") then
							if Me.db.profile.charges.max > 8 then
								Me.db.profile.charges.max = 8;
							end
							
							if Me.db.profile.charges.count > 8 then
								Me.db.profile.charges.count = 8
							end
							Me.configOptionsCharges.args.chargesGroup.args.chargesMax.hidden = false
							Me.configOptionsCharges.args.chargesGroup.args.chargesMaxTwo.hidden = true
						else
							Me.configOptionsCharges.args.chargesGroup.args.chargesMax.hidden = true
							Me.configOptionsCharges.args.chargesGroup.args.chargesMaxTwo.hidden = false
						end
						Me.OnChargesChanged()
					end;
					get   = function( info ) return Me.db.profile.charges.symbol end;
				};
				
				chargesPos = {
					order = 70;
					name  = "Anclar barra de cargas debajo de barra de salud";
					desc  = "Mueve las cargas bajo la barra de salud";
					width = "full";
					type  = "toggle";
					set = function( info, val ) 
						Me.db.profile.charges.pos = val
						Me.OnChargesChanged()
					end;
					get = function( info ) return Me.db.profile.charges.pos end;
				};
			};
		};
	};
}

Me.configOptionsProgressBar = {
	type  = "group";
	order = 1;
	args = { 
		-----------------------------------------------------------------------
		header = {
			order = 0;
			name  = "Configurar marco de barra de progreso.";
			type  = "description";
		};
		
		enableMorale = {
			order = 15;
			name  = "Activar barra de progreso.";
			desc  = "Activar el uso de una barra de progreso de todo el grupo cuando eres líder.";
			width = "full";
			type  = "toggle";
			set = function( info, val ) 
				Me.db.profile.morale.enable = val 
				Me.configOptionsProgressBar.args.moraleGroup.hidden = not val
				Me.RefreshMoraleFrame() 
			end;
			get = function( info ) return Me.db.profile.morale.enable end;
		};
		
		moraleGroup = {
			name     = "Barra de progreso";
			inline   = true;
			order    = 16;
			type     = "group";
			hidden   = true;
			args = {
				moraleName = {
					order = 20;
					name  = "Nombre de barra de progreso";
					desc  = "Nombre de la barra de progreso. Ejemplos: moral, cordura, integridad de escudo.";
					type  = "input";
					set = function( info, val ) 
						Me.db.profile.morale.name = val
						Me.RefreshMoraleFrame()
					end;
					get = function( info ) return Me.db.profile.morale.name end;
				};
				
				moraleColor = {
					order = 30;
					name  = "Color de barra de progreso";
					desc  = "Color de la barra de progreso.";
					type  = "color";
					set = function( info, r, g, b ) 
						Me.db.profile.morale.color = {r,g,b}
						Me.RefreshMoraleFrame()
					end;
					get = function( info ) 
						return Me.db.profile.morale.color[1],
							   Me.db.profile.morale.color[2],
							   Me.db.profile.morale.color[3]
					end;
				};
				
				moraleSymbol = {
					order = 40;
					name  = "Apariencia de barra de progreso";
					desc  = "Apariencia personalizada de la barra de progreso.";
					type  = "select"; 
					style = "dropdown";
					values = {
						["morale-bar"] = "Liga de Lordaeron",
						["Air"] = "Aire",
						["Ice"] = "Hielo",
						["Fire"] = "Fuego",
						["Rock"] = "Roca",
						["Water"] = "Agua",
						["Meat"] = "Carne",
						["UndeadMeat"] = "Carne Putrefacta",
						["WoWUI"] = "Generico",
						["WoodPlank"] = "Tabla de madera",
						["WoodWithMetal"] = "Madera con Metal",
						["Darkmoon"] = "Luna Negra",
						["MoltenRock"] = "Roca fundida",
						["Alliance"] = "Alianza",
						["Horde"] = "Horda",
						["Amber"] = "Ambar",
						["Druid"] = "Druida",
						["FancyPanda"] = "Pandaren lujoso",
						["Mechanical"] = "Mecanco",
						["Map"] = "Mapa",
						["InquisitionTorment"] = "Inquisidor",
						["Bamboo"] = "Bambú",
						["Onyxia"] = "Onyxia",
						["StoneDesign"] = "Diseño de piedra",
						["NaaruCharge"] = "Naaru",
						["ShadowPaladinBar"] = "Paladin de las sombras",
						["Xavius"] = "Pesadilla de Xavius",
						["BulletBar"] = "Balas",
						["Azerite"] = "Azerita",
						["Chogall"] = "Cho'gall",
						["FuelGauge"] = "Indicador de combustible",
						["FelCorruption"] = "Corrupción vil",
						["Murozond"] = "Reloj de arena de Murozond",
						["Pride"] = "Orgullo",
						["Rhyolith"] = "Rhyolith",
						["KargathRoarCrowd"] = "Ogro",
						["Meditation"] = "Meditación",
						["Jaina"] = "Jaina",
						["NZoth"] = "N'zoth",
					};
					set   = function( info, val ) 
						Me.db.profile.morale.symbol = val
						Me.RefreshMoraleFrame()
					end;
					get   = function( info ) return Me.db.profile.morale.symbol end;
				}; 
				
				moraleTooltip = {
					order = 50;
					name  = "Descripción de barra de progreso";
					desc  = "la descripción de la barra de progreso..";
					type  = "input";
					multiline = 3;
					width = "full";
					set = function( info, val ) 
						Me.db.profile.morale.tooltip = val
						Me.RefreshMoraleFrame()
					end;
					get = function( info ) return Me.db.profile.morale.tooltip end;
				};
				
				moraleCount = {
					order = 60;
					name  = "Valor de inicio";
					desc  = "El valor inicial de la barra de progreso (ya sea completo, medio o vacío).";
					type  = "range"; 
					min   = 0;
					max   = 100;
					step  = 1;
					set   = function( info, val ) 
						Me.db.profile.morale.count = val
						Me.RefreshMoraleFrame( val )
					end;
					get   = function( info ) return Me.db.profile.morale.count end;
				}; 
				
				moraleStep = {
					order = 70;
					name  = "Aumentar / disminuir el valor";
					desc  = "La cantidad que se agrega / elimina cuando se hace clic en la barra de progreso.";
					type  = "range"; 
					min   = 1;
					max   = 100;
					step  = 1;
					set   = function( info, val ) 
						Me.db.profile.morale.step = val
						Me.RefreshMoraleFrame()
					end;
					get   = function( info ) return Me.db.profile.morale.step end;
				}; 
				
				moraleScale = {
					order     = 80;
					name      = "Escala de barra de progreso";
					desc      = "Cambiar el tamaño del marco de la barra de progreso.";
					type      = "range";
					min       = 0.25;
					max       = 10;
					softMax   = 4;
					isPercent = true;
					set = function( info, val ) 
						Me.db.profile.morale.scale = val;
						Me.ApplyUiScale()
					end;
					get = function( info ) return Me.db.profile.morale.scale end;
				}; 
			};
		};
	};
}

Me.configOptionsManager = {
	type  = "group";
	order = 1;
	args = { 
		-----------------------------------------------------------------------
		header = {
			order = 0;
			name  = "Configurar los ajustes del administrador de DM.";
			type  = "description";
		};
		
		hideTracker = {
			order = 10;
			name  = "Activar Administrador DM";
			desc  = "Habilitar el marco de Administrador DM para realizar un seguimiento de las tiradas del grupo y ver las notas de todo el grupo.";
			type  = "toggle";
			width = "double";
			set = function( info, val )
				Me.db.global.hideTracker = val
				if val == true then
					DiceMasterRollFrame:Show()
				else
					DiceMasterRollFrame:Hide()
				end
			end;
			get = function( info ) return Me.db.global.hideTracker end;
		};
		
		trackerScale = {
			order     = 20;
			name      = "Escala del Administrador DM";
			desc      = "Ajusta el tamaño del Administrador DM.";
			type      = "range";
			min       = 0.25;
			max       = 10;
			softMax   = 4;
			isPercent = true;
			set = function( info, val ) 
				Me.db.char.trackerScale = val;
				Me.ApplyUiScale()
			end;
			get = function( info ) return Me.db.char.trackerScale end;
		};
		
		trackerAnchor = {
			order = 30;
			name  = "Detalle de anclaje de marco ";
			desc  = "Elige el detalle de marco de izquierda o derecha.";
			type  = "select"; 
			style = "radio";
			values = {
				["LEFT"] = "Izquierda",
				["RIGHT"] = "Derecha",
			};
			set   = function( info, val ) 
				Me.db.global.trackerAnchor = val
				Me.DiceMasterRollDetailFrame_Update()
			end;
			get   = function( info ) return Me.db.global.trackerAnchor end;
		};
		
		trackerKeybind = {
			order     = 40;
			name	  = "Tecla para Mostrar/Ocultar";
			desc      = "Fijar una combinación de teclas para el Administrador DM.";
			type      = "keybinding";
			set = function( info, val ) 
				Me.db.char.trackerKeybind = val;
				Me.ApplyKeybindings()
			end;
			get = function( info ) return Me.db.char.trackerKeybind end;
		};
	};
}

Me.configOptionsUF = {
	type  = "group";
	order = 1;
	args = { 
		-----------------------------------------------------------------------
		header = {
			order = 0;
			name  = "Configurar los ajustes de los cuadros de unidad.";
			type  = "description";
		};
		
		enable = {
			order = 1;
			name  = "Habilitar marcos de unidades";
			desc  = "Alternar la visualización de los marcos de la unidad.";
			type  = "toggle";
			set   = function( info, val ) 
				if IsAddOnLoaded("DiceMaster_UnitFrames") then
					if val then
						Me.PrintMessage("|TInterface/AddOns/DiceMaster/Texture/logo:12|t Marcos de Unidad habilitados.", "SYSTEM")
					else
						Me.PrintMessage("|TInterface/AddOns/DiceMaster/Texture/logo:12|t Marcos de Unidad deshabilitados.", "SYSTEM")
					end
					Me.ShowUnitPanel( val )
				else
					Me.PrintMessage("|TInterface/AddOns/DiceMaster/Texture/logo:12|t Módulo DiceMaster Unit Frames no encontrado. Habilite el módulo de su lista de Addons.", "SYSTEM")
				end
			end;
			get   = function( info ) return not Me.db.char.unitframes.enable end;
		};
 
		uiScale = {
			order     = 5;
			name      = "Escala de UI";
			desc      = "El tamaño del panel de marcos de unidades.";
			type      = "range";
			min       = 0.25;
			max       = 10;
			softMax   = 4;
			isPercent = true;
			set = function( info, val ) 
				Me.db.char.unitframes.scale = val;
				if IsAddOnLoaded("DiceMaster_UnitFrames") then
					Me.ApplyUiScaleUF()
				end
			end;
			get = function( info ) return Me.db.char.unitframes.scale end;
		};
		
		miniFrames = {
			order = 10;
			name  = "Usar marcos más pequeños por defecto";
			desc  = "Los marcos de unidades aparecen más pequeños por defecto a menos que se expandan manualmente.";
			type  = "toggle";
			width = "full";
			set = function( info, val )
				Me.db.global.miniFrames = val
				if IsAddOnLoaded("DiceMaster_UnitFrames") then
					Me.ApplyUiScaleUF()
				end
			end;
			get = function( info ) return Me.db.global.miniFrames end;
		};
		
		talkingHeads = {
			order = 15;
			name  = "Habilitar objetivos parlantes";
			desc  = "Permitir que el líder del grupo envíe mensajes dinámicos de objetivos parlantes.";
			type  = "toggle";
			width = "full";
			set = function( info, val )
				Me.db.global.talkingHeads = val
			end;
			get = function( info ) return Me.db.global.talkingHeads end;
		};
		
		soundEffects = {
			order = 20;
			name  = "Habilitar efectos de sonido.";
			desc  = "permite al lider de grupo usar efectos de sonido a través de Dicemaster.";
			type  = "toggle";
			width = "full";
			set = function( info, val )
				Me.db.global.soundEffects = val
			end;
			get = function( info ) return Me.db.global.soundEffects end;
		};
		
		dungeonMasterGroup = {
			name     = "Configuración de maestro de mazmorras";
			inline   = true;
			order    = 30;
			type     = "group";
			args = {
				header = {
					order = 0;
					name  = "Esta opción solo está disponible para el lider del grupo o banda.";
					type  = "description";
				};
				
				allowAssistantTalkingHeads = {
					order = 10;
					name  = "Permitir a los ayudantes de banda a mandar NPC parlantes";
					desc  = "Permite a los ayudantes de banda a hacer hablar a NPCs.";
					width = "full";
					type  = "toggle";
					set = function( info, val ) 
						Me.db.global.allowAssistantTalkingHeads = val
						if Me.IsLeader( false ) then
							for i = 1, #DiceMasterUnitsPanel.unitframes do
								DiceMasterUnitsPanel.unitframes[i].allowRaidAssistant = val
							end
							Me.UpdateUnitFrames()
						end
					end;
					get = function( info ) return Me.db.global.allowAssistantTalkingHeads end;
				};
				
				allowBuffs = {
					order = 20;
					name  = "Permite a los jugadores poner bufos en los marcos de unidad.";
					desc  = "Toggle whether players can apply buffs to Unit Frames.";
					width = "full";
					type  = "toggle";
					set = function( info, val ) 
						Me.db.global.allowBuffs = val
						if Me.IsLeader( false ) then
							for i = 1, #DiceMasterUnitsPanel.unitframes do
								DiceMasterUnitsPanel.unitframes[i].allowBuffs = val
							end
						end
					end;
					get = function( info ) return Me.db.global.allowBuffs end;
				};
				
				bloodEffects = {
					order = 30;
					name  = "Habilitar animaciones sangrientas.";
					desc  = "Permite mostrar animaciones sangrientas en los marcos de unidad.";
					width = "full";
					type  = "toggle";
					set = function( info, val ) 
						Me.db.global.bloodEffects = val
						if Me.IsLeader( false ) then
							for i = 1, #DiceMasterUnitsPanel.unitframes do
								DiceMasterUnitsPanel.unitframes[i].bloodEnabled = val
							end
						end
					end;
					get = function( info ) return Me.db.global.bloodEffects end;
				};
			};
		};
	};
}

-------------------------------------------------------------------------------
function Me.SetupDB()
	
	local acedb = LibStub( "AceDB-3.0" )
  
	Me.db = acedb:New( "DiceMaster4_Saved", DB_DEFAULTS )
	
	Me.db.RegisterCallback( Me, "OnProfileChanged", "ApplyConfig" )
	Me.db.RegisterCallback( Me, "OnProfileCopied",  "ApplyConfig" )
	Me.db.RegisterCallback( Me, "OnProfileReset",   "ApplyConfig" )
	 
	local options = Me.configOptions
	local charges = Me.configOptionsCharges
	local progressbar = Me.configOptionsProgressBar
	local dmmanager = Me.configOptionsManager
	local unitframes = Me.configOptionsUF
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable( Me.db )
	profiles.order = 500
	 
	AceConfig:RegisterOptionsTable( "DiceMaster", options )	
	AceConfig:RegisterOptionsTable( "Charges", charges )	
	AceConfig:RegisterOptionsTable( "Progress Bar", progressbar )	
	AceConfig:RegisterOptionsTable( "DM Manager", dmmanager )	
	AceConfig:RegisterOptionsTable( "Unit Frames", unitframes )	
	AceConfig:RegisterOptionsTable( "DiceMaster Profiles", profiles )
	
	Me.config = AceConfigDialog:AddToBlizOptions( "DiceMaster", "DiceMaster" )
	Me.configCharges = AceConfigDialog:AddToBlizOptions( "Charges", "Cargas", "DiceMaster" )
	Me.configProgressBar = AceConfigDialog:AddToBlizOptions( "Progress Bar", "Barra de progreso", "DiceMaster" )
	Me.configManager = AceConfigDialog:AddToBlizOptions( "DM Manager", "Administrador DM", "DiceMaster" )
	Me.configUnitFrames = AceConfigDialog:AddToBlizOptions( "Unit Frames", "Marcos de Unidad", "DiceMaster" )
	Me.configProfiles = AceConfigDialog:AddToBlizOptions( "DiceMaster Profiles", "Perfiles", "DiceMaster" )
	
	local function CreateLogo( frame )
		local logo = CreateFrame('Frame', nil, frame)
		logo:SetFrameLevel(4)
		logo:SetSize(64, 64)
		logo:SetPoint('TOPRIGHT', 8, 24)
		logo:SetBackdrop({bgFile = "Interface/AddOns/DiceMaster/Texture/logo"})
		frame.logo = logo
	end
	
	CreateLogo( Me.config )
	CreateLogo( Me.configCharges )
	CreateLogo( Me.configProgressBar )
	CreateLogo( Me.configManager )
	CreateLogo( Me.configUnitFrames )
	CreateLogo( Me.configProfiles )
end

local interfaceOptionsNeedsInit = true
-------------------------------------------------------------------------------
-- Open the configuration panel.
--
function Me.OpenConfig() 
	Me.configOptionsCharges.args.chargesGroup.hidden = not Me.db.profile.charges.enable
	Me.configOptionsProgressBar.args.moraleGroup.hidden = not Me.db.profile.morale.enable
	Me.configOptionsCharges.args.healthGroup.args.healthCurrent.max = Me.db.profile.healthMax
	
	if Me.db.profile.charges.enable and Me.db.profile.charges.symbol:find("charge") then
		if Me.db.profile.charges.max > 8 then
			Me.db.profile.charges.max = 8;
		end
		if Me.db.profile.charges.count > 8 then
			Me.db.profile.charges.count = 8
		end
		Me.configOptionsCharges.args.chargesGroup.args.chargesMax.hidden = false
		Me.configOptionsCharges.args.chargesGroup.args.chargesMaxTwo.hidden = true
	else
		Me.configOptionsCharges.args.chargesGroup.args.chargesMax.hidden = true
		Me.configOptionsCharges.args.chargesGroup.args.chargesMaxTwo.hidden = false
	end
	
	if Me.db.profile.health > Me.db.profile.healthMax then
		Me.db.profile.health = Me.db.profile.healthMax
	end
	
	-- the first time we open the options frame, it wont go to the right page
	if interfaceOptionsNeedsInit then
		InterfaceOptionsFrame_OpenToCategory( "DiceMaster" )
		interfaceOptionsNeedsInit = nil
	end
	InterfaceOptionsFrame_OpenToCategory( "DiceMaster" )
	LibStub("AceConfigRegistry-3.0"):NotifyChange( "DiceMaster" )
end

-------------------------------------------------------------------------------
function Me.ApplyConfig( onload )
	Me.configOptionsCharges.args.chargesGroup.hidden = not Me.db.profile.charges.enable
	Me.configOptionsProgressBar.args.moraleGroup.hidden = not Me.db.profile.morale.enable
	Me.configOptionsCharges.args.healthGroup.args.healthCurrent.max = Me.db.profile.healthMax
	
	-- bump all serials, everything is considered dirty
	Me.BumpSerial( Me.db.char, "statusSerial" )
	for i = 1, 5 do
		Me.BumpSerial( Me.db.char.traitSerials, i )
	end
	Me.Inspect_ShareStatusWithParty()
	
	Me.ApplyUiScale()
	Me.RefreshHealthbarFrame( DiceMasterChargesFrame.healthbar, Me.db.profile.health, Me.db.profile.healthMax, Me.db.profile.armor )
	Me.RefreshChargesFrame( true, true )  
	Me.TraitEditor_Refresh()
	Me.UpdatePanelTraits()
	Me.configOptions.args.enableRoundBanners.hidden = not Me.PermittedUse()
end
