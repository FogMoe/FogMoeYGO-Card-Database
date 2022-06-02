--水彩童话·心灵悸动
function c11114.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c11114.MatFilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e16))
	e1:SetValue(2000)
	c:RegisterEffect(e1)
--
end
--
function c11114.MatFilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3e16) and c:IsFusionType(TYPE_XYZ)
end
--