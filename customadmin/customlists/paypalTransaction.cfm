<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<ft:processform action="Resolve With PayPal">
	<cfset o = application.fapi.getContentType(typename="paypalTransaction") />
	<cfloop list="#form.selectedobjectid#" index="thistransaction">
		<cfset stResult = o.resolveWithPayPal(objectid=thistransaction) />
		<cfif findnocase("success",stResult.result)>
			<skin:bubble message="Payment of #stResult.amount# by #stResult.firstname# #stResult.lastname# at #timeformat(stResult.datetimeTransactionStart,'hh:mm:sstt')#, #dateformat(stResult.datetimeTransactionStart,'d mmm yyyy')# was successfull" tags="paypalTransaction" />
		<cfelse>
			<skin:bubble message="Payment of #stResult.amount# by #stResult.firstname# #stResult.lastname# at #timeformat(stResult.datetimeTransactionStart,'hh:mm:sstt')#, #dateformat(stResult.datetimeTransactionStart,'d mmm yyyy')# failed: #stResult.result#" tags="paypalTransaction,error" />
		</cfif>
	</cfloop>
</ft:processform>



<!--- set up page header --->
<admin:header title="Transaction Log" />

<cfset aColumns = listToArray("firstname,lastname,invoiceno,transactionID,amount,creditcardnumber,datetimeTransactionStart,result") />
<cfset aColumns[4] = structnew() />
<cfset aColumns[4].webskin = "cellTransactionID" />
<cfset aColumns[4].title = "Transaction No" />

<ft:objectAdmin
	title="Transaction Log"
	typename="paypalTransaction"
	ColumnList="firstname,lastname,invoiceno,amount,creditcardnumber,datetimeTransactionStart,result"
	aCustomColumns="#aColumns#"
	SortableColumns=""
	lFilterFields="firstname,lastname,invoiceno,transactionID,amount,creditcardnumber,result"
	sqlorderby="datetimeTransactionStart desc"
	lCustomActions="Resolve With PayPal"
	plugin="paypal" />

<admin:footer />

<cfsetting enablecfoutputonly="no">
