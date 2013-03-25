<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: PayPal details --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<cfif len(stObj.transactionID)>
	<cfset stTransaction = application.fc.lib.paypal.getTransactionDetails(transactionID=stObj.transactionID) />
	
	<skin:loadJS id="jquery" />
	
	<ft:form>
		<cfoutput><div class="basicdetails"></cfoutput>
			<ft:field label="Transaction ID"><cfoutput>#stTransaction.transactionID#</cfoutput></ft:field>
			<ft:field label="Payer"><cfoutput>#stTransaction.RECEIVEREMAIL#</cfoutput></ft:field>
			<ft:field label="Payer ID"><cfoutput>#stTransaction.PAYERID#</cfoutput></ft:field>
			<ft:field label="First Name"><cfoutput>#stTransaction.FIRSTNAME#</cfoutput></ft:field>
			<ft:field label="Last Name"><cfoutput>#stTransaction.LASTNAME#</cfoutput></ft:field>
			<ft:field label="Gross Amount"><cfoutput>#stTransaction.AMT#</cfoutput></ft:field>
			<ft:field label="Payment Status"><cfoutput>#stTransaction.PAYERSTATUS#</cfoutput></ft:field>
			<ft:field label="Pending Reason"><cfoutput>#stTransaction.PENDINGREASON#</cfoutput></ft:field>
		<cfoutput></div><div class="fulldump" style="display:none;"></cfoutput>
		<cfdump var="#stTransaction#">
		<cfoutput></div></cfoutput>
		
		<ft:buttonPanel>
			<cfoutput><a href="##" onclick="$j('.basicdetails').toggle();$j('.fulldump').toggle();return false;" style="padding:10px;">full details</a></cfoutput>
			<!--- <ft:button value="Refund" url="#application.fapi.getLink(objectid=stObj.objectid,type=stObj.typename,view='webtopDialogStandard',bodyView='webtopRefund')#" /> --->
		</ft:buttonPanel>
	</ft:form>
<cfelse>
	<cfoutput>No transaction ID</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false" />