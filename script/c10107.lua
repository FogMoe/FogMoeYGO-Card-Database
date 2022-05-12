function c10107.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10107.spcon)
	e1:SetOperation(c10107.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10107)
	e2:SetTarget(c10107.tdtg)
	e2:SetOperation(c10107.tdop)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
end
function c10107.spfilter(c)
	return c:IsSetCard(0x7f7) and c:IsAbleToRemoveAsCost()
end
function c10107.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10107.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c10107.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10107.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10107.tdfilter(c,tp)
	return c:IsAbleToDeck()
		and c:IsType(TYPE_NORMAL) or c:IsType(TYPE_SPELL)
end
function c10107.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c10107.tdfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10107.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10107.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	if g:GetFirst():IsType(TYPE_SPELL) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c10107.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and ((tc:IsType(TYPE_NORMAL) and tc:IsLocation(LOCATION_DECK))
			or (tc:IsType(TYPE_SPELL) and tc:IsLocation(LOCATION_DECK))) then
		if tc:IsType(TYPE_SPELL) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if tc:IsType(TYPE_NORMAL)
			and c:IsFaceup() and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end