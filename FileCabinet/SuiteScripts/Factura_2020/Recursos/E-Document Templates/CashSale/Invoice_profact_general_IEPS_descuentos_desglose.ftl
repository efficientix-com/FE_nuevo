<?xml version="1.0" encoding="utf-8"?>

<#setting locale = "es_MX">
<#setting time_zone= "America/Mexico_City">

<#function getAttrPair attr value>
<#if value?has_content>
<#assign result="${attr}=\"${value}\"">
<#return result>
</#if>
</#function>

<#function getNodePair node attr value>
<#if value?has_content>
<#assign result="<${node} ${attr}=\"${value}\" />">
<#return result>
</#if>
</#function>


<#if custom.multiCurrencyFeature == "true">
<#assign "currencyCode" = transaction.currencysymbol>
<#if transaction.exchangerate == 1>
<#assign exchangeRate = 1>
<#else>
<#assign exchangeRate = transaction.exchangerate?string["0.000000"]>
</#if>
<#else>
<#assign "currencyCode" = "MXN">
<#assign exchangeRate = 1>
</#if>
<#if custom.oneWorldFeature == "true">
<#assign customCompanyInfo = transaction.subsidiary>
<#else>
<#assign "customCompanyInfo" = companyinformation>
</#if>
<#if customer.isperson == "T">
<#assign customerName = customer.firstname + ' ' + customer.lastname>
<#else>
<#assign "customerName" = customer.companyname>
</#if>
<#assign "summary" = custom.summary>
<#assign "total_traslados_ivacero" = 0>
<#assign "satCodes" = custom.satcodes>
<#assign "totalAmount" = summary.subtotal - summary.totalDiscount>
<#assign "companyTaxRegNumber" = custom.companyInfo.rfc>
<#assign paymentMethod = satCodes.paymentMethod>
<#assign paymentTerm = satCodes.paymentTerm>

<#assign desglose_json_cabecera = transaction.custbody_efx_fe_tax_json>
<#assign desglose_cab = desglose_json_cabecera?eval>
<#assign "ComercioE" = transaction.custbody_efx_fe_comercio_exterior>
<#assign "ImpLocal" = transaction.custbody_efx_fe_local_tax>

<cfdi:Comprobante
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:cce11="http://www.sat.gob.mx/ComercioExterior11"
        xmlns:cfdi="http://www.sat.gob.mx/cfd/3"
<#if ImpLocal == true>
        xmlns:implocal="http://www.sat.gob.mx/implocal"
</#if>

<#assign "Add_name" = customer.custentity_efx_fe_default_addenda>
<#if Add_name=="Liverpool" || Add_name=="HEB">
xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd http://www.sat.gob.mx/detallista http://www.sat.gob.mx/sitio_internet/cfd/detallista/detallista.xsd"

<#elseif ComercioE == true>

<#assign "CEreceptorNumR" = transaction.custbody_efx_fe_ce_recep_num_reg>
<#assign "CEreceptorResidF" = transaction.custbody_efx_fe_ce_rec_residenciaf>
xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd http://www.sat.gob.mx/ComercioExterior11 http://www.sat.gob.mx/sitio_internet/cfd/ComercioExterior11/ComercioExterior11.xsd"
<#elseif ImpLocal == true>
xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd http://www.sat.gob.mx/implocal http://www.sat.gob.mx/sitio_internet/cfd/implocal/implocal.xsd"
<#elseif ComercioE == false>
<#if ImpLocal == false>
xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd"
</#if>
</#if>



<#if transaction.custbody_efx_fe_actual_date == true>
<#assign aDateTime = .now>
<#assign aDate = aDateTime?date>
Fecha="${aDate?string("yyyy-MM-dd")}T${aDate?string("HH:mm:ss")}"
<#else>
    <#if transaction.custbody_efx_fe_actual_hour?has_content>
    Fecha="${transaction.trandate?string.iso_nz}T${transaction.custbody_efx_fe_actual_hour}"
    <#else>
    <#assign aDateTime = .now>
    <#assign aDate = aDateTime?date>
    Fecha="${transaction.trandate?string.iso_nz}T${aDate?string("HH:mm:ss")}"
    </#if>
