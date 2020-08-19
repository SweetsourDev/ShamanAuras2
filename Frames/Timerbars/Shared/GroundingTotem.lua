local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetSpecialization = GetSpecialization

-- Cache Global Addon Variables
local GroundingTotemBar = SSA.GroundingTotemBar

-- Initialize Data Variables
GroundingTotemBar.spellID = 204336
GroundingTotemBar.icon = 136039
GroundingTotemBar.start = 0
GroundingTotemBar.duration = 3
GroundingTotemBar.elapsed = 0
GroundingTotemBar.condition = function() 
	local spec = SSA.spec or GetSpecialization()
	local spellID = (spec == 1 and 3620) or (spec == 2 and 3622) or (spec == 3 and 715)
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(spellID)
	--[[if (spec == 1) then
		spellID = 3620
	elseif (spec == 2) then
		spellID = 3622
	elseif (spec == 3) then
		spellID = 715
	end]]
	
	return selected and Auras:IsPvPZone()
end

GroundingTotemBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

GroundingTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)