--构想之位·烈焰燎原
function c11157.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11157.tg1)
	e1:SetOperation(c11157.op1)
	c:RegisterEffect(e1)
--
end
--
function c11157.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsCode(11151) and chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,11151) and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_ONFIELD,0,1,1,nil,11151)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c11157.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetCode(EFFECT_DISABLE)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_1)
		local e1_2=Effect.CreateEffect(e:GetHandler())
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_2:SetCode(EFFECT_DISABLE_EFFECT)
		e1_2:SetValue(RESET_TURN_SET)
		e1_2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_2)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		if Duel.GetTurnPlayer()==tp then
			Duel.AdjustInstantly()
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11153,0,TYPES_TOKEN_MONSTER,100,100,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP)
		and Duel.SelectYesNo(tp,aux.Stringid(11157,0)) then
		local token=Duel.CreateToken(tp,11153)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
