local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local TotemMastery = SSA.TotemMastery1

TotemMastery:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(1)) then
		local remaining
		local _,_,_,selected = GetTalentInfo(2,3,1)
		local isTotem,isRefresh = false,false
		--local buff = UnitBuff('player',Auras:GetSpellName(202192))
		local buff = Auras:RetrieveBuffInfo("player", Auras:GetSpellName(202192))
		local canAttack = UnitCanAttack('player','target')
		local db = Auras.db.char
	
		Auras:ToggleAuraVisibility(self,true,'showhide')
		
		for i=1,5 do
			local _,name = GetTotemInfo(i)

			if (name == 'Totem Mastery') then
				local _,_,start,duration = GetTotemInfo(i)
				
				isTotem = true
				remaining = (start + duration) - GetTime()
				break
			end
		end

		if ((remaining or 0) <= db.settings[1].totemMastery) then
			isRefresh = true
		end

		if (((not isTotem or isRefresh or not buff) and selected and db.elements[1].frames.TotemMastery1.isEnabled and canAttack) or db.elements[1].isMoving) then
			self:SetAlpha(1)
			
			if (not self.Flash:IsPlaying()) then
				self.Flash:Play()
			end
			if (UnitAffectingCombat('player')) then
				self.Flash.fadeOut:SetToAlpha(0.6)
				self.Flash.fadeIn:SetFromAlpha(1)
			else
				self.Flash.fadeOut:SetToAlpha(0.3)
				self.Flash.fadeIn:SetFromAlpha(0.6)
			end
		else
			self:SetAlpha(0)
			
			if (self.Flash:IsPlaying()) then
				self.Flash:Stop()
			end
		end
		
		Auras:ToggleFrameMove(self,db.elements[1].isMoving)
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)

TotemMastery:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements[1].isMoving) then
		Auras:MoveOnMouseDown(self,'AuraGroup1',button)
	end
end)

TotemMastery:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements[1].isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[1].frames[self:GetName()])
	end
end)