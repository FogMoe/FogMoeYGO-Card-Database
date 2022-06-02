--水彩童话·梦幻白兔
local m=11113
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c11100") end,function() require("script/c11100") end)
--
function c11113.initial_effect(c)
--
	c:SetSPSummonOnce(11113)
	c:EnableReviveLimit()
	muxu.AddXyzProcedureFreeByColour(c,c11113.XyzFilter,4)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11113.cost1)
	e1:SetTarget(c11113.tg1)
	e1:SetOperation(c11113.op1)
	c:RegisterEffect(e1)
--
end
--
function c11113.XyzFilter(c)
	return c:IsSetCard(0x3e16) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER)
end
--
function c11113.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11113.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end
function c11113.ofilter1(c)
	return c:IsSetCard(0x3e16) and c:IsFaceup()
end
function c11113.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c11113.ofilter1,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,ct+1,nil)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
--
