local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTime = GetTime
local GetSpecialization = GetSpecialization

-- Cache Global Addon Variables
local HexBar = SSA.HexBar

-- Initialize Data Variables
HexBar.spellID = 51514
HexBar.start = 0
HexBar.duration = 60
HexBar.condition = function() return IsSpellKnown(51514) end

HexBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,51514)) then
		Auras:RunTimerBarCode(self)
	end
end)

local hexIDs = {
	[51514] = true,  -- Frog
	[210873] = true, -- Compy
	[211004] = true, -- Spider
	[211010] = true, -- Snake
	[211015] = true, -- Cockroach
	[269352] = true, -- Skeletal Hatchling
	[277778] = true, -- Zandalari Tendonripper (Horde Only)
	[277784] = true, -- Wicker Mongrel (Alliance only)
}

-- The following script handle only the application and removal of any Hex debuffs
-- If the hex is removed on the original target, it will hide the Hex Timer Bar
HexBar:HookScript('OnEvent',function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	local spec = GetSpecialization()
	local hexBar = Auras.db.char.timerbars[spec].bars[self:GetName()]
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_REMOVED") and srcGUID == UnitGUID("player") and hexIDs[spellID]) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			hexBar.data.start = GetTime()
			self:Show()
		elseif (subevent == "SPELL_AURA_REMOVED") then
			hexBar.data.start = 0
		end
	end
end)