--不畏苦暗
local m=60022
local cm=_G["c"..m]
cm.name="不畏苦暗"
cm.isArkFog=true
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.descon1)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCondition(cm.descon2)
	c:RegisterEffect(e3)
end
function cm.tgfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function cm.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.tgfilter,1,nil,tp)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(cm.tgfilter,1,nil,tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		 and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
