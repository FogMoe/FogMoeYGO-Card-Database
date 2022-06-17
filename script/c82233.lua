local m=82233
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pierce  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e2)  
end