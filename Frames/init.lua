local SSA, Auras, L, LSM = unpack(select(2,...))

-- Prepare All Move Functionality
--Auras:BuildMoveUI(1);
--Auras:BuildMoveUI(2);
--Auras:BuildMoveUI(3);

local iconSize,glowSize = 32,45
local EventFrame = CreateFrame("Frame")


-- Aura Icon Builder
--local function InitializeFrames(name,icon,isGCD,isGlow,isCharge)
local function InitializeFrame(name,db)
	--[[local db = nil
	
	for i=1,3 do
		if (Auras.db.char.auras[i].auras[name]) then
			db = Auras.db.char.auras[i].auras[name]
			break
		end
	end]]
	local Frame = CreateFrame('Frame',name)
	
	Frame:SetFrameStrata('LOW')
	Frame:SetWidth(iconSize)
	Frame:SetHeight(iconSize)

	-- Add the spell icon to the frame
	Frame.texture = Frame:CreateTexture(nil,'BACKGROUND')
	Frame.texture:SetTexture([[Interface\addons\ShamanAuras2\media\ICONS\]]..db.layout.icon)
	--Frame.texture:SetTexture([[Interface\addons\ShamanAurasDev\media\ICONS\]]..icon)
	Frame.texture:SetAllPoints(Frame)
	
	-- Build Cooldown Frame
	Frame.CD = CreateFrame('Cooldown', name..'CD', Frame, 'CooldownFrameTemplate')
	Frame.CD:SetAllPoints(Frame)
	
	Frame.CD.text = Frame.CD:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
	Frame.CD.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 18,'OUTLINE')
	Frame.CD.text:SetAllPoints(Frame.CD)
	Frame.CD.text:SetPoint('CENTER',0,0)
	Frame.CD.text:SetTextColor(1,1,0,1)
	
	-- Animation for Cooldown Frame
	Frame.CD.Flash = Frame.CD:CreateAnimationGroup()
	Frame.CD.Flash:SetLooping('BOUNCE')

	Frame.CD.Flash.fadeIn = Frame.CD.Flash:CreateAnimation('Alpha')
	Frame.CD.Flash.fadeIn:SetFromAlpha(1)
	Frame.CD.Flash.fadeIn:SetToAlpha(0.5)
	Frame.CD.Flash.fadeIn:SetDuration(0.4)
	Frame.CD.Flash.fadeIn:SetEndDelay(0.1)

	Frame.CD.Flash.fadeOut = Frame.CD.Flash:CreateAnimation('Alpha')
	Frame.CD.Flash.fadeOut:SetFromAlpha(0.5)
	Frame.CD.Flash.fadeOut:SetToAlpha(1)
	Frame.CD.Flash.fadeOut:SetDuration(0.4)
	Frame.CD.Flash.fadeOut:SetEndDelay(0.1)
	
	-- Build Cooldown Preview Frame
	Frame.PCD = CreateFrame("Cooldown", name.."PCD", Frame, "CooldownFrameTemplate");
	Frame.PCD:SetAllPoints(Frame);
	Frame.PCD:Hide();
	
	Frame.PCD.text = Frame.PCD:CreateFontString(nil, "MEDIUM", "GameFontHighlightLarge");
	Frame.PCD.text:SetPoint("CENTER",0,0);
	Frame.PCD.text:SetTextColor(1,0.85,0,1);
	
	-- Animation for Cooldown Preview
	Frame.PCD.Flash = Frame.PCD:CreateAnimationGroup()
	Frame.PCD.Flash:SetLooping('BOUNCE')

	Frame.PCD.Flash.fadeIn = Frame.PCD.Flash:CreateAnimation('Alpha')
	Frame.PCD.Flash.fadeIn:SetFromAlpha(1)
	Frame.PCD.Flash.fadeIn:SetToAlpha(0.5)
	Frame.PCD.Flash.fadeIn:SetDuration(0.4)
	Frame.PCD.Flash.fadeIn:SetEndDelay(0.1)

	Frame.PCD.Flash.fadeOut = Frame.PCD.Flash:CreateAnimation('Alpha')
	Frame.PCD.Flash.fadeOut:SetFromAlpha(0.5)
	Frame.PCD.Flash.fadeOut:SetToAlpha(1)
	Frame.PCD.Flash.fadeOut:SetDuration(0.4)
	Frame.PCD.Flash.fadeOut:SetEndDelay(0.1)
	
	-- If the current frame has a GCD (Global Cooldown) Frame, build it
	if (db.layout.isGCD) then
	--if (isGCD) then
		Frame.GCD = CreateFrame("Cooldown", name.."GCD", Frame, "CooldownFrameTemplate");
		Frame.GCD:SetAllPoints(Frame);
		Frame.GCD:Hide();
	end
	
	-- If the current frame has a glow effect, build a glow frame
	if (db.glow) then
	--if (isGlow) then
		Frame.glow = CreateFrame('Frame',name..'Glow',Frame)
		Frame.glow:SetPoint('CENTER',0,0)
		Frame.glow:SetFrameStrata('BACKGROUND')
		Frame.glow:SetWidth(glowSize)
		Frame.glow:SetHeight(glowSize)
		Frame.glow:Show()
	end
	
	-- If the current frame has charges to track, but the Charges frame
	if (db.layout.isCharge) then
	--if (isCharge) then
		Frame.ChargeCD = CreateFrame('Cooldown', name..'ChargeCD', Frame, 'CooldownFrameTemplate')
		Frame.ChargeCD:SetAllPoints(Frame)
		Frame.ChargeCD:SetFrameStrata('LOW')
		Frame.ChargeCD:Show()

		Frame.Charges = CreateFrame('Frame',name..'Charges',Frame)
		Frame.Charges:SetAllPoints(Frame)
		Frame.Charges:SetFrameStrata("MEDIUM")
		Frame.Charges:SetWidth(iconSize)
		Frame.Charges:SetHeight(iconSize)

		Frame.Charges.text = Frame.Charges:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
		Frame.Charges.text:SetPoint('BOTTOMRIGHT',-3,3)
		Frame.Charges.text:SetFont((LSM.MediaTable.font['PT Sans Narrow'] or LSM.DefaultMedia.font), 13.5,'OUTLINE')
		Frame.Charges.text:SetTextColor(1,1,1,1)		
	end
	
	SSA[name] = Frame
	_G['SSA_'..name] = Frame
