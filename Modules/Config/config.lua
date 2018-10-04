local SSA, Auras, L, LSM = unpack(select(2,...))
Auras.version = GetAddOnMetadata(..., 'Version')

local split, tonumber = string.split, tonumber
local upper = string.upper

--[[----------------------------------------------------------------
	Constants
------------------------------------------------------------------]]
local POWER_MAELSTROM_ID = Enum.PowerType.Maelstrom
local POWER_MANA_ID = Enum.PowerType.Mana

--[[local COOLDOWN_P1_VALUES = {
	["primary;2"] = PRIMARY.." #2",
	["primary;3"] = PRIMARY.." #3",
	["primary;4"] = PRIMARY.." #4",
	["secondary;1"] = SECONDARY.." #1",
	["secondary;2"] = SECONDARY.." #2",
}

local COOLDOWN_P2_VALUES = {
	["primary;1"] = PRIMARY.." #1",
	["primary;3"] = PRIMARY.." #3",
	["primary;4"] = PRIMARY.." #4",
	["secondary;1"] = SECONDARY.." #1",
	["secondary;2"] = SECONDARY.." #2",
}

local COOLDOWN_P3_VALUES = {
	["primary;1"] = PRIMARY.." #1",
	["primary;2"] = PRIMARY.." #2",
	["primary;4"] = PRIMARY.." #4",
	["secondary;1"] = SECONDARY.." #1",
	["secondary;2"] = SECONDARY.." #2",
}

local COOLDOWN_P4_VALUES = {
	["primary;1"] = PRIMARY.." #1",
	["primary;2"] = PRIMARY.." #2",
	["primary;3"] = PRIMARY.." #3",
	["secondary;1"] = SECONDARY.." #1",
	["secondary;2"] = SECONDARY.." #2",
}

local COOLDOWN_S1_VALUES = {
	["primary;1"] = PRIMARY.." #1",
	["primary;2"] = PRIMARY.." #2",
	["primary;3"] = PRIMARY.." #3",
	["primary;4"] = PRIMARY.." #4",
	["secondary;2"] = SECONDARY.." #2",
}

local COOLDOWN_S2_VALUES = {
	["primary;1"] = PRIMARY.." #1",
	["primary;2"] = PRIMARY.." #2",
	["primary;3"] = PRIMARY.." #3",
	["primary;4"] = PRIMARY.." #4",
	["secondary;1"] = SECONDARY.." #1",
}]]
		
local FRAME_ANCHOR_OPTIONS = {
	["TOPLEFT"] = L["OPTION_TOP_LEFT"],
	["TOP"] = L["OPTION_TOP"],
	["TOPRIGHT"] = L["OPTION_TOP_RIGHT"],
	["LEFT"] = L["OPTION_LEFT"],
	["CENTER"] = L["OPTION_CENTER"],
	["RIGHT"] = L["OPTION_RIGHT"],
	["BOTTOMLEFT"] = L["OPTION_BOTTOM_LEFT"],
	["BOTTOM"] = L["OPTION_BOTTOM"],
	["BOTTOMRIGHT"] = L["OPTION_BOTTOM_RIGHT"],
}

local FONT_OUTLINES = {
	[""] = NONE,
	["OUTLINE"] = L["OPTION_OUTLINE"],
	["THICKOUTLINE"] = L["OPTION_OUTLINE_THICK"],
	["MONOCHROME"] = L["OPTION_OUTLINE_MONOCHROME"],
	["OUTLINE, MONOCHROME"] = L["OPTION_OUTLINE_MONOCHROME_OUTLINE"],
	["THICKOUTLINE, MONOCHROME"] = L["OPTION_OUTLINE_MONOCHROME_THICK"],
}

local ORIENTATION = {
	["Horizontal"] = L["OPTION_HORIZONTAL"],
	["Vertical"] = L["OPTION_VERTICAL"],
}

local ICON_JUSTIFY = {
	["LEFT"] = L["OPTION_LEFT"],
	["RIGHT"] = L["OPTION_RIGHT"],
}

local TIDAL_WAVES_OPTIONS = {
	["Always"] = ALWAYS,
	["Target & On Heal"] = L["OPTION_TARGET_HEAL"],
	["Target Only"] = L["OPTION_TARGET_ONLY"],
	["On Heal Only"] = L["OPTION_HEAL_ONLY"],
	["Never"] = NEVER,
}

--[[local COOLDOWN_OPTIONS = {
	["primary;1"] = PRIMARY.." #1",
	["primary;2"] = PRIMARY.." #2",
	["primary;3"] = PRIMARY.." #3",
	["secondary;1"] = SECONDARY.." #1",
	["secondary;2"] = SECONDARY.." #2",
}]]

local TIME_FORMATS = {
	["full"] = "2:25",
	["short"] = "2m",
}


local ele_options

