function BeStride:IsFlyableArea()
	return IsFlyableArea()
end

function BeStride:IsMountable()
	if self:IsFlyable() and IsOutdoors() then
		return true
	elseif not self:IsFlyable() and IsOutdoors() then
		return true
	elseif not IsOutdoors() then
		return false
	else
		return false
	end
end

function BeStride:IsFlyable()
	if IsOutdoors() then
		local skill,spells = self:GetRidingSkill()
		local mapID = C_Map.GetBestMapForUnit("player")
		
		if countTable(BeStride_Constants.Riding.Flight.Restricted.Continents) > 0 then
			local continent = BeStride:GetMapUntil(mapID,2)
			if continent ~= nil then
				for key,value in pairsByKeys(BeStride_Constants.Riding.Flight.Restricted.Continents) do
					if continent.mapID == key and value.blocked == true then
						return false
					elseif continent.mapID == key and value.requires ~= nil and spells[value.requires] == true then
						break
					elseif continent.mapID == key and value.requires ~= nil then
						return false
					end
				end
			end
		end
		
		if countTable(BeStride_Constants.Riding.Flight.Restricted.Continents) > 0 then
			local zone = BeStride:GetMapUntil(mapID,3)
			if zone ~= nil then
				for key,value in pairsByKeys(BeStride_Constants.Riding.Flight.Restricted.Zones) do
					if zone.mapID == key and value.blocked == true and (not value.except or (value.except and value.except ~= GetSubZoneText())) then
						return false
					elseif zone.mapID == key and value.requires ~= nil and spells[value.requires] == true then
						break
					elseif zone.mapID == key and value.requires ~= nil then
						return false
					end
				end
			end
		end
				
		if self:IsFlyableArea() and skill >= 225 then
			return true
		else
			return false
		end
	else
		return false
	end
end

function BeStride:IsUnderwater()
	if IsSwimming() and BeStride:DBGet("settings.mount.noswimming") == false then
		local timer, initial, maxvalue, scale, paused, label = GetMirrorTimerInfo(2)
		if timer ~= nil and timer == "BREATH" and scale < 0 then
			return true
		else
			return false
		end
	else
		return false
	end
end

function BeStride:IsSpecialZone()
	local mapID = C_Map.GetBestMapForUnit("player")
	local micro = BeStride:GetMapUntil(mapID,5)
	local dungeon = BeStride:GetMapUntil(mapID,4)
	local zone = BeStride:GetMapUntil(mapID,3)
	local continent = BeStride:GetMapUntil(mapID,2)
	
	if continent ~= nil and continent.name == LibStub("AceLocale-3.0"):GetLocale("BeStride")["Continent.Draenor"] and micro.name == LibStub("AceLocale-3.0"):GetLocale("BeStride")["Zone.Nagrand"] and self:DBGet("settings.mount.telaari") == true then
		local garrisonAbilityName = GetSpellInfo(161691)
		local _,_,_,_,_,_,spellID = GetSpellInfo(garrisonAbilityName)
		if(spellID == 165803 or spellID == 164222) then
			return true
		end
	end
	
	return false
end

function BeStride:WGActive()
	return true
end