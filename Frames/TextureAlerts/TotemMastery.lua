local SSA, Auras = unpack(select(2,...))

-- Totem Mastery Notification
local TotemMastery = CreateFrame('Frame','TotemMastery',SSA.AuraBase)
TotemMastery:SetPoint('CENTER',0,-210)
TotemMastery:SetWidth(300)
TotemMastery:SetHeight(135)
TotemMastery:SetFrameStrata('BACKGROUND')
TotemMastery:RegisterForDrag('LeftButton')
TotemMastery:SetAlpha(0)
TotemMastery:Show()

TotemMastery.header = TotemMastery:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
TotemMastery.header:SetFont([[Interface\AddOns\ShamanAuras2\Media\fonts\PT_Sans_Narrow.TTF]], 14,'OUTLINE')
TotemMastery.header:SetPoint('TOPLEFT',TotemMastery,"TOPLEFT",5,5)
TotemMastery.header:SetTextColor(1,1,1,1)
TotemMastery.header:SetText(GetSpellInfo(210643))
TotemMastery.header:Hide()
				
TotemMastery.texture = TotemMastery:CreateTexture(nil,'LOW')
--TotemMastery.texture:SetTexture([[Textures\SpellActivationOverlays\Echo_of_the_Elements]])
TotemMastery.texture:SetTexture(1057288)
TotemMastery.texture:SetPoint('CENTER',TotemMastery,'CENTER',0,0)
TotemMastery.texture:SetWidth(TotemMastery:GetHeight())
TotemMastery.texture:SetHeight(TotemMastery:GetWidth() + 20)
TotemMastery.texture:SetRotation(rad(-90))
TotemMastery.texture:SetAlpha(0.7)

-- Animation for Totem Mastery Notification Texture
TotemMastery.Flash = TotemMastery.texture:CreateAnimationGroup()
TotemMastery.Flash:SetLooping('BOUNCE')

TotemMastery.Flash.fadeIn = TotemMastery.Flash:CreateAnimation('Alpha')
TotemMastery.Flash.fadeIn:SetFromAlpha(1)
TotemMastery.Flash.fadeIn:SetToAlpha(0.4)
TotemMastery.Flash.fadeIn:SetDuration(0.4)

TotemMastery.Flash.fadeOut = TotemMastery.Flash:CreateAnimation('Alpha')
TotemMastery.Flash.fadeOut:SetFromAlpha(0.4)
TotemMastery.Flash.fadeOut:SetToAlpha(1)
TotemMastery.Flash.fadeOut:SetDuration(0.4)
TotemMastery.Flash.fadeOut:SetEndDelay(0)

TotemMastery:SetScript('OnUpdate',function(self)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:CharacterCheck(nil,1)) then
			local remaining
			local _,_,_,selected = GetTalentInfo(2,3,1)
			local isTotem,isRefresh = false,false
			--local buff = UnitBuff('player',Auras:GetSpellName(202192))
			local buff = Auras:RetrieveAuraInfo("player", 202192)
			local canAttack = UnitCanAttack('player','target')
			local db = Auras.db.char
		
			self:SetPoint(db.elements[1].frames[self:GetName()].point,SSA[db.elements[1].frames[self:GetName()].relativeTo],db.elements[1].frames[self:GetName()].relativePoint,db.elements[1].frames[self:GetName()].x,db.elements[1].frames[self:GetName()].y)
			Auras:ToggleFrameMove(self,Auras.db.char.settings.move.isMoving)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			
			for i=1,5 do
				local _,name = GetTotemInfo(i)

				if (name == Auras:GetSpellName(210643)) then
					local _,_,start,duration = GetTotemInfo(i)
					
					isTotem = true
					remaining = (start + duration) - GetTime()
					break
				end
			end

			if ((remaining or 0) <= db.settings[1].totemMastery) then
				isRefresh = true
			end

			if (((not isTotem or isRefresh or not buff) and selected and db.elements[1].frames.TotemMastery.isEnabled and canAttack) or db.settings.move.isMoving) then
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
			
			--Auras:ToggleFrameMove(self,db.elements[1].isMoving)
		else
			Auras:ToggleAuraVisibility(self,false,'showhide')
		end
	end
end)

TotemMastery:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

TotemMastery:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[1].frames[self:GetName()])
	end
end)

_G["SSA_TotemMastery"] = TotemMastery