<!-- 
*************************************************
CallerService.cfc

This coldufion component reused by all sample page to get credential information and 
it has getNVPResponse method which takes nvpString as parameter and return Nvpresponse 
as CF Struct object. using this object we can pring the response values in Display.cfm page

*************************************************
--->
<cfcomponent>
	
	<cffunction name="getNVPResponse" access="public" returntype="struct" hint="This method will take response from the server and display accordingly in the browser">
		<cfargument name="nvpString" type="string" required="yes" >
		
		<cfset var responseStruct = StructNew()>
		<cfset var thisvalue = "">
		
		<cfloop list="#arguments.nvpString#" index="thisvalue" delimiters="&">
			<cfset responseStruct[trim(listfirst(thisvalue,"="))] = urldecode(trim(listlast(thisvalue,"="))) />
		</cfloop>
		
		<cfreturn responseStruct>
	</cffunction>
	
	<cffunction name="parseProxy" access="private" output="false" returntype="struct">
		<cfargument name="proxy" type="string" required="true" />
		
		<cfset var stResult = structnew() />
		
		<cfif len(arguments.proxy)>
			<cfif listlen(arguments.proxy,"@") eq 2>
				<cfset stResult.login = listfirst(arguments.proxy,"@") />
				<cfset stResult.user = listfirst(stResult.login,":") />
				<cfset stResult.password = listlast(stResult.login,":") />
			<cfelse>
				<cfset stResult.user = "" />
				<cfset stResult.password = "" />
			</cfif>
			<cfset stResult.server = listlast(arguments.proxy,"@") />
			<cfset stResult.domain = listfirst(stResult.server,":") />
			<cfif listlen(stResult.server,":") eq 2>
				<cfset stResult.port = listlast(stResult.server,":") />
			<cfelse>
				<cfset stResult.port = "80" />
			</cfif>
		<cfelse>
			<cfset stResult.user = "" />
			<cfset stResult.password = "" />
			<cfset stResult.domain = "" />
			<cfset stREsult.port = "80" />
		</cfif>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="makeAPIRequest" access="public" returntype="struct">
		<cfargument name="server" type="string" required="false" default="#application.config.paypal.server#" />
		<cfargument name="username" type="string" required="false" default="#application.config.paypal.username#" />
		<cfargument name="password" type="string" required="false" default="#application.config.paypal.password#" />
		<cfargument name="signature" type="string" required="false" default="#application.config.paypal.signature#" />
		<cfargument name="proxy" type="string" required="false" default="#application.config.paypal.proxy#" />
		
		<cfargument name="requestData" type="struct" required="true" />
		
		<cfset var stProxy = parseProxy(arguments.proxy) />
		<cfset var cfhttp = structnew() />
		<cfset var key = "" />
		<cfset var wddx = "" />
		
		<cfset arguments.requestData.USER = arguments.username />
		<cfset arguments.requestData.PWD = arguments.password />
		<cfset arguments.requestData.SIGNATURE = arguments.signature />
		<cfset arguments.requestData.SUBJECT = "" />
		<cfset arguments.requestData.VERSION = "92.0">
		
		<cfhttp url="https://#arguments.server#" method="POST" proxyPort="#stProxy.port#" proxyUser="#stProxy.user#" proxyPassword="#stProxy.password#" timeout="60">
			<cfloop collection="#arguments.requestData#" item="key">
				<cfhttpparam name="#key#" value="#requestData[key]#" type="FormField" encoded="YES">
			</cfloop>
		</cfhttp>
		
		<cfif not cfhttp.statuscode eq "200 OK">
			<cfwddx action="cfml2wddx" input="#arguments#" output="wddx" />
			<cfthrow message="Error accessing API: #cfhttp.statuscode#" detail="#wddx#" extendedinfo="#cfhttp.filecontent#" type="api" />
		<cfelse>
			<cfreturn getNVPResponse(cfhttp.FileContent) />
		</cfif>
	</cffunction>
	
	<cffunction name="populateEmptyValue" returntype="array" output="no" hint="This is method check whether note and uniqueid is null or not if it is null, it will create empty object">
		<cfargument name="noteORuid" type="any" required="true">
		<cfargument name="size" type="any" required="true">
		<cfif ArrayIsEmpty(noteORuid)>
			<cfloop index = "i" from = "1" to = #size#>
				<cfset noteORuid[i] = "">
			</cfloop>
		<cfelse> 
			<cfloop index = "i" from = "1" to = #size#>
				<cfif  ArrayLen(noteORuid) not equal size>
					<cfscript>
						ArrayAppend(noteORuid, "");
					</cfscript>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn #noteORuid#>
	</cffunction>
	
	<cffunction name="arrayify" returntype="struct" output="false" access="private" hint="Looks for specified numbered properties and converts to an array of structs">
		<cfargument name="st" type="struct" required="true" />
		<cfargument name="properties" type="string" required="true" />
		<cfargument name="arrayname" type="string" required="true" />
		
		<cfset var stResult = duplicate(arguments.st) />
		<cfset var thisprop = "" />
		<cfset var regexp = "^L_(#replace(arguments.properties,',','|','all')#)\d+$" />
		<cfset var index = 0 />
		<cfset var key = "" />
		
		<cfset stResult[arguments.arrayname] = arraynew(1) />
		
		<cfloop collection="#stResult#" item="key">
			<cfif refindnocase(regexp,key)>
				<cfset index = int(rereplace(key,"^[A-Z_]+(\d+)$","\1")) + 1 />
				
				<cfif not arrayIsDefined(stResult[arguments.arrayname],index)>
					<cfset stResult[arguments.arrayname][index] = structnew() />
				</cfif>
				
				<cfset stResult[arguments.arrayname][index][rereplace(key,"^L_([A-Z_]+)\d+$","\1")] = stResult[key] />
				<cfset structdelete(stResult,key) />
			</cfif>
		</cfloop>
		
		<cfreturn stResult />
	</cffunction>
	
	
	<!--- HELPER FUNCTIONS --->
	
	<!--- https://www.x.com/developers/paypal/documentation-tools/api/transactionsearch-api-operation-nvp --->
	<cffunction name="searchTransactions" access="public" output="false" returntype="struct" hint="Searches transaction history for transactions that meet the specified criteria">
		<cfargument name="server" type="string" required="false" default="#application.config.paypal.server#" />
		<cfargument name="username" type="string" required="false" default="#application.config.paypal.username#" />
		<cfargument name="password" type="string" required="false" default="#application.config.paypal.password#" />
		<cfargument name="signature" type="string" required="false" default="#application.config.paypal.signature#" />
		<cfargument name="proxy" type="string" required="false" default="#application.config.paypal.proxy#" />
		
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="false" />
		<cfargument name="transactionID" type="string" required="false" />
		<cfargument name="invoiceNo" type="string" required="false" />
		<cfargument name="status" type="string" required="false" options="Pending,Processing,Success,Denied,Reversed" />
		<cfargument name="firstname" type="string" required="false" />
		<cfargument name="lastname" type="string" required="false" />
		
		
		<cfset var stRequestData = structnew() />
		<cfset var stResponse = "" />
		<cfset var key = "" />
		<cfset var index = 0 />
		
		
		<cfset requestData.METHOD = "TransactionSearch" />
		<cfset requestData.STARTDATE = "#dateformat(arguments.startDate,'yyyy-mm-dd')#T00:00:00Z" />
		
		<cfif structkeyexists(arguments,"endDate")>
			<cfset requestData.ENDDATE = "#dateformat(arguments.endDate,'yyyy-mm-dd')#T23:00:00Z" />
		<cfelse>
			<cfset requestData.ENDDATE = "#dateformat(arguments.startDate,'yyyy-mm-dd')#T23:00:00Z" />
		</cfif>
		
		<cfif structkeyexists(arguments,"transactionID")>
			<cfset requestData.TRANSACTIONID = arguments.transactionID />
		</cfif>
		
		<cfif structkeyexists(arguments,"invoiceNo")>
			<cfset requestData.INVNUM = arguments.invoiceNo />
		</cfif>
		
		<cfif structkeyexists(arguments,"status")>
			<cfset requestData.STATUS = arguments.status />
		</cfif>
		
		<cfif structkeyexists(arguments,"firstname")>
			<cfset requestData.FIRSTNAME = arguments.firstname />
		</cfif>
		
		<cfif structkeyexists(arguments,"lastname")>
			<cfset requestData.LASTNAME = arguments.lastname />
		</cfif>
		
		<cfset stResponse = makeAPIRequest(
			server=arguments.server,
			username=arguments.username,
			password=arguments.password,
			signature=arguments.signature,
			proxy=arguments.proxy,
			requestData=requestData) />
		
		<cfset stResponse = arrayify(stResponse,"errorcode,longmessage,severitycode,shortmessage","errors") />
		<cfset stResponse = arrayify(stResponse,"timestamp,timezone,type,email,name,transactionid,status,amt,currencycode,feeamt,netamt","transactions") />
		
		<cfreturn stResponse />
	</cffunction>
	
	<!--- https://www.x.com/developers/paypal/documentation-tools/api/dodirectpayment-api-operation-nvp --->
	<cffunction name="makeDirectPayment" access="public" output="false" returntype="struct" hint="Enables you to process a credit card payment">
		<cfargument name="server" type="string" required="false" default="#application.config.paypal.server#" />
		<cfargument name="username" type="string" required="false" default="#application.config.paypal.username#" />
		<cfargument name="password" type="string" required="false" default="#application.config.paypal.password#" />
		<cfargument name="signature" type="string" required="false" default="#application.config.paypal.signature#" />
		<cfargument name="proxy" type="string" required="false" default="#application.config.paypal.proxy#" />
		
		<cfargument name="paymentAction" type="string" required="false" default="sale" options="sale,authorization" />
		<cfargument name="ipaddress" type="string" required="false" default="#cgi.remote_addr#" hint="Should be the IP address of the buyer" />
		<cfargument name="returnFMDetails" type="boolean" required="false" default="false" hint="Flag to indicate whether you want the results returned by Fraud Management Filters" />
		
		<!--- Credit card details --->
		<cfargument name="creditcardtype" type="string" required="false" options="visa,mastercard,discover,amex,maestro" />
		<cfargument name="creditcardnumber" type="string" required="true" />
		<cfargument name="creditcardexpiry" type="string" required="false" />
		<cfargument name="creditcardcvv2" type="string" required="false" />
		
		<!--- MESTRO only --->
		<cfargument name="startDate" type="string" required="false" hint="Month and year that Maestro card was issued" />
		<cfargument name="issueNumber" type="string" required="false" hint="Issue number of Maestro card" />
		
		<!--- 3D Secure Request Fields (U.K. Merchants Only). Values returned by the Cardinal Centinel. --->
		<cfargument name="authStatus3DS" type="string" required="false" hint="A . If the cmpi_lookup request returns Y for Enrolled, set this field to the PAResStatus value returned by cmpi_authenticate. Otherwise, set this field to blank." />
		<cfargument name="mpivendor3DS" type="string" required="false" hint="Set this field to the Enrolled value returned by cmpi_lookup." />
		<cfargument name="CAVV" type="string" required="false" hint="If the cmpi_lookup request returns Y for Enrolled, set this field to the Cavv value returned by cmpi_authenticate. Otherwise, set this field to blank." />
		<cfargument name="eci3DS" type="string" required="false" hint="If the cmpi_lookup request returns Y for Enrolled, set this field to the EciFlag value returned by cmpi_authenticate. Otherwise, set this field to the EciFlag value returned by cmpi_lookup." />
		<cfargument name="XID" type="string" required="false" hint="If the cmpi_lookup request returns Y for Enrolled, set this field to the Xid value returned by cmpi_authenticate. Otherwise, set this field to blank. " />
		
		<!--- Payer details --->
		<cfargument name="farcryuser" type="string" required="false" default="#application.security.getCurrentUser()#" />
		<cfargument name="email" type="string" required="false" maxLength="127" />
		<cfargument name="firstname" type="string" required="true" maxLength="25" />
		<cfargument name="lastname" type="string" required="true" maxLength="25" />
		
		<!--- Address --->
		<cfargument name="street" type="string" required="true" maxLength="100" />
		<cfargument name="street2" type="string" required="false" maxLength="100" />
		<cfargument name="city" type="string" required="true" maxLength="40" />
		<cfargument name="state" type="string" required="true" maxLength="40" />
		<cfargument name="country" type="string" required="true" maxLength="2" />
		<cfargument name="zip" type="string" required="true" maxLength="20" />
		<cfargument name="phone" type="string" required="false" maxLength="20" />
		
		<!--- Shipping --->
		<cfargument name="shipToName" type="string" required="false" maxLength="32" hint="Person’s name associated with this shipping address. It is required if using a shipping address." />
		<cfargument name="shipToStreet" type="string" required="false" maxLength="100" hint="Required if using a shipping address" />
		<cfargument name="shipToStreet2" type="string" required="false" maxLength="100" />
		<cfargument name="shipToCity" type="string" required="false" maxLength="40" hint="Required if using a shipping address" />
		<cfargument name="shipToState" type="string" required="false" maxLength="40" hint="Required if using a shipping address" />
		<cfargument name="shipToCountry" type="string" required="false" maxLength="2" hint="Required if using a shipping address" />
		<cfargument name="shipToZip" type="string" required="false" maxLength="20" hint="Required if using a shipping address" />
		
		<!--- Payment --->
		<cfargument name="amount" type="numeric" required="true" hint="The total cost of the transaction to the buyer. If shipping cost and tax charges are known, include them in this value." />
		<cfargument name="currencyCode" type="string" required="false" default="AUD" maxLength="3" hint="A 3-character currency code" />
		<cfargument name="itemAmount" type="numeric" required="false" hint="Sum of cost of all items in this order" />
		<cfargument name="shippingAmount" type="numeric" required="false" hint="Total shipping costs for this order. If you specify this, you must also specify itemAmmount." />
		<cfargument name="insuranceAmount" type="numeric" required="false" hint="Total shipping insurance costs for this order" />
		<cfargument name="shippingDiscountAmount" type="numeric" required="false" hint="Shipping discount for this order, specified as a negative number" />
		<cfargument name="handlingAmount" type="numeric" required="false" hint="Total handling costs for this order. If you specify this, you must also specify itemAmmount." />
		<cfargument name="taxAmount" type="numeric" required="false" hint="Sum of tax for all items in this order. This is required if you specifiy item taxAmount's." />
		
		<!--- Miscellaneous --->
		<cfargument name="description" type="string" required="false" maxLength="127" hint="Description of items the buyer is purchasing" />
		<cfargument name="custom" type="string" required="false" maxLength="256" hint="A free-form field for your own use" />
		<cfargument name="invoiceNo" type="string" required="false" maxLength="256" hint="Your own invoice or tracking number" />
		<cfargument name="buttonSource" type="string" required="false" maxLength="32" hint="An identification code for use by third-party applications to identify transactions" />
		<cfargument name="notifyURL" type="string" required="false" maxLength="2048" hint="Your URL for receiving Instant Payment Notification (IPN) about this transaction. If you do not specify this value in the request, the notification URL from your Merchant Profile is used, if one exists." />
		<cfargument name="recurring" type="string" required="false" hint="Flag to indicate a recurring transaction" />
		
		<!--- Items --->
		<cfargument name="items" type="array" required="false" hint="Specific items in this payment" />
		<!--- name 			: (opt) max 127 characters --->
		<!--- description 	: (opt) max 127 characters --->
		<!--- amount 		: (opt) if this is specified, then so should itemAmount (above) --->
		<!--- number 		: (opt) item number, max 127 characters --->
		<!--- quantity		: (opt) --->
		<!--- taxAmount		: (opt) --->
		
		
		<cfset var stRequestData = structnew() />
		<cfset var stResponse = "" />
		<cfset var key = "" />
		<cfset var index = 0 />
		
		
		<cfset requestData.METHOD = "DoDirectPayment" />
		<cfset requestData.PAYMENTACTION = arguments.paymentaction />
		<cfset requestData.IPADDRESS = arguments.ipaddress />
		<cfif arguments.returnFMDetails>
			<cfset requestData.RETURNFMDETAILS = 1 />
		<cfelse>
			<cfset requestData.RETURNFMDETAILS = 0 />
		</cfif>
		
		<!--- Credit card details --->
		<cfif structkeyexists(arguments,"creditcardtype")>
			<cfset requestData.CREDITCARDTYPE = left(arguments.creditcardtype,10) />
		</cfif>
		<cfset requestData.ACCT = rereplace(arguments.creditcardnumber,"[^\d]+","","ALL") />
		<cfif structkeyexists(arguments,"creditcardexpiry")>
			<cfset requestData.EXPDATE = rereplace(arguments.creditcardexpiry,"[^\d]+","","ALL") />
		</cfif>
		<cfif structkeyexists(arguments,"creditcardcvv2")>
			<cfset requestData.CVV2 = left(arguments.creditcardcvv2,4) />
		</cfif>
		
		<!--- MESTRO only --->
		<cfif structkeyexists(arguments,"startDate")>
			<cfset requestData.STARTDATE = rereplace(arguments.startDate,"[^\d]+","","ALL") />
		</cfif>
		<cfif structkeyexists(arguments,"issueNumber")>
			<cfset requestData.ISSUENUMBER = left(rereplace(arguments.issueNumber,"[^\d]+","","ALL"),2) />
		</cfif>
		
		<!--- 3D Secure Request Fields (U.K. Merchants Only). Values returned by the Cardinal Centinel. --->
		<cfif structkeyexists(arguments,"authStatus3DS")>
			<cfset requestData.AUTHSTATUS3DS = arguments.authStatus3DS />
		</cfif>
		<cfif structkeyexists(arguments,"mpivendor3DS")>
			<cfset requestData.MPIVENDOR3DS = arguments.mpivendor3DS />
		</cfif>
		<cfif structkeyexists(arguments,"CAVV")>
			<cfset requestData.CAVV = arguments.CAVV />
		</cfif>
		<cfif structkeyexists(arguments,"eci3DS")>
			<cfset requestData.ECI3DS = arguments.eci3DS />
		</cfif>
		<cfif structkeyexists(arguments,"XID")>
			<cfset requestData.XID = arguments.XID />
		</cfif>
		
		<!--- Payer details --->
		<cfif structkeyexists(arguments,"email")>
			<cfset requestData.EMAIL = left(arguments.email,127) />
		</cfif>
		<cfset requestData.FIRSTNAME = left(arguments.firstname,25) />
		<cfset requestData.LASTNAME = left(arguments.lastname,25) />
		
		<!--- Address --->
		<cfset requestData.STREET = left(arguments.street,100) />
		<cfif structkeyexists(arguments,"street2")>
			<cfset requestData.STREET2 = left(arguments.street2,100) />
		</cfif>
		<cfset requestData.CITY = left(arguments.city,40) />
		<cfset requestData.STATE = left(arguments.state,40) />
		<cfset requestData.COUNTRYCODE = left(arguments.country,2) />
		<cfset requestData.ZIP = left(arguments.zip,20) />
		<cfif structkeyexists(arguments,"phone")>
			<cfset requestData.SHIPTOPHONENUM = left(arguments.phone,20) />
		</cfif>
		
		<!--- Shipping --->
		<cfif structkeyexists(arguments,"shipToName")>
			<cfset requestData.SHIPTONAME = left(arguments.shipToName,32) />
		</cfif>
		<cfif structkeyexists(arguments,"shipToStreet")>
			<cfset requestData.SHIPTOSTREET = left(arguments.shipToStreet,100) />
		</cfif>
		<cfif structkeyexists(arguments,"shipToStreet2")>
			<cfset requestData.SHIPTOSTREET2 = left(arguments.shipToStreet2,100) />
		</cfif>
		<cfif structkeyexists(arguments,"shipToCity")>
			<cfset requestData.SHIPTOCITY = left(arguments.shipToCity,40) />
		</cfif>
		<cfif structkeyexists(arguments,"shipToState")>
			<cfset requestData.SHIPTOSTATE = left(arguments.shipToState,40) />
		</cfif>
		<cfif structkeyexists(arguments,"shipToCountry")>
			<cfset requestData.SHIPTOCOUNTRY = left(arguments.shipToCountry,2) />
		</cfif>
		<cfif structkeyexists(arguments,"shipToZip")>
			<cfset requestData.SHIPTOZIP = left(arguments.shipToZip,20) />
		</cfif>
		
		<!--- Payment --->
		<cfset requestData.AMT = numberformat(arguments.amount,"0.00") />
		<cfif structkeyexists(arguments,"currencyCode")>
			<cfset requestData.CURRENCYCODE = left(arguments.currencyCode,3) />
		</cfif>
		<cfif structkeyexists(arguments,"itemAmount")>
			<cfset requestData.ITEMAMT = numberformat(arguments.itemAmount,"0.00") />
		</cfif>
		<cfif structkeyexists(arguments,"shippingAmount")>
			<cfset requestData.SHIPPINGAMT = numberformat(arguments.shippingAmount,"0.00") />
		</cfif>
		<cfif structkeyexists(arguments,"insuranceAmount")>
			<cfset requestData.INSURANCEAMT = numberformat(arguments.insuranceAmount,"0.00") />
		</cfif>
		<cfif structkeyexists(arguments,"shippingDiscountAmount")>
			<cfset requestData.SHIPDISCAMT = numberformat(arguments.shippingDiscountAmount,"0.00") />
		</cfif>
		<cfif structkeyexists(arguments,"handlingAmount")>
			<cfset requestData.HANDLINGAMT = numberformat(arguments.handlingAmount,"0.00") />
		</cfif>
		<cfif structkeyexists(arguments,"taxAmount")>
			<cfset requestData.TAXAMT = numberformat(arguments.taxAmount,"0.00") />
		</cfif>
		
		<!--- Miscellaneous --->
		<cfif structkeyexists(arguments,"description")>
			<cfset requestData.DESC = left(arguments.description,127) />
		</cfif>
		<cfif structkeyexists(arguments,"custom")>
			<cfset requestData.CUSTOM = left(arguments.custom,256) />
		</cfif>
		<cfif structkeyexists(arguments,"invoiceNo")>
			<cfset requestData.INVNUM = left(arguments.invoiceNo,256) />
		</cfif>
		<cfif structkeyexists(arguments,"buttonSource")>
			<cfset requestData.BUTTONSOURCE = left(arguments.buttonSource,32) />
		</cfif>
		<cfif structkeyexists(arguments,"notifyURL")>
			<cfset requestData.NOTIFYURL = left(arguments.notifyURL,2048) />
		</cfif>
		<cfif structkeyexists(arguments,"recurring")>
			<cfset requestData.RECURRING = left(arguments.recurring,1) />
		</cfif>
		
		<!--- Items --->
		<cfif structkeyexists(arguments,"items")>
			<cfloop from="1" to="#arraylen(arguments.items)#" index="index">
				<cfif structkeyexists(arguments.items[index],"name")>
					<cfset requestData["L_NAME#index-1#"] = left(arguments.items[index].name,127) />
				</cfif>
				<cfif structkeyexists(arguments.items[index],"description")>
					<cfset requestData["L_DESC#index-1#"] = left(arguments.items[index].description,127) />
				</cfif>
				<cfif structkeyexists(arguments.items[index],"name")>
					<cfset requestData["L_AMT#index-1#"] = numberformat(arguments.items[index].amount,"0.00") />
				</cfif>
				<cfif structkeyexists(arguments.items[index],"number")>
					<cfset requestData["L_NUMBER#index-1#"] = left(arguments.items[index].number,127) />
				</cfif>
				<cfif structkeyexists(arguments.items[index],"quantity") and isnumeric(arguments.items[index].quantity)>
					<cfset requestData["L_QTY#index-1#"] = numberformat(arguments.items[index].quantity,"0") />
				</cfif>
				<cfif structkeyexists(arguments.items[index],"taxAmount")>
					<cfset requestData["L_TAXAMT#index-1#"] = numberformat(arguments.items[index].taxAmount,"0.00") />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfset stLog = duplicate(arguments) />
		<cfset stLog.objectid = application.fapi.getUUID() />
		<cfset stLog.typename ="paypalTransaction" />
		<cfset stLog.datetimeTransactionStart = now() />
		<cfset stLog.result = "Processing" />
		<cfset application.fapi.setData(stProperties=stLog) />
		
		<cfset stResponse = makeAPIRequest(
			server=arguments.server,
			username=arguments.username,
			password=arguments.password,
			signature=arguments.signature,
			proxy=arguments.proxy,
			requestData=requestData) />
		
		<cfset stResponse = arrayify(stResponse,"errorcode,longmessage,severitycode,shortmessage","errors") />
		
		<cfset stLog.result = stResponse.ack />
		<cfif structkeyexists(stResponse,"transactionID")>
			<cfset stLog.transactionID = stResponse.transactionID />
		</cfif>
		<cfif structkeyexists(stResponse,"correlationID")>
			<cfset stLog.correlationID = stResponse.correlationID />
		</cfif>
		<cfif structkeyexists(stResponse,"avsCode")>
			<cfset stLog.avsCode = stResponse.avsCode />
		</cfif>
		<cfif structkeyexists(stResponse,"cvv2Match")>
			<cfset stLog.cvv2Match = stResponse.cvv2Match />
		</cfif>
		<cfset stLog.errors = stResponse.errors />
		<cfset stLog.datetimeTransactionFinish = now() />
		<cfset application.fapi.setData(stProperties=stLog) />
		
		<cfreturn stResponse />
	</cffunction>
	
	<!--- https://www.x.com/developers/paypal/documentation-tools/api/gettransactiondetails-api-operation-nvp --->
	<cffunction name="getTransactionDetails" access="public" output="false" returntype="struct" hint="Returns information about a specific transaction">
		<cfargument name="server" type="string" required="false" default="#application.config.paypal.server#" />
		<cfargument name="username" type="string" required="false" default="#application.config.paypal.username#" />
		<cfargument name="password" type="string" required="false" default="#application.config.paypal.password#" />
		<cfargument name="signature" type="string" required="false" default="#application.config.paypal.signature#" />
		<cfargument name="proxy" type="string" required="false" default="#application.config.paypal.proxy#" />
		
		<cfargument name="transactionID" type="string" required="true" />
		
		<cfset var requestData = structnew() />
		<cfset var stResponse = structnew() />
		
		<cfset requestData.METHOD = "GetTransactionDetails" />
		<cfset requestData.TRANSACTIONID = arguments.transactionID />
		
		<cfset stResponse = makeAPIRequest(
			server=arguments.server,
			username=arguments.username,
			password=arguments.password,
			signature=arguments.signature,
			proxy=arguments.proxy,
			requestData=requestData) />
		
		<cfset stResponse = arrayify(stResponse,"errorcode,longmessage,severitycode,shortmessage","errors") />
		
		<cfreturn stResponse />
	</cffunction>
	
</cfcomponent>