</#if>




<#assign serie_parteuno = transaction.tranid?keep_before("-")>

<#assign serie_partedos_keep = transaction.tranid?keep_after("-")>
<#assign serielength = (serie_partedos_keep?length) - 6>

<#assign serie_partedos = serie_partedos_keep?substring(0, serielength)>

<#assign folio_transaction = serie_partedos_keep?substring(serielength, (serielength+6))>


<#if transaction.custbody_efx_fe_gbl_folio?has_content>
${getAttrPair("Folio",transaction.custbody_efx_fe_gbl_folio)}
<#else>
${getAttrPair("Folio",folio_transaction)}
</#if>

${getAttrPair("Serie",(serie_parteuno + "-" + serie_partedos))}
${getAttrPair("FormaPago",(paymentMethod)!"")!""}
LugarExpedicion="${customCompanyInfo.zip}"
${getAttrPair("MetodoPago",(paymentTerm)!"")!""}
TipoCambio="${exchangeRate}"
Moneda="${currencyCode}"



<#assign total_ieps = desglose_cab.ieps_total?number>
<#assign total_ivasubtotal = 0>
<#assign total_desc_cabecera = desglose_cab.descuentoSinImpuesto?number>

<#list custom.items as customItem>
    <#assign "item" = transaction.item[customItem.line?number]>
    <#if customItem.type != "Discount">
        <#assign desglose_json = item.custcol_efx_fe_tax_json>
        <#assign desglose = desglose_json?eval>
    </#if>
    <#if desglose.iva.name?has_content>
    <#assign total_ivasubtotal = total_ivasubtotal + desglose.iva.importe?number>
    </#if>
</#list>


<#if transaction.custbody_efx_fe_kiosko_customer?has_content>
    <#assign desglosa_ieps = transaction.custbody_efx_fe_kiosko_customer.custentity_efx_cmp_registra_ieps>
<#else>
    <#assign desglosa_ieps = customer.custentity_efx_cmp_registra_ieps>
</#if>


<#if transaction.shippingcost?length gt 0>
<#assign envio_total = transaction.shippingcost?string["0.00"]>
<#assign impuesto_envio_rate = transaction.shippingtax1rate>
<#assign impuesto_envio_total = (envio_total?number * impuesto_envio_rate?number)/100>
<#assign subtotal_envio = desglose_cab.subtotal?number + envio_total?number>
<#assign total_envio = desglose_cab.total?number + envio_total?number + impuesto_envio_total>
<#if desglosa_ieps == true>
SubTotal="${subtotal_envio?string["0.00"]}"
<#else>
<#assign sub_conieps = subtotal_envio + total_ieps>
SubTotal="${sub_conieps?string["0.00"]}"
</#if>
Total="${total_envio?string["0.00"]}"
<#else>
<#assign subtotal_xml = desglose_cab.subtotal?string["0.00"]>
<#if desglosa_ieps == true>
SubTotal="${desglose_cab.subtotal?number?string["0.00"]}"
<#else>
<#assign sub_conieps = desglose_cab.subtotal?number + total_ieps>
<#assign total_xml = desglose_cab.total?number>
SubTotal="${((total_xml - total_ivasubtotal)+total_desc_cabecera)?string["0.00"]}"
</#if>
<#assign total_xml = desglose_cab.total?number?string["0.00"]>
Total="${total_xml}"
</#if>



TipoDeComprobante="${satCodes.proofType}"
Version="3.3"



Descuento="${total_desc_cabecera}">

<#if transaction.recmachcustrecord_mx_rcs_orig_trans?has_content>

