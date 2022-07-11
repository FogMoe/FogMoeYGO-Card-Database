--星葬零序龙
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20752") end) then require("script/c20752") end
function cm.initial_effect(c)
	local e1={fu_zeroth.same(c,m,cm.Zeroth_Effect)}
end
--Zeroth_Effect
function cm.Zeroth_Effect(c)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(m,0))
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e:SetCode(EVENT_SPSUMMON_SUCCESS)
	e:SetProperty(EFFECT_FLAG_DELAY)
	e:SetTarget(cm.Zeroth_Effect_tg)
	e:SetOperation(cm.Zeroth_Effect_op)
	return e
end
function cm.Zeroth_Effect_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
end
function cm.Zeroth_Effect_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end