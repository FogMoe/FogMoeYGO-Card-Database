--水彩童话·睡衣派对
local m=11112
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c11100") end,function() require("script/c11100") end)
--
function c11112.initial_effect(c)
--
	c:SetSPSummonOnce(11112)
	c:EnableReviveLimit()
	muxu.AddXyzProcedureFreeByColour(c,c11112.XyzFilter,3)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11112.cost1)
	e1:SetTarget(c11112.tg1)
	e1:SetOperation(c11112.op1)
	c:RegisterEffect(e1)
--
end
--
function c11112.XyzFilter(c)
	return c:IsSetCard(0x3e16) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
end
--
function c11112.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end
function c11112.tfilter1(c,e,tp)
	return c:IsSetCard(0x3e16) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11112.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c11112.tfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c11112.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c11112.tfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end