<#list custom.relatedCfdis.types as cfdiRelType>
<cfdi:CfdiRelacionados TipoRelacion="${cfdiRelType}">
    <#assign "cfdisArray" = custom.relatedCfdis.cfdis["k"+cfdiRelType?index]>
    <#if cfdisArray?has_content>
    <#list cfdisArray as cfdiIdx>
    <cfdi:CfdiRelacionado  UUID="${transaction.recmachcustrecord_mx_rcs_orig_trans[cfdiIdx.index?number].custrecord_mx_rcs_uuid}" />
</#list>
</#if>
</cfdi:CfdiRelacionados>
</#list>
</#if>
<cfdi:Emisor ${getAttrPair("Nombre", customCompanyInfo.legalname)} RegimenFiscal="${satCodes.industryType}" Rfc="${companyTaxRegNumber}" />
<#if transaction.custbody_efx_fe_kiosko_customer?has_content>
<cfdi:Receptor Nombre="${transaction.custbody_efx_fe_kiosko_name}"
<#if ComercioE == true>
NumRegIdTrib="${CEreceptorNumR}"
ResidenciaFiscal="${CEreceptorResidF}"
</#if>
Rfc="${transaction.custbody_efx_fe_kiosko_rfc}"
UsoCFDI="${satCodes.cfdiUsage}" />

<#else>

<cfdi:Receptor Nombre="${customerName}"
<#if ComercioE == true>
NumRegIdTrib="${CEreceptorNumR}"
ResidenciaFiscal="${CEreceptorResidF}"
</#if>
Rfc="${customer.custentity_mx_rfc}"
UsoCFDI="${satCodes.cfdiUsage}" />
</#if>
<#assign total_impuestos_t_ivas = 0>
<cfdi:Conceptos>
    <#list custom.items as customItem>
    <#assign "item" = transaction.item[customItem.line?number]>
    <#assign "taxes" = customItem.taxes>
    <#assign "itemSatCodes" = satCodes.items[customItem.line?number]>
    <#if customItem.type == "Group"  || customItem.type == "Kit">
    <#assign "itemSatUnitCode" = "H87">
    <#else>
    <#assign "itemSatUnitCode" = (customItem.satUnitCode)!"">

</#if>
<#if customItem.type != "Discount">
<#assign desglose_json = item.custcol_efx_fe_tax_json>
<#assign desglose = desglose_json?eval>
</#if>

<cfdi:Concepto
        Cantidad="${item.quantity?string["0.000000"]}"
<#if ComercioE == true>
NoIdentificacion="${item.item}"
</#if>
<#if item.custcol_efx_fe_upc_code?has_content>
<#if ComercioE == false>
NoIdentificacion="${item.custcol_efx_fe_upc_code}"
</#if>
</#if>

${getAttrPair("ClaveProdServ",(itemSatCodes.itemCode)!"")!""}
${getAttrPair("ClaveUnidad",itemSatUnitCode)!""}
Descripcion="${item.description}"
<#if desglosa_ieps == true>
    Importe="${customItem.amount?number?string["0.00"]}"
    <#if customItem.rate != "">
        ValorUnitario="${customItem.rate?number?string["0.00"]}"
    <#else>
        <#assign rate_faltante = customItem.amount?number / item.quantity?number>
        ValorUnitario="${rate_faltante?string["0.00"]}"
    </#if>
<#else>
    <#if desglose.ieps.name?has_content>
        <#assign imp_ieps_linea = desglose.ieps.importe?number>
        <#assign imp_linea_sindesglose =  customItem.amount?number + imp_ieps_linea>
        <#assign valu_linea_sindesglose =  imp_linea_sindesglose/item.quantity>
        Importe="${imp_linea_sindesglose?string["0.00"]}"
        <#if valu_linea_sindesglose?has_content>
            ValorUnitario="${valu_linea_sindesglose?string["0.00"]}"
        <#else>
            <#assign rate_faltante = imp_linea_sindesglose / item.quantity>
            ValorUnitario="${rate_faltante?string["0.00"]}"
        </#if>
    <#else>
        Importe="${customItem.amount?number?string["0.00"]}"
        <#if customItem.rate != "">
                ValorUnitario="${customItem.rate?number?string["0.00"]}"
            <#else>
                <#assign rate_faltante = customItem.amount?number / item.quantity?number>
                ValorUnitario="${rate_faltante?string["0.00"]}"
            </#if>
    </#if>
