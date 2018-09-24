local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthElementalBar = SSA.EarthElementalBar
local PrimalEarthElementalBar = SSA.PrimalEarthElementalBar

EarthElementalBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,198103)) then
		Auras:RunTimerBarCode(self)
	end
end)

--EarthElementalBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EarthElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end

	Auras:RunTimerEvent_Elemental(self,nil,CombatLogGetCurrentEventInfo())
end)

PrimalEarthElementalBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,6,2)) then
		Auras:RunTimerBarCode(self)
	end
end)

--PrimalEarthElementalBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
PrimalEarthElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	--[[local spec = 1
	local primalEarthBar = Auras.db.char.timerbars[spec][self:GetName()]
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	

	if (srcGUID == UnitGUID("player") and subevent == "SPELL_SUMMON") then
		-- If the player casts Primal Fire Elemental while the Primal Earth Elemental is already active,
		-- hide the timer bar for Primal Earth Elemental
		if (spellID == 118291 and primalEarthBar.startTime > 0) then
			primalEarthBar.startTime = 0
		elseif (spellID == 118323) then
			primalEarthBar.startTime = GetTime()
			primalEarthBar.event.elementalGUID = destGUID
			self:Show()
		end
	elseif (subevent == "UNIT_DIED" and destGUID == primalEarthBar.event.elementalGUID) then
		primalEarthBar.startTime = 0
	end]]
	
	Auras:RunTimerEvent_Elemental(self,{118291,157319},CombatLogGetCurrentEventInfo())
end)