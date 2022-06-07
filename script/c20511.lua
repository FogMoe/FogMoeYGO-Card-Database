--堕魔仪
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20512)
	local e1=aux.AddRitualProcUltimate(c,aux.FilterBoolFunction(Card.IsCode,20512),Card.GetLevel,"Equal",LOCATION_DECK,nil,aux.FilterBoolFunction(Card.IsLocation,LOCATION_ONFIELD))
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	aux.AddRitualProcUltimate(c,aux.FilterBoolFunction(Card.IsSetCard,0x3fd5),Card.GetLevel,"Equal"):SetDescription(aux.Stringid(m,1))
end