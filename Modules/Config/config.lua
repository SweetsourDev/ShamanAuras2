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

local gen_options

local function GetGeneralOptions()
	if not gen_options then
		local db = Auras.db.char
		local lowCPUMode = db.settings.lowCPUMode
		
		gen_options = {
			name = "General Options",
			order = 1,
			type = "group",
			args = {
				lowCPU = {
					name = "Low CPU Usage Settings",
					order = 1,
					type = "group",
					guiInline = true,
					args = {
						lowCPU = Auras:Toggle_Basic(lowCPUMode,0,"Low CPU Mode","Toggles Low CPU Mode.\n\nLow CPU Mode reduces the data refresh rate of the addon from real-time to 0.5 seconds for Auras and 0.1 seconds for Timer bars.\n\nIf you're noticing severe frame rate drops, try turning this on.",false,'isEnabled'),
						--reduceRate = Auras:Slider_Basic(lowCPUMode,1,"Reduction Rate (%)","The rate at which to reduce the addon's CPU usage.",10,100,10,"normal",false,"reduceRate"),
						reduceRate = {
							order = 1,
							type = "range",
							name = "Reduction Rate (%)",
							desc = "The rate at which to reduce the addon's CPU usage.",
							disabled = function() return (not lowCPUMode.isEnabled and true or false) end,
							min = 10,
							max = 100,
							step = 10,
							bigStep = 10,
							get = function() return lowCPUMode.reduceRate end,
							set = function(this,value)
								lowCPUMode.reduceRate = value
								gen_options.args.lowCPU.args.currentRate.name = "Auras Refresh Rate: |cFF00FF00"..(0.5 * (lowCPUMode.reduceRate / 100)).."|rs\nTimer Bars Refresh Rate: |cFF00FF00"..(0.1 * (lowCPUMode.reduceRate / 100)).."|rs"
							end,
							width = "normal",
						},
						spacer = Auras:Spacer(2,0.25),
						currentRate = {
							order = 3,
							type = "description",
							name = "Auras Refresh Rate: |cFF00FF00"..(0.5 * (lowCPUMode.reduceRate / 100)).."|rs\nTimer Bars Refresh Rate: |cFF00FF00"..(0.1 * (lowCPUMode.reduceRate / 100)).."|rs",
							width = "normal",
						},
						lowCPUOptions = {
							name = "Options",
							order = 4,
							type = "group",
							--guiInline = true,
							disabled = function() return (not lowCPUMode.isEnabled and true or false) end,
							args = {
								isAlways = Auras:Toggle_Basic(lowCPUMode,0,"Always","",function() return (not lowCPUMode.isEnabled and true or false) end,'isAlways'),
								isScenario = Auras:Toggle_Basic(lowCPUMode,1,"Scenario","",function() return (((lowCPUMode.isEnabled and lowCPUMode.isAlways) or not lowCPUMode.isEnabled) and true or false) end,'isInScenario'),
								isDungeon = Auras:Toggle_Basic(lowCPUMode,2,"Dungeons","",function() return (((lowCPUMode.isEnabled and lowCPUMode.isAlways) or not lowCPUMode.isEnabled) and true or false) end,'isInDungeon'),
								isRaid = Auras:Toggle_Basic(lowCPUMode,3,"Raids","",function() return (((lowCPUMode.isEnabled and lowCPUMode.isAlways) or not lowCPUMode.isEnabled) and true or false) end,'isInRaid'),
								isWorld = Auras:Toggle_Basic(lowCPUMode,4,"World","",function() return (((lowCPUMode.isEnabled and lowCPUMode.isAlways) or not lowCPUMode.isEnabled) and true or false) end,'isInWorld'),
								isArena = Auras:Toggle_Basic(lowCPUMode,5,"Arena","",function() return (((lowCPUMode.isEnabled and lowCPUMode.isAlways) or not lowCPUMode.isEnabled) and true or false) end,'isInArena'),
								isBG = Auras:Toggle_Basic(lowCPUMode,6,"Battleground","",function() return (((lowCPUMode.isEnabled and lowCPUMode.isAlways) or not lowCPUMode.isEnabled) and true or false) end,'isInBG'),
							},
						},
					},
				},
				--[[display = {
					name = "Display Settings",
					order = 2,
					type = "group",
					guiInline = true,
					childGroups = "tab",
					args = {
						ele = {
							name = "Elemental",
							order = 1,
							type = "group",
							guiInline = true,
							childGroups = "tab",
							args = {
								
							},
						},
						enh = {
							name = "Enhancement",
							order = 2,
							type = "group",
							guiInline = true,
							childGroups = "tab",
							args = {
							
							},
						},
						res = {
							name = "Restoration",
							order = 3,
							type = "group",
							guiInline = true,
							childGroups = "tab",
							args = {
							
							},
						},
					},
				},]]
			},
		}
	end
	
	return gen_options
end

local ele_options

