local SSA, Auras = unpack(select(2,...))
local LSM = LibStub("LibSharedMedia-3.0")

local function IsPvPZone()
	local pvpType = GetZonePVPInfo()
	if ((C_PvP.IsPVPMap() or (C_PvP.IsWarModeDesired() and not IsInInstance())) and pvpType ~= "sanctuary") then
		return true
	else
		return false
	end
end



local defaults = {
	auras = {
		[1] = {
			groups = {
				[1] = {
					auraCount = 5,
					name = "Primary #1",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[2] = {
					auraCount = 6,
					name = "Primary #2",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[3] = {
					auraCount = 6,
					name = "Buff Auras",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[4] = {
					auraCount = 6,
					name = "PvP Auras",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[5] = {
					auraCount = 6,
					name = "Secondary #1",
					icon = 25,
					spacing = 30,
					charges = 13.5,
					orientation = "Vertical",
					isAdjust = false,
				},
				[6] = {
					auraCount = 5,
					name = "Secondary #2",
					icon = 25,
					spacing = 30,
					charges = 13.5,
					orientation = "Vertical",
					isAdjust = false,
				},
			},
			frames = {
				[1] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -180,
					width = 250,
					height = 50,
				},
				[2] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -225,
					width = 250,
					height = 50,
				},
				[3] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -105,
					width = 100,
					height = 50,
				},
				[4] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -60,
					width = 100,
					height = 50,
				},
				[5] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = -175,
					y = -170,
					width = 35,
					height = 160,
				},
				[6] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 175,
					y = -170,
					width = 35,
					height = 160,
				},
			},
			cooldowns = {
				isEnabled = true,
				text = true,
				sweep = true,
				inverse = false,
				bling = true,
				interrupted = false,
				adjust = false,
				selected = 1,
				GCD = {
					isEnabled = false,
					length = 0,
					sweep = true,
					bling = true,
				},
				groups = {
					[1] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[2] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[3] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[4] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[5] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[6] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
				},
			},
			auras = {
				["Adaptation"] = {
					group = 4,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 60,
							},
						},
						
					},
				},
				["AncestralGuidance"] = {
					group = 5,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 120,
							},
						},
						
					},
				},
				["Ascendance"] = {
					group = 2,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 180,
							},
						},
						
					},
				},
				["AstralShift"] = {
					group = 5,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 90,
							},
						},
						
					},
				},
				["CapacitorTotem"] = {
					group = 6,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 60,
							},
						},
						
					},
				},
				["CleanseSpirit"] = {
					group = 5,
					order = 6,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["CounterstrikeTotem"] = {
					group = 4,
					order = 5,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 45,
							},
						},
						
					},
				},
				["EarthElemental"] = {
					group = 6,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 300,
							},
						},
						
					},
				},
				["EarthShield"] = {
					group = 3,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 60,
								min = 1,
								max = 540,
							},
							["charges"] = {
								threshold = 3,
								min = 1,
								max = 9,
							},
						},
						
					},
				},
				["EarthShock"] = {
					group = 1,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["EarthbindTotem"] = {
					group = 6,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 5,
								min = 1,
								max = 30,
							},
						},
						
					},
				},
				["EarthenStrength"] = {
					group = 3,
					order = 6,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["Earthquake"] = {
					group = 1,
					order = 4,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["ElementalBlast"] = {
					group = 1,
					order = 5,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["ExposedElements"] = {
					group = 3,
					order = 3,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["FireElemental"] = {
					group = 2,
					order = 1,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["FlameShock"] = {
					group = 1,
					order = 1,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["GladiatorsMedallion"] = {
					group = 4,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 120,
							},
						},
						
					},
				},
				["GroundingTotem"] = {
					group = 4,
					order = 6,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 5,
								min = 1,
								max = 30,
							},
						},
						
					},
				},
				["Hex"] = {
					group = 5,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 5,
								min = 1,
								max = 30,
							},
						},
						
					},
				},
				["Icefury"] = {
					group = 2,
					order = 6,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["LavaBurst"]  = {
					group = 1,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "all",
							["time"] = {
								threshold = 2,
								min = 1,
								max = 8,
							},
							["buffs"] = {
								["lava_Surge"] = true,
								["ascendance"] = false,
							},
						},
						
					},
				},
				["LightningLasso"] = {
					group = 4,
					order = 3,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["LiquidMagmaTotem"] = {
					group = 2,
					order = 5,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["MasterOfElements"] = {
					group = 3,
					order = 5,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["NaturesGuardian"] = {
					group = 3,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 45,
							},
						},
						
					},
				},
				["SkyfuryTotem"] = {
					group = 4,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 5,
								min = 1,
								max = 40,
							},
						},
						
					},
				},
				["StormElemental"] = {
					group = 2,
					order = 2,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["Stormkeeper"] = {
					group = 2,
					order = 3,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["Thunderstorm"] = {
					group = 6,
					order = 1,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["TremorTotem"] = {
					group = 6,
					order = 5,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 60,
							},
						},
						
					},
				},
				["UnlimitedPower"] = {
					--condition = function() return select(4,GetTalentInfo(7,1,1)) end,
					--spellID = 260895,
					group = 3,
					order = 1,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["WindRushTotem"] = {
					--condition = function() return select(4,GetTalentInfo(5,3,1)) end,
					--spellID = 192077,
					group = 5,
					order = 5,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 120,
							},
						},
						
					},
				},
				["WindShear"] = {
					--condition = function() return IsSpellKnown(57994) end,
					--spellID = 57994,
					group = 5,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							cooldown = {
								isEnabled = false,
								groupName = "Spell Cooldown",
								threshold = 3,
								min = 1,
								max = 12,
								show = "all",
							},
							interrupt = {
								isEnabled = true,
								groupName = "Spell Interrupt",
								combat = "all",
							},
						},
					},
				},
			},
		},
		[2] = {
			groups = {
				[1] = {
					auraCount = 5,
					name = "Primary #1",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[2] = {
					auraCount = 5,
					name = "Primary #2",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[3] = {
					auraCount = 3,
					name = "Buff Auras",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[4] = {
					auraCount = 8,
					name = "PvP Auras",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[5] = {
					auraCount = 5,
					name = "Secondary #1",
					icon = 25,
					spacing = 30,
					charges = 13.5,
					orientation = "Vertical",
					isAdjust = false,
				},
				[6] = {
					auraCount = 5,
					name = "Secondary #2",
					icon = 25,
					spacing = 30,
					charges = 13.5,
					orientation = "Vertical",
					isAdjust = false,
				},
			},
			frames = {
				[1] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -180,
					width = 250,
					height = 50,
				},
				[2] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -225,
					width = 250,
					height = 50,
				},
				[3] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -105,
					width = 100,
					height = 50,
				},
				[4] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -60,
					width = 100,
					height = 50,
				},
				[5] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = -175,
					y = -170,
					width = 35,
					height = 160,
				},
				[6] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 175,
					y = -170,
					width = 35,
					height = 160,
				},
			},
			cooldowns = {
				isEnabled = true,
				text = true,
				sweep = true,
				inverse = false,
				bling = true,
				interrupted = false,
				adjust = false,
				selected = 1,
				GCD = {
					isEnabled = false,
					length = 0,
					sweep = true,
					bling = true,
				},
				groups = {
					[1] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[2] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[3] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[4] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[5] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[6] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
				},
			},
			auras = {
				["Adaptation"] = {
					group = 3,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 1,
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["Ascendance"] = {
					group = 2,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 180,
							},
						},
						
					},
				},
				["AstralShift"] = {
					group = 5,
					order = 5,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 90,
							},
						},
						
					},
				},
				["CapacitorTotem"] = {
					group = 6,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 60,
							},
						},
						
					},
				},
				["CleanseSpirit"] = {
					group = 5,
					order = 3,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["CounterstrikeTotem"] = {
					group = 4,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 45,
							},
						},
						
					},
				},
				["CrashLightning"] = {
					group = 1,
					order = 4,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["EarthElemental"] = {
					group = 0,
					order = 0,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 300,
							},
						},
						
					},
				},
				["EarthShield"] = {
					group = 3,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 60,
								min = 1,
								max = 540,
							},
							["charges"] = {
								threshold = 3,
								min = 1,
								max = 9,
							},
						},
						
					},
				},
				["EarthbindTotem"] = {
					group = 6,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 5,
								min = 1,
								max = 30,
							},
						},
						
					},
				},
				["EarthenSpike"] = {
					group = 2,
					order = 3,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["EtherealForm"] = {
					group = 4,
					order = 5,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["FeralLunge"] = {
					group = 6,
					order = 5,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["FeralSpirit"] = {
					group = 2,
					order = 5,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["Flametongue"] = {
					group = 1,
					order = 1,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["ForcefulWinds"] = {
					group = 3,
					order = 1,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["Frostbrand"] = {
					group = 1,
					order = 2,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["GladiatorsMedallion"] = {
					group = 4,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 120,
							},
						},
						
					},
				},
				["GroundingTotem"] = {
					group = 4,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 5,
								min = 1,
								max = 30,
							},
						},
						
					},
				},
				["Hex"] = {
					group = 5,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 5,
								min = 1,
								max = 30,
							},
						},
						
					},
				},
				["LavaLash"] = {
					group = 1,
					order = 5,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["NaturesGuardian"] = {
					group = 3,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 45,
							},
						},
						
					},
				},
				["Rockbiter"] = {
					group = 2,
					order = 1,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["SkyfuryTotem"] = {
					group = 4,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 5,
								min = 1,
								max = 40,
							},
						},
						
					},
				},
				["SpiritWalk"] = {
					group = 5,
					order = 4,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["StaticCling"] = {
					group = 4,
					order = 6,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["Stormstrike"] = {
					group = 1,
					order = 3,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["Sundering"] = {
					group = 2,
					order = 4,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["Thundercharge"] = {
					group = 4,
					order = 7,
					isEnabled = true,
					isInUse = true,
					isCustomize = false,
					glow = {
						isEnabled = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								min = 5,
								max = 60,
							},
						},
						
					},
				},
				["TremorTotem"] = {
					group = 6,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 60,
							},
						},
						
					},
				},
				["WindRushTotem"] = {
					group = 6,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "time",
							["time"] = {
								threshold = 10,
								min = 1,
								max = 120,
							},
						},
						
					},
				},
				["WindShear"] = {
					group = 5,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							cooldown = {
								isEnabled = false,
								groupName = "Cooldown Glow",
								threshold = 3,
								min = 1,
								max = 12,
								show = "all",
							},
							interrupt = {
								isEnabled = true,
								groupName = "Spell Interrupt",
								combat = "all",
							},
						},
					},
				},
			},
		},
		[3] = {
			groups = {
				[1] = {
					auraCount = 6,
					name = "Primary #1",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[2] = {
					auraCount = 7,
					name = "Primary #2",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[3] = {
					auraCount = 3,
					name = "Buff Auras",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[4] = {
					auraCount = 6,
					name = "PvP Auras",
					icon = 32,
					spacing = 50,
					charges = 13.5,
					orientation = "Horizontal",
					isAdjust = false,
				},
				[5] = {
					auraCount = 5,
					name = "Secondary #1",
					icon = 25,
					spacing = 30,
					charges = 13.5,
					orientation = "Vertical",
					isAdjust = false,
				},
				[6] = {
					auraCount = 5,
					name = "Secondary #2",
					icon = 25,
					spacing = 30,
					charges = 13.5,
					orientation = "Vertical",
					isAdjust = false,
				},
			},
			frames = {
				[1] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -180,
					width = 250,
					height = 50,
				},
				[2] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -225,
					width = 250,
					height = 50,
				},
				[3] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -105,
					width = 100,
					height = 50,
				},
				[4] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -60,
					width = 100,
					height = 50,
				},
				[5] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = -175,
					y = -170,
					width = 35,
					height = 160,
				},
				[6] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 175,
					y = -170,
					width = 35,
					height = 160,
				},
			},
			cooldowns = {
				isEnabled = true,
				text = true,
				sweep = true,
				inverse = false,
				bling = true,
				interrupted = false,
				adjust = false,
				selected = 1,
				GCD = {
					isEnabled = false,
					length = 0,
					sweep = true,
					bling = true,
				},
				groups = {
					[1] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[2] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[3] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[4] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[5] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
					[6] = {
						isPreview = false,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							formatting = {
								length = "full",
								decimals = false,
								alert = {
									isEnabled = false,
									threshold = 5,
									animate = false,
									color = {
										r = 1,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
					},
				},
			},
			auras = {
				["Adaptation"] = {
					group = 4,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 60,
								pulseRate = 1,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["AncestralProtectionTotem"] = {
					group = 2,
					order = 6,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 300,
								pulseRate = 1,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["Ascendance"] = {
					group = 2,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = true,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 180,
								pulseRate = 1,
								displayTime = 5,
								show = "on",
								combat = "on",
							},
						},
					},
				},
				["AstralShift"] = {
					group = 5,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 90,
								pulseRate = 1,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["CapacitorTotem"] = {
					group = 6,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 60,
								pulseRate = 1,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["CloudburstTotem"] = {
					group = 1,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 5,
								start = 0,
								duration = 30,
								pulseRate = 1,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["CounterstrikeTotem"] = {
					group = 4,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 5,
								start = 0,
								duration = 45,
								pulseRate = 1,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["Downpour"] = {
					group = 1,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 60,
								pulseRate = 1,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["EarthElemental"] = {
					group = 0,
					order = 0,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 300,
								pulseRate = 1,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["EarthShield"] = {
					group = 3,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = true,
								isActive = false,
								type = "charges",
								name = "Buff Stacks",
								spellID = 974,
								threshold = 3,
								start = 0,
								charges = 9,
								pulseRate = 2,
								displayTime = 5,
								disableShow = true,
								combat = "all",
							},
							[2] = {
								isEnabled = true,
								isActive = false,
								type = "buff",
								name = "Buff Duration",
								spellID = 974,
								threshold = 60,
								start = 0,
								duration = 600,
								pulseRate = 0.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["EarthbindTotem"] = {
					group = 6,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 5,
								start = 0,
								duration = 30,
								pulseRate = 1,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["EarthenWallTotem"] = {
					group = 2,
					order = 5,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 60,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["EarthgrabTotem"] = {
					group = 6,
					order = 5,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 60,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["FlameShock"] = {
					group = 6,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = true,
								type = "debuff",
								name = "Debuff Duration",
								threshold = 10,
								start = 0,
								duration = 27,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["FlashFlood"] = {
					group = 3,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = true,
								type = "buff",
								name = "Buff Duration",
								threshold = 5,
								start = 0,
								duration = 15,
								pulseRate = 1.5,
								displayTime = 0,
								show = "on",
								combat = "on",
							},
						},
					},
				},
				["GladiatorsMedallion"] = {
					group = 4,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 120,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["GroundingTotem"] = {
					group = 4,
					order = 5,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 5,
								start = 0,
								duration = 30,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["HealingRain"] = {
					group = 1,
					order = 5,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 3,
								start = 0,
								duration = 10,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["HealingStreamTotem"] = {
					group = 1,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 5,
								start = 0,
								duration = 30,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["HealingTideTotem"] = {
					group = 2,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 180,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["Hex"] = {
					group = 5,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = true,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 5,
								start = 0,
								duration = 30,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["LavaBurst"] = {
					group = 6,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							[1] = {
								isEnabled = true,
								type = "buff",
								name = "Lava Surge Proc",
								threshold = false,
								pulseRate = 1.5,
								displayTime = false,
								show = "on",
								combat = "on",
							},
							[2] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 2,
								start = 0,
								duration = 8,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["NaturesGuardian"] = {
					group = 3,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 45,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["PurifySpirit"] = {
					group = 5,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 2,
								start = 0,
								duration = 8,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["Riptide"] = {
					group = 1,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = true,
								type = "buff",
								name = "Buff Duration",
								spellID = 53390,
								threshold = 5,
								start = 0,
								duration = 15,
								pulseRate = 0.5,
								displayTime = 5,
								show = "on",
								combat = "on",
							},
							[2] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								spellID = 61295,
								threshold = 2,
								start = 0,
								duration = 6,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["SkyfuryTotem"] = {
					group = 4,
					order = 3,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 5,
								start = 0,
								duration = 40,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["SpiritLinkTotem"] = {
					group = 2,
					order = 2,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 180,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["SpiritwalkersGrace"] = {
					group = 5,
					order = 5,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 120,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["Tidebringer"] = {
					group = 4,
					order = 6,
					isEnabled = true,
					isInUse = true,
					--[[glow = {
						isEnabled = false,
						isCustomize = false,
						states = {
							combat = "both",
							usable = "always",
						},
						triggers = {
							selected = "buff",
							["buffs"] = {
								["tidebringer"] = false,
							},
						},
						
					},]]
				},
				["TremorTotem"] = {
					group = 6,
					order = 6,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 60,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["UnleashLife"] = {
					group = 1,
					order = 6,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 5,
								start = 0,
								duration = 15,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["Wellspring"] = {
					group = 2,
					order = 4,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 5,
								start = 0,
								duration = 20,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["WindRushTotem"] = {
					group = 2,
					order = 7,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 10,
								start = 0,
								duration = 120,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
						},
					},
				},
				["WindShear"] = {
					group = 5,
					order = 1,
					isEnabled = true,
					isInUse = true,
					glow = {
						isCustomize = false,
						triggers = {
							[1] = {
								isEnabled = false,
								type = "cooldown",
								name = "Spell Cooldown",
								threshold = 3,
								start = 0,
								duration = 12,
								pulseRate = 1.5,
								displayTime = 5,
								show = "all",
								combat = "on",
							},
							[2] = {
								isEnabled = true,
								type = "interrupt",
								name = "Spell Interrupt",
								threshold = false,
								pulseRate = 1.5,
								displayTime = false,
								show = false,
								combat = "on",
							},
							--[[interrupt = {
								isEnabled = true,
								groupName = "Spell Interrupt",
								combat = "all",
							},]]
						},
					},
				},
			},
		},
		templates = {
			groups = {
				auraCount = 0,
				name = '',
				icon = 32,
				spacing = 50,
				charges = 13.5,
				orientation = "Horizontal",
				isAdjust = false,
			},
			frames = {
				isEnabled = true,
				point = "CENTER",
				relativeTo = 'AuraBase',
				relativePoint = "CENTER",
				x = 0,
				y = 0,
				width = 50,
				height = 50,
			},
			cooldowns = {
				isPreview = false,
				text = {
					justify = "CENTER",
					x = 0,
					y = 0,
					formatting = {
						length = "full",
						decimals = false,
						alert = {
							isEnabled = false,
							threshold = 5,
							animate = false,
							color = {
								r = 1,
								g = 0,
								b = 0,
								a = 1,
							},
						},
					},
					font = {
						name = "Friz Quadrata TT",
						size = 12,
						flag = "OUTLINE",
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 1,
						},
						shadow = {
							offset = {
								x = 2,
								y = -2,
							},
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 1,
							},
						},
					},
				},
			},
		},
	},
	timerbars = {
		[1] = {
			groups = {
				[1] = {
					barCount = 9,
					name = "Buff Timers",
					layout = {
						width = 175,
						height = 17,
						growth = "RIGHT",
						orientation = "VERTICAL",
						anchor = "CENTER",
						spacing = 5,
						strata = "LOW",
					},
					nametext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					alphaCombat = 1,
					alphaOoC = 0.5,
					isAdjust = false,
				},
				[2] = {
					barCount = 7,
					name = "Utility Timers",
					layout = {
						width = 175,
						height = 17,
						growth = "LEFT",
						anchor = "CENTER",
						orientation = "VERTICAL",
						spacing = 5,
					},
					nametext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					alphaCombat = 1,
					alphaOoC = 0.5,
					isAdjust = false,
				},
			},
			frames = {
				[1] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 200,
					y = -125,
					width = 17,
					height = 175,
				},
				[2] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = -200,
					y = -125,
					width = 17,
					height = 175,
				},
			},
			bars = {
				["AncestralGuidanceBar"] = {
					layout = {
						group = 1,
						text = "Ancestral Guidance",
						texture = "Glamour2",
						color = {
							r = 0.2,
							g = 0.42,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["AscendanceBar"] = {
					layout = {
						group = 1,
						text = "Ascendance",
						texture = "Glamour2",
						color = {
							r = 0.98,
							g = 0.58,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["AstralShiftBar"] = {
					layout = {
						group = 1,
						text = "Astral Shift",
						texture = "Glamour2",
						color = {
							r = 0.94,
							g = 0.22,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["BloodlustBar"] = {
					layout = {
						group = 1,
						text = "Bloodlust",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.07,
							b = 0.30,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["CounterstrikeTotemBar"] = {
					layout = {
						group = 2,
						text = "Counterstrike Totem",
						texture = "Glamour2",
						color = {
							r = 0.22,
							g = 0.24,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["EarthElementalBar"] = {
					layout = {
						group = 2,
						text = "Earth Elemental",
						texture = "Glamour2",
						color = {
							r = 0.84,
							g = 0.65,
							b = 0.51,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["EarthbindTotemBar"] = {
					layout = {
						group = 2,
						text = "Earthbind Totem",
						texture = "Glamour2",
						color = {
							r = 0.50,
							g = 0.69,
							b = 0.38,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["ElementalBlastBarCrit"] = {
					layout = {
						group = 1,
						text = "Critical Strike",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.39,
							b = 0.60,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["ElementalBlastBarHaste"] = {
					layout = {
						group = 1,
						text = "Haste",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.39,
							b = 0.60,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["ElementalBlastBarMastery"] = {
					layout = {
						group = 1,
						text = "Mastery",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.39,
							b = 0.60,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["EmberElementalBar"] = {
					layout = {
						group = 2,
						text = "Ember Elemental",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.63,
							b = 0.17,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["FireElementalBar"] = {
					layout = {
						group = 2,
						text = "Fire Elemental",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.63,
							b = 0.17,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["GroundingTotemBar"] = {
					layout = {
						group = 2,
						text = "Grounding Totem",
						texture = "Glamour2",
						color = {
							r = 0.34,
							g = 0,
							b = 0.84,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["HeroismBar"] = {
					layout = {
						group = 1,
						text = "Heroism",
						texture = "Glamour2",
						color = {
							r = 0,
							g = 0.47,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["HexBar"] = {
					layout = {
						group = 2,
						text = "Hex",
						texture = "Glamour2",
						color = {
							r = 0.30,
							g = 0.76,
							b = 0.28,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["LiquidMagmaTotemBar"] = {
					layout = {
						group = 2,
						text = "Liquid Magma Totem",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.40,
							b = 0.25,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["PrimalEarthElementalBar"] = {
					layout = {
						group = 2,
						text = "Primal Earth Elemental",
						texture = "Glamour2",
						color = {
							r = 0.84,
							g = 0.65,
							b = 0.51,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["PrimalFireElementalBar"] = {
					layout = {
						group = 2,
						text = "Primal Fire Elemental",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.63,
							b = 0.17,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["PrimalStormElementalBar"] = {
					layout = {
						group = 2,
						text = "Primal Storm Elemental",
						texture = "Glamour2",
						color = {
							r = 0.43,
							g = 0.57,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["SkyfuryTotemBar"] = {
					layout = {
						group = 2,
						text = "Skyfury Totem",
						texture = "Glamour2",
						color = {
							r = 0.74,
							g = 0,
							b = 0.05,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["StormElementalBar"] = {
					layout = {
						group = 2,
						text = "Storm Elemental",
						texture = "Glamour2",
						color = {
							r = 0.43,
							g = 0.57,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["TimeWarpBar"] = {
					layout = {
						group = 1,
						text = "Time Warp",
						texture = "Glamour2",
						color = {
							r = 0.76,
							g = 0.16,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["TremorTotemBar"] = {
					layout = {
						group = 2,
						text = "Tremor Totem",
						texture = "Glamour2",
						color = {
							r = 0.86,
							g = 0.68,
							b = 0,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["WindRushTotemBar"] = {
					layout = {
						group = 2,
						text = "Wind Rush Totem",
						texture = "Glamour2",
						color = {
							r = 0.68,
							g = 0.76,
							b = 0.34,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
			},
		},
		[2] = {
			groups = {
				[1] = {
					barCount = 5,
					name = "Buff Timers",
					layout = {
						width = 175,
						height = 17,
						growth = "RIGHT",
						orientation = "VERTICAL",
						anchor = "CENTER",
						spacing = 5,
						strata = "LOW",
					},
					nametext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					alphaCombat = 1,
					alphaOoC = 0.5,
					isAdjust = false,
				},
				[2] = {
					barCount = 12,
					name = "Utility Timers",
					layout = {
						width = 175,
						height = 17,
						growth = "LEFT",
						anchor = "CENTER",
						orientation = "VERTICAL",
						spacing = 5,
					},
					nametext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					alphaCombat = 1,
					alphaOoC = 0.5,
					isAdjust = false,
				},
			},
			frames = {
				[1] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 200,
					y = -125,
					width = 17,
					height = 175,
				},
				[2] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = -200,
					y = -125,
					width = 17,
					height = 175,
				},
			},
			bars = {
				["AscendanceBar"] = {
					layout = {
						group = 1,
						text = "Ascendance",
						texture = "Glamour2",
						color = {
							r = 0.98,
							g = 0.58,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["AstralShiftBar"] = {
					layout = {
						group = 1,
						text = "Astral Shift",
						texture = "Glamour2",
						color = {
							r = 0.94,
							g = 0.22,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["BloodlustBar"] = {
					layout = {
						group = 1,
						text = "Bloodlust",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.07,
							b = 0.30,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["CounterstrikeTotemBar"] = {
					layout = {
						group = 2,
						text = "Counterstrike Totem",
						texture = "Glamour2",
						color = {
							r = 0.22,
							g = 0.24,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["CrashLightningBar"] = {
					layout = {
						group = 2,
						text = "Crash Lightning",
						texture = "Glamour2",
						color = {
							r = 0,
							g = 0.52,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["EarthElementalBar"] = {
					layout = {
						group = 2,
						text = "Earth Elemental",
						texture = "Glamour2",
						color = {
							r = 0.84,
							g = 0.65,
							b = 0.51,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["EarthbindTotemBar"] = {
					layout = {
						group = 2,
						text = "Earthbind Totem",
						texture = "Glamour2",
						color = {
							r = 0.50,
							g = 0.69,
							b = 0.38,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["EarthenSpikeBar"] = {
					layout = {
						group = 2,
						text = "Earthen Spike",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.07,
							b = 0.30,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["EtherealFormBar"] = {
					layout = {
						group = 2,
						text = "Ethereal Form",
						texture = "Glamour2",
						color = {
							r = 0.51,
							g = 0.51,
							b = 0.51,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["FeralSpiritBar"] = {
					layout = {
						group = 1,
						text = "Feral Spirit",
						texture = "Glamour2",
						color = {
							r = 0.33,
							g = 0,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["FlametongueBar"] = {
					layout = {
						group = 2,
						text = "Flametongue",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.63,
							b = 0.17,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["ForcefulWindsBar"] = {
					layout = {
						group = 2,
						text = "Forceful Winds",
						texture = "Glamour2",
						color = {
							r = 0.63,
							g = 0.63,
							b = 0.63,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["FrostbrandBar"] = {
					layout = {
						group = 2,
						text = "Frostbrand",
						texture = "Glamour2",
						color = {
							r = 0,
							g = 0.78,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["GroundingTotemBar"] = {
					layout = {
						group = 2,
						text = "Grounding Totem",
						texture = "Glamour2",
						color = {
							r = 0.34,
							g = 0,
							b = 0.84,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["HeroismBar"] = {
					layout = {
						group = 1,
						text = "Heroism",
						texture = "Glamour2",
						color = {
							r = 0,
							g = 0.47,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["HexBar"] = {
					layout = {
						group = 2,
						text = "Hex",
						texture = "Glamour2",
						color = {
							r = 0.30,
							g = 0.76,
							b = 0.28,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["SkyfuryTotemBar"] = {
					layout = {
						group = 2,
						text = "Skyfury Totem",
						texture = "Glamour2",
						color = {
							r = 0.74,
							g = 0,
							b = 0.05,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["SpiritWalkBar"] = {
					layout = {
						group = 2,
						text = "Spirit Walk",
						texture = "Glamour2",
						color = {
							r = 0.70,
							g = 0.51,
							b = 0.25,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["TimeWarpBar"] = {
					layout = {
						group = 1,
						text = "Time Warp",
						texture = "Glamour2",
						color = {
							r = 0.76,
							g = 0.16,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["TremorTotemBar"] = {
					layout = {
						group = 2,
						text = "Tremor Totem",
						texture = "Glamour2",
						color = {
							r = 0.86,
							g = 0.68,
							b = 0,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["WindRushTotemBar"] = {
					layout = {
						group = 2,
						text = "Wind Rush Totem",
						texture = "Glamour2",
						color = {
							r = 0.68,
							g = 0.76,
							b = 0.34,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
			},
		},
		[3] = {
			groups = {
				[1] = {
					barCount = 3,
					name = "Buff Timers",
					layout = {
						width = 175,
						height = 17,
						growth = "RIGHT",
						orientation = "VERTICAL",
						anchor = "CENTER",
						spacing = 5,
						strata = "LOW",
					},
					nametext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					alphaCombat = 1,
					alphaOoC = 0.5,
					isAdjust = false,
				},
				[2] = {
					barCount = 13,
					name = "Utility Timers",
					layout = {
						width = 175,
						height = 17,
						growth = "LEFT",
						anchor = "CENTER",
						orientation = "VERTICAL",
						spacing = 5,
					},
					nametext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					alphaCombat = 1,
					alphaOoC = 0.5,
					isAdjust = false,
				},
			},
			frames = {
				[1] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 200,
					y = -125,
					width = 17,
					height = 175,
				},
				[2] = {
					isEnabled = true,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = -200,
					y = -125,
					width = 17,
					height = 175,
				},
			},
			bars = {
				["AncestralProtectionTotemBar"] = {
					layout = {
						group = 2,
						text = "Ancestral Protection",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.20,
							b = 0.22,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["AscendanceBar"] = {
					layout = {
						group = 1,
						text = "Ascendance",
						texture = "Glamour2",
						color = {
							r = 0.98,
							g = 0.58,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["AstralShiftBar"] = {
					layout = {
						group = 1,
						text = "Astral Shift",
						texture = "Glamour2",
						color = {
							r = 0.94,
							g = 0.22,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["BloodlustBar"] = {
					layout = {
						group = 1,
						text = "Bloodlust",
						texture = "Glamour2",
						color = {
							r = 1,
							g = 0.07,
							b = 0.30,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["CloudburstTotemBar"] = {
					layout = {
						group = 2,
						text = "Cloudburst Totem",
						texture = "Glamour2",
						color = {
							r = 0.46,
							g = 0.82,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["CounterstrikeTotemBar"] = {
					layout = {
						group = 2,
						text = "Counterstrike Totem",
						texture = "Glamour2",
						color = {
							r = 0.22,
							g = 0.24,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["EarthElementalBar"] = {
					layout = {
						group = 2,
						text = "Earth Elemental",
						texture = "Glamour2",
						color = {
							r = 0.84,
							g = 0.65,
							b = 0.51,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["EarthbindTotemBar"] = {
					layout = {
						group = 2,
						text = "Earthbind Totem",
						texture = "Glamour2",
						color = {
							r = 0.50,
							g = 0.69,
							b = 0.38,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["EarthgrabTotemBar"] = {
					layout = {
						group = 2,
						text = "Earthgrab Totem",
						texture = "Glamour2",
						color = {
							r = 0.66,
							g = 0.90,
							b = 0.49,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["GroundingTotemBar"] = {
					layout = {
						group = 2,
						text = "Grounding Totem",
						texture = "Glamour2",
						color = {
							r = 0.34,
							g = 0,
							b = 0.84,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["HealingStreamTotemBarOne"] = {
					layout = {
						group = 2,
						text = "Healing Stream Totem",
						texture = "Glamour2",
						color = {
							r = 0.22,
							g = 0.80,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["HealingStreamTotemBarTwo"] = {
					layout = {
						group = 2,
						text = "Healing Stream Totem",
						texture = "Glamour2",
						color = {
							r = 0.22,
							g = 0.80,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["HealingTideTotemBar"] = {
					layout = {
						group = 2,
						text = "Healing Tide Totem",
						texture = "Glamour2",
						color = {
							r = 0,
							g = 1,
							b = 0.81,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["HeroismBar"] = {
					layout = {
						group = 1,
						text = "Heroism",
						texture = "Glamour2",
						color = {
							r = 0,
							g = 0.47,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["HexBar"] = {
					layout = {
						group = 2,
						text = "Hex",
						texture = "Glamour2",
						color = {
							r = 0.30,
							g = 0.76,
							b = 0.28,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["SkyfuryTotemBar"] = {
					layout = {
						group = 2,
						text = "Skyfury Totem",
						texture = "Glamour2",
						color = {
							r = 0.74,
							g = 0,
							b = 0.05,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["SpiritLinkTotemBar"] = {
					layout = {
						group = 2,
						text = "Spirit Link Totem",
						texture = "Glamour2",
						color = {
							r = 0.46,
							g = 0.82,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["SpiritwalkersGraceBar"] = {
					layout = {
						group = 1,
						text = "Spiritwalkers Grace",
						texture = "Glamour2",
						color = {
							r = 0.65,
							g = 1,
							b = 0.33,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["TimeWarpBar"] = {
					layout = {
						group = 1,
						text = "Time Warp",
						texture = "Glamour2",
						color = {
							r = 0.76,
							g = 0.16,
							b = 1,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["TremorTotemBar"] = {
					layout = {
						group = 2,
						text = "Tremor Totem",
						texture = "Glamour2",
						color = {
							r = 0.86,
							g = 0.68,
							b = 0,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
				["UnleashLifeBar"] = {
					layout = {
						group = 1,
						text = "Unleash Life",
						texture = "Glamour2",
						color = {
							r = 0.1,
							g = 1,
							b = 0,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = false,
				},
				["WindRushTotemBar"] = {
					layout = {
						group = 2,
						text = "Wind Rush Totem",
						texture = "Glamour2",
						color = {
							r = 0.68,
							g = 0.76,
							b = 0.34,
						},
					},
					isEnabled = true,
					isInUse = true,
					isAdjust = false,
					isCustomize = false,
					isShared = true,
				},
			},
		},
		templates = {
			groups = {
				barCount = 0,
				name = "",
				layout = {
					width = 175,
					height = 17,
					growth = "RIGHT",
					orientation = "VERTICAL",
					anchor = "CENTER",
					spacing = 5,
					strata = "LOW",
				},
				nametext = {
					isDisplayText = true,
					justify = "CENTER",
					x = 0,
					y = 0,
					font = {
						name = "Friz Quadrata TT",
						size = 12,
						flag = "OUTLINE",
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 1,
						},
						shadow = {
							isEnabled = false,
							offset = {
								x = 2,
								y = -2,
							},
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 1,
							},
						},
					},
				},
				timetext = {
					isDisplayText = true,
					justify = "CENTER",
					x = 0,
					y = 0,
					font = {
						name = "Friz Quadrata TT",
						size = 12,
						flag = "OUTLINE",
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 1,
						},
						shadow = {
							isEnabled = false,
							offset = {
								x = 2,
								y = -2,
							},
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 1,
							},
						},
					},
				},
				alphaCombat = 1,
				alphaOoC = 0.5,
				isAdjust = false,
			},
			frames = {
				isEnabled = true,
				point = "CENTER",
				relativeTo = 'AuraBase',
				relativePoint = "CENTER",
				x = 0,
				y = 0,
				width = 17,
				height = 175,
			},
		},
	},
	statusbars = {
		[1] = {
			defaultBar = false,
			bars = {
				["MaelstromBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					animate = true,
					text = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					foreground = {
						texture = 'Fifths',
						color = {
							r = 0,
							g = 0.5,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -139,
						strata = "LOW",
					},
					attachToHealth = {
						isAttached = true,
						x = 0,
						y = 0,
						point = "TOP",
					},
					justify = "CENTER",
					threshold = 90,
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
				["CastBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					nametext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					icon = {
						isEnabled = true,
						justify = "LEFT",
					},
					spark = true,
					foreground = {
						texture = 'Glamour2',
						color = {
							r = 1,
							g = 0.85,
							b = 0,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 13,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -155,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 1,
				},
				["ChannelBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					selectedText = 'Name Text',
					nametext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					icon = {
						isEnabled = true,
						justify = "LEFT",
					},
					spark = true,
					foreground = {
						texture = 'Glamour2',
						color = {
							r = 1,
							g = 0.85,
							b = 0,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 13,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -155,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 1,
				},
				["IcefuryBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
						showTimer = false,
					},
					isEnabled = true,
					counttext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					timerBar = {
						texture = 'Blizzard',
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 0.35,
						},
					},
					foreground = {
						texture = 'Fourths',
						color = {
							r = 0.66,
							g = 0.49,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -110,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
			},
			defaults = {
				["MaelstromBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					animate = true,
					text = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					foreground = {
						texture = 'Fifths',
						color = {
							r = 0,
							g = 0.5,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -139,
						strata = "LOW",
					},
					attachToHealth = {
						isAttached = true,
						x = 0,
						y = 0,
						point = "TOP",
					},
					justify = "CENTER",
					threshold = 90,
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
				["IcefuryBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
						showTimer = false,
					},
					isEnabled = true,
					counttext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					timerBar = {
						texture = 'Blizzard',
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 0.35,
						},
					},
					foreground = {
						texture = 'Fourths',
						color = {
							r = 0.66,
							g = 0.49,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -110,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
			},
		},
		[2] = {
			defaultBar = false,
			bars = {
				["MaelstromBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					animate = true,
					text = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					foreground = {
						texture = 'Fifths',
						color = {
							r = 0,
							g = 0.5,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -139,
						strata = "LOW",
					},
					attachToHealth = {
						isAttached = true,
						x = 0,
						y = 0,
						point = "TOP",
					},
					justify = "CENTER",
					threshold = 90,
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
				["CastBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					nametext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					icon = {
						isEnabled = true,
						justify = "LEFT",
					},
					spark = true,
					foreground = {
						texture = 'Glamour2',
						color = {
							r = 1,
							g = 0.85,
							b = 0,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 13,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -155,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 1,
				},
				["ChannelBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					selectedText = 'Name Text',
					nametext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					icon = {
						isEnabled = true,
						justify = "LEFT",
					},
					spark = true,
					foreground = {
						texture = 'Glamour2',
						color = {
							r = 1,
							g = 0.85,
							b = 0,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 13,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -155,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 1,
				},
			},
			defaults = {
				["MaelstromBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					animate = true,
					text = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					foreground = {
						texture = 'Fifths',
						color = {
							r = 0,
							g = 0.5,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -139,
						strata = "LOW",
					},
					attachToHealth = {
						isAttached = true,
						x = 0,
						y = 0,
						point = "TOP",
					},
					justify = "CENTER",
					threshold = 90,
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
			},
		},
		[3] = {
			defaultBar = false,
			bars = {
				["ManaBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					text = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					foreground = {
						texture = 'Fifths',
						color = {
							r = 0,
							g = 0.5,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -139,
						strata = "LOW",
					},
					precision = "Long",
					grouping = true,
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
				["CastBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					selectedText = 'Name Text',
					nametext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					icon = {
						isEnabled = true,
						justify = "LEFT",
					},
					spark = true,
					foreground = {
						texture = 'Glamour2',
						color = {
							r = 1,
							g = 0.85,
							b = 0,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 13,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -155,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 1,
				},
				["ChannelBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					selectedText = 'Name Text',
					nametext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 10,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					icon = {
						isEnabled = true,
						justify = "LEFT",
					},
					spark = true,
					foreground = {
						texture = 'Glamour2',
						color = {
							r = 1,
							g = 0.85,
							b = 0,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 13,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -155,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 1,
				},
				["EarthenWallTotemBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
						showTimer = false,
					},
					isEnabled = true,
					data = {
						spellID = 198838,
						start = 0,
						duration = 15,
						GUID = '',
						health = 0,
						damage = 0,
					},
					healthtext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					timerBar = {
						texture = 'Blizzard',
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 0.35,
						},
					},
					foreground = {
						texture = 'Fifths',
						color = {
							r = 0.66,
							g = 0.49,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -110,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
				["TidalWavesBar"] = {
					TidalWaveTime = 5,
					combatDisplay = "Always",
					OoCDisplay = "Target & On Heal",
					OoCTime = 5,
					emptyColor = {
						r = 1,
						g = 0,
						b = 0,
						a = 1,
					},
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					animate = true,
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					foreground = {
						texture = 'Halves',
						color = {
							r = 0.35,
							g = 0.76,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 225,
						height = 7,
						point = 'CENTER',
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -202,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
			},
			defaults = {
				["ManaBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					text = {
						isDisplayText = true,
						justify = "CENTER",
						x = 0,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					foreground = {
						texture = 'Fifths',
						color = {
							r = 0,
							g = 0.5,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -139,
						strata = "LOW",
					},
					precision = "Long",
					grouping = true,
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
				["EarthenWallTotemBar"] = {
					adjust = {
						isEnabled = false,
						showBG = false,
						showTimer = false,
					},
					isEnabled = true,
					data = {
						spellID = 198838,
						start = 0,
						duration = 15,
						GUID = '',
						health = 0,
						damage = 0,
					},
					healthtext = {
						isDisplayText = true,
						justify = "LEFT",
						x = 5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					timetext = {
						isDisplayText = true,
						justify = "RIGHT",
						x = -5,
						y = 0,
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								isEnabled = false,
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					timerBar = {
						texture = 'Blizzard',
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 0.35,
						},
					},
					foreground = {
						texture = 'Fifths',
						color = {
							r = 0.66,
							g = 0.49,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 260,
						height = 21,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -110,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
				["TidalWavesBar"] = {
					TidalWaveTime = 5,
					combatDisplay = "Always",
					OoCDisplay = "Target & On Heal",
					OoCTime = 5,
					emptyColor = {
						r = 1,
						g = 0,
						b = 0,
						a = 1,
					},
					adjust = {
						isEnabled = false,
						showBG = false,
					},
					isEnabled = true,
					animate = true,
					background = {
						texture = 'Flat',
						color = {
							r = 0,
							g = 0,
							b = 0,
							a = 0.5,
						},
					},
					foreground = {
						texture = 'Halves',
						color = {
							r = 0.35,
							g = 0.76,
							b = 1,
							a = 1,
						},
					},
					layout = {
						width = 225,
						height = 7,
						point = 'CENTER',
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -202,
						strata = "LOW",
					},
					alphaCombat = 1,
					alphaOoC = 0,
					alphaTar = 0.5,
				},
			},
		},
		defaults = {
			["CastBar"] = {
				adjust = {
					isEnabled = false,
					showBG = false,
				},
				isEnabled = true,
				selectedText = 'Name Text',
				nametext = {
					isDisplayText = true,
					justify = "LEFT",
					x = 5,
					y = 0,
					font = {
						name = "Friz Quadrata TT",
						size = 10,
						flag = "OUTLINE",
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 1,
						},
						shadow = {
							isEnabled = false,
							offset = {
								x = 2,
								y = -2,
							},
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 1,
							},
						},
					},
				},
				timetext = {
					isDisplayText = true,
					justify = "RIGHT",
					x = -5,
					y = 0,
					font = {
						name = "Friz Quadrata TT",
						size = 10,
						flag = "OUTLINE",
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 1,
						},
						shadow = {
							isEnabled = false,
							offset = {
								x = 2,
								y = -2,
							},
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 1,
							},
						},
					},
				},
				background = {
					texture = 'Flat',
					color = {
						r = 0,
						g = 0,
						b = 0,
						a = 0.5,
					},
				},
				icon = {
					isEnabled = true,
					justify = "LEFT",
				},
				spark = true,
				foreground = {
					texture = 'Glamour2',
					color = {
						r = 1,
						g = 0.85,
						b = 0,
						a = 1,
					},
				},
				layout = {
					width = 260,
					height = 13,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -155,
					strata = "LOW",
				},
				alphaCombat = 1,
				alphaOoC = 1,
			},
			["ChannelBar"] = {
				adjust = {
					isEnabled = false,
					showBG = false,
				},
				isEnabled = true,
				selectedText = 'Name Text',
				nametext = {
					isDisplayText = true,
					justify = "LEFT",
					x = 5,
					y = 0,
					font = {
						name = "Friz Quadrata TT",
						size = 10,
						flag = "OUTLINE",
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 1,
						},
						shadow = {
							isEnabled = false,
							offset = {
								x = 2,
								y = -2,
							},
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 1,
							},
						},
					},
				},
				timetext = {
					isDisplayText = true,
					justify = "RIGHT",
					x = -5,
					y = 0,
					font = {
						name = "Friz Quadrata TT",
						size = 10,
						flag = "OUTLINE",
						color = {
							r = 1,
							g = 1,
							b = 1,
							a = 1,
						},
						shadow = {
							isEnabled = false,
							offset = {
								x = 2,
								y = -2,
							},
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 1,
							},
						},
					},
				},
				background = {
					texture = 'Flat',
					color = {
						r = 0,
						g = 0,
						b = 0,
						a = 0.5,
					},
				},
				icon = {
					isEnabled = true,
					justify = "LEFT",
				},
				spark = true,
				foreground = {
					texture = 'Glamour2',
					color = {
						r = 1,
						g = 0.85,
						b = 0,
						a = 1,
					},
				},
				layout = {
					width = 260,
					height = 13,
					point = "CENTER",
					relativeTo = 'AuraBase',
					relativePoint = "CENTER",
					x = 0,
					y = -155,
					strata = "LOW",
				},
				alphaCombat = 1,
				alphaOoC = 1,
			},
		}
	},
}

local database = {
	char = {
		EquippedArtifact = '',
		isFirstEverLoad = true,
		version = nil,
		name = nil,
		isMoveGrid = true,
		elements = {
			AuraBase = {
				isEnabled = true,
				point = "CENTER",
				relativeTo = nil,
				relativePoint = "CENTER",
				x = 0,
				y = 0,
				width = math.ceil(GetScreenWidth() - 500),
				height = math.ceil(GetScreenHeight() - 250),
			},
			[1] = {
				isEnabled = true,
				isMoving = false,
				--[[cooldowns = {
					isEnabled = true,
					text = true,
					sweep = true,
					inverse = false,
					bling = true,
					interrupted = false,
					adjust = false,
					selected = 1,
					GCD = {
						isEnabled = false,
						length = 0,
						sweep = true,
						bling = true,
					},
					groups = {
					},
				},]]
				--[[timerbars = {
					buff = {
						isEnabled = true,
						ancestralGuidance = true,
						ascendance = true,
						astralShift = true,
						bloodlust = true,
						elementalBlast = true,
						elementalMastery = true,
						heroism = true,
						timeWarp = true,
					},
					main = {
						isEnabled = true,
						earthElemental = true,
						fireElemental = true,
						stormElemental = true,
					},
					util = {
						isEnabled = true,
						earthbindTotem = true,
						liquidMagmaTotem = true,
						windRushTotem = true,
					},
				},]]
				statusbars = {
					defaultBar = false,
					--[[healthBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						numtext = {
							isDisplayText = true,
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						perctext = {
							isDisplayText = true,
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						icon = {
							isEnabled = true,
							justify = "LEFT",
						},
						spark = true,
						foreground = {
							texture = 'Armory',
							color = {
								r = 0.8,
								g = 0,
								b = 0,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 42,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -155,
							strata = "LOW",
						},
						precision = "Long",
						grouping = true,
						alphaCombat = 1,
						alphaOoC = 1,
						alphaTar = 0.5,
					},]]
					--[[maelstromBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						animate = true,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						foreground = {
							texture = 'Fifths',
							color = {
								r = 0,
								g = 0.5,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 21,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -139,
							strata = "LOW",
						},
						attachToHealth = {
							isAttached = true,
							x = 0,
							y = 0,
							point = "TOP",
						},
						justify = "CENTER",
						threshold = 90,
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},
					castBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						nametext = {
							isDisplayText = true,
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							isDisplayText = true,
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						icon = {
							isEnabled = true,
							justify = "LEFT",
						},
						spark = true,
						foreground = {
							texture = 'Glamour2',
							color = {
								r = 1,
								g = 0.85,
								b = 0,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 13,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -155,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 1,
					},
					channelBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						selectedText = 'Name Text',
						nametext = {
							isDisplayText = true,
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							isDisplayText = true,
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						icon = {
							isEnabled = true,
							justify = "LEFT",
						},
						spark = true,
						foreground = {
							texture = 'Glamour2',
							color = {
								r = 1,
								g = 0.85,
								b = 0,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 13,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -155,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 1,
					},
					icefuryBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
							showTimer = false,
						},
						isEnabled = true,
						counttext = {
							isDisplayText = true,
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							isDisplayText = true,
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						timerBar = {
							texture = 'Blizzard',
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 0.35,
							},
						},
						foreground = {
							texture = 'Fourths',
							color = {
								r = 0.66,
								g = 0.49,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 21,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -110,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},]]
				},
				frames = {
					AuraBase = {
						x = 0,
						y = 0,
					},
					--[[auras = {
						groups = {
						},
					},
					timerbars = {
						groups = {
						},
					},]]
					--[[BuffTimerBarGrp1 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 250,
						y = -125,
						width = 115,
						height = 180,
					},
					MainTimerBarGrp1 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = -250,
						y = -125,
						width = 90,
						height = 180,
					},
					UtilTimerBarGrp1 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = -240,
						y = -125,
						width = 70,
						height = 180,
					},]]
					--[[TotemGroup1 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = -200,
						y = 0,
						width = 200,
						height = 50,
						BackdropColor = {
							r = 0.15,
							g = 0.15,
							b = 0.15,
							a = 0.6,
						}
					},]]
					TotemMastery1 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -210,
						width = 400,
						height = 180,
					},
					StormkeeperChargeGrp = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -110,
						width = 260,
						height = 50,
					}
				},
			},
			[2] = {
				isEnabled = true,
				isMoving = false,
				--[[cooldowns = {
					isEnabled = true,
					text = true,
					sweep = true,
					inverse = false,
					bling = true,
					interrupted = false,
					adjust = false,
					selected = 1,
					GCD = {
						isEnabled = false,
						length = 0,
						sweep = true,
						bling = true,
					},
					groups = {
					},
				},]]
				--[[timerbars = {
					buff = {
						isEnabled = true,
						ascendance = true,
						astralShift = true,
						bloodlust = true,
						etherealForm = true,
						heroism = true,
						hex = true,
						spiritWalk = true,
						timeWarp = true,
					},
					main = {
						isEnabled = true,
						crashLightning = true,
						earthenSpike = true,
						flametongue = true,
						frostbrand = true,
						landslide = true,
						lightningCrash = true,
					},
					util = {
						isEnabled = true,
						earthbindTotem = true,
						windRushTotem = true,
					},
				},]]
				statusbars = {
					defaultBar = false,
					--[[maelstromBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						animate = true,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						foreground = {
							texture = 'Fifths',
							color = {
								r = 0,
								g = 0.5,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 21,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -139,
							strata = "LOW",
						},
						justify = "CENTER",
						threshold = 130,
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},
					castBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						selectedText = 'Name Text',
						nametext = {
							isDisplayText = true,
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							isDisplayText = true,
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						icon = {
							isEnabled = true,
							justify = "LEFT",
						},
						spark = true,
						foreground = {
							texture = 'Glamour2',
							color = {
								r = 1,
								g = 0.85,
								b = 0,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 13,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -155,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 1,
					},
					channelBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						selectedText = 'Name Text',
						nametext = {
							isDisplayText = true,
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							isDisplayText = true,
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						icon = {
							isEnabled = true,
							justify = "LEFT",
						},
						spark = true,
						foreground = {
							texture = 'Glamour2',
							color = {
								r = 1,
								g = 0.85,
								b = 0,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 13,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -155,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 1,
					},]]
				},
				frames = {
					AuraBase = {
						x = 0,
						y = 0,
					},
					--[[auras = {
						groups = {
						},
					},
					timerbars = {
						groups = {
						},
					},]]
					--[[BuffTimerBarGrp2 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 257,
						y = -125,
						width = 131,
						height = 180,
					},
					MainTimerBarGrp2 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = -257,
						y = -125,
						width = 131,
						height = 180,
					},
					UtilTimerBarGrp2 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = -215,
						y = -125,
						width = 47,
						height = 180,
					},]]
					StormstrikeChargeGrp = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -100,
						width = 260,
						height = 50,
					},
					TotemMastery2 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = -210,
						width = 400,
						height = 180,
					},
					--[[DoomWindsTexture = { (REMOVED IN 8.0)
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = -150,
						y = 0,
						width = 125,
						height = 240,
					},]]
				},
			},
			[3] = {
				isEnabled = true,
				isMoving = false,
				--[[cooldowns = {
					isEnabled = true,
					text = true,
					sweep = true,
					inverse = false,
					bling = true,
					interrupted = false,
					adjust = false,
					selected = 1,
					GCD = {
						isEnabled = false,
						length = 0,
						sweep = true,
						bling = true,
					},
					groups = {
					},
				},]]
				--[[timerbars = {
					buff = {
						isEnabled = true,
						ascendance = true,
						astralShift = true,
						bloodlust = true,
						heroism = true,
						spiritwalkersGrace = true,
						timeWarp = true,
						unleashLife = true,
					},
					main = {
						isEnabled = true,
						ancestralProtectionTotem = true,
						cloudburstTotem = true,
						healingStreamTotemOne = true,
						healingStreamTotemTwo = true,
						healingTideTotem = true,
						spiritLinkTotem = true,
					},
					util = {
						isEnabled = true,
						earthbindTotem = true,
						earthgrabTotem = true,
						windRushTotem = true,
					},
				},]]
				statusbars = {
					defaultBar = false,
					--[[earthenWallBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
							showTimer = false,
						},
						isEnabled = true,
						healthtext = {
							isDisplayText = true,
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							isDisplayText = true,
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						timerBar = {
							texture = 'Blizzard',
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 0.35,
							},
						},
						foreground = {
							texture = 'Fifths',
							color = {
								r = 0.66,
								g = 0.49,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 21,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -110,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},
					manaBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						text = {
							isDisplayText = true,
							justify = "CENTER",
							x = 0,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						foreground = {
							texture = 'Fifths',
							color = {
								r = 0,
								g = 0.5,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 21,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -139,
							strata = "LOW",
						},
						precision = "Long",
						grouping = true,
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},
					castBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						selectedText = 'Name Text',
						nametext = {
							isDisplayText = true,
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							isDisplayText = true,
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						icon = {
							isEnabled = true,
							justify = "LEFT",
						},
						spark = true,
						foreground = {
							texture = 'Glamour2',
							color = {
								r = 1,
								g = 0.85,
								b = 0,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 13,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -155,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 1,
					},
					channelBar = {
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						selectedText = 'Name Text',
						nametext = {
							isDisplayText = true,
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							isDisplayText = true,
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									isEnabled = false,
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						icon = {
							isEnabled = true,
							justify = "LEFT",
						},
						spark = true,
						foreground = {
							texture = 'Glamour2',
							color = {
								r = 1,
								g = 0.85,
								b = 0,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 13,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -155,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 1,
					},
					tidalWavesBar = {
						TidalWaveTime = 5,
						combatDisplay = "Always",
						OoCDisplay = "Target & On Heal",
						OoCTime = 5,
						emptyColor = {
							r = 1,
							g = 0,
							b = 0,
							a = 1,
						},
						adjust = {
							isEnabled = false,
							showBG = false,
						},
						isEnabled = true,
						animate = true,
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						foreground = {
							texture = 'Halves',
							color = {
								r = 0.35,
								g = 0.76,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 225,
							height = 7,
							point = 'CENTER',
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -202,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},]]
				},
				frames = {
					AuraBase = {
						x = 0,
						y = 0,
					},
					--[[auras = {
						groups = {
						},
					},
					timerbars = {
						groups = {
						},
					},]]
					--[[BuffTimerBarGrp3 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 257,
						y = -125,
						width = 131,
						height = 180,
					},
					MainTimerBarGrp3 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = -244,
						y = -125,
						width = 105,
						height = 180,
					},
					UtilTimerBarGrp3 = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = -215,
						y = -125,
						width = 47,
						height = 180,
					},]]
					Cloudburst = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = -200,
						y = 0,
						width = 150,
						height = 40,
						BackdropColor = {
							r = 0.15,
							g = 0.15,
							b = 0.15,
							a = 0.6,
						}
					},
					Undulation = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						model = 'SPELLS/Monk_ForceSpere_Orb.m2',
						x = 0,
						y = -275,
						width = 60,
						height = 60,
					},
				},
			},
			defaults = {
				--[[cooldowns = {
					isPreview = false,
					text = {
						justify = "CENTER",
						x = 0,
						y = 0,
						formatting = {
							length = "full",
							decimals = false,
							alert = {
								isEnabled = false,
								threshold = 5,
								animate = false,
								color = {
									r = 1,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
						font = {
							name = "Friz Quadrata TT",
							size = 12,
							flag = "OUTLINE",
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1,
							},
							shadow = {
								offset = {
									x = 2,
									y = -2,
								},
								color = {
									r = 0,
									g = 0,
									b = 0,
									a = 1,
								},
							},
						},
					},
				},]]
				--[[statusbars = {
					castBar = {
						nametext = {
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name= "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						icon = {
							justify = "LEFT",
						},
						foreground = {
							texture = 'Glamour2',
							color = {
								r = 1,
								g = 0.85,
								b = 0,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 13,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -155,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 1,
					},
					channelBar = {
						nametext = {
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 10,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						icon = {
							justify = "LEFT",
						},
						foreground = {
							texture = 'Glamour2',
							color = {
								r = 1,
								g = 0.85,
								b = 0,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 13,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -155,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 1,
					},
					maelstromBar = {
						text = {
							justify = "CENTER",
							x = 0,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						foreground = {
							texture = 'Fifths',
							color = {
								r = 0,
								g = 0.5,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 21,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -139,
							strata = "LOW",
						},
						justify = "CENTER",
						threshold = 90,
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},
					icefuryBar = {
						counttext = {
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						timerBar = {
							texture = 'Blizzard',
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 0.35,
							},
						},
						foreground = {
							texture = 'Fourths',
							color = {
								r = 0.66,
								g = 0.49,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 21,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -110,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},
					manaBar = {
						text = {
							justify = "CENTER",
							x = 0,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						foreground = {
							texture = 'Fifths',
							color = {
								r = 0,
								g = 0.5,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 21,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -139,
							strata = "LOW",
						},
						precision = "Long",
						grouping = true,
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},
					earthenWallBar = {
						healthtext = {
							justify = "LEFT",
							x = 5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						timetext = {
							justify = "RIGHT",
							x = -5,
							y = 0,
							font = {
								name = "Friz Quadrata TT",
								size = 12,
								flag = "OUTLINE",
								color = {
									r = 1,
									g = 1,
									b = 1,
									a = 1,
								},
								shadow = {
									offset = {
										x = 2,
										y = -2,
									},
									color = {
										r = 0,
										g = 0,
										b = 0,
										a = 1,
									},
								},
							},
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						timerBar = {
							texture = 'Blizzard',
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 0.35,
							},
						},
						foreground = {
							texture = 'Fifths',
							color = {
								r = 0.66,
								g = 0.49,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 260,
							height = 21,
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -110,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					},
					tidalWavesBar = {
						TidalWaveTime = 5,
						combatDisplay = "Always",
						OoCDisplay = "Target & On Heal",
						OoCTime = 5,
						emptyColor = {
							r = 1,
							g = 0,
							b = 0,
							a = 1,
						},
						background = {
							texture = 'Flat',
							color = {
								r = 0,
								g = 0,
								b = 0,
								a = 0.5,
							},
						},
						foreground = {
							texture = 'Halves',
							color = {
								r = 0.35,
								g = 0.76,
								b = 1,
								a = 1,
							},
						},
						layout = {
							width = 225,
							height = 7,
							point = 'CENTER',
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -202,
							strata = "LOW",
						},
						alphaCombat = 1,
						alphaOoC = 0,
						alphaTar = 0.5,
					}
				},]]
				--[[templates = {
					auras = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = 0,
						width = 50,
						height = 50,
					},
					timerbars = {
						isEnabled = true,
						point = "CENTER",
						relativeTo = 'AuraBase',
						relativePoint = "CENTER",
						x = 0,
						y = 0,
						width = 17,
						height = 175,
					},
				},]]
				[1] = {
					--[[frames = {
						AuraBase = {
							point = "CENTER",
							relativeTo = nil,
							relativePoint = "CENTER",
							x = 0,
							y = 0,
						},
						groups = {
							[1] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -180,
							},
							[2] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -225,
							},
							[3] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -105,
							},
							[4] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -60,
							},
							[5] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = -175,
								y = -170,
							},
							[6] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 175,
								y = -170,
							},
						},
						BuffTimerBarGrp1 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 250,
							y = -125,
						},
						MainTimerBarGrp1 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = -250,
							y = -125,
						},
						UtilTimerBarGrp1 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = -240,
							y = -125,
						},
						TotemMastery1 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -210,
						},
						StormkeeperChargeGrp = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -110,
						},
					},]]
				},
				[2] = {
					--[[frames = {
						AuraBase = {
							point = "CENTER",
							relativeTo = nil,
							relativePoint = "CENTER",
							x = 0,
							y = 0,
						},
						groups = {
							[1] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -180,
							},
							[2] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -225,
							},
							[3] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -105,
							},
							[4] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -60,
							},
							[5] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = -175,
								y = -170,
							},
							[6] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 175,
								y = -170,
							},
						},
						BuffTimerBarGrp2 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 257,
							y = -125,
						},
						MainTimerBarGrp2 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = -257,
							y = -125,
						},
						UtilTimerBarGrp2 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = -215,
							y = -125,
						},
						TotemMastery2 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -210,
						},
						StormstrikeChargeGrp = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -100,
						},
					},]]
				},
				[3] = {
					--[[frames = {
						AuraBase = {
							point = "CENTER",
							relativeTo = nil,
							relativePoint = "CENTER",
							x = 0,
							y = 0,
						},
						groups = {
							[1] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -180,
							},
							[2] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -225,
							},
							[3] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -105,
							},
							[4] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 0,
								y = -60,
							},
							[5] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = -175,
								y = -170,
							},
							[6] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 175,
								y = -170,
							},
						},
						timerGroups = {
							[1] = {
								point = "CENTER",
								relativeTo = 'AuraBase',
								relativePoint = "CENTER",
								x = 257,
								y = -125,
							},
						},
						BuffTimerBarGrp3 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 257,
							y = -125,
						},
						MainTimerBarGrp3 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = -244,
							y = -125,
						},
						UtilTimerBarGrp3 = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = -215,
							y = -125,
						},
						Cloudburst = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = -200,
							y = 0,
						},
						Undulation = {
							point = "CENTER",
							relativeTo = 'AuraBase',
							relativePoint = "CENTER",
							x = 0,
							y = -275,
						},
					},]]
				},
			},
		},		
		config = {
			isDragging = false,
			LeftButton = false,
			MiddleButton = false,
			RightButton = false,
			isShiftDown = false,
			isCtrlDown = false,
			[1] = {
				isMoving = false,
				cooldown = {
					text = true,
					sweep = true,
					inverse = false,
				},
			},
			[2] = {
				isMoving = false,
				cooldown = {
					text = true,
					sweep = true,
					inverse = false,
				},
				
			},
			[3] = {
				isMoving = false,
				cooldown = {
					text = true,
					sweep = true,
					inverse = false,
				},
				
			},
			default = {
				alphaOoC = 0,
				alphaTar = 0.5,
				alphaCombat = 1,
				justify = "Center",
				animate = true,
				isAdjustable = false,
				isDisplayText = true,
				cooldown = {
					text = true,
					sweep = true,
					inverse = false,
				},
			},
		},
		settings = {
			grid = {
				gridPreview = false,
				gridColor = {
					r = 0,
					g = 0,
					b = 0,
					a = 1,
				},
				axisColor = {
					r = 1,
					g = 0,
					b = 0,
					a = 1,
				},
			},
			[1] = {
				flameShock = 10,
				totemMastery = 15,
				OoCAlpha = 0.5,
				OoRColor = {
					r = 1,
					g = 0,
					b = 0,
					a = 1,
				}
			},
			[2] = {
				rockbiter = 5,
				totemMastery = 15,
				flametongue = 5,
				frostbrand = 5,
				lavaLash = {
					stacks = {
						isEnabled = true,
						value = 99,
					},
					glow = true,
				},
				OoCAlpha = 0.5,
				OoRColor = {
					r = 1,
					g = 0,
					b = 0,
					a = 1,
				}
			},
			[3] = {
				cloudburst = 300000,
				flameShock = 10,
				OoCAlpha = 0.5,
				OoRColor = {
					r = 1,
					g = 0,
					b = 0,
					a = 1,
				},
			},
			defaults = {
				OoCAlpha = 0.5,
				OoRColor = {
					r = 1,
					g = 0,
					b = 0,
					a = 1,
				},
				[1] = {
					flameShock = 10,
					totemMastery = 15,
				},
				[2] = {
					rockbiter = 5,
					flametongue = 5,
					frostbrand = 5,
					lavaLash = {
						stacks = 99,
					},
				},
				[3] = {
					cloudburst = 300000,
					flameShock = 10,
				},
			},
		},
		
	}
}

SSA.database = database
SSA.defaults = defaults