end


-- Build Aura Group Containers
local AuraBase = Auras:CreateGroup('AuraBase',UIParent)
AuraBase:SetPoint("CENTER",0,0)
AuraBase:SetScript('OnUpdate',function(self,button)
	Auras:ToggleFrameMove(self,Auras.db.char.elements.isMoving)
end)

AuraBase:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseDown(self,'AuraBase',button)
	end
end)

AuraBase:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[self:GetName()])
	end
end)

_G['SSA_AuraBase'] = AuraBase



--local function InitializeAuras()
	for i=1,3 do
		for k,v in pairs(SSA.defaults.auras[i].auras) do
			if (not SSA[k]) then
				InitializeFrame(k,v)
			end
		end
	end
--end
--Build Icon Frames Used by Multiple Shaman Specializations
-- InitializeFrames('Adaptation')
-- InitializeFrames('AncestralGuidance')
-- InitializeFrames('Ascendance')
-- InitializeFrames('AstralShift')
-- InitializeFrames('CapacitorTotem')
-- InitializeFrames('CleanseSpirit')
-- InitializeFrames('CounterstrikeTotem')
-- InitializeFrames('EarthbindTotem')
-- InitializeFrames('GladiatorsMedallion')
-- InitializeFrames('GroundingTotem')
-- InitializeFrames('Hex')
-- InitializeFrames('LavaBurst')
-- InitializeFrames('NaturesGuardian')
-- InitializeFrames('SkyfuryTotem')
-- InitializeFrames('TremorTotem')
-- InitializeFrames('WindRushTotem')
-- InitializeFrames('WindShear')

--Build Icon Frames Used by Elemental Shamans
-- InitializeFrames('EarthElemental')
-- InitializeFrames('EarthShock')
-- InitializeFrames('EarthShield')
-- InitializeFrames('EarthenStrength')
-- InitializeFrames('Earthquake')
-- InitializeFrames('ElementalBlast')
-- InitializeFrames('ExposedElements')
-- InitializeFrames('FireElemental')
-- InitializeFrames('FlameShock')
-- InitializeFrames('Icefury')
-- InitializeFrames('LightningLasso')
-- InitializeFrames('LiquidMagmaTotem')
-- InitializeFrames('MasterOfElements')
-- InitializeFrames('StormElemental')
-- InitializeFrames('Stormkeeper')
-- InitializeFrames('Thunderstorm')
-- InitializeFrames('UnlimitedPower')

