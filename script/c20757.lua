--死苑零序龙
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20752") end) then require("script/c20752") end
function cm.initial_effect(c)
	local e1={fu_zeroth.same(c,m,cm.Zeroth_Effect)}
end
--Zeroth_Effect
function cm.Zeroth_Effect(c)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(m,0))
	e:SetCategory(CATEGORY_TOHAND)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e:SetCode(EVENT_SPSUMMON_SUCCESS)
	e:SetProperty(EFFECT_FLAG_DELAY)
	e:SetTarget(cm.Zeroth_Effect_tg)
	e:SetOperation(cm.Zeroth_Effect_op)
	return e
end
function cm.Zeroth_Effect_tgf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.Zeroth_Effect_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(cm.Zeroth_Effect_tgf,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
end
function cm.Zeroth_Effect_op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.Zeroth_Effect_tgf,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end