</#if>
<#assign json_descuentos = desglose.descuentoSinImpuesto>
<#if json_descuentos?number gt 0>
Descuento="${desglose.descuentoSinImpuesto?number?string["0.00"]}">
<#else>
Descuento="0.00">
</#if>

<cfdi:Impuestos>
    <#if desglose.iva.name?has_content || desglose.ieps.name?has_content || desglose.exento.name?has_content>
    <cfdi:Traslados>

        <#if desglosa_ieps == true>
        <#if desglose.ieps.name?has_content>
        <cfdi:Traslado Base="${desglose.ieps.base_importe?number?string["0.00"]}" Importe="${desglose.ieps.importe?number?string["0.00"]}" Impuesto="003" TasaOCuota="${desglose.ieps.rate_div?number?string["0.000000"]}" TipoFactor="Tasa" />
    </#if>
</#if>

        <#if desglose.iva.name?has_content>

        <#assign iva_enfixed = desglose.iva.importe?number?string["0.00"]>
        <#assign total_impuestos_t_ivas = total_impuestos_t_ivas + iva_enfixed?number>
        <cfdi:Traslado Base="${desglose.iva.base_importe?number?string["0.00"]}" Importe="${desglose.iva.importe?number?string["0.00"]}" Impuesto="002" TasaOCuota="${desglose.iva.rate_div?number?string["0.000000"]}" TipoFactor="Tasa" />
    </#if>


<#if desglose.exento.name?has_content>
<cfdi:Traslado Base="${desglose.exento.base_importe?number?string["0.00"]}" Impuesto="002" TipoFactor="Exento" />
</#if>

</cfdi:Traslados>
</#if>


<#if desglose.retenciones.name?has_content>
<cfdi:Retenciones>

    <cfdi:Retencion Base="${desglose.retenciones.base_importe?number?string["0.00"]}" Importe="${(desglose.retenciones.importe?number)?string["0.00"]}" Impuesto="002" TasaOCuota="${desglose.retenciones.rate_div?number?string["0.000000"]}" TipoFactor="Tasa" />

</cfdi:Retenciones>
</#if>
</cfdi:Impuestos>

${getNodePair("cfdi:InformacionAduanera", "NumeroPedimento" ,item.custcol_mx_txn_line_sat_cust_req_num)}
${getNodePair("cfdi:CuentaPredial", "Numero" ,item.custcol_mx_txn_line_sat_cadastre_id)}
<#if customItem.parts?has_content>
<#list customItem.parts as part>
<#assign "partItem" = transaction.item[part.line?number]>
<#assign "partSatCodes" = satCodes.items[part.line?number]>
<cfdi:Parte Cantidad="${partItem.quantity?string["0.0"]}" ClaveProdServ="${partSatCodes.itemCode}" Descripcion="${partItem.description}" Importe="${part.amount?number?string["0.00"]}" ValorUnitario="${part.rate?number?string["0.00"]}"/>
</#list>
</#if>
</cfdi:Concepto>
</#list>

<#if transaction.shippingcost?length gt 0>
<#assign costo_envio_t = transaction.shippingcost?string["0.00"]>
<#if costo_envio_t != "0.00">
<cfdi:Concepto
        Cantidad="1.000000"
        ${getAttrPair("ClaveProdServ",(transaction.custbody_efx_fe_sat_cps_envio)!"")!""}
