<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

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
	plugin="paypal" />

<admin:footer />

<cfsetting enablecfoutputonly="no">