--Build Icon Frames Used by Enhancement Shamans
-- InitializeFrames('CrashLightning')
-- InitializeFrames('EarthenSpike')
-- InitializeFrames('EtherealForm')
-- InitializeFrames('FeralLunge')
-- InitializeFrames('FeralSpirit')
-- InitializeFrames('Flametongue')
-- InitializeFrames('ForcefulWinds')
-- InitializeFrames('Frostbrand')
-- InitializeFrames('LavaLash')
-- InitializeFrames('Rockbiter')
-- InitializeFrames('SpiritWalk')
-- InitializeFrames('StaticCling')
-- InitializeFrames('Stormstrike')
-- InitializeFrames('Sundering')
-- InitializeFrames('Thundercharge')

-- InitializeFrames('AncestralProtectionTotem')
-- InitializeFrames('CloudburstTotem')
-- InitializeFrames('Downpour')
-- InitializeFrames('EarthenWallTotem')
-- InitializeFrames('EarthgrabTotem')
-- InitializeFrames('FlashFlood')
-- InitializeFrames('HealingRain')
-- InitializeFrames('HealingStreamTotem')
-- InitializeFrames('HealingTideTotem')
-- InitializeFrames('PurifySpirit')
-- InitializeFrames('Riptide')
-- InitializeFrames('SpiritLinkTotem')
-- InitializeFrames('SpiritwalkersGrace')
-- InitializeFrames('Tidebringer')
-- InitializeFrames('UnleashLife')
-- InitializeFrames('Wellspring')

--Build Icon Frames Used by Multiple Shaman Specializations
-- InitializeFrames('Adaptation',[[shared\adaptation]])
-- InitializeFrames('AncestralGuidance',[[shared\ancestral_guidance]],true)
-- InitializeFrames('Ascendance',[[shared\ascendance]],true)
-- InitializeFrames('AstralShift',[[shared\astral_shift]],true)
-- InitializeFrames('CapacitorTotem',[[totems\capacitor_totem]],true)
-- InitializeFrames('CleanseSpirit',[[restoration\purify_spirit]],true)
-- InitializeFrames('CounterstrikeTotem',[[totems\totem_mastery]],true)
-- InitializeFrames('EarthbindTotem',[[totems\earthbind_totem]],true)
-- InitializeFrames('GladiatorsMedallion',[[shared\gladiators_medallion]])
-- InitializeFrames('GroundingTotem',[[totems\grounding_totem]],true)
-- InitializeFrames('Hex',[[shared\hex]],true)
-- InitializeFrames('LavaBurst',[[elemental\lava_burst]],true,true,true)
-- InitializeFrames('NaturesGuardian',[[shared\natures_guardian]],true)
-- InitializeFrames('SkyfuryTotem',[[totems\skyfury_totem]],true)
-- InitializeFrames('TremorTotem',[[totems\tremor_totem]],true)
-- InitializeFrames('WindRushTotem',[[totems\wind_rush_totem]],true)
-- InitializeFrames('WindShear',[[shared\wind_shear]],false,true)

--Build Icon Frames Used by Elemental Shamans
-- InitializeFrames('EarthElemental',[[elemental\earth_elemental]],true)
-- InitializeFrames('EarthShock',[[elemental\earth_shock]],true,true)
-- InitializeFrames('EarthShield',[[shared\earth_shield]],false,true,true)
-- InitializeFrames('EarthenStrength',[[elemental\earthen_strength]],false,true)
-- InitializeFrames('Earthquake',[[elemental\earthquake]],false,true)
-- InitializeFrames('ElementalBlast',[[elemental\elemental_blast]],true)
-- InitializeFrames('ExposedElements',[[elemental\exposed_elements]],false,true)
-- InitializeFrames('FireElemental',[[elemental\fire_elemental]],true)
-- InitializeFrames('FlameShock',[[shared\flame_shock]],true,true)
-- InitializeFrames('Icefury',[[elemental\icefury]],true)
-- InitializeFrames('LightningLasso',[[elemental\lightning_lasso]],true)
-- InitializeFrames('LiquidMagmaTotem',[[totems\liquid_magma_totem]],true)
-- InitializeFrames('MasterOfElements',[[elemental\master_of_elements]],false,true)
-- InitializeFrames('StormElemental',[[elemental\storm_elemental]],true)
-- InitializeFrames('Stormkeeper',[[elemental\stormkeeper]],true,true,true)
-- InitializeFrames('Thunderstorm',[[elemental\thunderstorm]],true)
-- InitializeFrames('UnlimitedPower',[[elemental\unlimited_power]],false,nil,true)

