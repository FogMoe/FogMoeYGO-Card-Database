--水彩童话·睡前晚安
function c11110.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11110.MatFilter,1,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c11110.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11110,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,11110)
	e2:SetTarget(c11110.tg2)
	e2:SetOperation(c11110.op2)
	c:RegisterEffect(e2)
--
end
--
function c11110.MatFilter(c)
	return c:IsLinkSetCard(0x3e16) and not c:IsLinkAttribute(ATTRIBUTE_EARTH)
end
--
function c11110.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_DIRECT_ATTACK)
	e1_1:SetTargetRange(LOCATION_MZONE,0)
	e1_1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e16))
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
end
--
function c11110.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11110.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.RegisterFlagEffect(tp,11110,0,0,0)
end
--
