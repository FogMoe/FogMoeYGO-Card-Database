--构想之位·剑影随形
function c11159.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11159.tg1)
	e1:SetOperation(c11159.op1)
	c:RegisterEffect(e1)
--
end
--
function c11159.tfilter1(c)
	return c:IsCode(11151) and c:IsFaceup()
end
function c11159.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11159.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c11159.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.GetMatchingGroup(c11159.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11153,0,TYPES_TOKEN_MONSTER,100,100,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP)
		and Duel.SelectYesNo(tp,aux.Stringid(11159,0)) then
		local token=Duel.CreateToken(tp,11153)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