--Build Icon Frames Used by Enhancement Shamans
-- InitializeFrames('CrashLightning',[[enhancement\crash_lightning]],true)
-- InitializeFrames('EarthenSpike',[[enhancement\earthen_spike]],true)
-- InitializeFrames('EtherealForm',[[enhancement\ethereal_form]],true)
-- InitializeFrames('FeralLunge',[[enhancement\feral_lunge]],true)
-- InitializeFrames('FeralSpirit',[[enhancement\feral_spirit]],true)
-- InitializeFrames('Flametongue',[[enhancement\flametongue]],true,true)
-- InitializeFrames('ForcefulWinds',[[enhancement\forceful_winds]],true,true,true)
-- InitializeFrames('Frostbrand',[[enhancement\frostbrand]],true,true)
-- InitializeFrames('LavaLash',[[enhancement\lava_lash]],true,true,true)
-- InitializeFrames('Rockbiter',[[enhancement\rockbiter]],true,true,true)
-- InitializeFrames('SpiritWalk',[[enhancement\spirit_walk]],true)
-- InitializeFrames('StaticCling',[[enhancement\static_cling]],true,true)
-- InitializeFrames('Stormstrike',[[enhancement\stormstrike]],true,true,true)
-- InitializeFrames('Sundering',[[enhancement\sundering]],true)
-- InitializeFrames('Thundercharge',[[enhancement\thundercharge]],true)

-- InitializeFrames('AncestralProtectionTotem',[[totems\ancestral_protection_totem]],true)
-- InitializeFrames('CloudburstTotem',[[totems\cloudburst_totem]],true,false,true)
-- InitializeFrames('Downpour',[[restoration\downpour]],true)
-- InitializeFrames('EarthenWallTotem',[[totems\earthen_wall_totem]],true)
-- InitializeFrames('EarthgrabTotem',[[totems\earthgrab_totem]],true)
-- InitializeFrames('FlashFlood',[[restoration\flash_flood]],false,true)
-- InitializeFrames('HealingRain',[[restoration\healing_rain]],true,true)
-- InitializeFrames('HealingStreamTotem',[[totems\healing_stream_totem]],true,false,true)
-- InitializeFrames('HealingTideTotem',[[totems\healing_tide_totem]],true)
-- InitializeFrames('PurifySpirit',[[restoration\purify_spirit]],true)
-- InitializeFrames('Riptide',[[restoration\riptide]],true,true,true)
-- InitializeFrames('SpiritLinkTotem',[[totems\spirit_link_totem]],true)
-- InitializeFrames('SpiritwalkersGrace',[[restoration\spiritwalkers_grace]],true)
-- InitializeFrames('Tidebringer',[[restoration\tidebringer]],false,false,true)
-- InitializeFrames('UnleashLife',[[restoration\unleash_life]],true)
-- InitializeFrames('Wellspring',[[restoration\wellspring]],true)

-------------------------------------------------------------------------------------------------------
----- Build and Initialize Timer Bars
-------------------------------------------------------------------------------------------------------

-- Build Shared Timer Bars	
SSA.AncestralGuidanceBar = CreateFrame('StatusBar','AncestralGuidanceBar')
_G['SSA_AncestralGuidanceBar'] = SSA.AncestralGuidanceBar
SSA.AscendanceBar = CreateFrame('StatusBar','AscendanceBar')
_G['SSA_AscendanceBar'] = SSA.AscendanceBar
SSA.AstralShiftBar = CreateFrame('StatusBar','AstralShiftBar')
_G['SSA_AstralShiftBar'] = SSA.AstralShiftBar
SSA.BloodlustBar = CreateFrame('StatusBar','BloodlustBar')
_G['SSA_AstralShiftBar'] = SSA.AstralShiftBar
SSA.EarthElementalBar = CreateFrame('StatusBar','EarthElementalBar')
_G['SSA_EarthElementalBar'] = SSA.EarthElementalBar
SSA.EarthbindTotemBar = CreateFrame('StatusBar','EarthbindTotemBar')
_G['SSA_EarthbindTotemBar'] = SSA.EarthbindTotemBar
SSA.HeroismBar = CreateFrame('StatusBar','HeroismBar')
_G['SSA_HeroismBar'] = SSA.HeroismBar
SSA.HexBar = CreateFrame('StatusBar','HexBar')
_G['SSA_HexBar'] = SSA.HexBar
SSA.TimeWarpBar = CreateFrame('StatusBar','TimeWarpBar')
_G['SSA_TimeWarpBar'] = SSA.TimeWarpBar
SSA.TremorTotemBar = CreateFrame('StatusBar','TremorTotemBar')
_G['SSA_TremorTotemBar'] = SSA.TremorTotemBar
SSA.WindRushTotemBar = CreateFrame('StatusBar','WindRushTotemBar')
_G['SSA_WindRushTotemBar'] = SSA.WindRushTotemBar