ClaveUnidad="E48"
Descripcion="${transaction.shipmethod}"
Importe="${transaction.shippingcost?string["0.00"]}"
ValorUnitario="${transaction.shippingcost?string["0.00"]}"
Descuento="0.00">
<#assign impuesto_envio_rate = transaction.shippingtax1rate>
<#assign tasa_envio = impuesto_envio_rate?number / 100>
<#assign envio_total = transaction.shippingcost?string["0.00"]>
<#assign impuesto_envio_total = (envio_total?number * impuesto_envio_rate?number)/100>
<cfdi:Impuestos>
    <cfdi:Traslados>
        <cfdi:Traslado Base="${transaction.shippingcost?string["0.00"]}" Importe="${impuesto_envio_total?string["0.00"]}" Impuesto="002" TasaOCuota="${tasa_envio?number?string["0.000000"]}" TipoFactor="Tasa" />
    </cfdi:Traslados>
</cfdi:Impuestos>
</cfdi:Concepto>
</#if>
</#if>
</cfdi:Conceptos>

<#assign json_ivas = desglose_cab.rates_iva_data>

<#list json_ivas as Iva_rate, Iva_total>
<#assign total_traslados_ivacero = total_traslados_ivacero + 1>
</#list>


<#assign total_tras = desglose_cab.ieps_total?number + desglose_cab.iva_total?number + desglose_cab.retencion_total?number>
<#assign total_trasladados_monto = desglose_cab.ieps_total?number + desglose_cab.iva_total?number>



<#assign total_impuestos_t = 0>
<#if desglose_cab.ieps_total != "0.00" && desglose_cab.iva_total != "0.00">
<#assign total_impuestos_t = desglose_cab.ieps_total?number + desglose_cab.iva_total?number>
<#elseif desglose_cab.ieps_total != "0.00">
<#assign total_impuestos_t = desglose_cab.ieps_total?number>
<#elseif desglose_cab.iva_total != "0.00">
<#assign total_impuestos_t = desglose_cab.iva_total?number>
</#if>

<#if exchangeRate?number gt 0>
<#if currencyCode=="MXN">
<#assign total_impuestos_t = total_impuestos_t / exchangeRate?number>
<#else>
<#assign total_impuestos_t = total_impuestos_t>
</#if>
</#if>

<#assign exentoContador = 0>
<#if desglosa_ieps == true>
    <#if (desglose_cab.ieps_total != "0.00" || desglose_cab.iva_total != "0.00") && desglose_cab.retencion_total != "0.00">
        <#assign exentoContador = exentoContador+1>
        <cfdi:Impuestos TotalImpuestosRetenidos="${(desglose_cab.retencion_total?number)?string["0.00"]}" TotalImpuestosTrasladados="${total_impuestos_t?string["0.00"]}">
    <#elseif desglose_cab.retencion_total != "0.00">
        <#assign exentoContador = exentoContador+1>
        <cfdi:Impuestos TotalImpuestosRetenidos="${(desglose_cab.retencion_total?number)?string["0.00"]}">
    <#elseif desglose_cab.ieps_total != "0.00" || desglose_cab.iva_total != "0.00" || total_traslados_ivacero gt 0>
        <#assign exentoContador = exentoContador+1>
        <cfdi:Impuestos TotalImpuestosTrasladados="${total_impuestos_t?string["0.00"]}">
    </#if>
<#else>
    <#assign total_impuestos_t = total_impuestos_t_ivas>
    <#if (desglose_cab.ieps_total != "0.00" || desglose_cab.iva_total != "0.00") && desglose_cab.retencion_total != "0.00">
        <#assign exentoContador = exentoContador+1>
        <cfdi:Impuestos TotalImpuestosRetenidos="${(desglose_cab.retencion_total?number)?string["0.00"]}" TotalImpuestosTrasladados="${total_impuestos_t?string["0.00"]}">
    <#elseif desglose_cab.retencion_total != "0.00">
        <#assign exentoContador = exentoContador+1>
        <cfdi:Impuestos TotalImpuestosRetenidos="${(desglose_cab.retencion_total?number)?string["0.00"]}">
    <#elseif desglose_cab.ieps_total != "0.00" || desglose_cab.iva_total != "0.00" || total_traslados_ivacero gt 0>
        <#assign exentoContador = exentoContador+1>
        <cfdi:Impuestos TotalImpuestosTrasladados="${total_impuestos_t?string["0.00"]}">
    </#if>
