local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthElementalBar = SSA.EarthElementalBar
local PrimalEarthElementalBar = SSA.PrimalEarthElementalBar

-- Initialize Data Variables
EarthElementalBar.spellID = 188616
EarthElementalBar.icon = 136024
EarthElementalBar.start = 0
EarthElementalBar.duration = 60
EarthElementalBar.GUID = ''
EarthElementalBar.elapsed = 0
EarthElementalBar.condition = function()
	return IsSpellKnown(198103)
end

EarthElementalBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

EarthElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end

	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Elemental(self,nil,CombatLogGetCurrentEventInfo())
	end
end)

-- Initialize Data Variables
PrimalEarthElementalBar.spellID = 118323
PrimalEarthElementalBar.start = 0
PrimalEarthElementalBar.duration = 60
PrimalEarthElementalBar.GUID = ''
PrimalEarthElementalBar.isPrimal = true
PrimalEarthElementalBar.elapsed = 0
PrimalEarthElementalBar.condition = function()
	local _,_,_,selected = GetTalentInfo(6,2,1)
	
	return selected
end

PrimalEarthElementalBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

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
	
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Elemental(self,{118291,157319},CombatLogGetCurrentEventInfo())
	end
end)