-- Build PvP Timer Bars
SSA.CounterstrikeTotemBar = CreateFrame('StatusBar','CounterstrikeTotemBar')
SSA.GroundingTotemBar = CreateFrame('StatusBar','GroundingTotemBar')
SSA.SkyfuryTotemBar = CreateFrame('StatusBar','SkyfuryTotemBar')

-- Build Elemental Timer Bars
SSA.PrimalEarthElementalBar = CreateFrame('StatusBar','PrimalEarthElementalBar')
SSA.ElementalBlastBarCrit = CreateFrame('StatusBar','ElementalBlastBarCrit')
_G['SSA_ElementalBlastBarCrit'] = SSA.ElementalBlastBarCrit
SSA.ElementalBlastBarHaste = CreateFrame('StatusBar','ElementalBlastBarHaste')
_G['SSA_ElementalBlastBarHaste'] = SSA.ElementalBlastBarHaste
SSA.ElementalBlastBarMastery = CreateFrame('StatusBar','ElementalBlastBarMastery')
_G['SSA_ElementalBlastBarMastery'] = SSA.ElementalBlastBarMastery
--[[SSA.ElementalBlastCritBar = CreateFrame('StatusBar','ElementalBlastCritBar')
_G['SSA_ElementalBlastCritBar'] = SSA.ElementalBlastCritBar
SSA.ElementalBlastHasteBar = CreateFrame('StatusBar','ElementalBlastHasteBar')
_G['SSA_ElementalBlastHasteBar'] = SSA.ElementalBlastHasteBar
SSA.ElementalBlastMasteryBar = CreateFrame('StatusBar','ElementalBlastMasteryBar',BuffTimerBarGrp)
_G['SSA_ElementalBlastMasteryBar'] = SSA.ElementalBlastMasteryBar]]
SSA.EmberElementalBar = CreateFrame('StatusBar','EmberElementalBar')
_G['SSA_EmberElementalBar'] = SSA.EmberElementalBar
SSA.FireElementalBar = CreateFrame('StatusBar','FireElementalBar')
SSA.PrimalFireElementalBar = CreateFrame('StatusBar','PrimalFireElementalBar')
_G['SSA_FireElementalBar'] = SSA.FireElementalBar
SSA.LiquidMagmaTotemBar = CreateFrame('StatusBar','LiquidMagmaTotemBar')
_G['SSA_LiquidMagmaTotemBar'] = SSA.LiquidMagmaTotemBar
SSA.StormElementalBar = CreateFrame('StatusBar','StormElementalBar')
SSA.PrimalStormElementalBar = CreateFrame('StatusBar','PrimalStormElementalBar')
_G['SSA_StormElementalBar'] = SSA.StormElementalBar

-- Build Enhancement Timer Bars
SSA.CrashLightningBar = CreateFrame('StatusBar','CrashLightningBar')
_G["SSA_CrashLightningBar"] = SSA.CrashLightningBar
SSA.EarthenSpikeBar = CreateFrame('StatusBar','EarthenSpikeBar')
_G["SSA_EarthenSpikeBar"] = SSA.EarthenSpikeBar
SSA.EtherealFormBar = CreateFrame('StatusBar','EtherealFormBar')
_G["SSA_EtherealFormBar"] = SSA.EtherealFormBar
SSA.FeralSpiritBar = CreateFrame('StatusBar','FeralSpiritBar')
_G["SSA_FeralSpiritBar"] = SSA.FeralSpiritBar
SSA.FlametongueBar = CreateFrame('StatusBar','FlametongueBar')
_G["SSA_FlametongueBar"] = SSA.FlametongueBar
SSA.ForcefulWindsBar = CreateFrame('StatusBar','ForcefulWindsBar')

