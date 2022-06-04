local m=95100
local cm=_G["c"..m]
cm.name="神奇的元素生物"
--風林火山
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_TOHAND)
	e1:SetCondition(cm.condition)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetCost(cm.descost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.cfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function cm.dfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WIND)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_EARTH)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		or Duel.IsExistingMatchingCard(cm.dfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsPlayerCanDraw(tp,2) end
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.dfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsPlayerCanDraw(tp,2) then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif opval[op]==2 then
		local g=Duel.GetMatchingGroup(cm.dfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif opval[op]==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif opval[op]==4 then
		Duel.Draw(tp,2,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		Duel.ConfirmCards(1-tp,g)
	end
end
