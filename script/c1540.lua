local m=1540
local cm=_G["c"..m]
cm.name="时天械01-黄玉"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.pocon)
	e1:SetOperation(cm.poop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
function cm.pocon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,2,nil,TYPE_MONSTER) and eg:IsExists(Card.IsFaceup,1,nil)
end
function cm.poop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsFaceup,nil)
	if g:GetCount()~=0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5f30)
end
function cm.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5f30) and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
		and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and g and g:IsExists(cm.tfilter,1,nil,tp) and re:IsActiveType(TYPE_TRAP)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end