SSA.FrostbrandBar = CreateFrame('StatusBar','FrostbrandBar')
SSA.LandslideBar = CreateFrame('StatusBar','LandslideBar')
SSA.LightningCrashBar = CreateFrame('StatusBar','LightningCrashBar')
SSA.SpiritWalkBar = CreateFrame('StatusBar','SpiritWalkBar')

-- Build Restoration Timer Bars
SSA.AncestralProtectionTotemBar = CreateFrame('StatusBar','AncestralProtectionTotemBar')
SSA.CloudburstTotemBar = CreateFrame('StatusBar','CloudburstTotemBar')
SSA.EarthgrabTotemBar = CreateFrame('StatusBar','EarthgrabTotemBar')
SSA.HealingStreamTotemBarOne = CreateFrame('StatusBar','HealingStreamTotemBarOne')
SSA.HealingStreamTotemBarTwo = CreateFrame('StatusBar','HealingStreamTotemBarTwo')
SSA.HealingTideTotemBar = CreateFrame('StatusBar','HealingTideTotemBar')
SSA.SpiritLinkTotemBar = CreateFrame('StatusBar','SpiritLinkTotemBar')
SSA.SpiritwalkersGraceBar = CreateFrame('StatusBar','SpiritwalkersGraceBar')
SSA.UnleashLifeBar = CreateFrame('StatusBar','UnleashLifeBar')

