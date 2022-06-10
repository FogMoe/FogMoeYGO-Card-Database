--构想之位·阴阳守御
function c11160.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11160.tg1)
	e1:SetOperation(c11160.op1)
	c:RegisterEffect(e1)
--
end
--
function c11160.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsCode(11151) and chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,11151) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_ONFIELD,0,1,1,nil,11151)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c11160.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local num=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_GRAVE,0,1,num,nil)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11153,0,TYPES_TOKEN_MONSTER,100,100,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP)
		and Duel.SelectYesNo(tp,aux.Stringid(11160,0)) then
		local token=Duel.CreateToken(tp,11153)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
