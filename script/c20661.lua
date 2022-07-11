--榨取之根绝者
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20650") end) then require("script/c20650") end
function cm.initial_effect(c)
	local e1=fu_Dlit.cont(c,450)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.tgf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local atk=bc:GetAttack()/2
	if chk==0 then return atk>0 end
	e:SetLabel(atk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(atk+e:GetHandler():GetBaseAttack())
	e:GetHandler():RegisterEffect(e1)
end
