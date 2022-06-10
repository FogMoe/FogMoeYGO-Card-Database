local m=95508
local cm=_G["c"..m]
cm.name="机械化遗迹"
function cm.initial_effect(c)
		--Activate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_ACTIVATE)
	e9:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e9)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.actcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--discard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.distg)
	e4:SetCondition(cm.setcon)
	e4:SetHintTiming(TIMING_END_PHASE)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(cm.antarget)
	c:RegisterEffect(e5)
end
function cm.antarget(e,c)
	return c:IsSetCard(0x9901)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.actfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9901) and c:IsControler(tp)
end
function cm.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and cm.actfilter(a,tp)) or (d and cm.actfilter(d,tp))
end


function cm.disfilter(c)
	return c:IsSetCard(0x9901) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
end