</#if>


<#if desglose_cab.retencion_total != "0.00">
<cfdi:Retenciones>
    <#assign json_ret = desglose_cab.rates_retencion_data>
    <#list json_ret as ret_rate, ret_total>
    <#assign ret_ratenum = ret_rate?number>
    <#assign ret_tasaocuota = ret_ratenum/100>
    <cfdi:Retencion Importe="${(ret_total?number)?string["0.00"]}" Impuesto="002" />

</#list>
</cfdi:Retenciones>
</#if>

<#if desglose_cab.ieps_total != "0.00" || desglose_cab.iva_total != "0.00" || total_traslados_ivacero gt 0>

<cfdi:Traslados>
    <#assign json_ieps = desglose_cab.rates_ieps_data>
    <#assign json_ivas = desglose_cab.rates_iva_data>

    <#list json_ieps as Ieps_rate, Ieps_total>
    <#assign ieps_ratenum = Ieps_rate?number>
    <#assign ieps_tasaocuota = ieps_ratenum/100>

    <#if exchangeRate?number gt 0>
    <#if currencyCode=="MXN">
    <#assign Ieps_total = Ieps_total?number / exchangeRate?number>
    <#else>
    <#assign Ieps_total = Ieps_total?number>
    </#if>
    </#if>


    <#if desglosa_ieps == true>
        <cfdi:Traslado Importe="${Ieps_total?number?string["0.00"]}" Impuesto="003" TasaOCuota="${ieps_tasaocuota?string["0.000000"]}" TipoFactor="Tasa" />
    </#if>
</#list>


<#list json_ivas as Iva_rate, Iva_total>
<#assign iva_ratenum = Iva_rate?number>
<#assign iva_tasaocuota = iva_ratenum/100>





<#if exchangeRate?number gt 0>
<#if currencyCode=="MXN">
    <#assign Iva_total_ex = Iva_total?number / exchangeRate?number>
    <#else>
    <#assign Iva_total_ex = Iva_total?number>
    </#if>
 <cfdi:Traslado Importe="${Iva_total_ex?number?string["0.00"]}" Impuesto="002" TasaOCuota="${iva_tasaocuota?string["0.000000"]}" TipoFactor="Tasa" />
 <#else>
 <cfdi:Traslado Importe="${Iva_total?number?string["0.00"]}" Impuesto="002" TasaOCuota="${iva_tasaocuota?string["0.000000"]}" TipoFactor="Tasa" />
 </#if>
</#list>

</cfdi:Traslados>
</#if>

<#if exentoContador gt 0>
</cfdi:Impuestos>
        </#if>

<#if ImpLocal == true>
<cfdi:Complemento>
    <implocal:ImpuestosLocales version="1.0" TotaldeRetenciones="0.00" TotaldeTraslados="${desglose_cab.local_total?number?string["0.00"]}">
    <#assign json_local = desglose_cab.rates_local_data>

    <#list json_local as local_rate, local_total>
    <#assign local_ratenum = local_rate?number>
    <#assign local_tasaocuota = local_ratenum/100>
        <implocal:TrasladosLocales ImpLocTrasladado="${local_rate}" TasadeTraslado="${local_rate?number?string["0.00"]}" Importe="${local_total?number?string["0.00"]}" />
    </#list>
    </implocal:ImpuestosLocales>
</cfdi:Complemento>
</#if>

