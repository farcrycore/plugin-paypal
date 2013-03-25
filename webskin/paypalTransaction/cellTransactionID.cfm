<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Object admin cell for transaction ID --->

<cfif len(stObj.transactionID)>
	<cfoutput><a href="##" onclick="$fc.objectAdminAction('PayPal Transaction', '#application.fapi.getLink(objectid=stObj.objectid,type=stobj.typename,view='webtopDialogStandard',bodyView='webtopOverviewTabPaypal')#');return false;">#stObj.transactionID#</a></cfoutput>
<cfelse>
	<cfoutput>N/A</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false" />