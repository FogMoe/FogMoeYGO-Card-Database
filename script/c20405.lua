--赤兽机艺•熙犬
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20400") end) then require("script/c20400") end
function cm.initial_effect(c)
	local e1=fu_hd.AttackTrigger(c,cm.Give)
end
function cm.Give(c)
	local tp=c:GetControler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.indval)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(fu_hd.GiveTarget)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function cm.indval(e,c)
	return not c:IsType(TYPE_NORMAL)
end