<#assign "Addenda" = transaction.custbody_mx_cfdi_sat_addendum>


<#if ComercioE == true>
    <#assign "CertOrigen" = transaction.custbody_efx_fe_ce_certificado_origen>
    <#assign "CEIncoterm" = transaction.custbody_efx_fe_ce_incoterm.custrecord_efx_fe_ce_incot_sat>
    <#assign "CESubdivision" = transaction.custbody_efx_fe_ce_subdivision>
    <#assign "CETipoCUSD" = transaction.custbody_efx_fe_ce_exchage>
    <#assign "CETotalUSD" = transaction.custbody_efx_fe_ce_totalusd>
    <#assign "CENcertOrigen" = transaction.custbody_efx_fe_ce_ncertificado_origen>
    <#assign "CEClavePedimento" = transaction.custbody_efx_fe_ce_clavepedimento>
    <#assign "CENExpConfiable" = transaction.custbody_efx_fe_numexp_confiable>
    <#assign "CEObservaciones" = transaction.custbody_efx_fe_ce_observaciones>
    <#assign "CEPropNumreg" = transaction.custbody_efx_fe_ce_propietario_numreg>
    <#assign "CEpropResidenciaF" = transaction.custbody_efx_fe_ce_p_residenciafiscal>

    <#assign "CEdestinatario" = transaction.custbody_efx_fe_ce_destinatario_name>
    <#assign "CEdestNumreg" = transaction.custbody_efx_fe_ce_destinatario_name.custrecord_efx_fe_cedd_numregidtrib>
    <#assign "CEdestName" = transaction.custbody_efx_fe_ce_destinatario_name.name>


    <#assign "json_direccion_field" = transaction.custbody_efx_fe_dirjson_emisor>
    <#if json_direccion_field?has_content>
        <#assign "json_direccion" = json_direccion_field?eval>
    </#if>

    <cfdi:Complemento>
        <cce11:ComercioExterior Version="1.1"
                                TipoOperacion="2"
                                ClaveDePedimento="${CEClavePedimento}"
                                CertificadoOrigen="${CertOrigen}"
        <#if CertOrigen != "0">
            NumCertificadoOrigen="${CENcertOrigen}"
        </#if>
        <#if CENExpConfiable?has_content>
            NumeroExportadorConfiable="${CENExpConfiable}"
        </#if>
        Incoterm="${CEIncoterm}"
        Subdivision="${CESubdivision}"
        <#if CEObservaciones?has_content>
            Observaciones="${CEObservaciones}"
        </#if>
        TipoCambioUSD="${CETipoCUSD?number?string["0.0000"]}"
        TotalUSD="${CETotalUSD?replace(',','')?number?string["0.00"]}">
        <#if json_direccion_field?has_content>
            <cce11:Emisor>
            <cce11:Domicilio Calle="${json_direccion.emisor.Calle}"
            <#if json_direccion.emisor.NumeroExterior?has_content>
                NumeroExterior="${json_direccion.emisor.NumeroExterior}"
            </#if>
            <#if json_direccion.emisor.NumeroInterior?has_content>
                NumeroInterior="${json_direccion.emisor.NumeroInterior}"
            </#if>
            Colonia="${json_direccion.emisor.Colonia}"
            <#if json_direccion.emisor.Localidad?has_content>
                Localidad="${json_direccion.emisor.Localidad}"
            </#if>
            <#if json_direccion.emisor.Referencia?has_content>
                Referencia="${json_direccion.emisor.Referencia}"
            </#if>
            Municipio="${json_direccion.emisor.Municipio}"
            Estado="${json_direccion.emisor.Estado}"
            Pais="${json_direccion.emisor.Pais}"
            CodigoPostal="${json_direccion.emisor.CodigoPostal}"/>
            </cce11:Emisor>

            <#if CEPropNumreg?has_content && CEpropResidenciaF?has_content>
                <cce11:Propietario NumRegIdTrib="${CEPropNumreg}" ResidenciaFiscal="${CEpropResidenciaF}"/>
            </#if>
            <cce11:Receptor>
            <cce11:Domicilio Calle="${json_direccion.receptor.Calle}"
            <#if json_direccion.receptor.NumeroExterior?has_content>
                NumeroExterior="${json_direccion.receptor.NumeroExterior}"
            </#if>
            <#if json_direccion.receptor.NumeroInterior?has_content>
                NumeroInterior="${json_direccion.receptor.NumeroInterior}"
            </#if>
            <#if json_direccion.receptor.Colonia?has_content>
                Colonia="${json_direccion.receptor.Colonia}"
            </#if>
            <#if json_direccion.receptor.Localidad?has_content>
                Localidad="${json_direccion.receptor.Localidad}"
            </#if>
            <#if json_direccion.receptor.Referencia?has_content>
                Referencia="${json_direccion.receptor.Referencia}"
            </#if>
            <#if json_direccion.receptor.Municipio?has_content>
                Municipio="${json_direccion.receptor.Municipio}"
            </#if>
            Estado="${json_direccion.receptor.Estado}"
            Pais="${json_direccion.receptor.Pais}"
            CodigoPostal="${json_direccion.receptor.CodigoPostal}"/>
            </cce11:Receptor>
            <#if CEdestinatario?has_content>
                <cce11:Destinatario NumRegIdTrib="${CEdestNumreg}" Nombre="${CEdestName}">
                    <cce11:Domicilio Calle="${json_direccion.destinatario.Calle}"
                    <#if json_direccion.destinatario.NumeroExterior?has_content>
                        NumeroExterior="${json_direccion.destinatario.NumeroExterior}"
                    </#if>
                    <#if json_direccion.destinatario.NumeroInterior?has_content>
                        NumeroInterior="${json_direccion.destinatario.NumeroInterior}"
                    </#if>
                Colonia="${json_direccion.destinatario.Colonia}"
                    <#if json_direccion.destinatario.Localidad?has_content>
                        Localidad="${json_direccion.destinatario.Localidad}"
                    </#if>
                Municipio="${json_direccion.destinatario.Municipio}"
                Estado="${json_direccion.destinatario.Estado}"
                Pais="${json_direccion.destinatario.Pais}"
                CodigoPostal="${json_direccion.destinatario.CodigoPostal}"/>
                </cce11:Destinatario>
            </#if>
        </#if>
    <cce11:Mercancias>
    <#list custom.items as customItem>
        <#assign "item" = transaction.item[customItem.line?number]>
        <cce11:Mercancia NoIdentificacion="${item.item}" FraccionArancelaria="${item.custcol_efx_fe_ce_farancel_code}" CantidadAduana="${item.custcol_efx_fe_ce_cant_aduana?replace(',','')?number?string["0.000"]}" UnidadAduana="${item.custcol_efx_fe_unit_code_ce}" ValorUnitarioAduana="${item.custcol_efx_fe_ce_val_uni_aduana?replace(',','')?number?string["0.00"]}" ValorDolares="${item.custcol_efx_fe_ce_val_dolares?replace(',','')?number?string["0.00"]}">
       <#if item.custcol_efx_fe_ce_des_especificas?has_content>
          <cce11:DescripcionesEspecificas Marca="${item.custcol_efx_fe_ce_des_especificas}" NumeroSerie="${item.custcol_efx_fe_ce_des_numero_serie}" Modelo="${item.custcol_efx_fe_ce_des_modelo}"/>
        </#if>
        </cce11:Mercancia>

    </#list>
    </cce11:Mercancias>
    </cce11:ComercioExterior>
    </cfdi:Complemento>
</#if>
<#if Addenda?has_content>
    ${Addenda?replace("&gt;", ">")?replace("&lt;", "<")?replace("<br />","")}
</#if>
</cfdi:Comprobante>