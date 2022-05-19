--碑纹骑士 奥丁
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function cm.val1(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function cm.val2(e,c)
	local tp = e:GetHandler():GetControler()
	local val = math.abs(Duel.GetLP(1-tp) - Duel.GetLP(tp))
	return val > 0 and val or 0
end