local function GetElementalOptions()
	if not ele_options then
		local db = Auras.db.char
	
		-- Database Shortcuts
		local auras = db.auras[1]
		local cooldowns = db.auras[1].cooldowns
		local timerbars = db.timerbars[1]
		local statusbars = db.statusbars[1]
		local elements = db.elements[1].frames
		local settings = db.settings
		local settingsDefaults = SSA.defaults.settings
		
		
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
							order = 1,
							guiInline = true,
							args = {
								MoveAuras = Auras:Execute_MoveAuras(settings,1,1,"|cFFFFCC00"..L["BUTTON_MOVE_AURAS_ELEMENTAL"].."|r"),
								ResetAuras = Auras:Execute_ResetAuras(2,"|cFFFFCC00"..L["BUTTON_RESET_AURAS_ELEMENTAL"].."|r"),
								OoCAlpha = Auras:Slider_VerifyDefaults(settings,3,1,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_AURAS_ALPHA_NO_COMBAT"],0,1,0.1,nil,false,'OoCAlpha','Settings'),
								OoRColor = Auras:Color_VerifyDefaults(settings[1],5,1,L["LABEL_COLOR_NO_RANGE"],L["TOOLTIP_COLOR_OUT_OF_RANGE"],true,nil,false,'OoRColor','Settings'),
								vehicleToggle = Auras:Toggle_Basic(settings[1],6,"Display in Vehicle","Toggles the display of this addon while in a vehicle.\n\nThis includes Tortolan WQs like \"Beachhead\".",false,'isShowInVehicle'),
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_SETTINGS"],
									func = function()
										--settings.totemMastery = settingDefaults[1].totemMastery
										settings[1].OoCAlpha = settingsDefaults[1].OoCAlpha
										settings[1].OoRColor.r = settingsDefaults[1].OoRColor.r
										settings[1].OoRColor.g = settingsDefaults[1].OoRColor.g
										settings[1].OoRColor.b = settingsDefaults[1].OoRColor.b
										settings[1].OoRColor.a = settingsDefaults[1].OoRColor.a
										ele_options.args.general.args.settings.args.reset.disabled = true
										ele_options.args.general.args.settings.args.reset.name = "|cFF666666"..L["BUTTON_RESET_SETTINGS"].."|r"
									end,
								},
							},
						},
						flametongueWeaponSettings = {
							name = "Flametongue Weapon Settings",
							type = "group",
							order = 2,
							guiInline = true,
							args = {
								toggle = Auras:Toggle_Basic(elements.FlametongueWeapon,1,"Enable","Toggles the display of the \"Flametongue Weapon\" texture alert.",false,'isEnabled'),
								threshold = Auras:Slider_VerifyDefaults(settings[1],2,1,"Threshold Trigger","Sets the threshold, in seconds remaining, for when the alert appear.",5,300,1,nil,false,'flametongueWeapon','Settings'),
							},
						},
						lightningShieldSettings = {
							name = "Lightning Shield Settings",
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								toggle = Auras:Toggle_Basic(elements.LightningShield,1,"Enable","Toggles the display of the \"Lightning Shield\" texture alert.",false,'isEnabled'),
								threshold = Auras:Slider_VerifyDefaults(settings[1],2,1,"Threshold Trigger","Sets the threshold, in seconds remaining, for when the alert appear.",5,300,1,nil,false,'lightningShield','Settings'),
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
										fulminationToggle = Auras:Toggle_Statusbar(statusbars.bars.FulminationBar,4,L["TOGGLE_FULMINATION_BAR"],L["TOOLTIP_TOGGLE_FULMINATION_BAR"],'isEnabled','FulminationBar'),
										icefuryToggle = Auras:Toggle_Statusbar(statusbars.bars.IcefuryBar,5,L["TOGGLE_ICEFURY_BAR"],L["TOOLTIP_TOGGLE_ICEFURY_BAR"],'isEnabled','IcefuryBar'),
									},
								},
							},
						},
						CastBar = {
							name = L["LABEL_STATUSBAR_CAST"],
							order = 2,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,1,1,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],'full',false,'isEnabled','Cast'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 2,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,1,1,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,false,'alphaCombat','Cast'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,2,1,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,false,'alphaOoC','Cast'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 3,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar,1,1,L["TOGGLE_SPARK"],nil,nil,false,nil,'spark','Cast'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.icon,2,1,L["TOGGLE_ICON"],nil,nil,false,nil,'isEnabled','Cast'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.icon,3,1,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,false,'justify','Cast'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext,1,1,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],"single",false,nil,'isDisplayText','Cast'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font,2,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Cast'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,3,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Cast'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font,4,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Cast'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,5,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Cast'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext,6,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Cast'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,7,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Cast'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,8,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Cast'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,1,1,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Cast'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Cast'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Cast'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Cast'),
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
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext,1,1,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],'single',false,nil,'isDisplayText','Cast'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font,2,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Cast'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,3,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Cast'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font,4,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Cast'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,5,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Cast'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext,6,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Cast'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,7,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Cast'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,8,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Cast'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,1,1,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Cast'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Cast'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Cast'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Cast'),
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
										texture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Cast'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Cast'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.background,3,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Cast'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.background,4,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Cast'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,5,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,nil,'showBG','Cast'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,6,1,L["LABEL_WIDTH"],nil,100,500,1,nil,false,'width','Cast'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,7,1,L["LABEL_HEIGHT"],nil,10,100,1,nil,false,'height','Cast'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CAST"],
									func = function()
										local bar = statusbars.bars.CastBar
										local default = SSA.defaults.statusbars.defaults.CastBar
										
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
							order = 3,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,1,1,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],"full",false,nil,'isEnabled','Channel'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 2,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,1,1,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,false,'alphaCombat','Channel'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,2,1,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,false,'alphaOoC','Channel'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 3,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar,1,1,L["TOGGLE_SPARK"],nil,nil,false,nil,'spark','Channel'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.icon,2,1,L["TOGGLE_ICON"],nil,nil,false,nil,'isEnabled','Channel'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.icon,3,1,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,false,'justify','Channel'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext,1,1,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],"single",false,nil,'isDisplayText','Channel'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,2,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Channel'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,3,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Channel'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,4,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Channel'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,5,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Channel'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext,6,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Channel'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,7,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Channel'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,8,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Channel'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,1,1,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Channel'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Channel'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Channel'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Channel'),
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
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext,1,1,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],"single",false,nil,'isDisplayText','Channel'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,2,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Channel'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,3,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Channel'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,4,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Channel'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,5,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Channel'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext,6,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Channel'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,7,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Channel'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,8,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Channel'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,1,1,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Channel'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Channel'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Channel'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Channel'),
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
										texture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Channel'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Channel'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.background,3,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Channel'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.background,4,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Channel'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,5,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,nil,'showBG','Channel'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,6,1,L["LABEL_WIDTH"],nil,100,500,1,nil,false,'width','Channel'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,7,1,L["LABEL_HEIGHT"],nil,10,100,1,nil,false,'height','Channel'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CHANNEL"],
									func = function()
										local bar = statusbars.bars.ChannelBar
										local default = SSA.defaults.statusbars.defaults.ChannelBar
										
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
						FulminationBar = {
							name = L["LABEL_STATUSBAR_FULMINATION"],
							order = 4,
							type = "group",
							inline = false,
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.FulminationBar.adjust,1,1,L["LABEL_STATUSBAR_MODIFY_FULMINATION"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,nil,'isEnabled','Fulmination'),
								animation = Auras:Toggle_VerifyDefaults(statusbars.bars.FulminationBar,2,1,L["LABEL_STATUSBAR_ANIMATE_FULMINATION"],nil,'double',false,nil,'animate','Fulmination'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 3,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar,1,1,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,false,'alphaCombat','Fulmination'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar,2,1,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,false,'alphaOoC','Fulmination'),
										alphaTarget = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar,3,1,L["LABEL_ALPHA_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_TARGET_NO_COMBAT"],0,1,0.1,nil,false,'alphaTar','Fulmination'),
										threshold = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar,4,1,L["LABEL_TRIGGER_FULMINATION"],L["TOOLTIP_FULMINATION_TIME_TRIGGER"],3,8,1,nil,false,'threshold','Fulmination'),
									},
								},
								counttext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_COUNT"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.FulminationBar.counttext,1,1,L["TOGGLE_COUNT_TEXT"],L["TOOLTIP_TOGGLE_FULMINATION_TEXT"],'single',false,nil,'isDisplayText','Fulmination'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.FulminationBar.counttext.font,2,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Fulmination'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.FulminationBar.counttext.font,3,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Fulmination'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.counttext.font,4,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Fulmination'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.FulminationBar.counttext.font,5,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Fulmination'),
										textAnchor = Auras:Select_VerifyDefaults(statusbars.bars.FulminationBar.counttext,6,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Fulmination'),
										textX = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.counttext,7,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Fulmination'),
										textY = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.counttext,8,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Fulmination'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.FulminationBar.counttext.font.shadow,1,1,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Fulmination'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.FulminationBar.counttext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Fulmination'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.counttext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Fulmination'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.counttext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Fulmination'),
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
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.FulminationBar.timetext,1,1,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],'single',false,nil,'isDisplayText','Fulmination'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.FulminationBar.timetext.font,2,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,'double',nil,'color','Fulmination'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.FulminationBar.timetext.font,3,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Fulmination'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.timetext.font,4,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Fulmination'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.FulminationBar.timetext.font,5,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Fulmination'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.FulminationBar.timetext,6,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Fulmination'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.timetext,7,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Fulmination'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.timetext,8,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Fulmination'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 8,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.FulminationBar.timetext.font.shadow,1,1,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Fulmination'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.FulminationBar.timetext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Fulmination'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.timetext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Fulmination'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.timetext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Fulmination'),
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
										texture = Auras:Select_VerifyDefaults(statusbars.bars.FulminationBar.foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Fulmination'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.FulminationBar.foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Fulmination'),
										timerTexture = Auras:Select_VerifyDefaults(statusbars.bars.FulminationBar.timerBar,3,1,L["LABEL_TIME_BAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Fulmination'),
										timerColor = Auras:Color_VerifyDefaults(statusbars.bars.FulminationBar.timerBar,4,1,L["LABEL_STATUSBAR_COLOR"],nil,true,nil,false,'color','Fulmination'),
										timerToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.FulminationBar.adjust,5,1,L["LABEL_STATUSBAR_MODIFY_TIMER"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,nil,'showTimer','Fulmination'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.FulminationBar.background,6,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Fulmination'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.FulminationBar.background,7,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Fulmination'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.FulminationBar.adjust,8,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,nil,'showBG','Fulmination'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.layout,9,1,L["LABEL_WIDTH"],nil,100,500,1,nil,false,'width','Fulmination'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.FulminationBar.layout,10,1,L["LABEL_HEIGHT"],nil,10,100,1,nil,false,'height','Fulmination'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_FULMINATION"],
									func = function()
										local bar = statusbars.bars.FulminationBar
										local default = SSA.defaults.statusbars[1].defaults.FulminationBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										bar.alphaTar = default.alphaTar
										bar.animate = true
										bar.threshold = default.threshold

										Auras:ResetText(bar,'counttext',default)
										Auras:ResetText(bar,'timetext',default)

										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)

										ele_options.args.bars.args.FulminationBar.args.reset.disabled = true
										ele_options.args.bars.args.FulminationBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_FULMINATION"].."|r"
										Auras:VerifyDefaultValues(1,ele_options,'Fulmination')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('FulminationBar','Timer','counttext','timetext',1)
										end
									end,
								},
							},
						},
						IcefuryBar = {
							name = L["LABEL_STATUSBAR_ICEFURY"],
							order = 5,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.adjust,1,1,L["LABEL_STATUSBAR_MODIFY_ICEFURY"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],'full',false,nil,'isEnabled','Icefury'),
								counttext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_COUNT"]..'|r',
									type = "group",
									order = 2,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.counttext,1,1,L["TOGGLE_COUNT_TEXT"],L["TOOLTIP_TOGGLE_ICEFURY_TEXT"],'single',false,nil,'isDisplayText','Icefury'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font,2,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,'double',nil,'color','Icefury'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font,3,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Icefury'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font,4,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Icefury'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font,5,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Icefury'),
										textAnchor = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.counttext,6,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Icefury'),
										textX = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext,7,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Icefury'),
										textY = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext,8,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Icefury'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font.shadow,1,1,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Icefury'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Icefury'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Icefury'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.counttext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Icefury'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 3,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.timetext,1,1,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],'single',false,nil,'isDisplayText','Icefury'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font,2,1,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,'double',nil,'color','Icefury'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font,3,1,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Icefury'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font,4,1,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Icefury'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font,5,1,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Icefury'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.timetext,6,1,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Icefury'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext,7,1,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Icefury'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext,8,1,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Icefury'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font.shadow,1,1,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Icefury'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font.shadow,2,1,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Icefury'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font.shadow.offset,3,1,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Icefury'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.timetext.font.shadow.offset,4,1,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Icefury'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 4,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Icefury'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Icefury'),
										timerTexture = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.timerBar,3,1,L["LABEL_TIME_BAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Icefury'),
										timerColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.timerBar,4,1,L["LABEL_STATUSBAR_COLOR"],nil,true,nil,false,'color','Icefury'),
										timerToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.adjust,5,1,L["LABEL_STATUSBAR_MODIFY_TIMER"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,nil,'showTimer','Icefury'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.IcefuryBar.background,6,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','Icefury'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.IcefuryBar.background,7,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Icefury'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.IcefuryBar.adjust,8,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,nil,'showBG','Icefury'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.layout,9,1,L["LABEL_WIDTH"],nil,100,500,1,nil,false,'width','Icefury'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.IcefuryBar.layout,10,1,L["LABEL_HEIGHT"],nil,10,100,1,nil,false,'height','Icefury'),
									},
								},
								reset = {
									order = 5,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_ICEFURY"],
									func = function()
										local bar = statusbars.bars.IcefuryBar
										local default = SSA.defaults.statusbars[1].defaults.IcefuryBar
										
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
						--[[toggle = Auras:Toggle_VerifyDefaults(cooldowns,1,1,ENABLE,L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],"full",false,'isEnabled','Cooldowns'),
						text = Auras:Toggle_Basic(cooldowns,2,L["LABEL_COOLDOWN_TEXT"],L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],not cooldowns.isEnabled,'text'),
						sweep = Auras:Toggle_Cooldowns(cooldowns,3,1,L["LABEL_COOLDOWN_SWEEP"],L["TOOLTIP_TOGGLE_COOLDOWN_SWEEP"],not cooldowns.isEnabled,'sweep','AuraBase','Cooldowns'),
						GCD = Auras:Toggle_Basic(cooldowns.GCD,4,L["LABEL_COOLDOWN_GCD"],L["TOOLTIP_TOGGLE_COOLDOWN_GCD"],not cooldowns.sweep and not cooldowns.isEnabled,'isEnabled'),
						inverse = Auras:Toggle_Cooldowns(cooldowns,5,1,L["LABEL_COOLDOWN_REVERSE_SWEEP"],L["TOOLTIP_COOLDOWN_REVERSE_SWEEP"],not cooldowns.sweep and not cooldowns.isEnabled,'inverse','AuraBase'),
						bling = Auras:Toggle_Cooldowns(cooldowns,6,1,L["LABEL_COOLDOWN_BLING"],L["TOOLTIP_TOGGLE_COOLDOWN_BLING"],not cooldowns.sweep and not cooldowns.isEnabled,'blind','AuraBase'),]]
						adjustToggle = Auras:Toggle_VerifyDefaults(cooldowns,1,1,L["LABEL_COOLDOWN_ADJUST"],nil,2.5,false,nil,'adjust','Cooldowns',nil,true),
						group = Auras:Select_VerifyDefaults(cooldowns,2,1,L["LABEL_COOLDOWN_GROUP"],L["TOOLTIP_AURAS_GROUP_SELECT"],nil,COOLDOWN_OPTIONS,0.8,nil,'selected','Cooldowns',nil,false,true),
						cdGroups = {
							name = "Cooldown Groups",
							order = 3,
							desc = "TESTING",
							type = "group",
							guiInline = true,
							args = {
							},
						},
					},
				},
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
		local auras = db.auras[2]
		local cooldowns = db.auras[2].cooldowns
		local timerbars = db.timerbars[2]
		local statusbars = db.statusbars[2]
		local elements = db.elements[2].frames
		local settings = db.settings
		local settingsDefaults = SSA.defaults.settings
		
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
							order = 1,
							guiInline = true,
							args = {
								MoveAuras = Auras:Execute_MoveAuras(settings,1,2,"|cFFFFCC00"..L["BUTTON_MOVE_AURAS_ENHANCEMENT"].."|r"),
								ResetAuras = Auras:Execute_ResetAuras(2,"|cFFFFCC00"..L["BUTTON_RESET_AURAS_ENHANCEMENT"].."|r"),
								OoCAlpha = Auras:Slider_VerifyDefaults(settings[2],3,2,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_AURAS_ALPHA_NO_COMBAT"],0,1,0.1,nil,false,'OoCAlpha','Settings'),
								OoRColor = Auras:Color_VerifyDefaults(settings[2],4,2,L["LABEL_COLOR_NO_RANGE"],L["TOOLTIP_COLOR_OUT_OF_RANGE"],true,"double",false,'OoRColor','Settings'),
								vehicleToggle = Auras:Toggle_Basic(settings[2],5,"Display in Vehicle","Toggles the display of this addon while in a vehicle.\n\nThis includes Tortolan WQs like \"Beachhead\".",false,'isShowInVehicle'),
								reset = {
									order = 6,
									type = "execute",
									name = L["BUTTON_RESET_SETTINGS"],
									func = function()
										settings[2].OoCAlpha = settingsDefaults[2].OoCAlpha
										settings[2].OoRColor.r = settingsDefaults[2].OoRColor.r
										settings[2].OoRColor.g = settingsDefaults[2].OoRColor.g
										settings[2].OoRColor.b = settingsDefaults[2].OoRColor.b
										settings[2].OoRColor.a = settingsDefaults[2].OoRColor.a
										enh_options.args.general.args.settings.args.reset.disabled = true
										enh_options.args.general.args.settings.args.reset.name = "|cFF666666"..L["BUTTON_RESET_SETTINGS"].."|r"
									end,
								},
							},
						},
						flametongueWeaponSettings = {
							name = "Flametongue Weapon Settings",
							type = "group",
							order = 2,
							guiInline = true,
							args = {
								toggle = Auras:Toggle_Basic(elements.FlametongueWeapon,1,"Enable","Toggles the display of the \"Flametongue Weapon\" texture alert.",false,'isEnabled'),
								threshold = Auras:Slider_VerifyDefaults(settings[2],2,1,"Threshold Trigger","Sets the threshold, in seconds remaining, for when the alert appear.",5,300,1,nil,false,'flametongueWeapon','Settings'),
							},
						},
						lightningShieldSettings = {
							name = "Lightning Shield Settings",
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								toggle = Auras:Toggle_Basic(elements.LightningShield,1,"Enable","Toggles the display of the \"Lightning Shield\" texture alert.",false,'isEnabled'),
								threshold = Auras:Slider_VerifyDefaults(settings[2],2,1,"Threshold Trigger","Sets the threshold, in seconds remaining, for when the alert appear.",5,300,1,nil,false,'lightningShield','Settings'),
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
										maelstromWeaponToggle = Auras:Toggle_Statusbar(statusbars.bars.MaelstromWeaponBar,4,L["TOGGLE_MAELSTROM_WEAPON_BAR"],L["TOOLTIP_TOGGLE_MAELSTROM_WEAPON_BAR"],'isEnabled','MaelstromWeaponBar'),
									},
								},
							},
						},
						CastBar = {
							name = L["LABEL_STATUSBAR_CAST"],
							order = 2,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,1,2,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],"full",false,nil,'isEnabled','Cast'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 2,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,1,2,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,false,'alphaCombat','Cast'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,2,2,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,false,'alphaOoC','Cast'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 3,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar,1,2,L["TOGGLE_SPARK"],nil,nil,false,nil,'spark','Cast'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.icon,2,2,L["TOGGLE_ICON"],nil,nil,false,nil,'isEnabled','Cast'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.icon,3,2,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,false,'justify','Cast'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext,1,2,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],"single",false,nil,'isDisplayText','Cast'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font,2,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Cast'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,3,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Cast'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font,4,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Cast'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,5,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Cast'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext,6,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Cast'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,7,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Cast'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,8,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Cast'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,1,2,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Cast'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Cast'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Cast'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Cast'),
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
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext,1,2,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],"single",false,nil,'isDisplayText','Cast'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font,2,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Cast'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,3,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Cast'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font,4,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Cast'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,5,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Cast'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext,6,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Cast'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,7,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Cast'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,8,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Cast'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,1,2,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Cast'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Cast'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Cast'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Cast'),
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
										texture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.foreground,1,2,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Cast'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.foreground,2,2,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Cast'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.background,3,2,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Cast'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.background,4,2,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Cast'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,5,2,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,nil,'showBG','Cast'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,6,2,L["LABEL_WIDTH"],nil,100,500,1,nil,nil,'width','Cast'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,7,2,L["LABEL_HEIGHT"],nil,10,100,1,nil,nil,'height','Cast'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CAST"],
									func = function()
										local bar = statusbars.bars.CastBar
										local default = SSA.defaults.statusbars.defaults.CastBar
										
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
							order = 3,
							inline = false,
							type = "group",
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,1,2,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],"full",false,nil,'isEnabled','Channel'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 2,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,1,2,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,false,'alphaCombat','Channel'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,2,2,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,false,'alphaOoC','Channel'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 3,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar,1,2,L["TOGGLE_SPARK"],nil,nil,false,nil,'spark','Channel'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.icon,2,2,L["TOGGLE_ICON"],nil,nil,false,nil,'isEnabled','Channel'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.icon,3,2,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,false,'justify','Channel'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext,1,2,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],"single",false,nil,'isDisplayText','Channel'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,2,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Channel'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,3,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Channel'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,4,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Channel'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,5,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Channel'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext,6,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Channel'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,7,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Channel'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,8,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Channel'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,1,2,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Channel'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Channel'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Channel'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Channel'),
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
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext,1,2,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],"single",false,nil,'isDisplayText','Channel'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,2,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Channel'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,3,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Channel'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,4,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Channel'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,5,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Channel'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext,6,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Channel'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,7,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Channel'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,8,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Channel'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,1,2,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Channel'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Channel'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Channel'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Channel'),
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
										texture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.foreground,1,2,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Channel'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.foreground,2,2,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Channel'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.background,3,2,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,nil,'texture','Channel'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.background,4,2,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Channel'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,5,2,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,nil,'showBG','Channel'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,6,2,L["LABEL_WIDTH"],nil,100,500,1,nil,nil,'width','Channel'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,7,2,L["LABEL_HEIGHT"],nil,10,100,1,nil,nil,'height','Channel'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CHANNEL"],
									func = function()
										local bar = statusbars.bars.ChannelBar
										local default = SSA.defaults.statusbars.defaults.ChannelBar
										
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
						MaelstromWeaponBar = {
							name = L["LABEL_STATUSBAR_MAELSTROM_WEAPON"],
							order = 4,
							type = "group",
							inline = false,
							args = {
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.adjust,1,2,L["LABEL_STATUSBAR_MODIFY_MAELSTROM_WEAPON"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,false,nil,'isEnabled','MaelstromWeapon'),
								animation = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromWeaponBar,2,2,L["LABEL_STATUSBAR_ANIMATE_MAELSTROM_WEAPON"],nil,'double',false,nil,'animate','MaelstromWeapon'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 3,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar,1,2,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,false,'alphaCombat','MaelstromWeapon'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar,2,2,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,false,'alphaOoC','MaelstromWeapon'),
										alphaTarget = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar,3,2,L["LABEL_ALPHA_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_TARGET_NO_COMBAT"],0,1,0.1,nil,false,'alphaTar','MaelstromWeapon'),
										threshold = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar,4,2,L["LABEL_TRIGGER_MAELSTROM_WEAPON"],L["TOOLTIP_MAELSTROM_WEAPON_TIME_TRIGGER"],3,8,1,nil,false,'threshold','MaelstromWeapon'),
									},
								},
								counttext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_COUNT"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext,1,2,L["TOGGLE_COUNT_TEXT"],L["TOOLTIP_TOGGLE_MAELSTROM_WEAPON_TEXT"],'single',false,nil,'isDisplayText','MaelstromWeapon'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext.font,2,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,'double',nil,'color','MaelstromWeapon'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext.font,3,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','MaelstromWeapon'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext.font,4,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','MaelstromWeapon'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext.font,5,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','MaelstromWeapon'),
										textAnchor = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext,6,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','MaelstromWeapon'),
										textX = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext,7,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','MaelstromWeapon'),
										textY = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext,8,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','MaelstromWeapon'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext.font.shadow,1,2,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','MaelstromWeapon'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','MaelstromWeapon'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','MaelstromWeapon'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.counttext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','MaelstromWeapon'),
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
										timetextToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext,1,2,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],'single',false,nil,'isDisplayText','MaelstromWeapon'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext.font,2,2,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,'double',nil,'color','MaelstromWeapon'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext.font,3,2,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','MaelstromWeapon'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext.font,4,2,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','MaelstromWeapon'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext.font,5,2,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','MaelstromWeapon'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext,6,2,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','MaelstromWeapon'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext,7,2,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','MaelstromWeapon'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext,8,2,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','MaelstromWeapon'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext.font.shadow,1,2,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','MaelstromWeapon'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext.font.shadow,2,2,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','MaelstromWeapon'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext.font.shadow.offset,3,2,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','MaelstromWeapon'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timetext.font.shadow.offset,4,2,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','MaelstromWeapon'),
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
										texture = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.foreground,1,2,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','MaelstromWeapon'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.foreground,2,2,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','MaelstromWeapon'),
										timerTexture = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timerBar,3,2,L["LABEL_TIME_BAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','MaelstromWeapon'),
										timerColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.timerBar,4,2,L["LABEL_STATUSBAR_COLOR"],nil,true,nil,false,'color','MaelstromWeapon'),
										timerToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.adjust,5,2,L["LABEL_STATUSBAR_MODIFY_TIMER"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,nil,nil,'showTimer','MaelstromWeapon'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.background,6,2,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,false,'texture','MaelstromWeapon'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.background,7,2,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','MaelstromWeapon'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.adjust,8,2,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,nil,'showBG','MaelstromWeapon'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.layout,9,2,L["LABEL_WIDTH"],nil,100,500,1,nil,nil,'width','MaelstromWeapon'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.MaelstromWeaponBar.layout,10,2,L["LABEL_HEIGHT"],nil,10,100,1,nil,nil,'height','MaelstromWeapon'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_MAELSTROM_WEAPON"],
									func = function()
										local bar = statusbars.bars.MaelstromWeaponBar
										local default = SSA.defaults.statusbars[2].defaults.MaelstromWeaponBar
										
										bar.alphaCombat = default.alphaCombat
										bar.alphaOoC = default.alphaOoC
										bar.alphaTar = default.alphaTar
										bar.animate = true
										bar.threshold = default.threshold

										Auras:ResetText(bar,'counttext',default)
										Auras:ResetText(bar,'timetext',default)

										Auras:ResetBackground(bar,default)
										Auras:ResetForeground(bar,default)
										Auras:ResetLayout(bar,default)

										enh_options.args.bars.args.MaelstromWeaponBar.args.reset.disabled = true
										enh_options.args.bars.args.MaelstromWeaponBar.args.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_MAELSTROM_WEAPON"].."|r"
										Auras:VerifyDefaultValues(2,enh_options,'MaelstromWeapon')
										
										if (not bar.adjust.isEnabled) then
											Auras:InitializeProgressBar('MaelstromWeaponBar','Timer','counttext','timetext',2)
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
						--[[toggle = Auras:Toggle_VerifyDefaults(cooldowns,1,2,ENABLE,L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],"full",false,'isEnabled','Cooldowns'),
						text = Auras:Toggle_Basic(cooldowns,2,L["LABEL_COOLDOWN_TEXT"],L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],not cooldowns.isEnabled,'text'),
						sweep = Auras:Toggle_Cooldowns(cooldowns,3,2,L["LABEL_COOLDOWN_SWEEP"],L["TOOLTIP_TOGGLE_COOLDOWN_SWEEP"],not cooldowns.isEnabled,'sweep','AuraBase','Cooldowns'),
						GCD = Auras:Toggle_Basic(cooldowns.GCD,4,L["LABEL_COOLDOWN_GCD"],L["TOOLTIP_TOGGLE_COOLDOWN_GCD"],not cooldowns.sweep and not cooldowns.isEnabled,'isEnabled'),
						inverse = Auras:Toggle_Cooldowns(cooldowns,5,2,L["LABEL_COOLDOWN_REVERSE_SWEEP"],L["TOOLTIP_COOLDOWN_REVERSE_SWEEP"],not cooldowns.sweep and not cooldowns.isEnabled,'inverse','AuraGroup1'),
						bling = Auras:Toggle_Cooldowns(cooldowns,6,2,L["LABEL_COOLDOWN_BLING"],L["TOOLTIP_TOGGLE_COOLDOWN_BLING"],not cooldowns.sweep and not cooldowns.isEnabled,'blind','AuraBase'),]]
						adjustToggle = Auras:Toggle_VerifyDefaults(cooldowns,1,2,L["LABEL_COOLDOWN_ADJUST"],nil,2.5,false,nil,'adjust','Cooldowns'),
						group = Auras:Select_VerifyDefaults(cooldowns,2,2,L["LABEL_COOLDOWN_GROUP"],L["TOOLTIP_AURAS_GROUP_SELECT"],nil,COOLDOWN_OPTIONS,0.8,false,'selected','Cooldowns'),
						cdGroups = {
							name = "Cooldown Groups",
							order = 3,
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
		local auras = db.auras[3]
		local cooldowns = db.auras[3].cooldowns
		local timerbars = db.timerbars[3]
		local statusbars = db.statusbars[3]
		local elements = db.elements[3].frames
		local settings = db.settings
		local settingsDefaults = SSA.defaults.settings
		
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
							order = 1,
							guiInline = true,
							args = {
								MoveAuras = Auras:Execute_MoveAuras(settings,1,3,"|cFFFFCC00"..L["BUTTON_MOVE_AURAS_RESTORATION"].."|r"),
								ResetAuras = Auras:Execute_ResetAuras(2,"|cFFFFCC00"..L["BUTTON_RESET_AURAS_RESTORATION"].."|r"),
								OoCAlpha = Auras:Slider_VerifyDefaults(settings[3],3,3,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_AURAS_ALPHA_NO_COMBAT"],0,1,0.1,nil,nil,'OoCAlpha','Settings'),
								OoRColor = Auras:Color_VerifyDefaults(settings[3],4,3,L["LABEL_COLOR_NO_RANGE"],L["TOOLTIP_COLOR_OUT_OF_RANGE"],true,"full",nil,'OoRColor','Settings'),
								vehicleToggle = Auras:Toggle_Basic(settings[3],5,"Display in Vehicle","Toggles the display of this addon while in a vehicle.\n\nThis includes Tortolan WQs like \"Beachhead\".",false,'isShowInVehicle'),
								reset = {
									order = 6,
									type = "execute",
									--name = "|cFFFFCC00"..L["BUTTON_RESET_SETTINGS"].."|r",
									--disabled = false,
									name = L["BUTTON_RESET_SETTINGS"],
									func = function()
										settings[3].OoCAlpha = settingDefaults[3].OoCAlpha
										settings[3].OoRColor.r = settingDefaults[3].OoRColor.r
										settings[3].OoRColor.g = settingDefaults[3].OoRColor.g
										settings[3].OoRColor.b = settingDefaults[3].OoRColor.b
										settings[3].OoRColor.a = settingDefaults[3].OoRColor.a
										
										res_options.args.bars.args.triggers.args.reset.disabled = true
										res_options.args.bars.args.triggers.args.reset.name = "|cFF666666"..L["BUTTON_RESET_SETTINGS"].."|r"
									end,
								},
							},
						},
						flametongueWeaponSettings = {
							name = "Flametongue Weapon Settings",
							type = "group",
							order = 2,
							guiInline = true,
							args = {
								toggle = Auras:Toggle_Basic(elements.FlametongueWeapon,1,"Enable","Toggles the display of the \"Flametongue Weapon\" texture alert.",false,'isEnabled'),
								threshold = Auras:Slider_VerifyDefaults(settings[3],2,1,"Threshold Trigger","Sets the threshold, in seconds remaining, for when the alert appear.",5,300,1,nil,false,'flametongueWeapon','Settings'),
							},
						},
						lightningShieldSettings = {
							name = "Lightning Shield Settings",
							type = "group",
							order = 3,
							guiInline = true,
							args = {
								toggle = Auras:Toggle_Basic(elements.LightningShield,1,"Enable","Toggles the display of the \"Lightning Shield\" texture alert.",false,'isEnabled'),
								threshold = Auras:Slider_VerifyDefaults(settings[3],2,1,"Threshold Trigger","Sets the threshold, in seconds remaining, for when the alert appear.",5,300,1,nil,false,'lightningShield','Settings'),
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
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 2,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar,1,3,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,nil,'alphaCombat','Mana'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar,2,3,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,nil,'alphaOoC','Mana'),
										alphaTarget = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar,3,3,L["LABEL_ALPHA_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_TARGET_NO_COMBAT"],0,1,0.1,nil,nil,'alphaTar','Mana'),
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
									order = 3,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ManaBar.text,1,3,L["LABEL_TEXT_MANA"],L["TOOLTIP_TOGGLE_MANA_TEXT"],"single",false,'isDisplayText','Mana'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.ManaBar.text.font,2,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Mana'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.text.font,3,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Mana'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text.font,4,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Mana'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.text.font,5,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Mana'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.text,6,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Mana'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text,7,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Mana'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text,8,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Mana'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ManaBar.text.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,'isEnabled','Mana'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ManaBar.text.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Mana'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Mana'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.text.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Mana'),
											},
										},
									},
								},
								layout = {
									name = L["LABEL_LAYOUT_DESIGN"],
									type = "group",
									order = 4,
									guiInline = true,
									args = {
										texture = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.foreground,1,3,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Mana'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.ManaBar.foreground,2,3,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Mana'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.ManaBar.background,3,3,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Mana'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.ManaBar.background,4,3,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Mana'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ManaBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,'showBG','Mana'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.layout,6,3,L["LABEL_WIDTH"],nil,100,500,1,nil,nil,'width','Mana'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.ManaBar.layout,7,3,L["LABEL_HEIGHT"],nil,10,100,1,nil,nil,'height','Mana'),
									},
								},
								reset = {
									order = 5,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_MANA"],
									func = function()
										local bar = statusbars.bars.ManaBar
										local default = SSA.defaults.statusbars[3].defaults.ManaBar
										
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
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,1,3,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],"full",nil,nil,'isEnabled','Cast','castBar'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 2,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,1,3,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,nil,'alphaCombat','Cast','castBar'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar,2,3,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,nil,'alphaOoC','Cast','castBar'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 3,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar,1,3,L["TOGGLE_SPARK"],nil,nil,nil,nil,'spark','Cast','castBar'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.icon,2,3,L["TOGGLE_ICON"],nil,nil,nil,nil,'isEnabled','Cast','castBar'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.icon,3,3,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,nil,'justify','Cast','castBar'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext,1,3,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],"single",false,nil,'isDisplayText','Cast','castBar'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font,2,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Cast','castBar'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,3,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Cast','castBar'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font,4,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Cast','castBar'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext.font,5,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Cast','castBar'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.nametext,6,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Cast','castBar'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,7,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Cast','castBar'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext,8,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Cast','castBar'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Cast','castBar'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Cast','castBar'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Cast','castBar'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.nametext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Cast','castBar'),
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
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext,1,3,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],"single",false,nil,'isDisplayText','Cast','castBar'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font,2,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Cast','castBar'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,3,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Cast','castBar'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font,4,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Cast','castBar'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext.font,5,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Cast','castBar'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.timetext,6,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Cast','castBar'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,7,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Cast','castBar'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext,8,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Cast','castBar'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Cast','castBar'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Cast','castBar'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Cast','castBar'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.timetext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Cast','castBar'),
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
										texture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.foreground,1,3,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Cast','castBar'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.foreground,2,3,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Cast','castBar'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.CastBar.background,3,3,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Cast','castBar'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.CastBar.background,4,3,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Cast','castBar'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.CastBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,nil,'showBG','Cast','castBar'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,6,3,L["LABEL_WIDTH"],nil,100,500,1,nil,nil,'width','Cast','castBar'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.CastBar.layout,7,3,L["LABEL_HEIGHT"],nil,10,100,1,nil,nil,'height','Cast','castBar'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CAST"],
									func = function()
										local bar = statusbars.bars.CastBar
										local default = SSA.defaults.statusbars.defaults.CastBar
										
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
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,1,3,L["LABEL_STATUSBAR_MODIFY_CAST"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],"full",nil,nil,'isEnabled','Channel','channelBar'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 2,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,1,3,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,nil,'alphaCombat','Channel','channelBar'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar,2,3,L["LABEL_ALPHA_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,nil,'alphaOoC','Channel','channelBar'),
									},
								},
								iconSpark = {
									name = '|cFFFFFFFF'..L["LABEL_ICON_SPARK"]..'|r',
									type = "group",
									order = 3,
									disabled = true,
									guiInline = true,
									args = {
										sparkToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar,1,3,L["TOGGLE_SPARK"],nil,nil,nil,nil,'spark','Channel','channelBar'),
										iconToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.icon,2,3,L["TOGGLE_ICON"],nil,nil,nil,nil,'isEnabled','Channel','channelBar'),
										iconJustify = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.icon,3,3,L["LABEL_ICON_JUSTIFY"],L["TOOLTIP_STATUSBAR_ICON_LOCATION"],nil,ICON_JUSTIFY,nil,nil,'justify','Channel','channelBar'),
									},
								},
								nametext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_SPELL"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext,1,3,L["TOGGLE_SPELL_TEXT"],L["TOOLTIP_TOGGLE_SPELL_TEXT"],"single",false,nil,'isDisplayText','Channel','channelBar'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,2,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Channel','channelBar'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,3,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Channel','channelBar'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,4,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Channel','channelBar'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font,5,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Channel','channelBar'),
										nametextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.nametext,6,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Channel','channelBar'),
										nametextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,7,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Channel','channelBar'),
										nametextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext,8,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Channel','channelBar'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Channel','channelBar'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Channel','channelBar'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Channel','channelBar'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.nametext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Channel','channelBar'),
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
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext,1,3,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],"single",false,nil,'isDisplayText','Channel','channelBar'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,2,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Channel','channelBar'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,3,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Channel','channelBar'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,4,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Channel','channelBar'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font,5,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Channel','channelBar'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.timetext,6,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Channel','channelBar'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,7,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Channel','channelBar'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext,8,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Channel','channelBar'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Channel','channelBar'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Channel','channelBar'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Channel','channelBar'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.timetext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Channel','channelBar'),
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
										texture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.foreground,1,3,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Channel','channelBar'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.foreground,2,3,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Channel','channelBar'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.ChannelBar.background,3,3,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Channel','channelBar'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.ChannelBar.background,4,3,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Channel','channelBar'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.ChannelBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,nil,'showBG','Channel','channelBar'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,6,3,L["LABEL_WIDTH"],nil,100,500,1,nil,nil,'width','Channel','channelBar'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.ChannelBar.layout,7,3,L["LABEL_HEIGHT"],nil,10,100,1,nil,nil,'height','Channel','channelBar'),
									},
								},
								reset = {
									order = 7,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_CHANNEL"],
									func = function()
										local bar = statusbars.bars.ChannelBar
										local default = SSA.defaults.statusbars.defaults.ChannelBar
										
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
								adjust = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.adjust,1,3,L["LABEL_STATUSBAR_MODIFY_EARTHEN_WALL"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],"full",nil,nil,'isEnabled','Earthen Wall'),
								general = {
									name = "|cFFFFFFFF"..SETTINGS.."|r",
									order = 2,
									type = "group",
									guiInline = true,
									args = {
										alphaCombat = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar,1,3,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,nil,'alphaCombat','Earthen Wall'),
										alphaOoC = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar,2,3,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,nil,'alphaOoC','Earthen Wall'),
										alphaTarget = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar,3,3,L["LABEL_ALPHA_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_TARGET_NO_COMBAT"],0,1,0.1,nil,nil,'alphaTar','Earthen Wall'),
									},
								},
								healthtext = {
									name = '|cFFFFFFFF'..L["LABEL_TEXT_HEALTH"]..'|r',
									type = "group",
									order = 3,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext,1,3,L["TOGGLE_HEALTH_TEXT"],L["TOOLTIP_TOGGLE_HEALTH_TEXT"],"single",false,nil,'isDisplayText','Earthen Wall'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font,2,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Earthen Wall'),
										fontName = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font,3,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Earthen Wall'),
										fontSize = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font,4,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Earthen Wall'),
										fontOutline = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font,5,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Earthen Wall'),
										textAnchor = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext,6,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Earthen Wall'),
										textX = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext,7,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Earthen Wall'),
										textY = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext,8,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Earthen Wall'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Earthen Wall'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Earthen Wall'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Earthen Wall'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.healthtext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Earthen Wall'),
											},
										},
									},
								},
								timetext = {
									name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
									type = "group",
									order = 4,
									disabled = true,
									guiInline = true,
									args = {
										toggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext,1,3,L["TOGGLE_TIME_TEXT"],L["TOOLTIP_TOGGLE_TIME_TEXT"],"single",false,nil,'isDisplayText','Earthen Wall'),
										color = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font,2,3,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"double",nil,'color','Earthen Wall'),
										timeFontName = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font,3,3,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Earthen Wall'),
										timeFontSize = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font,4,3,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Earthen Wall'),
										timeFontOutline = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font,5,3,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Earthen Wall'),
										timeTextAnchor = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext,6,3,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Earthen Wall'),
										timeTextX = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext,7,3,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,1,nil,nil,'x','Earthen Wall'),
										timeTextY = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext,8,3,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Earthen Wall'),
										shadow = {
											name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
											type = "group",
											order = 9,
											hidden = false,
											guiInline = true,
											args = {
												shadowToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font.shadow,1,3,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Earthen Wall'),
												shadowColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font.shadow,2,3,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Earthen Wall'),
												shadowX = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font.shadow.offset,3,3,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Earthen Wall'),
												shadowY = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timetext.font.shadow.offset,4,3,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Earthen Wall'),
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
										texture = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.foreground,1,3,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Earthen Wall'),
										textureColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.foreground,2,3,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",nil,'color','Earthen Wall'),
										timerTexture = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timerBar,3,3,L["LABEL_TIME_BAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Earthen Wall'),
										timerColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.timerBar,4,3,L["LABEL_STATUSBAR_COLOR"],nil,true,nil,nil,'color','Earthen Wall'),
										timerToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_TIMER"],L["TOOLTIP_TOGGLE_STATUSBAR_CUSTOMIZATON"],nil,nil,nil,'showTimer','Earthen Wall'),
										backgroundTexture = Auras:Select_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.background,6,3,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),nil,nil,'texture','Earthen Wall'),
										backgroundColor = Auras:Color_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.background,7,3,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,nil,'color','Earthen Wall'),
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.adjust,8,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,nil,'showBG','Earthen Wall'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.layout,9,3,L["LABEL_WIDTH"],nil,100,500,1,nil,nil,'width','Earthen Wall'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.EarthenWallTotemBar.layout,10,3,L["LABEL_HEIGHT"],nil,10,100,1,nil,nil,'height','Earthen Wall'),
									},
								},
								reset = {
									order = 6,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_EARTHEN_WALL"],
									func = function()
										local bar = statusbars.bars.EarthenWallTotemBar
										local default = SSA.defaults.statusbar[3].defaults.EarthenWallTotemBar
										
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
										animate = Auras:Toggle_VerifyDefaults(statusbars.bars.TidalWavesBar,1,3,L["LABEL_STATUSBAR_TIDAL_WAVES_ANIMATE"],nil,nil,nil,nil,'animate','Tidal Waves'),
										emptyColor = Auras:Color_VerifyDefaults(statusbars.bars.TidalWavesBar,2,3,L["LABEL_STATUSBAR_TIDAL_WAVES_EMPTY"],L["TOOLTIP_STATUSBAR_TIDAL_WAVES_EMPTY"],false,"double",nil,'emptyColor',"Tidal Waves"),
										combatDisplay = Auras:Select_VerifyDefaults(statusbars.bars.TidalWavesBar,3,3,L["LABEL_TIDAL_WAVES_DISPLAY_COMBAT"],L["TOOLTIP_TIDAL_WAVES_DISPLAY_METHOD_COMBAT"],nil,TIDAL_WAVES_OPTIONS,nil,nil,'combatDisplay','Tidal Waves'),
										OoCDisplay = Auras:Select_VerifyDefaults(statusbars.bars.TidalWavesBar,4,3,L["LABEL_TIDAL_WAVES_DISPLAY_NO_COMBAT"],L["TOOLTIP_TIDAL_WAVES_DISPLAY_METHOD_NO_COMBAT"],nil,TIDAL_WAVES_OPTIONS,nil,nil,'OoCDisplay','Tidal Waves'),
										OoCTime = Auras:Slider_VerifyDefaults(statusbars.bars.TidalWavesBar,5,3,L["LABEL_TIDAL_WAVES_DURATION_NO_COMBAT"],L["TOOLTIP_TIDAL_WAVES_TIMER_NO_TARGET_NO_COMBAT"],1,15,1,nil,nil,'OoCTime',"Tidal Waves"),
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
										backgroundToggle = Auras:Toggle_VerifyDefaults(statusbars.bars.TidalWavesBar.adjust,5,3,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,nil,nil,'showBG','Tidal Waves'),
										width = Auras:Slider_VerifyDefaults(statusbars.bars.TidalWavesBar.layout,6,3,L["LABEL_WIDTH"],nil,100,500,1,nil,nil,'width','Tidal Waves'),
										height = Auras:Slider_VerifyDefaults(statusbars.bars.TidalWavesBar.layout,7,3,L["LABEL_HEIGHT"],nil,10,100,1,nil,nil,'height','Tidal Waves'),
									},
								},
								reset = {
									order = 4,
									type = "execute",
									name = L["BUTTON_RESET_STATUSBAR_TIDAL_WAVES"],
									func = function()
										local bar = statusbars.bars.TidalWavesBar
										local default = SSA.defaults.statusbars[3].defaults.TidalWavesBar
										
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
						--[[toggle = Auras:Toggle_VerifyDefaults(cooldowns,1,3,ENABLE,L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],"full",false,'isEnabled','Cooldowns'),
						text = Auras:Toggle_Basic(cooldowns,2,L["LABEL_COOLDOWN_TEXT"],L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],not cooldowns.isEnabled,'text'),
						sweep = Auras:Toggle_Cooldowns(cooldowns,3,3,L["LABEL_COOLDOWN_SWEEP"],L["TOOLTIP_TOGGLE_COOLDOWN_SWEEP"],not cooldowns.isEnabled,'sweep','AuraBase','Cooldowns'),
						GCD = Auras:Toggle_Basic(cooldowns.GCD,4,L["LABEL_COOLDOWN_GCD"],L["TOOLTIP_TOGGLE_COOLDOWN_GCD"],not cooldowns.sweep and not cooldowns.isEnabled,'isEnabled'),
						inverse = Auras:Toggle_Cooldowns(cooldowns,5,3,L["LABEL_COOLDOWN_REVERSE_SWEEP"],L["TOOLTIP_COOLDOWN_REVERSE_SWEEP"],not cooldowns.sweep and not cooldowns.isEnabled,'inverse','AuraBase'),
						bling = Auras:Toggle_Cooldowns(cooldowns,6,3,L["LABEL_COOLDOWN_BLING"],L["TOOLTIP_TOGGLE_COOLDOWN_BLING"],not cooldowns.sweep and not cooldowns.isEnabled,'blind','AuraBase'),]]
						adjustToggle = Auras:Toggle_VerifyDefaults(cooldowns,1,3,L["LABEL_COOLDOWN_ADJUST"],nil,2.5,false,nil,'adjust','Cooldowns'),
						group = Auras:Select_VerifyDefaults(cooldowns,2,3,L["LABEL_COOLDOWN_GROUP"],L["TOOLTIP_AURAS_GROUP_SELECT"],nil,COOLDOWN_OPTIONS,0.8,not cooldowns.isEnabled,'selected','Cooldowns',nil,false,true),
						cdGroups = {
							name = "Cooldown Groups",
							order = 3,
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
	ACFG:RegisterOptionsTable("ShamanAuras General Options", GetGeneralOptions)
	ACFG:RegisterOptionsTable("ShamanAuras Elemental Auras", GetElementalOptions)
	ACFG:RegisterOptionsTable("ShamanAuras Enhancement Auras", GetEnhancementOptions)
	ACFG:RegisterOptionsTable("ShamanAuras Restoration Auras", GetRestorationOptions)
	--ACFG:RegisterOptionsTable("ShamanAuras Settings", GetSettingsOptions)

	local ACD = LibStub("AceConfigDialog-3.0")
	ACD:AddToBlizOptions("ShamanAuras General Options", "General Options", "ShamanAuras")
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
		Auras:VerifyDefaultValues(1,ele_options,'Fulmination')
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
		Auras:VerifyDefaultValues(2,enh_options,'MaelstromWeapon','All')
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
	
	db.statusbars[1].bars.FulminationBar.adjust.isEnabled = false
	db.statusbars[1].bars.CastBar.adjust.isEnabled = false
	db.statusbars[1].bars.ChannelBar.adjust.isEnabled = false
	db.statusbars[1].bars.IcefuryBar.adjust.isEnabled = false
	
	for k,v in pairs(db.timerbars[1].bars) do
		if (v.isAdjust) then
			v.isAdjust = false
			if (db.timerbars[1].groups[v.layout.group].isAdjust) then
				db.timerbars[1].groups[v.layout.group].isAdjust = false
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