local function GetElementalOptions()
	if not ele_options then
		local db = Auras.db.char
	
		-- Database Shortcuts
		local settings = db.settings[1]
		local settingDefaults = db.settings.defaults
		
		-- Element Tables
		local elements = db.elements[1]
		local cooldowns = db.auras[1].cooldowns
		local timerbars = db.timerbars[1]
		local statusbars = db.statusbars[1]
		local frames = db.elements[1].frames
		local auras = db.auras[1]
		
		-- Layout Table
		--local layout = db.layout[1]
		--local layoutDefaults = db.layout.defaults
		
		-- Element Defaults Tables
		--[[local timerbarDefaults = db.elements.defaults[1].timerbars
		local cooldownDefaults = db.elements.defaults.cooldowns
		local statusbarDefaults = db.elements.defaults[1].statusbars
		local frameDefaults = db.elements.defaults[1].frames]]
		
		-- Misc Vars
		local group,subgroup
		
		local COOLDOWN_OPTIONS = {}
	
		for i=1,#auras.groups do
			tinsert(COOLDOWN_OPTIONS,"Group #"..i.." Cooldowns")
		end
		
		ele_options = {
			type = "group",
			childGroups = "tab",
			order = 1,
			name = L["LABEL_AURAS_ELEMENTAL"],
			desc = '',
			args = {
				--[[display = {
					name = DISPLAY,
					order = 0,
					type = "group",
					args = {
						show = Auras:Toggle_Basic(elements,1,1,L["LABEL_SHOW_ELEMENTAL_AURAS"],L["TOOLTIP_TOGGLE_ELEMENTAL_AURAS"],false,'isEnabled',true),
						MajorAuras = {
							name = L["LABEL_AURAS_PRIMARY"],
							type = "group",
							order = 2,
							guiInline = true,
							args = {
								AncestralGuidance = Auras:Toggle_Basic(auras,1,1,Auras:GetSpellName(108281),nil,false,'AncestralGuidance',true),
								Ascendance = Auras:Toggle_Basic(auras,2,1,Auras:GetSpellName(114050),nil,false,'Ascendance',true),
								Earthquake = Auras:Toggle_Basic(auras,3,1,Auras:GetSpellName(61882),nil,false,'Earthquake',true),
								EarthShock = Auras:Toggle_Basic(auras,4,1,Auras:GetSpellName(8042),nil,false,'EarthShock',true),
								ElementalBlast = Auras:Toggle_Basic(auras,5,1,Auras:GetSpellName(117014),nil,false,'ElementalBlast',true),
								FireElemental = Auras:Toggle_Basic(auras,6,1,Auras:GetSpellName(198067),nil,false,'FireElemental',true),
								FlameShock = Auras:Toggle_Basic(auras,7,1,Auras:GetSpellName(188389),nil,false,'FlameShock',true),
								Icefury = Auras:Toggle_Basic(auras,8,1,Auras:GetSpellName(210714),nil,false,'Icefury',true),
								LavaBurst = Auras:Toggle_Basic(auras,9,1,Auras:GetSpellName(51505),nil,false,'LavaBurst',true),
								LiquidMagmaTotem = Auras:Toggle_Basic(auras,10,1,Auras:GetSpellName(192222),nil,false,'LiquidMagmaTotem',true),
								StormElemental = Auras:Toggle_Basic(auras,11,1,Auras:GetSpellName(192249),nil,false,'StormElemental',true),
								Stormkeeper = Auras:Toggle_Basic(auras,12,1,Auras:GetSpellName(205495),nil,false,'Stormkeeper',true),
							},
						},
						BuffAuras = {
							name = L["LABEL_AURAS_BUFF"],
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								EarthShield = Auras:Toggle_Basic(auras,1,1,Auras:GetSpellName(974),nil,false,'EarthShield',true),
								EarthenStrength = Auras:Toggle_Basic(auras,2,1,Auras:GetSpellName(252141),nil,false,'EarthenStrength',true),
								ExposedElements = Auras:Toggle_Basic(auras,3,1,Auras:GetSpellName(260694),nil,false,'ExposedElements',true),
								MasterOfElements = Auras:Toggle_Basic(auras,4,1,Auras:GetSpellName(16166),nil,false,'MasterOfElements',true),
								NaturesGuardian = Auras:Toggle_Basic(auras,5,1,Auras:GetSpellName(30884),nil,false,'NaturesGuardian',true),
								UnlimitedPower = Auras:Toggle_Basic(auras,6,1,Auras:GetSpellName(260895),nil,false,'UnlimitedPower',true),
							},
						},
						PvPAuras = {
							name = L["LABEL_AURAS_PVP"],
							type = "group",
							order = 4,
							guiInline = true,
							args = {
								Adaptation = Auras:Toggle_Basic(auras,1,1,Auras:GetSpellName(214027),nil,false,'Adaptation',true),
								CounterstrikeTotem = Auras:Toggle_Basic(auras,2,1,Auras:GetSpellName(204331),nil,false,'CounterstrikeTotem',true),
								GladiatorsMedallion = Auras:Toggle_Basic(auras,3,1,Auras:GetSpellName(208683),nil,false,'GladiatorsMedallion',true),
								GroundingTotem = Auras:Toggle_Basic(auras,4,1,Auras:GetSpellName(204336),nil,false,'GroundingTotem',true),
								LightningLasso = Auras:Toggle_Basic(auras,5,1,Auras:GetSpellName(204437),nil,false,'LightningLasso',true),
								SkyfuryTotem = Auras:Toggle_Basic(auras,6,1,Auras:GetSpellName(204330),nil,false,'SkyfuryTotem',true),
							},
						},
						MinorAuras = {
							name = L["LABEL_AURAS_SECONDARY"],
							type = "group",
							order = 5,
							guiInline = true,
							args = {
								AstralShift = Auras:Toggle_Basic(auras,1,1,Auras:GetSpellName(108271),nil,false,'AstralShift',true),
								CapacitorTotem = Auras:Toggle_Basic(auras,2,1,Auras:GetSpellName(192058),nil,false,'CapacitorTotem',true),
								CleanseSpirit = Auras:Toggle_Basic(auras,3,1,Auras:GetSpellName(51886),nil,false,'CleanseSpirit',true),
								EarthElemental = Auras:Toggle_Basic(auras,4,1,Auras:GetSpellName(198103),nil,false,'EarthElemental',true),
								EarthbindTotem = Auras:Toggle_Basic(auras,5,1,Auras:GetSpellName(2484),nil,false,'EarthbindTotem',true),
								Hex = Auras:Toggle_Basic(auras,6,1,Auras:GetSpellName(51514),nil,false,'Hex',true),
								Thunderstorm = Auras:Toggle_Basic(auras,7,1,Auras:GetSpellName(51490),nil,false,'Thunderstorm',true),
								WindRushTotem = Auras:Toggle_Basic(auras,8,1,Auras:GetSpellName(192077),nil,false,'WindRushTotem',true),
								Windshear = Auras:Toggle_Basic(auras,9,1,Auras:GetSpellName(57994),nil,false,'WindShear',true),
							},
						},
						ProgressBars = {
							name = L["LABEL_PROGRESS_BARS"],
							type = "group",
							order = 6,
							guiInline = true,
							args = {
								BuffTimerBars = {
									name = L["LABEL_STATUSBAR_BUFF_TIMER"],
									type = "group",
									order = 1,
									guiInline = true,
									args = {
										AncestralGuidance = Auras:Toggle_Basic(timerbars,1,1,Auras:GetSpellName(108281),nil,false,'AncestralGuidanceBar'),
										Ascendance = Auras:Toggle_Basic(timerbars,2,1,Auras:GetSpellName(114050),nil,false,'AscendanceBar'),
										AstralShift = Auras:Toggle_Basic(timerbars,3,1,Auras:GetSpellName(108271),nil,false,'AstralShiftBar'),
										Bloodlust = Auras:Toggle_Basic(timerbars,4,1,Auras:GetSpellName(2825),nil,false,'BloodlustBar'),
										ElementalBlast = Auras:Toggle_Basic(timerbars,5,1,Auras:GetSpellName(117014),nil,false,'ElementalBlastBar'),
										Heroism = Auras:Toggle_Basic(timerbars,6,1,Auras:GetSpellName(32182),nil,false,'HeroismBar'),
										TimeWarp = Auras:Toggle_Basic(timerbars,7,1,Auras:GetSpellName(80353),nil,false,'TimeWarpBar'),
									},
								},
								ElementalTimerBars = {
									name = L["LABEL_TIMERS_ELEMENTAL"],
									type = "group",
									order = 5,
									guiInline = true,
									args = {
										EarthElemental = Auras:Toggle_Basic(timerbars,1,1,Auras:GetSpellName(198103),nil,false,'EarthElementalBar'),
										FireElemental = Auras:Toggle_Basic(timerbars,2,1,Auras:GetSpellName(198067),nil,false,'FireElementalBar'),
										StormElemental = Auras:Toggle_Basic(timerbars,3,1,Auras:GetSpellName(192249),nil,false,'StormElementalBar'),
									},
								},
								TotemTimerBars = {
									name = L["LABEL_TIMERS_TOTEM"],
									type = "group",
									order = 6,
									guiInline = true,
									args = {
										EarthbindTotem = Auras:Toggle_Basic(timerbars,1,1,Auras:GetSpellName(2484),nil,false,'EarthbindTotemBar'),
										LiquidMagmaTotem = Auras:Toggle_Basic(timerbars,2,1,Auras:GetSpellName(192222),nil,false,'LiquidMagmaTotemBar'),
										WindRushTotem = Auras:Toggle_Basic(timerbars,3,1,Auras:GetSpellName(192077),nil,false,'WindRushTotemBar'),
									},
								},
							},
						},
						TextureAlerts = {
							name = L["TOOLTIP_TEXTURE_ALERTS"],
							type = "group",
							order = 7,
							guiInline = true,
							args = {
								TotemMastery = Auras:Toggle_Basic(frames.TotemMastery1,1,1,Auras:GetSpellName(210643),nil,false,'isEnabled'),
								Stormkeeper = Auras:Toggle_Basic(frames.StormkeeperChargeGrp,2,1,L["LABEL_STORMKEEPER_ORBS"],nil,false,'isEnabled'),
							},
						},
					},
				},]]
				general = {
					name = MAIN_MENU,
					order = 2,
					type = "group",
					childGroups = "tab",
					disabled = true,
					args = {
						settings = {
							name = L["LABEL_AURAS_SETTINGS"],
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								OoCAlpha = Auras:Slider_VerifyDefaults(settings,1,1,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_AURAS_ALPHA_NO_COMBAT"],0,1,nil,false,'OoCAlpha','Settings'),
								FlameShock = Auras:Slider_VerifyDefaults(settings,2,1,Auras:GetSpellName(188838),L["TOOLTIP_GLOW_TIME_TRIGGER"],5,15,nil,false,'flameShock','Settings'),
								TotemMastery = Auras:Slider_VerifyDefaults(settings,3,1,Auras:GetSpellName(210643),L["TOOLTIP_TOTEM_MASTERY_TRIGGER_TIMER"],5,30,nil,false,'totemMastery','Settings'),
								OoRColor = Auras:Color_VerifyDefaults(settings,4,1,L["LABEL_COLOR_NO_RANGE"],L["TOOLTIP_COLOR_OUT_OF_RANGE"],true,"full",false,'OoRColor','Settings'),
								reset = {
									order = 5,
									type = "execute",
									name = L["BUTTON_RESET_SETTINGS"],
									func = function()
										settings.flameShock = settingDefaults[1].flameShock
										settings.totemMastery = settingDefaults[1].totemMastery
										settings.OoCAlpha = settingDefaults.OoCAlpha
										settings.OoRColor.r = settingDefaults.OoRColor.r
										settings.OoRColor.g = settingDefaults.OoRColor.g
										settings.OoRColor.b = settingDefaults.OoRColor.b
										settings.OoRColor.a = settingDefaults.OoRColor.a
										ele_options.args.general.args.settings.args.reset.disabled = true
										ele_options.args.general.args.settings.args.reset.name = "|cFF666666"..L["BUTTON_RESET_SETTINGS"].."|r"
									end,
								},
							},
						},
					},
				},
				auraGroups = {
					name = "Aura Builder",
					type = "group",
					childGroups = "tab",
					order = 3,
					args = {
					},
				},
				timerbarGroups = {
					name = "Timer Bar Builder",
					type = "group",
					childGroups = "tab",
					order = 4,
					args = {
					},
				},
				bars = {
					name = L["LABEL_PROGRESS_BARS"],
					order = 5,
					type = "group",
					childGroups = "tab",
					disabled = true,
					args = {
						general = {
							name = GENERAL,
							order = 5,
							inline = false,
							type = "group",
							args = {
								statusbars = {
									name = L["LABEL_STATUSBAR_MANAGER"],
									type = "group",
									order = 1,
									guiInline = true,
									args = {
										defaultBarToggle = Auras:Toggle_Basic(statusbars,1,L["LABEL_STATUSBAR_BLIZZARD"],L["TOOLTIP_TOGGLE_BLIZZARD_BAR"],false,'defaultBar'),
										castBarToggle = Auras:Toggle_Statusbar(statusbars.bars.CastBar,2,L["TOGGLE_CAST_BAR"],L["TOOLTIP_TOGGLE_CAST_BAR"],'isEnabled','CastBar'),
										channelToggle = Auras:Toggle_Statusbar(statusbars.bars.ChannelBar,3,L["TOGGLE_CHANNEL_BAR"],L["TOOLTIP_TOGGLE_CHANNEL_BAR"],'isEnabled','ChannelBar'),
										--healthToggle = Auras:Toggle_Statusbar(statusbars.healthBar,4,L["TOGGLE_HEALTH_BAR"],L["TOOLTIP_TOGGLE_HEALTH_BAR"],'isEnabled','healthBar'),
										maelstromToggle = Auras:Toggle_Statusbar(statusbars.bars.MaelstromBar,5,L["TOGGLE_MAELSTROM_BAR"],L["TOOLTIP_TOGGLE_MAELSTROM_BAR"],'isEnabled','MaelstromBar'),
										icefuryToggle = Auras:Toggle_Statusbar(statusbars.bars.IcefuryBar,6,L["TOGGLE_ICEFURY_BAR"],L["TOOLTIP_TOGGLE_ICEFURY_BAR"],'isEnabled','IcefuryBar'),
									},
								},
							},
						},
						--[[healthBar = {
							name = L["LABEL_STATUSBAR_HEALTH"],
							order = 7,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.healthBar.adjust,1,1,L["LABEL_STATUSBAR_MODIFY_HEALTH"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,'isEnabled','Health'),
								numtextToggle = Auras:Toggle_VerifyDefaults(statusbars.healthBar.numtext,2,1,L["TOGGLE_HEALTH_TEXT"],L["TOOLTIP_TOGGLE_HEALTH_TEXT"],nil,false,'isDisplayText','Health'),
								perctextToggle = Auras:Toggle_VerifyDefaults(statusbars.healthBar.perctext,3,1,L["TOGGLE_PERCENT_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],nil,false,'isDisplayText','Health'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.healthmBar,1,1,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,false,'alphaCombat','Health'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.healthBar,2,1,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,false,'alphaOoC','Health'),
										alphaTarget = Auras:Slider_VerifyDefaults(statusbars.healthBar,3,1,L["LABEL_ALPHA_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_TARGET_NO_COMBAT"],0,1,nil,false,'alphaTar','Health'),
									},
								},
								numtext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_HEALTH"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.healthBar.numtext.font,1,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Health'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.healthBar.numtext.font,2,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Health'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.healthBar.numtext.font,3,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Health'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.healthBar.numtext.font,4,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Health'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.healthBar.numtext,5,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Health'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.healthBar.numtext,6,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Health'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.healthBar.numtext,7,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Health'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.healthBar.numtext.font.shadow,1,1,L["TOGGLE"],nil,nil,false,'isEnabled','Health'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.healthBar.numtext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Health'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.healthBar.numtext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Health'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.healthBar.numtext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Health'),
											},
										},
									},
								},
								perctext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 7,
									disabled = true,
									guiInline = true,
									args = {
										name = '|cFFFFFFFF'..L["LABEL_TEXT_HEALTH"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.healthBar.perctext.font,1,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Health'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.healthBar.perctext.font,2,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Health'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.healthBar.perctext.font,3,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Health'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.healthBar.perctext.font,4,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Health'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.healthBar.perctext,5,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Health'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.healthBar.perctext,6,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Health'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.healthBar.perctext,7,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Health'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.healthBar.perctext.font.shadow,1,1,L["TOGGLE"],nil,nil,false,'isEnabled','Health'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.healthBar.perctext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Health'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.healthBar.perctext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Health'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.healthBar.perctext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Health'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 8,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.healthBar.foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Health'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.healthBar.foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Health'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.healthBar.background,3,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Health'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.healthBar.background,4,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Health'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.healthBar.adjust,5,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,'showBG','Health'),
										width = Auras:Slider_VerifyDefaults(statusbars.healthBar.layout,6,1,L["LABEL_WIDTH"],nil,100,500,nil,false,'width','Health'),
										height = Auras:Slider_VerifyDefaults(statusbars.healthBar.layout,6,1,L["LABEL_HEIGHT"],nil,10,100,nil,false,'height','Health'),
										texture = {
											order = 1,
											type = "select",
											name = L["LABEL_STATUSBAR_TEXTURE"],
											desc = L["TOOLTIP_STATUSBAR_TEXTURE"],
											dialogControl = "LSM30_Statusbar",
											get = function()
												return statusbars.healthBar.foreground.texture
											end,
											set = function(self,value)
												statusbars.healthBar.foreground.texture = value
												Auras:VerifyDefaultValues(1,ele_options,'Health')
											end,
											values = LSM:HashTable(LSM.MediaType.STATUSBAR),
										},
									},
								},
								reset = {
									order = 9,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CAST"],
									func = function()
										local bar = statusbars.healthBar
										local default = statusbarDefaults.healthBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										
										Auras:ResetText(bar,'numtext',default)
										Auras:ResetText(bar,'perctext',default)
										
										bar.icon.isEnabled = true
										bar.icon.justify = default.icon.justify
										bar.spark = true
										
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)
										ele_options.args.bars.args.healthBar.args.reset.disabled = true
										ele_options.args.bars.args.healthBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_CAST"].."|r"
										Auras:VerifyDefaultValues(1,ele_options,'Health')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('CastBar1',nil,'healthBar','numtext','perctext',1)
										end
									end,
								},
							},
						},]]
						MaelstromBar = {
							name = L["LABEL_STATUSBAR_MAELSTROM"],
							order = 6,
							type = "group",
							inline = false,
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar.adjust,1,1,L["LABEL_STATUSBAR_MODIFY_MAELSTROM"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,'isEnabled','Maelstrom'),
								textToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar.text,2,1,L["LABEL_TEXT_MAELSTROM"],L["TOOLTIP_TOGGLE_MAELSTROM_TEXT"],nil,false,'isDisplayText','Maelstrom'),
								animation = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar,3,1,L["LABEL_STATUSBAR_ANIMATE_MAELSTROM"],nil,nil,false,'animate','Maelstrom'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar,1,1,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,false,'alphaCombat','Maelstrom'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar,2,1,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,false,'alphaOoC','Maelstrom'),
										alphaTarget = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar,3,1,L["LABEL_ALPHA_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_TARGET_NO_COMBAT"],0,1,nil,false,'alphaTar','Maelstrom'),
										threshold = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar,4,1,L["LABEL_TRIGGER_MAELSTROM"],L["TOOLTIP_MAELSTROM_TIME_TRIGGER"],50,100,nil,false,'threshold','Maelstrom'),
									},
								},
								text = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_MAELSTROM"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromBar.text.font,1,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Maelstrom'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.text.font,2,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Maelstrom'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text.font,3,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Maelstrom'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.text.font,4,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Maelstrom'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.text,5,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Maelstrom'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text,6,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Maelstrom'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text,7,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Maelstrom'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar.text.font.shadow,1,1,L["TOGGLE"],nil,nil,false,'isEnabled','Maelstrom'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromBar.text.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Maelstrom'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Maelstrom'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Maelstrom'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 6,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Maelstrom'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromBar.foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Maelstrom'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.background,3,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Maelstrom'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromBar.background,4,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Maelstrom'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar.adjust,5,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,'showBG','Maelstrom'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.layout,6,1,L["LABEL_WIDTH"],nil,100,500,nil,false,'width','Maelstrom'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.layout,7,1,L["LABEL_HEIGHT"],nil,10,100,nil,false,'height','Maelstrom'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_MAELSTROM"],
									func = function()
										local bar = statusbars.bars.MaelstromBar
										local default = statusbars.defaults.MaelstromBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										bar.alphaTar = default.alphaTar
										bar.animate = true
										bar.threshold = default.threshold

										Auras:ResetText(bar,'text',default)
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)

										ele_options.args.bars.args.MaelstromBar.args.reset.disabled = true
										ele_options.args.bars.args.MaelstromBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_MAELSTROM"].."|r"
										Auras:VerifyDefaultValues(1,ele_options,'Maelstrom')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('MaelstromBar',nil,'text',nil,1)
										end
									end,
								},
							},
						},
						CastBar = {
							name = L["LABEL_STATUSBAR_CAST"],
							order = 7,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,1,1,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,'isEnabled','Cast'),
								nametextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext,2,1,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],nil,false,'isDisplayText','Cast'),
								timetextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext,3,1,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],nil,false,'isDisplayText','Cast'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,1,1,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,false,'alphaCombat','Cast'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,2,1,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,false,'alphaOoC','Cast'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar,1,1,L["TOGGLE_SPARK"],nil,nil,false,'spark','Cast'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.icon,2,1,L["TOGGLE_ICON"],nil,nil,false,'isEnabled','Cast'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.icon,3,1,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,false,'justify','Cast'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 6,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font,1,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Cast'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,2,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Cast'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font,3,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Cast'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,4,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Cast'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext,5,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Cast'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,6,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Cast'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,7,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Cast'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,1,1,L["TOGGLE"],nil,nil,false,'isEnabled','Cast'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Cast'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Cast'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Cast'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 7,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font,1,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Cast'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,2,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Cast'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font,3,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Cast'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,4,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Cast'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext,5,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Cast'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,6,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Cast'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,7,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Cast'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,1,1,L["TOGGLE"],nil,nil,false,'isEnabled','Cast'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Cast'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Cast'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Cast'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 8,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Cast'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Cast'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.background,3,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Cast'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.background,4,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Cast'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,5,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,'showBG','Cast'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,6,1,L["LABEL_WIDTH"],nil,100,500,nil,false,'width','Cast'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,7,1,L["LABEL_HEIGHT"],nil,10,100,nil,false,'height','Cast'),
									},
								},
								reset = {
									order = 9,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CAST"],
									func = function()
										local bar = statusbars.bars.CastBar
										local default = Auras.db.char.statusbars.defaults.CastBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										
										Auras:ResetText(bar,'nametext',default)
										Auras:ResetText(bar,'timetext',default)
										
										bar.icon.isEnabled = true
										bar.icon.justify = default.icon.justify
										bar.spark = true
										
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)

										ele_options.args.bars.args.CastBar.args.reset.disabled = true
										ele_options.args.bars.args.CastBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_CAST"].."|r"
										Auras:VerifyDefaultValues(1,ele_options,'Cast')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('CastBar',nil,'nametext','timetext',1)
										end
									end,
								},
							},
						},
						ChannelBar = {
							name = L["LABEL_STATUSBAR_CHANNEL"],
							order = 8,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,1,1,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,'isEnabled','Channel'),
								nametextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext,2,1,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],nil,false,'isDisplayText','Channel'),
								timetextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext,3,1,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],nil,false,'isDisplayText','Channel'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,1,1,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,false,'alphaCombat','Channel'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,2,1,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,false,'alphaOoC','Channel'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar,1,1,L["TOGGLE_SPARK"],nil,nil,false,'spark','Channel'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.icon,2,1,L["TOGGLE_ICON"],nil,nil,false,'isEnabled','Channel'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.icon,3,1,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,false,'justify','Channel'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 6,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,1,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Channel'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,2,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Channel'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,3,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Channel'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,4,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Channel'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext,5,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Channel'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,6,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Channel'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,7,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Channel'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,1,1,L["TOGGLE"],nil,nil,false,'isEnabled','Channel'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Channel'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Channel'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Channel'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 6,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,1,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Channel'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,2,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Channel'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,3,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Channel'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,4,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Channel'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext,5,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Channel'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,6,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Channel'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,7,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Channel'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,1,1,L["TOGGLE"],nil,nil,false,'isEnabled','Channel'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Channel'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Channel'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Channel'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 7,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Channel'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Channel'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.background,3,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Channel'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.background,4,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Channel'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,5,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,'showBG','Channel'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,6,1,L["LABEL_WIDTH"],nil,100,500,nil,false,'width','Channel'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,7,1,L["LABEL_HEIGHT"],nil,10,100,nil,false,'height','Channel'),
									},
								},
								reset = {
									order = 8,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CHANNEL"],
									func = function()
										local bar = statusbars.bars.ChannelBar
										local default = Auras.db.char.statusbars.defaults.ChannelBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										
										Auras:ResetText(bar,'nametext',default)
										Auras:ResetText(bar,'timetext',default)
										
										bar.icon.isEnabled = true
										bar.icon.justify = default.icon.justify
										bar.spark = true
										
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)
										
										ele_options.args.bars.args.ChannelBar.args.reset.disabled = true
										ele_options.args.bars.args.ChannelBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_CHANNEL"].."|r"
										Auras:VerifyDefaultValues(1,ele_options,'Channel')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('ChannelBar',nil,'nametext','timetext',1)
										end
									end,
								},
							},
						},
						IcefuryBar = {
							name = L["LABEL_STATUSBAR_ICEFURY"],
							order = 9,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.adjust,1,1,L["LABEL_STATUSBAR_MODIFY_ICEFURY"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,'isEnabled','Icefury'),
								counttextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.counttext,2,1,L["TOGGLE_COUNT_TEXT"],L["TOOLTIP_TOGGLE_ICEFURY_TEXT"],nil,false,'isDisplayText','Icefury'),
								timetextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.timetext,2,1,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],nil,false,'isDisplayText','Icefury'),
								counttext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_COUNT"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font,1,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Icefury'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font,2,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Icefury'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font,3,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Icefury'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font,4,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Icefury'),
										textAnchor = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.counttext,5,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Icefury'),
										textX = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext,6,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Icefury'),
										textY = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext,7,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Icefury'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font.shadow,1,1,L["TOGGLE"],nil,nil,false,'isEnabled','Icefury'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Icefury'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Icefury'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Icefury'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font,1,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Icefury'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font,2,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Icefury'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font,3,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Icefury'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font,4,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Icefury'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.timetext,5,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Icefury'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext,6,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Icefury'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext,7,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Icefury'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font.shadow,1,1,L["TOGGLE"],nil,nil,false,'isEnabled','Icefury'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Icefury'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Icefury'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Icefury'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 6,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Icefury'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Icefury'),
										timerTexture = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.timerBar,3,1,L["LABEL_TIME_BAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Icefury'),
										timerColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.timerBar,4,1,L["LABEL_STATUSBAR_COLOR"],nil,true,nil,false,'color','Icefury'),
										timerToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.adjust,5,1,L["LABEL_STATUSBAR_MODIFY_TIMER"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,'showTimer','Icefury'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.background,6,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Icefury'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.background,7,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Icefury'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.adjust,8,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,'showBG','Icefury'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.layout,9,1,L["LABEL_WIDTH"],nil,100,500,nil,false,'width','Icefury'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.layout,10,1,L["LABEL_HEIGHT"],nil,10,100,nil,false,'height','Icefury'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_ICEFURY"],
									func = function()
										local bar = statusbars.bars.IcefuryBar
										local default = statusbars[1].defaults.IcefuryBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										bar.alphaTar = default.alphaTar
										
										Auras:ResetText(bar,'counttext',default)
										Auras:ResetText(bar,'timetext',default)
										
										Auras:ResetBackground(bar,default)
										Auras:ResetTimerBar(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)
										
										ele_options.args.bars.args.IcefuryBar.args.reset.disabled = true
										ele_options.args.bars.args.IcefuryBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_ICEFURY"].."|r"
										Auras:VerifyDefaultValues(1,ele_options,'Icefury')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('IcefuryBar','Timer','counttext','timetext',1)
										end
									end,
								},
							},
						},
					},
				},
				cooldowns = {
					name = L["LABEL_COOLDOWN"],
					order = 6,
					type = "group",
					disabled = true,
					args = {
						toggle = Auras:Toggle_VerifyDefaults(cooldowns,1,1,ENABLE,L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],"full",false,'isEnabled','Cooldowns'),
						text = Auras:Toggle_Basic(cooldowns,2,L["LABEL_COOLDOWN_TEXT"],L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],not cooldowns.isEnabled,'text'),
						sweep = Auras:Toggle_Cooldowns(cooldowns,3,1,L["LABEL_COOLDOWN_SWEEP"],L["TOOLTIP_TOGGLE_COOLDOWN_SWEEP"],not cooldowns.isEnabled,'sweep','AuraBase','Cooldowns'),
						GCD = Auras:Toggle_Basic(cooldowns.GCD,4,L["LABEL_COOLDOWN_GCD"],L["TOOLTIP_TOGGLE_COOLDOWN_GCD"],not cooldowns.sweep and not cooldowns.isEnabled,'isEnabled'),
						inverse = Auras:Toggle_Cooldowns(cooldowns,5,1,L["LABEL_COOLDOWN_REVERSE_SWEEP"],L["TOOLTIP_COOLDOWN_REVERSE_SWEEP"],not cooldowns.sweep and not cooldowns.isEnabled,'inverse','AuraBase'),
						bling = Auras:Toggle_Cooldowns(cooldowns,6,1,L["LABEL_COOLDOWN_BLING"],L["TOOLTIP_TOGGLE_COOLDOWN_BLING"],not cooldowns.sweep and not cooldowns.isEnabled,'blind','AuraBase'),
						group = Auras:Select_VerifyDefaults(cooldowns,7,1,L["LABEL_COOLDOWN_GROUP"],L["TOOLTIP_AURAS_GROUP_SELECT"],nil,COOLDOWN_OPTIONS,nil,not cooldowns.isEnabled,'selected','Cooldowns',nil,false,true),
						adjustToggle = Auras:Toggle_VerifyDefaults(cooldowns,8,1,L["LABEL_COOLDOWN_ADJUST"],nil,nil,not cooldowns.isEnabled,'adjust','Cooldowns'),
						cdGroups = {
							name = "Cooldown Groups",
							order = 9,
							desc = "TESTING",
							type = "group",
							guiInline = true,
							args = {
							},
						},
					},
				},
				--[[layout = {
					name = L["LABEL_LAYOUT"],
					order = 6,
					type = "group",
					disabled = true,
					args = {
						MoveAuras = Auras:Execute_MoveAuras(elements,1,1,"|cFFFFCC00"..L["BUTTON_MOVE_AURAS_ELEMENTAL"].."|r"),
						ResetAuras = Auras:Execute_ResetAuras(2,'AuraGroup1',"|cFFFFCC00"..L["BUTTON_RESET_AURAS_ELEMENTAL"].."|r"),
						primaryAuras = {
							name = L["LABEL_AURAS_PRIMARY"],
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								PrimaryOrientation1 = Auras:Select_VerifyDefaults(layout.orientation,1,1,L["LABEL_AURAS_ORIENTATION"].." 1",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'top','Primary',nil,true),
								PrimaryOrientation2 = Auras:Select_VerifyDefaults(layout.orientation,2,1,L["LABEL_AURAS_ORIENTATION"].." 2",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'bottom','Primary',nil,true),
								filler_1 = Auras:Spacer(3),
								AuraSizeRow1 = Auras:Slider_VerifyDefaults(layout.primary.top,4,1,L["LABEL_AURAS_SIZE"].." 1",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Primary',nil,true),
								AuraSpacingRow1 = Auras:Slider_VerifyDefaults(layout.primary.top,5,1,L["LABEL_AURAS_SPACING"].." 1",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Primary',nil,true),
								AuraChargesRow1 = Auras:Slider_VerifyDefaults(layout.primary.top,6,1,L["LABEL_AURAS_CHARGES"].." 1",L["TOOLTIP_AURAS_CHARGE_SIZE"],10,60,nil,'charges','Primary',nil,true),
								AuraSizeRow2 = Auras:Slider_VerifyDefaults(layout.primary.bottom,7,1,L["LABEL_AURAS_SIZE"].." 2",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Primary',nil,true),
								AuraSpacingRow2 = Auras:Slider_VerifyDefaults(layout.primary.bottom,8,1,L["LABEL_AURAS_SPACING"].." 2",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Primary',nil,true),
								filler_3 = Auras:Spacer(9),
								ResetPrimaryLayout = {
									order = 10,
									type = "execute",
									name = L["BUTTON_RESET_LAYOUT_PRIMARY"],
									func = function()
										layout.orientation.top = layoutDefaults.orientation.top
										layout.orientation.bottom = layoutDefaults.orientation.bottom
										layout.primary.top.icon = layoutDefaults.primary.top.icon
										layout.primary.top.spacing = layoutDefaults.primary.top.spacing
										layout.primary.top.charges = layoutDefaults.primary.top.charges
										layout.primary.bottom.icon = layoutDefaults.primary.bottom.icon
										layout.primary.bottom.spacing = layoutDefaults.primary.bottom.spacing
										--layout.primary.bottom.charges = layoutDefaults.primary.bottom.charges
										res_options.args.layout.args.primaryAuras.args.ResetPrimaryLayout.disabled = true
										res_options.args.layout.args.primaryAuras.args.ResetPrimaryLayout.name = "|cFF666666"..L["BUTTON_RESET_LAYOUT_PRIMARY"].."|r"
										Auras:UpdateTalents()
									end,
								},
							},
						},
						secondaryAuras = {
							name = L["LABEL_AURAS_SECONDARY"],
							type = "group",
							order = 4,
							guiInline = true,
							args = {
								SecondaryOrientation1 = Auras:Select_VerifyDefaults(layout.orientation,1,1,L["LABEL_AURAS_ORIENTATION"].." 1",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'left','Secondary',nil,true),
								SecondaryOrientation2 = Auras:Select_VerifyDefaults(layout.orientation,2,1,L["LABEL_AURAS_ORIENTATION"].." 2",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'right','Secondary',nil,true),
								filler_1 = Auras:Spacer(3),
								AuraSizeCol1 = Auras:Slider_VerifyDefaults(layout.secondary.left,4,1,L["LABEL_AURAS_SIZE"].." 1",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Secondary',nil,true),
								AuraSpacingCol1 = Auras:Slider_VerifyDefaults(layout.secondary.left,5,1,L["LABEL_AURAS_SPACING"].." 1",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Secondary',nil,true),
								filler_2 = Auras:Spacer(6),
								AuraSizeCol2 = Auras:Slider_VerifyDefaults(layout.secondary.right,7,1,L["LABEL_AURAS_SIZE"].." 2",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Secondary',nil,true),
								AuraSpacingCol2 = Auras:Slider_VerifyDefaults(layout.secondary.right,8,1,L["LABEL_AURAS_SPACING"].." 2",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Secondary',nil,true),
								filler_3 = Auras:Spacer(9),
								ResetSecondaryLayout = {
									order = 10,
									type = "execute",
									--name = "|cFFFFCC00"..L["BUTTON_RESET_LAYOUT_SECONDARY"].."|r",
									--disabled = false,
									name = L["BUTTON_RESET_LAYOUT_SECONDARY"],
									func = function()
										layout.orientation.left = layoutDefaults.orientation.left
										layout.orientation.right = layoutDefaults.orientation.right
										layout.secondary.left.icon = layoutDefaults.secondary.left.icon
										layout.secondary.left.spacing = layoutDefaults.secondary.left.spacing
										--layout.secondary.left.charges = layoutDefaults.secondary.left.charges
										layout.secondary.right.icon = layoutDefaults.secondary.right.icon
										layout.secondary.right.spacing = layoutDefaults.secondary.right.spacing
										--layout.secondary.right.charges = layoutDefaults.secondary.right.charges
										ele_options.args.layout.args.secondaryAuras.args.ResetSecondaryLayout.disabled = true
										ele_options.args.layout.args.secondaryAuras.args.ResetSecondaryLayout.name = "|cFF666666"..L["BUTTON_RESET_LAYOUT_SECONDARY"].."|r"
										Auras:UpdateTalents()
									end,
								},
							},
						},
					},
				},]]
			},
		}
	end
		
	return ele_options
end

local enh_options

local function GetEnhancementOptions()
	if not enh_options then
		local db = Auras.db.char
	
		-- Database Shortcuts
		local settings = db.settings[2]
		local settingDefaults = db.settings.defaults
		
		-- Element Tables
		--local elements = db.elements[2]
		local cooldowns = db.auras[2].cooldowns
		local timerbars = db.timerbars[2]
		local statusbars = db.statusbars[2]
		--local frames = db.elements[2].frames
		local auras = db.auras[2]
		
		-- Layout Table
		--local layout = db.layout[2]
		--local layoutDefaults = db.layout.defaults
		
		-- Element Defaults Tables
		--[[local timerbarDefaults = db.elements.defaults[2].timerbars
		local cooldownDefaults = db.elements.defaults[2].cooldowns
		local statusbarDefaults = db.elements.defaults[2].statusbars
		local frameDefaults = db.elements.defaults[2].frames]]
	
		local COOLDOWN_OPTIONS = {}
	
		for i=1,#auras.groups do
			tinsert(COOLDOWN_OPTIONS,"Group #"..i.." Cooldowns")
		end
		
		enh_options = {
			type = "group",
			childGroups = "tab",
			order = 1,
			name = L["LABEL_AURAS_ENHANCEMENT"],
			desc = '',
			args = {
				--[[display = {
					name = DISPLAY,
					type = "group",
					order = 1,
					args = {
						show = Auras:Toggle_Basic(elements,1,L["LABEL_SHOW_ENHANCEMENT_AURAS"],L["TOOLTIP_TOGGLE_ENHANCEMENT_AURAS"],'isEnabled',true),
						MajorAuras = {
							name = L["LABEL_AURAS_PRIMARY"],
							type = "group",
							order = 2,
							guiInline = true,
							args = {
								Ascendance = Auras:Toggle_Basic(auras.toggle,1,Auras:GetSpellName(114051),nil,false,'Ascendance',true),
								CrashLightning = Auras:Toggle_Basic(auras.toggle,2,Auras:GetSpellName(187874),nil,false,'CrashLightning',true),
								EarthenSpike = Auras:Toggle_Basic(auras.toggle,3,Auras:GetSpellName(188089),nil,false,'EarthenSpike',true),
								FeralLunge = Auras:Toggle_Basic(auras.toggle,4,Auras:GetSpellName(196884),nil,false,'FeralLunge',true),
								FeralSpirit = Auras:Toggle_Basic(auras.toggle,5,Auras:GetSpellName(51533),nil,false,'FeralSpirit',true),
								Flametongue = Auras:Toggle_Basic(auras.toggle,6,Auras:GetSpellName(193796),nil,false,'Flametongue',true),
								Frostbrand = Auras:Toggle_Basic(auras.toggle,7,Auras:GetSpellName(196834),nil,false,'Frostbrand',true),
								LavaLash = Auras:Toggle_Basic(auras.toggle,8,Auras:GetSpellName(60103),nil,false,'LavaLash',true),
								Rockbiter = Auras:Toggle_Basic(auras.toggle,9,Auras:GetSpellName(193786),nil,false,'Rockbiter',true),
								Stormstrike = Auras:Toggle_Basic(auras.toggle,10,Auras:GetSpellName(17364),nil,false,'Stormstrike',true),
								Sundering = Auras:Toggle_Basic(auras.toggle,11,Auras:GetSpellName(197214),nil,false,'Sundering',true),
							},
						},
						BuffAuras = {
							name = L["LABEL_AURAS_BUFF"],
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								EarthShield = Auras:Toggle_Basic(auras.toggle,1,Auras:GetSpellName(974),nil,false,'EarthShield',true),
								ForcefulWinds = Auras:Toggle_Basic(auras.toggle,2,Auras:GetSpellName(262647),nil,false,'ForcefulWinds',true),
								NaturesGuardian = Auras:Toggle_Basic(auras.toggle,3,Auras:GetSpellName(30884),nil,false,'NaturesGuardian',true),
							},
						},
						PvPAuras = {
							name = L["LABEL_AURAS_PVP"],
							type = "group",
							order = 4,
							guiInline = true,
							args = {
								Adaptation = Auras:Toggle_Basic(auras.toggle,1,Auras:GetSpellName(214027),nil,false,'Adaptation',true),
								CounterstrikeTotem = Auras:Toggle_Basic(auras.toggle,2,Auras:GetSpellName(204331),nil,false,'CounterstrikeTotem',true),
								EtherealForm = Auras:Toggle_Basic(auras.toggle,3,Auras:GetSpellName(210918),nil,false,'EtherealForm',true),
								GladiatorsMedallion = Auras:Toggle_Basic(auras.toggle,4,Auras:GetSpellName(208683),nil,false,'GladiatorsMedallion',true),
								GroundingTotem = Auras:Toggle_Basic(auras.toggle,5,Auras:GetSpellName(204336),nil,false,'GroundingTotem',true),
								SkyfuryTotem = Auras:Toggle_Basic(auras.toggle,6,Auras:GetSpellName(204330),nil,false,'SkyfuryTotem',true),
								StaticCling = Auras:Toggle_Basic(auras.toggle,7,Auras:GetSpellName(211062),nil,false,'StaticCling',true),
								Thundercharge = Auras:Toggle_Basic(auras.toggle,8,Auras:GetSpellName(204366),nil,false,'Thundercharge',true),
							},
						},
						MinorAuras = {
							name = L["LABEL_AURAS_SECONDARY"],
							type = "group",
							order = 5,
							guiInline = true,
							args = {
								AstralShift = Auras:Toggle_Basic(auras.toggle,1,Auras:GetSpellName(108271),nil,false,'AstralShift',true),
								CapacitorTotem = Auras:Toggle_Basic(auras.toggle,2,Auras:GetSpellName(192058),nil,false,'CapacitorTotem',true),
								CleanseSpirit = Auras:Toggle_Basic(auras.toggle,3,Auras:GetSpellName(51886),nil,false,'CleanseSpirit',true),
								EarthbindTotem = Auras:Toggle_Basic(auras.toggle,4,Auras:GetSpellName(2484),nil,false,'EarthbindTotem',true),
								Hex = Auras:Toggle_Basic(auras.toggle,5,Auras:GetSpellName(51514),nil,false,'Hex',true),
								SpiritWalk = Auras:Toggle_Basic(auras.toggle,6,Auras:GetSpellName(58875),nil,false,'SpiritWalk',true),
								WindRushTotem = Auras:Toggle_Basic(auras.toggle,7,Auras:GetSpellName(192077),nil,false,'WindRushTotem',true),
								WindShear = Auras:Toggle_Basic(auras.toggle,8,Auras:GetSpellName(57994),nil,false,'WindShear',true),
							},
						},
						ProgressBars = {
							name = L["LABEL_PROGRESS_BARS"],
							type = "group",
							order = 6,
							guiInline = true,
							args = {
								BuffTimerBars = {
									name = L["LABEL_STATUSBAR_BUFF_TIMER"],
									type = "group",
									order = 2,
									guiInline = true,
									args = {
										AscendanceBar2 = Auras:Toggle_Basic(timerbars.buff,1,Auras:GetSpellName(114051),nil,false,'ascendance'),
										AstralShiftBar2 = Auras:Toggle_Basic(timerbars.buff,2,Auras:GetSpellName(108271),nil,false,'astralShift'),
										Bloodlust = Auras:Toggle_Basic(timerbars.buff,3,Auras:GetSpellName(2825),nil,false,'bloodlust'),
										Heroism = Auras:Toggle_Basic(timerbars.buff,4,Auras:GetSpellName(32182),nil,false,'heroism'),
										HexBar2 = Auras:Toggle_Basic(timerbars.buff,5,Auras:GetSpellName(51514),nil,false,'hex'),
										SpiritWalkBar = Auras:Toggle_Basic(timerbars.buff,6,Auras:GetSpellName(58875),nil,false,'spiritWalk'),
										TimeWarp = Auras:Toggle_Basic(timerbars.buff,7,Auras:GetSpellName(80353),nil,false,'timeWarp'),
									},
								},
								MainTimerBars = {
									name = L["LABEL_TIMERS_ABILITY"],
									type = "group",
									order = 3,
									guiInline = true,
									args = {
										CrashLightningBar = Auras:Toggle_Basic(timerbars.main,1,Auras:GetSpellName(187874),nil,false,'crashLightning'),
										EarthenSpikeBar = Auras:Toggle_Basic(timerbars.main,2,Auras:GetSpellName(188089),nil,false,'earthenSpike'),
										FlametongueBar = Auras:Toggle_Basic(timerbars.main,3,Auras:GetSpellName(193796),nil,false,'flametongue'),
										FrostbrandBar = Auras:Toggle_Basic(timerbars.main,4,Auras:GetSpellName(196834),nil,false,'frostbrand'),
										Landslide = Auras:Toggle_Basic(timerbars.main,5,Auras:GetSpellName(197992),nil,false,'landslide'),
									},
								},
								TotemTimerBars = {
									name = L["LABEL_TIMERS_TOTEM"],
									type = "group",
									order = 4,
									guiInline = true,
									args = {
										EarthbindTotemBar = Auras:Toggle_Basic(timerbars.util,1,Auras:GetSpellName(2484),nil,false,'earthbindTotem'),
										WindRushTotemBar2 = Auras:Toggle_Basic(timerbars.util,2,Auras:GetSpellName(192077),nil,false,'windRushTotem'),
									},
								},
							},
						},
						TextureAlerts = {
							name = L["TOOLTIP_TEXTURE_ALERTS"],
							type = "group",
							order = 7,
							guiInline = true,
							args = {
								StormstrikeOrbs = Auras:Toggle_Basic(frames.StormstrikeChargeGrp,1,L["LABEL_STORMSTRIKE_ORBS"],nil,false,'isEnabled'),
							},
						},
					},
				},]]
				general = {
					name = MAIN_MENU,
					order = 2,
					type = "group",
					childGroups = "tab",
					disabled = true,
					args = {
						settings = {
							name = L["LABEL_AURAS_SETTINGS"],
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								OoCAlpha = Auras:Slider_VerifyDefaults(settings,1,2,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_AURAS_ALPHA_NO_COMBAT"],0,1,nil,false,'OoCAlpha','Settings'),
								OoRColor = Auras:Color_VerifyDefaults(settings,2,2,L["LABEL_COLOR_NO_RANGE"],L["TOOLTIP_COLOR_OUT_OF_RANGE"],true,"double",false,'OoRColor','Settings'),
								lavaLash = {
									name = L["LABEL_LAVA_LASH_OPTIONS"],
									type = "group",
									order = 3,
									guiInline = true,
									args = {
										LavaLashStacks = Auras:Toggle_VerifyDefaults(settings.lavaLash.stacks,1,2,L["TOGGLE_LAVA_LASH_STACKS"],L["TOOLTIP_TOGGLE_LAVA_LASH_STACKS"],nil,false,'isEnabled','Settings'),
										LavaLashGlow = Auras:Toggle_VerifyDefaults(settings.lavaLash,2,2,L["TOGGLE_LAVA_LASH_GLOW"],L["TOOLTIP_TOGGLE_LAVA_LASH_GLOW"],nil,false,'glow','Settings'),
										LavaLashGlowStacks = Auras:Slider_VerifyDefaults(settings.lavaLash.stacks,3,2,L["LABEL_LAVA_LASH_STACKS"],L["TOOLTIP_LAVA_LASH_STACKS"],1,99,nil,false,'value','Settings'),
									},
								},
								reset = {
									order = 4,
									type = "execute",
									name = L["BUTTON_RESET_SETTINGS"],
									func = function()
										settings.OoCAlpha = settingDefaults.OoCAlpha
										settings.OoRColor.r = settingDefaults.OoRColor.r
										settings.OoRColor.g = settingDefaults.OoRColor.g
										settings.OoRColor.b = settingDefaults.OoRColor.b
										settings.OoRColor.a = settingDefaults.OoRColor.a
										settings.lavaLash.stacks.isEnabled = true
										settings.lavaLash.stacks.value = settingDefaults[2].lavaLash.stacks
										settings.lavaLash.glow = true
										enh_options.args.general.args.settings.args.lavaLash.args.LavaLashGlowStacks.disabled = false
										enh_options.args.general.args.settings.args.reset.disabled = true
										enh_options.args.general.args.settings.args.reset.name = "|cFF666666"..L["BUTTON_RESET_SETTINGS"].."|r"
									end,
								},
							},
						},
					},
				},
				auraGroups = {
					name = "Aura Builder",
					type = "group",
					childGroups = "tab",
					order = 3,
					args = {
					},
				},
				timerbarGroups = {
					name = "Timer Bar Builder",
					type = "group",
					childGroups = "tab",
					order = 4,
					args = {
					},
				},
				bars = {
					name = L["LABEL_PROGRESS_BARS"],
					order = 4,
					type = "group",
					childGroups = "tab",
					disabled = true,
					args = {
						general = {
							name = GENERAL,
							order = 1,
							inline = false,
							type = "group",
							args = {
								statusbars = {
									name = L["LABEL_STATUSBAR_MANAGER"],
									type = "group",
									order = 1,
									guiInline = true,
									args = {
										defaultBarToggle = Auras:Toggle_Basic(statusbars,1,L["LABEL_STATUSBAR_BLIZZARD"],L["TOOLTIP_TOGGLE_BLIZZARD_BAR"],false,'defaultBar'),
										castBarToggle = Auras:Toggle_Statusbar(statusbars.bars.CastBar,2,L["TOGGLE_CAST_BAR"],L["TOOLTIP_TOGGLE_CAST_BAR"],'isEnabled','CastBar'),
										channelToggle = Auras:Toggle_Statusbar(statusbars.bars.ChannelBar,3,L["TOGGLE_CHANNEL_BAR"],L["TOOLTIP_TOGGLE_CHANNEL_BAR"],'isEnabled','ChannelBar'),
										maelstromToggle = Auras:Toggle_Statusbar(statusbars.bars.MaelstromBar,5,L["TOGGLE_MAELSTROM_BAR"],L["TOOLTIP_TOGGLE_MAELSTROM_BAR"],'isEnabled','MaelstromBar'),
									},
								},
							},
						},
						MaelstromBar = {
							name = L["LABEL_STATUSBAR_MAELSTROM"],
							order = 2,
							type = "group",
							inline = false,
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar.adjust,1,2,L["LABEL_STATUSBAR_MODIFY_MAELSTROM"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,'isEnabled','Maelstrom'),
								textToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar.text,2,2,L["LABEL_TEXT_MAELSTROM"],L["TOOLTIP_TOGGLE_MAELSTROM_TEXT"],nil,false,'isDisplayText','Maelstrom'),
								animation = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar,3,2,L["LABEL_STATUSBAR_ANIMATE_MAELSTROM"],nil,nil,false,'animate','Maelstrom'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar,1,2,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,false,'alphaCombat','Maelstrom'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar,2,2,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,false,'alphaOoC','Maelstrom'),
										alphaTarget = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar,3,2,L["LABEL_ALPHA_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_TARGET_NO_COMBAT"],0,1,nil,false,'alphaTar','Maelstrom'),
										threshold = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar,4,2,L["LABEL_TRIGGER_MAELSTROM"],L["TOOLTIP_MAELSTROM_TIME_TRIGGER"],50,100,nil,false,'threshold','Maelstrom'),
									},
								},
								text = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_MAELSTROM"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromBar.text.font,1,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Maelstrom'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.text.font,2,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Maelstrom'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text.font,3,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Maelstrom'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.text.font,4,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,false,nil,'flag','Maelstrom'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.text,5,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,false,nil,'justify','Maelstrom'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text,6,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Maelstrom'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text,7,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Maelstrom'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar.text.font.shadow,1,2,L["TOGGLE"],nil,nil,false,'isEnabled','Maelstrom'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromBar.text.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Maelstrom'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Maelstrom'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.text.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Maelstrom'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 6,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.foreground,1,2,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Maelstrom'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromBar.foreground,2,2,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Maelstrom'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromBar.background,3,2,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Maelstrom'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromBar.background,4,2,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Maelstrom'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromBar.adjust,5,2,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,'showBG','Maelstrom'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.layout,6,2,L["LABEL_WIDTH"],nil,100,500,nil,false,'width','Maelstrom'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromBar.layout,7,2,L["LABEL_HEIGHT"],nil,10,100,nil,false,'height','Maelstrom'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_MAELSTROM"],
									func = function()
										local bar = statusbars.bars.MaelstromBar
										local default = statusbars.defaults.MaelstromBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										bar.alphaTar = default.alphaTar
										bar.threshold = default.threshold
										bar.animate = true
										
										Auras:ResetText(bar,'text',default)
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)
										
										enh_options.args.bars.args.MaelstromBar.args.reset.disabled = true
										enh_options.args.bars.args.MaelstromBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_MAELSTROM"].."|r"
										Auras:VerifyDefaultValues(2,enh_options,'Maelstrom')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('MaelstromBar',nil,'text',nil,2)
										end
									end,
								},
							},
						},
						CastBar = {
							name = L["LABEL_STATUSBAR_CAST"],
							order = 3,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,1,2,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,'isEnabled','Cast'),
								nametextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext,2,2,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],nil,false,'isDisplayText','Cast'),
								timetextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext,3,2,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],nil,false,'isDisplayText','Cast'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,1,2,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,false,'alphaCombat','Cast'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,2,2,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,false,'alphaOoC','Cast'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar,1,2,L["TOGGLE_SPARK"],nil,nil,false,'spark','Cast'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.icon,2,2,L["TOGGLE_ICON"],nil,nil,false,'isEnabled','Cast'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.icon,3,2,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,false,'justify','Cast'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 6,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font,1,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Cast'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,2,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),false,nil,'name','Cast'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font,3,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Cast'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,4,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,false,nil,'flag','Cast'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext,5,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,false,nil,'justify','Cast'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,6,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Cast'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,7,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Cast'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,1,2,L["TOGGLE"],nil,nil,false,'isEnabled','Cast'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Cast'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Cast'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Cast'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 7,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font,1,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Cast'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,2,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),false,nil,'name','Cast'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font,3,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Cast'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,4,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,false,nil,'flag','Cast'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext,5,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,false,nil,'justify','Cast'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,6,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Cast'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,7,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Cast'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,1,2,L["TOGGLE"],nil,nil,false,'isEnabled','Cast'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Cast'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Cast'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Cast'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 8,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.foreground,1,2,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Cast'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.foreground,2,2,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Cast'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.background,3,2,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Cast'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.background,4,2,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Cast'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,5,2,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,'showBG','Cast'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,6,2,L["LABEL_WIDTH"],nil,100,500,nil,false,'width','Cast'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,7,2,L["LABEL_HEIGHT"],nil,10,100,nil,false,'height','Cast'),
									},
								},
								reset = {
									order = 9,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CAST"],
									func = function()
										local bar = statusbars.bars.CastBar
										local default = Auras.db.char.statusbars.defaults.CastBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										
										Auras:ResetText(bar,'nametext',default)
										Auras:ResetText(bar,'timetext',default)
										
										bar.icon.isEnabled = true
										bar.icon.justify = default.icon.justify
										bar.spark = true
										
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)
										
										enh_options.args.bars.args.CastBar.args.reset.disabled = true
										enh_options.args.bars.args.CastBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_CAST"].."|r"
										Auras:VerifyDefaultValues(2,enh_options,'Cast')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('CastBar',nil,'nametext','timetext',2)
										end
									end,
								},
							},
						},
						ChannelBar = {
							name = L["LABEL_STATUSBAR_CHANNEL"],
							order = 4,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,1,2,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,'isEnabled','Channel'),
								nametextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext,2,2,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],nil,false,'isDisplayText','Channel'),
								timetextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext,3,2,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],nil,false,'isDisplayText','Channel'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,1,2,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,false,'alphaCombat','Channel'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,2,2,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,false,'alphaOoC','Channel'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar,1,2,L["TOGGLE_SPARK"],nil,nil,false,'spark','Channel'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.icon,2,2,L["TOGGLE_ICON"],nil,nil,false,'isEnabled','Channel'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.icon,3,2,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,false,'justify','Channel'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 6,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,1,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Channel'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,2,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),false,nil,'name','Channel'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,3,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Channel'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,4,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,false,nil,'flag','Channel'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext,5,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,false,nil,'justify','Channel'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,6,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Channel'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,7,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Channel'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,1,2,L["TOGGLE"],nil,nil,false,'isEnabled','Channel'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Channel'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Channel'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Channel'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 6,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,1,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Channel'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,2,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),false,nil,'name','Channel'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,3,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,false,'size','Channel'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,4,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,false,nil,'flag','Channel'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext,5,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,false,nil,'justify','Channel'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,6,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Channel'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,7,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Channel'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,1,2,L["TOGGLE"],nil,nil,false,'isEnabled','Channel'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Channel'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,false,'x','Channel'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,false,'y','Channel'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 7,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.foreground,1,2,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Channel'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.foreground,2,2,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Channel'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.background,3,2,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Channel'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.background,4,2,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Channel'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,5,2,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,'showBG','Channel'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,6,2,L["LABEL_WIDTH"],nil,100,500,nil,false,'width','Channel'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,7,2,L["LABEL_HEIGHT"],nil,10,100,nil,false,'height','Channel'),
									},
								},
								reset = {
									order = 8,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CHANNEL"],
									func = function()
										local bar = statusbars.bars.ChannelBar
										local default = Auras.db.char.statusbars.default.channelBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										
										Auras:ResetText(bar,'nametext',default)
										Auras:ResetText(bar,'timetext',default)
										
										bar.icon.isEnabled = true
										bar.icon.justify = default.icon.justify
										bar.spark = true
										
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)

										enh_options.args.bars.args.ChannelBar.args.reset.disabled = true
										enh_options.args.bars.args.ChannelBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_CHANNEL"].."|r"
										Auras:VerifyDefaultValues(2,enh_options,'Channel')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('ChannelBar',nil,'nametext','timetext',2)
										end
									end,
								},
							},
						},
					},
				},
				cooldowns = {
					name = L["LABEL_COOLDOWN"],
					order = 5,
					type = "group",
					disabled = true,
					args = {
						toggle = Auras:Toggle_VerifyDefaults(cooldowns,1,2,ENABLE,L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],"full",false,'isEnabled','Cooldowns'),
						text = Auras:Toggle_Basic(cooldowns,2,L["LABEL_COOLDOWN_TEXT"],L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],not cooldowns.isEnabled,'text'),
						sweep = Auras:Toggle_Cooldowns(cooldowns,3,2,L["LABEL_COOLDOWN_SWEEP"],L["TOOLTIP_TOGGLE_COOLDOWN_SWEEP"],not cooldowns.isEnabled,'sweep','AuraBase','Cooldowns'),
						GCD = Auras:Toggle_Basic(cooldowns.GCD,4,L["LABEL_COOLDOWN_GCD"],L["TOOLTIP_TOGGLE_COOLDOWN_GCD"],not cooldowns.sweep and not cooldowns.isEnabled,'isEnabled'),
						inverse = Auras:Toggle_Cooldowns(cooldowns,5,2,L["LABEL_COOLDOWN_REVERSE_SWEEP"],L["TOOLTIP_COOLDOWN_REVERSE_SWEEP"],not cooldowns.sweep and not cooldowns.isEnabled,'inverse','AuraGroup1'),
						bling = Auras:Toggle_Cooldowns(cooldowns,6,2,L["LABEL_COOLDOWN_BLING"],L["TOOLTIP_TOGGLE_COOLDOWN_BLING"],not cooldowns.sweep and not cooldowns.isEnabled,'blind','AuraBase'),
						group = Auras:Select_VerifyDefaults(cooldowns,7,2,L["LABEL_COOLDOWN_GROUP"],L["TOOLTIP_AURAS_GROUP_SELECT"],nil,COOLDOWN_OPTIONS,nil,not cooldowns.isEnabled,'selected','Cooldowns'),
						adjustToggle = Auras:Toggle_VerifyDefaults(cooldowns,8,2,L["LABEL_COOLDOWN_ADJUST"],nil,nil,not cooldowns.isEnabled,'adjust','Cooldowns'),
						cdGroups = {
							name = "Cooldown Groups",
							order = 9,
							desc = "TESTING",
							type = "group",
							guiInline = true,
							args = {
							},
						},
					},
				},
				--[[layout = {
					name = L["LABEL_LAYOUT"],
					order = 6,
					type = "group",
					disabled = true,
					args = {
						MoveAuras = Auras:Execute_MoveAuras(elements,1,2,"|cFFFFCC00"..L["BUTTON_MOVE_AURAS_ENHANCEMENT"].."|r"),
						ResetAuras = Auras:Execute_ResetAuras(2,'AuraGroup2',"|cFFFFCC00"..L["BUTTON_RESET_AURAS_ENHANCEMENT"].."|r"),
						primaryAuras = {
							name = L["LABEL_AURAS_PRIMARY"],
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								PrimaryOrientation1 = Auras:Select_VerifyDefaults(layout.orientation,1,2,L["LABEL_AURAS_ORIENTATION"].." 1",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'top','Primary',nil,true),
								PrimaryOrientation2 = Auras:Select_VerifyDefaults(layout.orientation,2,2,L["LABEL_AURAS_ORIENTATION"].." 2",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'bottom','Primary',nil,true),
								filler_1 = Auras:Spacer(3),
								AuraSizeRow1 = Auras:Slider_VerifyDefaults(layout.primary.top,4,2,L["LABEL_AURAS_SIZE"].." 1",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Primary',nil,true),
								AuraSpacingRow1 = Auras:Slider_VerifyDefaults(layout.primary.top,5,2,L["LABEL_AURAS_SPACING"].." 1",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Primary',nil,true),
								AuraChargesRow1 = Auras:Slider_VerifyDefaults(layout.primary.top,6,2,L["LABEL_AURAS_CHARGES"].." 1",L["TOOLTIP_AURAS_CHARGE_SIZE"],10,60,nil,'charges','Primary',nil,true),
								AuraSizeRow2 = Auras:Slider_VerifyDefaults(layout.primary.bottom,7,2,L["LABEL_AURAS_SIZE"].." 2",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Primary',nil,true),
								AuraSpacingRow2 = Auras:Slider_VerifyDefaults(layout.primary.bottom,8,2,L["LABEL_AURAS_SPACING"].." 2",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Primary',nil,true),
								AuraChargesRow2 = Auras:Slider_VerifyDefaults(layout.primary.top,9,2,L["LABEL_AURAS_CHARGES"].." 2",L["TOOLTIP_AURAS_CHARGE_SIZE"],10,60,nil,'charges','Primary',nil,true),
								ResetPrimaryLayout = {
									order = 12,
									type = "execute",
									--name = "|cFFFFCC00"..L["BUTTON_RESET_LAYOUT_PRIMARY"].."|r",
									--disabled = false,
									name = L["BUTTON_RESET_LAYOUT_PRIMARY"],
									func = function()
										layout.orientation.top = layoutDefaults.orientation.top
										layout.orientation.bottom = layoutDefaults.orientation.bottom
										layout.primary.top.icon = layoutDefaults.primary.top.icon
										layout.primary.top.spacing = layoutDefaults.primary.top.spacing
										layout.primary.top.charges = layoutDefaults.primary.top.charges
										layout.primary.bottom.icon = layoutDefaults.primary.bottom.icon
										layout.primary.bottom.spacing = layoutDefaults.primary.bottom.spacing
										layout.primary.bottom.charges = layoutDefaults.primary.bottom.charges
										enh_options.args.layout.args.primaryAuras.args.ResetPrimaryLayout.disabled = true
										enh_options.args.layout.args.primaryAuras.args.ResetPrimaryLayout.name = "|cFF666666"..L["BUTTON_RESET_LAYOUT_PRIMARY"].."|r"
										Auras:UpdateTalents()
									end,
								},
							},
						},
						secondaryAuras = {
							name = L["LABEL_AURAS_SECONDARY"],
							type = "group",
							order = 4,
							guiInline = true,
							args = {
								SecondaryOrientation1 = Auras:Select_VerifyDefaults(layout.orientation,1,2,L["LABEL_AURAS_ORIENTATION"].." 1",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'left','Secondary',nil,true),
								SecondaryOrientation2 = Auras:Select_VerifyDefaults(layout.orientation,2,2,L["LABEL_AURAS_ORIENTATION"].." 2",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'right','Secondary',nil,true),
								filler_1 = Auras:Spacer(3),
								AuraSizeCol1 = Auras:Slider_VerifyDefaults(layout.secondary.left,4,2,L["LABEL_AURAS_SIZE"].." 1",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Secondary',nil,true),
								AuraSpacingCol1 = Auras:Slider_VerifyDefaults(layout.secondary.left,5,2,L["LABEL_AURAS_SPACING"].." 1",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Secondary',nil,true),
								filler_2 = Auras:Spacer(6),
								AuraSizeCol2 = Auras:Slider_VerifyDefaults(layout.secondary.right,7,2,L["LABEL_AURAS_SIZE"].." 2",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Secondary',nil,true),
								AuraSpacingCol2 = Auras:Slider_VerifyDefaults(layout.secondary.right,8,2,L["LABEL_AURAS_SPACING"].." 2",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Secondary',nil,true),
								filler_3 = Auras:Spacer(9),
								ResetSecondaryLayout = {
									order = 10,
									type = "execute",
									--name = "|cFFFFCC00"..L["BUTTON_RESET_LAYOUT_SECONDARY"].."|r",
									--disabled = false,
									name = L["BUTTON_RESET_LAYOUT_SECONDARY"],
									func = function()
										layout.orientation.left = layoutDefaults.orientation.left
										layout.orientation.right = layoutDefaults.orientation.right
										layout.secondary.left.icon = layoutDefaults.secondary.left.icon
										layout.secondary.left.spacing = layoutDefaults.secondary.left.spacing
										layout.secondary.right.icon = layoutDefaults.secondary.right.icon
										layout.secondary.right.spacing = layoutDefaults.secondary.right.spacing
										enh_options.args.layout.args.secondaryAuras.args.ResetSecondaryLayout.disabled = true
										enh_options.args.layout.args.secondaryAuras.args.ResetSecondaryLayout.name = "|cFF666666"..L["BUTTON_RESET_LAYOUT_SECONDARY"].."|r"
										Auras:UpdateTalents()
									end,
								},
							},
						},
					},
				},]]
			}
		}
	end
		
	return enh_options
end



local res_options

local function GetRestorationOptions()
	if not res_options then
		local SSA = SSA
		local db = Auras.db.char
		
		-- Database Shortcuts
		local settings = db.settings[3]
		local settingDefaults = db.settings.defaults
		
		-- Element Tables
		--local elements = db.elements[3]
		local cooldowns = db.auras[3].cooldowns
		local timerbars = db.timerbars[3]
		local statusbars = db.statusbars[3]
		--local frames = db.elements[3].frames
		local auras = db.auras[3]
		
		-- Layout Table
		--local layout = db.layout[3]
		--local layoutDefaults = db.layout.defaults
		
		-- Element Defaults Tables
		--[[local timerbarDefaults = db.elements.defaults[3].timerbars
		local cooldownDefaults = db.elements.defaults[3].cooldowns
		local statusbarDefaults = db.elements.defaults[3].statusbars
		local frameDefaults = db.elements.defaults[3].frames]]
		
		local COOLDOWN_OPTIONS = {}
	
		for i=1,#auras.groups do
			tinsert(COOLDOWN_OPTIONS,"Group #"..i.." Cooldowns")
		end
		
		res_options = {
			type = "group",
			childGroups = "tab",
			order = 1,
			name = L["LABEL_AURAS_RESTORATION"],
			desc = '',
			args = {
				--[[display = {
					name = DISPLAY,
					order = 1,
					type = "group",
					args = {
						show = Auras:Toggle_Basic(elements,3,L["LABEL_SHOW_RESTORATION_AURAS"],L["TOOLTIP_TOGGLE_RESTORATION_AURAS"],'isEnabled',true),
						MajorAuras = {
							name = L["LABEL_AURAS_PRIMARY"],
							type = "group",
							order = 2,
							guiInline = true,
							args = {
								Ascendance = Auras:Toggle_Basic(auras.toggle,1,Auras:GetSpellName(114050),nil,'Ascendance',true),
								CloudburstTotem = Auras:Toggle_Basic(auras.toggle,2,Auras:GetSpellName(157153),nil,'CloudburstTotem',true),
								Downpour = Auras:Toggle_Basic(auras.toggle,3,Auras:GetSpellName(207778),nil,'Downpour',true),
								HealingRain = Auras:Toggle_Basic(auras.toggle,4,Auras:GetSpellName(73920),nil,'HealingRain',true),
								HealingStreamTotem = Auras:Toggle_Basic(auras.toggle,5,Auras:GetSpellName(5394),nil,'HealingStreamTotem',true),
								HealingTideTotem = Auras:Toggle_Basic(auras.toggle,6,Auras:GetSpellName(108280),nil,'HealingTideTotem',true),
								Riptide = Auras:Toggle_Basic(auras.toggle,7,Auras:GetSpellName(61295),nil,'Riptide',true),
								SpiritLinkTotem = Auras:Toggle_Basic(auras.toggle,8,Auras:GetSpellName(98008),nil,'SpiritLinkTotem',true),
								UnleashLife = Auras:Toggle_Basic(auras.toggle,9,Auras:GetSpellName(73685),nil,'UnleashLife',true),
								Wellspring = Auras:Toggle_Basic(auras.toggle,10,Auras:GetSpellName(197995),nil,'Wellspring',true),
								WindRushTotem = Auras:Toggle_Basic(auras.toggle,11,Auras:GetSpellName(192077),nil,'WindRushTotem',true),
							},
						},
						BuffAuras = {
							name = L["LABEL_AURAS_BUFF"],
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								EarthShield = Auras:Toggle_Basic(auras.toggle,1,Auras:GetSpellName(974),nil,'EarthShield',true),
								FlashFlood = Auras:Toggle_Basic(auras.toggle,2,Auras:GetSpellName(280614),nil,'FlashFlood',true),
								NaturesGuardian = Auras:Toggle_Basic(auras.toggle,3,Auras:GetSpellName(30884),nil,'NaturesGuardian',true),
							},
						},
						PvPAuras = {
							name = L["LABEL_AURAS_PVP"],
							type = "group",
							order = 4,
							guiInline = true,
							args = {
								Adaptation = Auras:Toggle_Basic(auras.toggle,1,Auras:GetSpellName(214027),nil,'Adaptation',true),
								CounterstrikeTotem = Auras:Toggle_Basic(auras.toggle,2,Auras:GetSpellName(204331),nil,'CounterstrikeTotem',true),
								GladiatorsMedallion = Auras:Toggle_Basic(auras.toggle,3,Auras:GetSpellName(208683),nil,'GladiatorsMedallion',true),
								GroundingTotem = Auras:Toggle_Basic(auras.toggle,4,Auras:GetSpellName(204336),nil,'GroundingTotem',true),
								SkyfuryTotem = Auras:Toggle_Basic(auras.toggle,5,Auras:GetSpellName(204330),nil,'SkyfuryTotem',true),
								Tidebringer = Auras:Toggle_Basic(auras.toggle,6,Auras:GetSpellName(236501),nil,'Tidebringer',true),
							},
						},
						MinorAuras = {
							name = L["LABEL_AURAS_SECONDARY"],
							type = "group",
							order = 5,
							guiInline = true,
							args = {
								AstralShift = Auras:Toggle_Basic(auras.toggle,1,Auras:GetSpellName(108271),nil,'AstralShift',true),
								CapacitorTotem = Auras:Toggle_Basic(auras.toggle,2,Auras:GetSpellName(192058),nil,'CapacitorTotem',true),
								EarthenWall = Auras:Toggle_Basic(auras.toggle,3,Auras:GetSpellName(198838),nil,'EarthenWallTotem',true),
								EarthbindTotem = Auras:Toggle_Basic(auras.toggle,4,Auras:GetSpellName(2484),nil,'EarthbindTotem',true),
								EarthgrabTotem = Auras:Toggle_Basic(auras.toggle,5,Auras:GetSpellName(51485),nil,'EarthgrabTotem',true),
								FlameShock = Auras:Toggle_Basic(auras.toggle,6,Auras:GetSpellName(188838),nil,'FlameShock',true),
								Hex = Auras:Toggle_Basic(auras.toggle,7,Auras:GetSpellName(51514),nil,'Hex',true),
								LavaBurst = Auras:Toggle_Basic(auras.toggle,8,Auras:GetSpellName(51505),nil,'LavaBurst',true),
								PurifySpirit = Auras:Toggle_Basic(auras.toggle,9,Auras:GetSpellName(77130),nil,'PurifySpirit',true),
								SpiritwalkersGrace = Auras:Toggle_Basic(auras.toggle,10,Auras:GetSpellName(79206),nil,'SpiritwalkersGrace',true),
								WindRushTotem = Auras:Toggle_Basic(auras.toggle,11,Auras:GetSpellName(192077),nil,'WindRushTotem',true),
								WindShear = Auras:Toggle_Basic(auras.toggle,12,Auras:GetSpellName(57994),nil,'WindShear',true),
							},
						},
						ProgressBars = {
							name = L["LABEL_PROGRESS_BARS"],
							type = "group",
							order = 6,
							guiInline = true,
							args = {
								BuffTimerBars = {
									name = L["LABEL_STATUSBAR_BUFF_TIMER"],
									type = "group",
									order = 4,
									guiInline = true,
									args = {
										AscendanceBar = Auras:Toggle_Basic(timerbars.buff,1,Auras:GetSpellName(114052),nil,'ascendance'),
										AstralShiftBar = Auras:Toggle_Basic(timerbars.buff,2,Auras:GetSpellName(114052),nil,'astralShift'),
										Bloodlust = Auras:Toggle_Basic(timerbars.buff,3,Auras:GetSpellName(2825),nil,'bloodlust'),
										Heroism = Auras:Toggle_Basic(timerbars.buff,4,Auras:GetSpellName(32182),nil,'heroism'),
										SpiritwalkersGraceBar = Auras:Toggle_Basic(timerbars.buff,5,Auras:GetSpellName(79206),nil,'spiritwalkersGrace'),
										TimeWarp = Auras:Toggle_Basic(timerbars.buff,6,Auras:GetSpellName(80353),nil,'timeWarp'),
										UnleashLifeBar = Auras:Toggle_Basic(timerbars.buff,7,Auras:GetSpellName(73685),nil,'unleashLife'),								
									},
								},
								TotemTimerBars = {
									name = L["LABEL_TIMERS_TOTEM"],
									type = "group",
									order = 5,
									guiInline = true,
									args = {
										AncestralProtectionTotemBar = Auras:Toggle_Basic(timerbars.main,1,Auras:GetSpellName(207399),nil,'ancestralProtectionTotem'),
										CloudburstTotemBar = Auras:Toggle_Basic(timerbars.main,2,Auras:GetSpellName(157153),nil,'cloudburstTotem'),
										EarthbindTotemBar = Auras:Toggle_Basic(timerbars.util,3,Auras:GetSpellName(2484),nil,'earthbindTotem'),
										EarthgrabTotemBar = Auras:Toggle_Basic(timerbars.util,4,Auras:GetSpellName(51485),nil,'earthgrabTotem'),
										HealingStreamTotemBar = Auras:Toggle_Basic(timerbars.main,5,Auras:GetSpellName(5394),nil,'healingStreamTotemOne'),
										HealingTideTotemBar = Auras:Toggle_Basic(timerbars.main,6,Auras:GetSpellName(108280),nil,'healingTideTotem'),
										SpiritLinkTotemBar = Auras:Toggle_Basic(timerbars.main,7,Auras:GetSpellName(98008),nil,'spiritLinkTotem'),
										WindRushTotemBar = Auras:Toggle_Basic(timerbars.util,8,Auras:GetSpellName(192077),nil,'windRushTotem'),
									},
								},
							},
						},
						TextureAlerts = {
							name = L["TOOLTIP_TEXTURE_ALERTS"],
							type = "group",
							order = 7,
							guiInline = true,
							args = {
								TotemMastery = Auras:Toggle_Basic(frames,1,Auras:GetSpellName(200071),nil,'Undulation'),
							},
						},
					},
				},]]
				general = {
					name = MAIN_MENU,
					order = 2,
					type = "group",
					childGroups = "tab",
					disabled = true,
					args = {
						settings = {
							name = L["LABEL_AURAS_SETTINGS"],
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								OoCAlpha = Auras:Slider_VerifyDefaults(settings,1,3,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_AURAS_ALPHA_NO_COMBAT"],0,1,nil,nil,'OoCAlpha','Settings'),
								FlameShock = Auras:Slider_VerifyDefaults(settings,2,3,Auras:GetSpellName(188838),L["TOOLTIP_GLOW_TIME_TRIGGER"],5,15,nil,nil,'flameShock','Settings'),
								OoRColor = Auras:Color_VerifyDefaults(settings,3,3,L["LABEL_COLOR_NO_RANGE"],L["TOOLTIP_COLOR_OUT_OF_RANGE"],true,"full",nil,'OoRColor','Settings'),
								reset = {
									order = 4,
									type = "execute",
									--name = "|cFFFFCC00"..L["BUTTON_RESET_SETTINGS"].."|r",
									--disabled = false,
									name = L["BUTTON_RESET_SETTINGS"],
									func = function()
										settings.OoCAlpha = Auras.db.char.triggers.default.OoCAlpha
										settings.flameShock = Auras.db.char.triggers.default[3].flameShock
										settings.OoRColor.r = Auras.db.char.triggers.default.OoRColor.r
										settings.OoRColor.g = Auras.db.char.triggers.default.OoRColor.g
										settings.OoRColor.b = Auras.db.char.triggers.default.OoRColor.b
										settings.OoRColor.a = Auras.db.char.triggers.default.OoRColor.a
										
										res_options.args.bars.args.triggers.args.reset.disabled = true
										res_options.args.bars.args.triggers.args.reset.name = "|cFF666666"..L["BUTTON_RESET_SETTINGS"].."|r"
									end,
								},
							},
						},
					},
				},
				auraGroups = {
					name = "Aura Builder",
					type = "group",
					childGroups = "tab",
					order = 3,
					args = {
					},
				},
				timerbarGroups = {
					name = "Timer Bar Builder",
					type = "group",
					childGroups = "tab",
					order = 4,
					args = {
					},
				},
				bars = {
					name = L["LABEL_PROGRESS_BARS"],
					order = 3,
					type = "group",
					childGroups = "tab",
					disabled = true,
					args = {
						general = {
							name = GENERAL,
							order = 1,
							inline = false,
							type = "group",
							args = {
								statusbars = {
									name = L["LABEL_STATUSBAR_MANAGER"],
									type = "group",
									order = 1,
									guiInline = true,
									args = {
										defaultBarToggle = Auras:Toggle_Basic(statusbars,1,L["LABEL_STATUSBAR_BLIZZARD"],L["TOOLTIP_TOGGLE_BLIZZARD_BAR"],nil,'defaultBar'),
										castBarToggle = Auras:Toggle_Statusbar(statusbars.bars.CastBar,2,L["TOGGLE_CAST_BAR"],L["TOOLTIP_TOGGLE_CAST_BAR"],'isEnabled','CastBar'),
										channelToggle = Auras:Toggle_Statusbar(statusbars.bars.ChannelBar,3,L["TOGGLE_CHANNEL_BAR"],L["TOOLTIP_TOGGLE_CHANNEL_BAR"],'isEnabled','ChannelBar'),
										manaToggle = Auras:Toggle_Statusbar(statusbars.bars.ManaBar,4,L["TOGGLE_MANA_BAR"],L["TOOLTIP_TOGGLE_MANA_BAR"],'isEnabled','ManaBar'),
										earthenWallToggle = Auras:Toggle_Statusbar(statusbars.bars.EarthenWallTotemBar,5,L["TOGGLE_EARTHEN_WALL_BAR"],L["TOOLTIP_TOGGLE_EARTHEN_WALL_BAR"],'isEnabled','EarthenWallTotemBar'),
										tidalWavesToggle = Auras:Toggle_Statusbar(statusbars.bars.TidalWavesBar,6,L["TOGGLE_TIDAL_WAVES_BAR"],L["TOOLTIP_TOGGLE_TIDAL_WAVES_BAR"],'isEnabled','TidalWavesBar'),
									},
								},
							},
						},
						ManaBar = {
							name = L["LABEL_STATUSBAR_MANA"],
							order = 2,
							type = "group",
							inline = false,
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.ManaBar.adjust,1,3,L["LABEL_STATUSBAR_MODIFY_MANA"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,nil,'isEnabled','Mana'),
								textToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ManaBar.text,2,3,L["LABEL_TEXT_MANA"],L["TOOLTIP_TOGGLE_MANA_TEXT"],nil,nil,'isDisplayText','Mana'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 3,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar,1,3,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,nil,'alphaCombat','Mana'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar,2,3,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,nil,'alphaOoC','Mana'),
										alphaTarget = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar,3,3,L["LABEL_ALPHA_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_TARGET_NO_COMBAT"],0,1,nil,nil,'alphaTar','Mana'),
										ManaBarDigitGrouping = {
											order = 4,
											name = L["LABEL_DIGIT_GROUPING"],
											desc = L["TOOLTIP_DIGIT_GROUPING"],
											type = "toggle",
											get = function()
												return statusbars.bars.ManaBar.grouping
											end,
											set = function(self,value)
												statusbars.bars.ManaBar.grouping = value
												Auras:VerifyDefaultValues(3,res_options,'Mana')
												if (value) then
													res_options.args.bars.args.ManaBar.args.general.args.ManaBarPrecision.values = {
														--[[[tostring(ManaPrecision("Full"))] = "Full",
														[tostring(ManaPrecision("Thousand"))] = "Thousand",
														[tostring(ManaPrecision("Million"))] = "Million",]]
														["Long"] = tostring(Auras:ManaPrecision("Long")),
														["Short"] = tostring(Auras:ManaPrecision("Short")),
													}
												else
													res_options.args.bars.args.ManaBar.args.general.args.ManaBarPrecision.values = {
														--[[[tostring(ManaPrecision("Full"))] = "Full",
														[tostring(ManaPrecision("Thousand"))] = "Thousand",
														[tostring(ManaPrecision("Million"))] = "Million",]]
														["Long"] = tostring(Auras:ManaPrecision("Long")),
														["Short"] = tostring(Auras:ManaPrecision("Short")),
													}
												end
												
													
											end,
										},
										ManaBarPrecision = {
											order = 5,
											type = "select",
											name = L["LABEL_PRECISION_MANA"],
											desc = L["TOOLTIP_AURAS_ORIENTATION"],
											get = function()
												res_options.args.bars.args.ManaBar.args.general.args.ManaBarPrecision.values = {
													["Long"] = tostring(Auras:ManaPrecision("Long")),
													["Short"] = tostring(Auras:ManaPrecision("Short")),
												}
												
												return statusbars.bars.ManaBar.precision
											end,
											set = function(self,value)
												statusbars.bars.ManaBar.precision = value
												Auras:VerifyDefaultValues(3,res_options,"Mana")
												Auras:UpdateTalents()
											end,
											values = {
												["Long"] = tostring(Auras:ManaPrecision("Long")),
												["Short"] = tostring(Auras:ManaPrecision("Short")),
											}
										},
									},
								},
								text = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_MANA"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.ManaBar.text.font,1,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",nil,'color','Mana'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.text.font,2,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Mana'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text.font,3,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,nil,'size','Mana'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.text.font,4,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Mana'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.text,5,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Mana'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text,6,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,nil,'x','Mana'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text,7,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,nil,'y','Mana'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ManaBar.text.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,'isEnabled','Mana'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ManaBar.text.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Mana'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,nil,'x','Mana'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,nil,'y','Mana'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 5,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.foreground,1,3,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Mana'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.ManaBar.foreground,2,3,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Mana'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.background,3,3,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Mana'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.ManaBar.background,4,3,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Mana'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ManaBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,'showBG','Mana'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.layout,6,3,L["LABEL_WIDTH"],nil,100,500,nil,nil,'width','Mana'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.layout,7,3,L["LABEL_HEIGHT"],nil,10,100,nil,nil,'height','Mana'),
									},
								},
								reset = {
									order = 6,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_MAELSTROM"],
									func = function()
										local bar = statusbars.bars.ManaBar
										local default = statusbars.defaults.ManaBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										bar.alphaTar = default.alphaTar
										
										bar.grouping = default.grouping
										bar.precision = default.precision
										
										Auras:ResetText(bar,'text',default)
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)
										
										res_options.args.bars.args.ManaBar.args.reset.disabled = true
										res_options.args.bars.args.ManaBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_MANA"].."|r"
										Auras:VerifyDefaultValues(3,res_options,"Mana")
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('ManaBar',nil,'text',nil,3)
										end
									end,
								},
							},
						},
						CastBar = {
							name = L["LABEL_STATUSBAR_CAST"],
							order = 3,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,1,3,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,nil,'isEnabled','Cast','castBar'),
								nametextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext,2,3,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],nil,nil,'isDisplayText','Cast','castBar'),
								timetextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext,3,3,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],nil,nil,'isDisplayText','Cast','castBar'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,1,3,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,nil,'alphaCombat','Cast','castBar'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,2,3,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,nil,'alphaOoC','Cast','castBar'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar,1,3,L["TOGGLE_SPARK"],nil,nil,nil,'spark','Cast','castBar'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.icon,2,3,L["TOGGLE_ICON"],nil,nil,nil,'isEnabled','Cast','castBar'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.icon,3,3,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,nil,'justify','Cast','castBar'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 6,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font,1,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",nil,'color','Cast','castBar'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,2,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Cast','castBar'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font,3,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,nil,'size','Cast','castBar'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,4,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Cast','castBar'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext,5,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Cast','castBar'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,6,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,nil,'x','Cast','castBar'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,7,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,nil,'y','Cast','castBar'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,'isEnabled','Cast','castBar'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Cast','castBar'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,nil,'x','Cast','castBar'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,nil,'y','Cast','castBar'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 7,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font,1,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",nil,'color','Cast','castBar'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,2,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Cast','castBar'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font,3,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,nil,'size','Cast','castBar'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,4,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Cast','castBar'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext,5,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Cast','castBar'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,6,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,nil,'x','Cast','castBar'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,7,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,nil,'y','Cast','castBar'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,'isEnabled','Cast','castBar'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Cast','castBar'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,nil,'x','Cast','castBar'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,nil,'y','Cast','castBar'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 8,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.foreground,1,3,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Cast','castBar'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.foreground,2,3,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Cast','castBar'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.background,3,3,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Cast','castBar'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.background,4,3,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Cast','castBar'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,'showBG','Cast','castBar'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,6,3,L["LABEL_WIDTH"],nil,100,500,nil,nil,'width','Cast','castBar'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,7,3,L["LABEL_HEIGHT"],nil,10,100,nil,nil,'height','Cast','castBar'),
									},
								},
								reset = {
									order = 9,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CAST"],
									func = function()
										local bar = statusbars.bars.CastBar
										local default = Auras.db.char.statusbars.defaults.CastBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										
										Auras:ResetText(bar,'nametext',default)
										Auras:ResetText(bar,'timetext',default)
										
										bar.icon.isEnabled = true
										bar.icon.justify = default.icon.justify
										bar.spark = true
										
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)

										res_options.args.bars.args.CastBar.args.reset.disabled = true
										res_options.args.bars.args.CastBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_CAST"].."|r"
										Auras:VerifyDefaultValues(3,res_options,'Cast')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('CastBar',nil,'nametext','timetext',3)
										end
									end,
								},
							},
						},
						ChannelBar = {
							name = L["LABEL_STATUSBAR_CHANNEL"],
							order = 4,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,1,3,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,nil,'isEnabled','Channel','channelBar'),
								nametextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext,2,3,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],nil,nil,'isDisplayText','Channel','channelBar'),
								timetextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext,3,3,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],nil,nil,'isDisplayText','Channel','channelBar'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,1,3,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,nil,'alphaCombat','Channel','channelBar'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,2,3,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,nil,'alphaOoC','Channel','channelBar'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar,1,3,L["TOGGLE_SPARK"],nil,nil,nil,'spark','Channel','channelBar'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.icon,2,3,L["TOGGLE_ICON"],nil,nil,nil,'isEnabled','Channel','channelBar'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.icon,3,3,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,nil,'justify','Channel','channelBar'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 6,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,1,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",nil,'color','Channel','channelBar'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,2,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Channel','channelBar'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,3,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,nil,'size','Channel','channelBar'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,4,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Channel','channelBar'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext,5,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Channel','channelBar'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,6,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,nil,'x','Channel','channelBar'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,7,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,nil,'y','Channel','channelBar'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,'isEnabled','Channel','channelBar'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Channel','channelBar'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,nil,'x','Channel','channelBar'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,nil,'y','Channel','channelBar'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 7,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,1,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",nil,'color','Channel','channelBar'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,2,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Channel','channelBar'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,3,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,nil,'size','Channel','channelBar'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,4,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Channel','channelBar'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext,5,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Channel','channelBar'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,6,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,nil,'x','Channel','channelBar'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,7,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,nil,'y','Channel','channelBar'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,'isEnabled','Channel','channelBar'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Channel','channelBar'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,nil,'x','Channel','channelBar'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,nil,'y','Channel','channelBar'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 8,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.foreground,1,3,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Channel','channelBar'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.foreground,2,3,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Channel','channelBar'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.background,3,3,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Channel','channelBar'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.background,4,3,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Channel','channelBar'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,'showBG','Channel','channelBar'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,6,3,L["LABEL_WIDTH"],nil,100,500,nil,nil,'width','Channel','channelBar'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,7,3,L["LABEL_HEIGHT"],nil,10,100,nil,nil,'height','Channel','channelBar'),
									},
								},
								reset = {
									order = 9,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CHANNEL"],
									func = function()
										local bar = statusbars.bars.ChannelBar
										local default = Auras.db.char.statusbars.defaults.ChannelBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										
										Auras:ResetText(bar,'nametext',default)
										Auras:ResetText(bar,'timetext',default)
										
										bar.icon.isEnabled = true
										bar.icon.justify = default.icon.justify
										bar.spark = true
										
										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)
										
										res_options.args.bars.args.ChannelBar.args.reset.disabled = true
										res_options.args.bars.args.ChannelBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_CHANNEL"].."|r"
										Auras:VerifyDefaultValues(3,res_options,'Channel')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('ChannelBar',nil,'nametext','timetext',3)
										end
									end,
								},
							},
						},
						EarthenWallTotemBar = {
							name = L["LABEL_STATUSBAR_EARTHEN_WALL"],
							type = "group",
							order = 5,
							inline = false,
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.adjust,1,3,L["LABEL_STATUSBAR_MODIFY_EARTHEN_WALL"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,nil,'isEnabled','Earthen Wall'),
								healthtextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext,2,3,L["TOGGLE_HEALTH_TEXT"],L["TOOLTIP_TOGGLE_HEALTH_TEXT"],nil,nil,'isDisplayText','Earthen Wall'),
								timetextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext,2,3,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],nil,nil,'isDisplayText','Earthen Wall'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 4,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar,1,3,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,nil,nil,'alphaCombat','Earthen Wall'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar,2,3,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,nil,nil,'alphaOoC','Earthen Wall'),
										alphaTarget = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar,3,3,L["LABEL_ALPHA_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_TARGET_NO_COMBAT"],0,1,nil,nil,'alphaTar','Earthen Wall'),
									},
								},
								healthtext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_HEALTH"]..'|r',
									type = "group",
									order = 5,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font,1,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",nil,'color','Earthen Wall'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font,2,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Earthen Wall'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font,3,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,nil,'size','Earthen Wall'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font,4,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Earthen Wall'),
										textAnchor = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext,5,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Earthen Wall'),
										textX = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext,6,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,nil,'x','Earthen Wall'),
										textY = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext,7,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,nil,'y','Earthen Wall'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,'isEnabled','Earthen Wall'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Earthen Wall'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,nil,'x','Earthen Wall'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,nil,'y','Earthen Wall'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 6,
									disabled = true,
									guiInline = true,
									args = {
										color = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font,1,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",nil,'color','Earthen Wall'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font,2,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Earthen Wall'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font,3,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,nil,nil,'size','Earthen Wall'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font,4,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Earthen Wall'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext,5,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Earthen Wall'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext,6,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,nil,'x','Earthen Wall'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext,7,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,nil,'y','Earthen Wall'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,'isEnabled','Earthen Wall'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Earthen Wall'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,nil,nil,'x','Earthen Wall'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,nil,nil,'y','Earthen Wall'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 7,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.foreground,1,3,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Earthen Wall'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.foreground,2,3,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Earthen Wall'),
										timerTexture = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timerBar,3,3,L["LABEL_TIME_BAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Earthen Wall'),
										timerColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timerBar,4,3,L["LABEL_STATUSBAR_COLOR"],nil,true,nil,nil,'color','Earthen Wall'),
										timerToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_TIMER"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,nil,'showTimer','Earthen Wall'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.background,6,3,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Earthen Wall'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.background,7,3,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Earthen Wall'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.adjust,8,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,'showBG','Earthen Wall'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.layout,9,3,L["LABEL_WIDTH"],nil,100,500,nil,nil,'width','Earthen Wall'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.layout,10,3,L["LABEL_HEIGHT"],nil,10,100,nil,nil,'height','Earthen Wall'),
									},
								},
								reset = {
									order = 8,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_EARTHEN_WALL"],
									func = function()
										local bar = statusbars.bars.EarthenWallTotemBar
										local default = statusbars.defaults.EarthenWallTotemBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										bar.alphaTar = default.alphaTar
										
										Auras:ResetText(bar,'healthtext',default)
										Auras:ResetText(bar,'timetext',default)
										
										Auras:ResetBackground(bar,default)
										Auras:ResetTimerBar(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)
										
										res_options.args.bars.args.EarthenWallTotemBar.args.reset.disabled = true
										res_options.args.bars.args.EarthenWallTotemBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_EARTHEN_WALL"].."|r"
										Auras:VerifyDefaultValues(3,res_options,'Earthen Wall')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('EarthenWallTotemBar','Timer','healthtext','timetext',3)
										end
									end,
								},
							},
						},
						TidalWavesBar = {
							name = L["LABEL_TIDAL_WAVES_BAR"],
							type = "group",
							order = 6,
							inline = false,
							args = {
								adjust = {
									order = 1,
									name = L["LABEL_STATUSBAR_MODIFY_TIDAL_WAVES"],
									desc = L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],
									type = "toggle",
									get = function()
										return statusbars.bars.TidalWavesBar.adjust.isEnabled
									end,
									set = function(self,value)
										statusbars.bars.TidalWavesBar.adjust.isEnabled = value
										Auras:VerifyDefaultValues(3,res_options,'Tidal Waves')
									end,
								},
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 2,
									type = "group",
									guiInline = true,
									args = {
										animate = Auras:Toggle_VerifyDefaults(statusbars.bars.TidalWavesBar,1,3,L["LABEL_STATUSBAR_TIDAL_WAVES_ANIMATE"],nil,nil,nil,'animate','Tidal Waves'),
										emptyColor = Auras:Color_VerifyDefaults(statusbars.bars.TidalWavesBar,2,3,L["LABEL_STATUSBAR_TIDAL_WAVES_EMPTY"],L["TOOLTIP_STATUSBAR_TIDAL_WAVES_EMPTY"],false,"double",nil,'emptyColor',"Tidal Waves"),
										combatDisplay = Auras:Select_VerifyDefaults(statusbars.bars.TidalWavesBar,3,3,L["LABEL_TIDAL_WAVES_DISPLAY_COMBAT"],L["TOOLTIP_TIDAL_WAVES_DISPLAY_METHOD_COMBAT"],nil,TIDAL_WAVES_OPTIONS,nil,nil,'combatDisplay','Tidal Waves'),
										OoCDisplay = Auras:Select_VerifyDefaults(statusbars.bars.TidalWavesBar,4,3,L["LABEL_TIDAL_WAVES_DISPLAY_NO_COMBAT"],L["TOOLTIP_TIDAL_WAVES_DISPLAY_METHOD_NO_COMBAT"],nil,TIDAL_WAVES_OPTIONS,nil,nil,'OoCDisplay','Tidal Waves'),
										OoCTime = Auras:Slider_VerifyDefaults(statusbars.bars.TidalWavesBar,5,3,L["LABEL_TIDAL_WAVES_DURATION_NO_COMBAT"],L["TOOLTIP_TIDAL_WAVES_TIMER_NO_TARGET_NO_COMBAT"],1,15,nil,nil,'OoCTime',"Tidal Waves"),
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 3,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.TidalWavesBar.foreground,1,3,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Tidal Waves'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.TidalWavesBar.foreground,2,3,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Tidal Waves'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.TidalWavesBar.background,3,3,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Tidal Waves'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.TidalWavesBar.background,4,3,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Tidal Waves'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.TidalWavesBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,'showBG','Tidal Waves'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.TidalWavesBar.layout,6,3,L["LABEL_WIDTH"],nil,100,500,nil,nil,'width','Tidal Waves'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.TidalWavesBar.layout,7,3,L["LABEL_HEIGHT"],nil,10,100,nil,nil,'height','Tidal Waves'),
									},
								},
								reset = {
									order = 4,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_TIDAL_WAVES"],
									func = function()
										local bar = statusbars.bars.TidalWavesBar
										local default = statusbars.defaults.TidalWavesBar
										
										bar.combatDisplay = default.combatDisplay
										bar.OoCDisplay = default.OoCDisplay
										bar.animate = default.animate
										bar.OoCTime = default.OoCTime
										
										Auras:ResetBackground(bar,default)
										Auras:ResetColor(bar,'emptyColor',default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(db,default)
										
										res_options.args.bars.args.TidalWavesBar.args.reset.disabled = true
										res_options.args.bars.args.TidalWavesBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_TIDAL_WAVES"].."|r"
									end,
								},
							},
						},
					},
				},
				cooldowns = {
					name = L["LABEL_COOLDOWN"],
					order = 5,
					type = "group",
					childGroups = "tab",
					disabled = true,
					args = {
						--[[toggle = Auras:Toggle_VerifyDefaults(cooldowns,1,3,ENABLE,L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],"full",'isEnabled','Cooldowns'),
						text = Auras:Toggle_Basic(cooldowns,2,L["LABEL_COOLDOWN_TEXT"],L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],'text'),
						sweep = Auras:Toggle_Cooldowns(cooldowns,3,1,L["LABEL_COOLDOWN_SWEEP"],L["TOOLTIP_TOGGLE_COOLDOWN_SWEEP"],'sweep','AuraGroup1','Cooldowns'),
						GCD = Auras:Toggle_Basic(cooldowns.GCD,4,L["LABEL_COOLDOWN_GCD"],L["TOOLTIP_TOGGLE_COOLDOWN_GCD"],'isEnabled'),
						inverse = Auras:Toggle_Cooldowns(cooldowns,5,1,L["LABEL_COOLDOWN_REVERSE_SWEEP"],L["TOOLTIP_COOLDOWN_REVERSE_SWEEP"],'inverse','AuraGroup1'),
						bling = Auras:Toggle_Cooldowns(cooldowns,6,1,L["LABEL_COOLDOWN_BLING"],L["TOOLTIP_TOGGLE_COOLDOWN_BLING"],'blind','AuraGroup1'),
						group = Auras:Select_VerifyDefaults(cooldowns,7,3,L["LABEL_COOLDOWN_GROUP"],L["TOOLTIP_AURAS_GROUP_SELECT"],nil,COOLDOWN_OPTIONS,'selected','Cooldowns'),
						adjustToggle = Auras:Toggle_VerifyDefaults(cooldowns,8,3,L["LABEL_COOLDOWN_ADJUST"],nil,nil,'adjust','Cooldowns'),]]
						toggle = Auras:Toggle_VerifyDefaults(cooldowns,1,3,ENABLE,L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],"full",false,'isEnabled','Cooldowns'),
						text = Auras:Toggle_Basic(cooldowns,2,L["LABEL_COOLDOWN_TEXT"],L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],not cooldowns.isEnabled,'text'),
						sweep = Auras:Toggle_Cooldowns(cooldowns,3,3,L["LABEL_COOLDOWN_SWEEP"],L["TOOLTIP_TOGGLE_COOLDOWN_SWEEP"],not cooldowns.isEnabled,'sweep','AuraBase','Cooldowns'),
						GCD = Auras:Toggle_Basic(cooldowns.GCD,4,L["LABEL_COOLDOWN_GCD"],L["TOOLTIP_TOGGLE_COOLDOWN_GCD"],not cooldowns.sweep and not cooldowns.isEnabled,'isEnabled'),
						inverse = Auras:Toggle_Cooldowns(cooldowns,5,3,L["LABEL_COOLDOWN_REVERSE_SWEEP"],L["TOOLTIP_COOLDOWN_REVERSE_SWEEP"],not cooldowns.sweep and not cooldowns.isEnabled,'inverse','AuraBase'),
						bling = Auras:Toggle_Cooldowns(cooldowns,6,3,L["LABEL_COOLDOWN_BLING"],L["TOOLTIP_TOGGLE_COOLDOWN_BLING"],not cooldowns.sweep and not cooldowns.isEnabled,'blind','AuraBase'),
						group = Auras:Select_VerifyDefaults(cooldowns,7,3,L["LABEL_COOLDOWN_GROUP"],L["TOOLTIP_AURAS_GROUP_SELECT"],nil,COOLDOWN_OPTIONS,nil,not cooldowns.isEnabled,'selected','Cooldowns',nil,false,true),
						adjustToggle = Auras:Toggle_VerifyDefaults(cooldowns,8,3,L["LABEL_COOLDOWN_ADJUST"],nil,nil,not cooldowns.isEnabled,'adjust','Cooldowns'),
						cdGroups = {
							name = "Cooldown Groups",
							order = 9,
							desc = "TESTING",
							type = "group",
							guiInline = true,
							args = {
							},
						},
					},
				},
				--[[layout = {
					name = L["LABEL_LAYOUT"],
					order = 6,
					type = "group",
					disabled = true,
					args = {
						MoveAuras = Auras:Execute_MoveAuras(elements,1,3,"|cFFFFCC00"..L["BUTTON_MOVE_AURAS_RESTORATION"].."|r"),
						ResetAuras = Auras:Execute_ResetAuras(2,'AuraGroup3',"|cFFFFCC00"..L["BUTTON_RESET_AURAS_RESTORATION"].."|r"),
						primaryAuras = {
							name = L["LABEL_AURAS_PRIMARY"],
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								PrimaryOrientation1 = Auras:Select_VerifyDefaults(layout.orientation,1,3,L["LABEL_AURAS_ORIENTATION"].." 1",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'top','Primary',nil,true),
								PrimaryOrientation2 = Auras:Select_VerifyDefaults(layout.orientation,2,3,L["LABEL_AURAS_ORIENTATION"].." 2",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'bottom','Primary',nil,true),
								filler_1 = Auras:Spacer(3),
								AuraSizeRow1 = Auras:Slider_VerifyDefaults(layout.primary.top,4,3,L["LABEL_AURAS_SIZE"].." 1",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Primary',nil,true),
								AuraSpacingRow1 = Auras:Slider_VerifyDefaults(layout.primary.top,5,3,L["LABEL_AURAS_SPACING"].." 1",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Primary',nil,true),
								AuraChargesRow1 = Auras:Slider_VerifyDefaults(layout.primary.top,6,3,L["LABEL_AURAS_CHARGES"].." 1",L["TOOLTIP_AURAS_CHARGE_SIZE"],10,60,nil,'charges','Primary',nil,true),
								AuraSizeRow2 = Auras:Slider_VerifyDefaults(layout.primary.bottom,7,3,L["LABEL_AURAS_SIZE"].." 2",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Primary',nil,true),
								AuraSpacingRow2 = Auras:Slider_VerifyDefaults(layout.primary.bottom,8,3,L["LABEL_AURAS_SPACING"].." 2",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Primary',nil,true),
								filler_3 = Auras:Spacer(9),
								ResetPrimaryLayout = {
									order = 11,
									type = "execute",
									--name = "|cFFFFCC00"..L["BUTTON_RESET_LAYOUT_PRIMARY"].."|r",
									--disabled = false,
									name = L["BUTTON_RESET_LAYOUT_PRIMARY"],
									func = function()
										layout.orientation.top = layoutDefaults.orientation.top
										layout.orientation.bottom = layoutDefaults.orientation.bottom
										layout.primary.top.icon = layoutDefaults.primary.top.icon
										layout.primary.top.spacing = layoutDefaults.primary.top.spacing
										layout.primary.top.charges = layoutDefaults.primary.top.charges
										layout.primary.bottom.icon = layoutDefaults.primary.bottom.icon
										layout.primary.bottom.spacing = layoutDefaults.primary.bottom.spacing
										res_options.args.layout.args.primaryAuras.args.ResetPrimaryLayout.disabled = true
										res_options.args.layout.args.primaryAuras.args.ResetPrimaryLayout.name = "|cFF666666"..L["BUTTON_RESET_LAYOUT_PRIMARY"].."|r"
										Auras:UpdateTalents()
									end,
								},
							},
						},
						secondaryAuras = {
							name = L["LABEL_AURAS_SECONDARY"],
							type = "group",
							order = 4,
							guiInline = true,
							args = {
								SecondaryOrientation1 = Auras:Select_VerifyDefaults(layout.orientation,1,3,L["LABEL_AURAS_ORIENTATION"].." 1",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'left','Secondary',nil,true),
								SecondaryOrientation2 = Auras:Select_VerifyDefaults(layout.orientation,2,3,L["LABEL_AURAS_ORIENTATION"].." 2",L["TOOLTIP_AURAS_ORIENTATION"],nil,ORIENTATION,'right','Secondary',nil,true),
								filler_1 = Auras:Spacer(3),
								AuraSizeCol1 = Auras:Slider_VerifyDefaults(layout.secondary.left,4,3,L["LABEL_AURAS_SIZE"].." 1",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Secondary',nil,true),
								AuraSpacingCol1 = Auras:Slider_VerifyDefaults(layout.secondary.left,5,3,L["LABEL_AURAS_SPACING"].." 1",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Secondary',nil,true),
								filler_2 = Auras:Spacer(6),
								AuraSizeCol2 = Auras:Slider_VerifyDefaults(layout.secondary.right,7,3,L["LABEL_AURAS_SIZE"].." 2",L["TOOLTIP_AURAS_SIZE"],16,256,nil,'icon','Secondary',nil,true),
								AuraSpacingCol2 = Auras:Slider_VerifyDefaults(layout.secondary.right,8,3,L["LABEL_AURAS_SPACING"].." 2",L["TOOLTIP_AURAS_SPACING"],32,300,nil,'spacing','Secondary',nil,true),
								AuraChargesRow1 = Auras:Slider_VerifyDefaults(layout.secondary.right,9,3,L["LABEL_AURAS_CHARGES"].." 1",L["TOOLTIP_AURAS_CHARGE_SIZE"],10,60,nil,'charges','Secondary',nil,true),
								ResetSecondaryLayout = {
									order = 10,
									type = "execute",
									--name = "|cFFFFCC00"..L["BUTTON_RESET_LAYOUT_SECONDARY"].."|r",
									--disabled = false,
									name = L["BUTTON_RESET_LAYOUT_SECONDARY"],
									func = function()
										layout.orientation.left = layoutDefaults.orientation.left
										layout.orientation.right = layoutDefaults.orientation.right
										layout.secondary.left.icon = layoutDefaults.secondary.left.icon
										layout.secondary.left.spacing = layoutDefaults.secondary.left.spacing
										layout.secondary.right.icon = layoutDefaults.secondary.right.icon
										layout.secondary.right.spacing = layoutDefaults.secondary.right.spacing
										layout.secondary.right.charges = layoutDefaults.secondary.right.charges
										res_options.args.layout.args.secondaryAuras.args.ResetSecondaryLayout.disabled = true
										res_options.args.layout.args.secondaryAuras.args.ResetSecondaryLayout.name = "|cFF666666"..L["BUTTON_RESET_LAYOUT_SECONDARY"].."|r"
										Auras:UpdateTalents()
									end,
								},
							},
						},
					},
				},]]
			},
		}
	end

		
	return res_options
end

function Auras:SetupOptions()
	local ACFG = LibStub("AceConfig-3.0")
	ACFG:RegisterOptionsTable("ShamanAuras Elemental Auras", GetElementalOptions)
	ACFG:RegisterOptionsTable("ShamanAuras Enhancement Auras", GetEnhancementOptions)
	ACFG:RegisterOptionsTable("ShamanAuras Restoration Auras", GetRestorationOptions)
	--ACFG:RegisterOptionsTable("ShamanAuras Settings", GetSettingsOptions)

	local ACD = LibStub("AceConfigDialog-3.0")
	ACD:AddToBlizOptions("ShamanAuras Elemental Auras", L["LABEL_AURAS_ELEMENTAL"], "ShamanAuras")
	ACD:AddToBlizOptions("ShamanAuras Enhancement Auras", L["LABEL_AURAS_ENHANCEMENT"], "ShamanAuras")
	ACD:AddToBlizOptions("ShamanAuras Restoration Auras", L["LABEL_AURAS_RESTORATION"], "ShamanAuras")
	--ACD:AddToBlizOptions("ShamanAuras Settings", SETTINGS, "ShamanAuras")
end

local function ToggleHasteBars(options,bloodlust,heroism)
	options.args.display.args.ProgressBars.args.BuffTimerBars.args.Bloodlust.hidden = bloodlust
	options.args.display.args.ProgressBars.args.BuffTimerBars.args.Heroism.hidden = heroism
end



function Auras:UpdateInterfaceSettings()
	local spec = GetSpecialization()
	local factionGroup = UnitFactionGroup('player')
_G["SSA_ele_options"] = GetElementalOptions()
	if (factionGroup == "Horde") then
		--ToggleHasteBars(GetElementalOptions(),false,true)
		--ToggleHasteBars(GetEnhancementOptions(),false,true)
		--ToggleHasteBars(GetRestorationOptions(),false,true)
	elseif (factionGroup == "Alliance") then
		--ToggleHasteBars(GetElementalOptions(),true,false)
		--ToggleHasteBars(GetEnhancementOptions(),true,false)
		--ToggleHasteBars(GetRestorationOptions(),true,false)
	end
	
	local ele_options = GetElementalOptions()
	local enh_options = GetEnhancementOptions()
	local res_options = GetRestorationOptions()
	if (spec == 1) then
		Auras:RefreshCooldownList(ele_options,1)
		Auras:RefreshAuraGroupList(ele_options,1)
		Auras:RefreshTimerBarGroupList(ele_options,1)
		
		Auras:VerifyDefaultValues(1,ele_options,'Cooldowns')
		Auras:VerifyDefaultValues(1,ele_options,'Maelstrom')
		Auras:VerifyDefaultValues(1,ele_options,'Cast')
		Auras:VerifyDefaultValues(1,ele_options,'Channel')
		Auras:VerifyDefaultValues(1,ele_options,'Settings')
		Auras:VerifyDefaultValues(1,ele_options,'Primary')
		Auras:VerifyDefaultValues(1,ele_options,'Secondary')
		Auras:VerifyDefaultValues(1,ele_options,'Icefury')
		
		ele_options.args.general.disabled = false
		ele_options.args.bars.disabled = false
		ele_options.args.cooldowns.disabled = false
		--ele_options.args.layout.disabled = false
		enh_options.args.general.disabled = true
		enh_options.args.bars.disabled = true
		enh_options.args.cooldowns.disabled = true
		--enh_options.args.layout.disabled = true
		res_options.args.general.disabled = true
		res_options.args.bars.disabled = true
		res_options.args.cooldowns.disabled = true
		--res_options.args.layout.disabled = true
	elseif (spec == 2) then
		Auras:RefreshCooldownList(enh_options,2)
		Auras:RefreshAuraGroupList(enh_options,2)
		Auras:RefreshTimerBarGroupList(enh_options,2)
		
		Auras:VerifyDefaultValues(2,enh_options,'Cooldowns')
		Auras:VerifyDefaultValues(2,enh_options,'Maelstrom','All')
		Auras:VerifyDefaultValues(2,enh_options,'Cast')
		Auras:VerifyDefaultValues(2,enh_options,'Channel')
		Auras:VerifyDefaultValues(2,enh_options,'Settings')
		Auras:VerifyDefaultValues(2,enh_options,'Primary')
		Auras:VerifyDefaultValues(2,enh_options,'Secondary')
		
		ele_options.args.general.disabled = true
		ele_options.args.bars.disabled = true
		ele_options.args.cooldowns.disabled = true
		--ele_options.args.layout.disabled = true
		enh_options.args.general.disabled = false
		enh_options.args.bars.disabled = false
		enh_options.args.cooldowns.disabled = false
		--enh_options.args.layout.disabled = false
		res_options.args.general.disabled = true
		res_options.args.bars.disabled = true
		res_options.args.cooldowns.disabled = true
		--res_options.args.layout.disabled = true
	elseif (spec == 3) then
		Auras:RefreshCooldownList(res_options,3)
		Auras:RefreshAuraGroupList(res_options,3)
		Auras:RefreshTimerBarGroupList(res_options,3)
		
		Auras:VerifyDefaultValues(3,res_options,'Cooldowns')
		Auras:VerifyDefaultValues(3,res_options,'Settings')
		Auras:VerifyDefaultValues(3,res_options,'Primary')
		Auras:VerifyDefaultValues(3,res_options,'Secondary')
		Auras:VerifyDefaultValues(3,res_options,'Earthen Wall')
		Auras:VerifyDefaultValues(3,res_options,'Mana Bar')
		Auras:VerifyDefaultValues(3,res_options,'Cast')
		Auras:VerifyDefaultValues(3,res_options,'Channel')
		Auras:VerifyDefaultValues(3,res_options,'Tidal Waves')
		
		ele_options.args.general.disabled = true
		ele_options.args.bars.disabled = true
		ele_options.args.cooldowns.disabled = true
		--ele_options.args.layout.disabled = true
		enh_options.args.general.disabled = true
		enh_options.args.bars.disabled = true
		enh_options.args.cooldowns.disabled = true
		--enh_options.args.layout.disabled = true
		res_options.args.general.disabled = false
		res_options.args.bars.disabled = false
		res_options.args.cooldowns.disabled = false
		--res_options.args.layout.disabled = false
	end
	
end

InterfaceOptionsFrame:HookScript("OnShow",function(self)
	Auras:UpdateInterfaceSettings()
end)

InterfaceOptionsFrame:HookScript("OnHide",function(self)
	local db = Auras.db.char
	
	db.statusbars[1].bars.MaelstromBar.adjust.isEnabled = false
	db.statusbars[1].bars.CastBar.adjust.isEnabled = false
	db.statusbars[1].bars.ChannelBar.adjust.isEnabled = false
	db.statusbars[1].bars.IcefuryBar.adjust.isEnabled = false
	
	for k,v in pairs(db.timerbars[1].bars) do
		if (v.isAdjust) then
			v.isAdjust = false
			if (db.timerbars[1].groups[v.group].isAdjust) then
				db.timerbars[1].groups[v.group].isAdjust = false
			end
		end
	end
	--[[db.elements[2].statusbars.maelstromBar.adjust.isEnabled = false
	db.elements[2].statusbars.castBar.adjust.isEnabled = false
	db.elements[2].statusbars.channelBar.adjust.isEnabled = false
	
	db.elements[3].statusbars.manaBar.adjust.isEnabled = false
	db.elements[3].statusbars.castBar.adjust.isEnabled = false
	db.elements[3].statusbars.channelBar.adjust.isEnabled = false
	db.elements[3].statusbars.earthenWallBar.adjust.isEnabled = false
	db.elements[3].statusbars.tidalWavesBar.adjust.isEnabled = false]]
end)


-- Original Code Line Count: 19,137