function Auras:InitializeTimerBars(spec)
	local ctr = 1
	for k,v in pairs(Auras.db.char.timerbars[spec].bars) do
		--[[if (SSA[k.."Bar"]) then) then
			Auras:CreateVerticalStatusBar(SSA[k.."Bar"],spec,k)
		end
		
		if (SSA[k.."Bar1"]) then
			Auras:CreateVerticalStatusBar(SSA[k.."Bar1"],spec,k)
		end
		
		if (SSA[k.."Bar2"]) then
			Auras:CreateVerticalStatusBar(SSA[k.."Bar2"],spec,k)
		end]]
		if (not SSA[k]) then
			SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."Bar Error: "..tostring(k).."\n")
		end
		
		--[[if (not SSA[k]:HasScript("OnUpdate")) then
			SSA[k]:SetScript('OnUpdate',function(this)
				if (v.startTime) then
					local expireTime = v.startTime + v.duration
					local timer,seconds = Auras:parseTime(expireTime - GetTime(),true)
					
					this:SetValue(seconds)
					this.timetext:SetText(timer)
					
					Auras:SortTimerBars(1)
					
					if (GetTime() > expireTime) then
						v.startTime = 0
					end
				else
					this:Hide()
				end
			end)
		end]]
		
		Auras:CreateVerticalStatusBar(SSA[k],spec,ctr)
		ctr = ctr + 1
	end
	--[[
	-- Initialize Shared Timer Bars
	Auras:CreateVerticalStatusBar(SSA.AscendanceBar,251,147,255,Auras:GetSpellName(114050),15);
	Auras:CreateVerticalStatusBar(SSA.AstralShiftBar,240,56,255,Auras:GetSpellName(108271),8);
	Auras:CreateVerticalStatusBar(SSA.BloodlustBar,255,18,76,Auras:GetSpellName(2825),40);
	Auras:CreateVerticalStatusBar(SSA.EarthbindTotemBar,127,175,97,Auras:GetSpellName(2484),20);
	Auras:CreateVerticalStatusBar(SSA.HeroismBar,0,121,255,Auras:GetSpellName(32182),40);
	Auras:CreateVerticalStatusBar(SSA.HexBar,76,195,71,Auras:GetSpellName(51514),60);
	Auras:CreateVerticalStatusBar(SSA.TimeWarpBar,195,42,255,Auras:GetSpellName(80353),40);
	Auras:CreateVerticalStatusBar(SSA.TremorTotemBar,219,174,0,Auras:GetSpellName(8143),10);
	Auras:CreateVerticalStatusBar(SSA.WindRushTotemBar,174,195,86,Auras:GetSpellName(177600),15);

	-- Initialize Shared Timer Bars
	Auras:CreateVerticalStatusBar(SSA.CounterstrikeTotemBar,56,60,255,Auras:GetSpellName(204331),15);
	Auras:CreateVerticalStatusBar(SSA.GroundingTotemBar,86,0,215,Auras:GetSpellName(204336),3);
	Auras:CreateVerticalStatusBar(SSA.SkyfuryTotemBar,189,0,13,Auras:GetSpellName(204330),15);

	-- Initialize Elemental Timer Bars
	Auras:CreateVerticalStatusBar(SSA.AncestralGuidanceBar,51,108,255,Auras:GetSpellName(108281),10);
	Auras:CreateVerticalStatusBar(SSA.ElementalBlastBar1,255,99,154,Auras:GetSpellName(165533),10);
	Auras:CreateVerticalStatusBar(SSA.ElementalBlastBar2,255,99,154,Auras:GetSpellName(28507),10);
	Auras:CreateVerticalStatusBar(SSA.FireElementalBar,255,160,43,Auras:GetSpellName(198067),30);
	Auras:CreateVerticalStatusBar(SSA.LiquidMagmaTotemBar,255,101,65,Auras:GetSpellName(192231),15);
	Auras:CreateVerticalStatusBar(SSA.StormElementalBar,110,145,255,Auras:GetSpellName(192249),30);
	Auras:CreateVerticalStatusBar(SSA.EarthElementalBar,213,165,131,Auras:GetSpellName(198103),60);

	-- Initialize Enhancement Timer Bars
	Auras:CreateVerticalStatusBar(SSA.CrashLightningBar,0,133,255,Auras:GetSpellName(187874),10);
	Auras:CreateVerticalStatusBar(SSA.EarthenSpikeBar,255,18,76,Auras:GetSpellName(2825),10);
	Auras:CreateVerticalStatusBar(SSA.EtherealFormBar,131,131,131,Auras:GetSpellName(210918),15);
	Auras:CreateVerticalStatusBar(SSA.FeralSpiritBar,83,0,255,Auras:GetSpellName(51533),15);
	Auras:CreateVerticalStatusBar(SSA.FlametongueBar,255,160,43,Auras:GetSpellName(193796),16);
	Auras:CreateVerticalStatusBar(SSA.ForcefulWindsBar,161,161,161,Auras:GetSpellName(262647),15);
	Auras:CreateVerticalStatusBar(SSA.LandslideBar,223,101,93,Auras:GetSpellName(197992),10);
	Auras:CreateVerticalStatusBar(SSA.LightningCrashBar,0,133,255,Auras:GetSpellName(242284),16,LSM.MediaTable.statusbar['Frost']);
	Auras:CreateVerticalStatusBar(SSA.FrostbrandBar,0,200,255,Auras:GetSpellName(196834),16);
	Auras:CreateVerticalStatusBar(SSA.SpiritWalkBar,177,129,65,Auras:GetSpellName(58875),8);

	-- Initialize Restoration Timer Bars
	Auras:CreateVerticalStatusBar(SSA.AncestralProtectionTotemBar,255,52,56,Auras:GetSpellName(207399),30);
	Auras:CreateVerticalStatusBar(SSA.CloudburstTotemBar,117,208,255,Auras:GetSpellName(157153),15);
	Auras:CreateVerticalStatusBar(SSA.EarthgrabTotemBar,168,229,124,Auras:GetSpellName(51485),20);
	Auras:CreateVerticalStatusBar(SSA.HealingStreamTotemBar1,55,205,255,Auras:GetSpellName(5394),15);
	Auras:CreateVerticalStatusBar(SSA.HealingStreamTotemBar2,55,205,255,Auras:GetSpellName(5394),15);
	Auras:CreateVerticalStatusBar(SSA.HealingTideTotemBar,0,255,207,Auras:GetSpellName(108280),10);
	Auras:CreateVerticalStatusBar(SSA.SpiritLinkTotemBar,117,208,255,Auras:GetSpellName(204314),6);
	Auras:CreateVerticalStatusBar(SSA.SpiritwalkersGraceBar,167,255,84,Auras:GetSpellName(79206),15);
	Auras:CreateVerticalStatusBar(SSA.UnleashLifeBar,25,255,0,Auras:GetSpellName(73685),10);
	
	]]
end

EventFrame:SetScript("OnEvent",function(self,event,...)
	local spec = GetSpecialization()
	
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	
	end
end)