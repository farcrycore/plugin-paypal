<cfcomponent displayname="PayPal Transaction" hint="PayPal processing transaction information" extends="farcry.core.packages.types.types" output="false" persistent="false">
	
	<cfproperty ftSeq="11" ftWizardStep="Status" ftFieldset="Status" ftLabel="Invoice Number"
				name="invoiceNo" type="string" />
	
	<cfproperty ftSeq="12" ftWizardStep="Status" ftFieldset="Status" ftLabel="Transaction ID"
				name="transactionID" type="string" />
	
	<cfproperty ftSeq="13" ftWizardStep="Status" ftFieldset="Status" ftLabel="Correlation ID"
				name="correlationID" type="string" />
	
	<cfproperty ftSeq="14" ftWizardStep="Status" ftFieldset="Status" ftLabel="Transaction Start"
				name="datetimeTransactionStart" type="datetime" />
	
	<cfproperty ftSeq="16" ftWizardStep="Status" ftFieldset="Status" ftLabel="Transaction Finish"
				name="datetimeTransactionFinish" type="datetime" />
	
	<cfproperty ftSeq="17" ftWizardStep="Status" ftFieldset="Status" ftLabel="Transaction Result"
				name="result" type="string" />
				
	<cfproperty ftSeq="18" ftWizardStep="Status" ftFieldset="Status" ftLabel="Messages"
				name="messages" type="longchar"
				ftEditMethod="ftDisplayMessages" />
	
	<cfproperty ftSeq="19" ftWizardStep="Status" ftFieldset="Status" ftLabel="Address Verification Code"
				name="AVSCode" type="string" />
	
	<cfproperty ftSeq="20" ftWizardStep="Status" ftFieldset="Status" ftLabel="CVV2 Match"
				name="CVV2Match" type="string" />
	
	<cfproperty ftSeq="21" ftWizardStep="Transaction" ftFieldset="Credit Card" ftLabel="Credit Card Number"
				name="creditcardnumber" type="string" />
	
	<cfproperty ftSeq="22" ftWizardStep="Transaction" ftFieldset="Credit Card" ftLabel="Credit Card Type"
				name="creditcardtype" type="string" ftType="creditcardtype"
				ftAcceptTypes="visa,mastercard,discover,amex" />
	
	<cfproperty ftSeq="23" ftWizardStep="Transaction" ftFieldset="Credit Card" ftLabel="Expiry Date"
				name="creditcardexpiry" type="string" />
	
	
	<cfproperty ftSeq="31" ftWizardStep="Transaction" ftFieldset="Amounts" ftLabel="Total"
				name="amount" type="numeric" />
	
	<cfproperty ftSeq="32" ftWizardStep="Transaction" ftFieldset="Amounts" ftLabel="Item Amount"
				name="itemAmount" type="numeric" />
	
	<cfproperty ftSeq="33" ftWizardStep="Transaction" ftFieldset="Amounts" ftLabel="Shipping"
				name="shippingAmount" type="numeric" />
	
	<cfproperty ftSeq="34" ftWizardStep="Transaction" ftFieldset="Amounts" ftLabel="Shipping Discount"
				name="shippingDiscountAmount" type="numeric" />
	
	<cfproperty ftSeq="35" ftWizardStep="Transaction" ftFieldset="Amounts" ftLabel="Insurance"
				name="insuranceAmount" type="numeric" />
	
	<cfproperty ftSeq="36" ftWizardStep="Transaction" ftFieldset="Amounts" ftLabel="Handling"
				name="handlingAmount" type="numeric" />
	
	<cfproperty ftSeq="37" ftWizardStep="Transaction" ftFieldset="Amounts" ftLabel="Tax"
				name="taxAmount" type="numeric" />
	
	<cfproperty ftSeq="38" ftWizardStep="Transaction" ftFieldset="Amounts" ftLabel="Currency"
				name="currencyCode" type="string" />
	
	<cfproperty ftSeq="39" ftWizardStep="Transaction" ftFieldset="Amounts" ftLabel="Recurring"
				name="recurring" type="string" />
	
	
	<cfproperty ftSeq="40" ftWizardStep="Customer" ftFieldset="User Information" ftLabel="Username"
				name="farcryuser" type="string" />
	
	<cfproperty ftSeq="41" ftWizardStep="Customer" ftFieldset="User Information" ftLabel="IP Address"
				name="ipAddress" type="string" />
	
	<cfproperty ftSeq="42" ftWizardStep="Customer" ftFieldset="User Information" ftLabel="Email"
				name="email" type="string" />
	
	<cfproperty ftSeq="43" ftWizardStep="Customer" ftFieldset="User Information" ftLabel="Firstname"
				name="firstname" type="string" />
	
	<cfproperty ftSeq="44" ftWizardStep="Customer" ftFieldset="User Information" ftLabel="Lastname"
				name="lastname" type="string" />
	
	<cfproperty ftSeq="45" ftWizardStep="Customer" ftFieldset="User Information" ftLabel="Phone"
				name="phone" type="string" />
	
	
	<cfproperty ftSeq="51" ftWizardStep="Customer" ftFieldset="Address" ftLabel="Street"
				name="street" type="string" />
	
	<cfproperty ftSeq="52" ftWizardStep="Customer" ftFieldset="Address" ftLabel="Street 2"
				name="street2" type="string" />
	
	<cfproperty ftSeq="53" ftWizardStep="Customer" ftFieldset="Address" ftLabel="City"
				name="city" type="string" />
	
	<cfproperty ftSeq="54" ftWizardStep="Customer" ftFieldset="Address" ftLabel="State"
				name="state" type="string" />
	
	<cfproperty ftSeq="55" ftWizardStep="Customer" ftFieldset="Address" ftLabel="Country"
				name="country" type="string" />
	
	<cfproperty ftSeq="56" ftWizardStep="Customer" ftFieldset="Address" ftLabel="Zip"
				name="zip" type="string" />
	
	
	<cfproperty ftSeq="61" ftWizardStep="Customer" ftFieldset="Shipping Address" ftLabel="Ship To"
				name="shipToName" type="string" />
	
	<cfproperty ftSeq="62" ftWizardStep="Customer" ftFieldset="Shipping Address" ftLabel="Street"
				name="shipToStreet" type="string" />
	
	<cfproperty ftSeq="63" ftWizardStep="Customer" ftFieldset="Shipping Address" ftLabel="Street 2"
				name="shipToStreet2" type="string" />
	
	<cfproperty ftSeq="64" ftWizardStep="Customer" ftFieldset="Shipping Address" ftLabel="City"
				name="shipToCity" type="string" />
	
	<cfproperty ftSeq="65" ftWizardStep="Customer" ftFieldset="Shipping Address" ftLabel="State"
				name="shipToState" type="string" />
	
	<cfproperty ftSeq="66" ftWizardStep="Customer" ftFieldset="Shipping Address" ftLabel="Country"
				name="shipToCountry" type="string" />
	
	<cfproperty ftSeq="67" ftWizardStep="Customer" ftFieldset="Shipping Address" ftLabel="Zip"
				name="shipToZip" type="string" />
	
	
	<cfproperty ftSeq="71" ftWizardStep="Items" ftFieldset="Items" ftLabel="Items"
				name="items" type="longchar"
				ftEditMethod="ftDisplayItems" />
	
	
	<cfproperty ftSeq="81" ftWizardStep="Miscellaneous" ftFieldset="Miscellaneous" ftLabel="Description"
				name="description" type="string" />
	
	<cfproperty ftSeq="82" ftWizardStep="Miscellaneous" ftFieldset="Miscellaneous" ftLabel="Custom"
				name="custom" type="string" />
	
	
	<cffunction name="setData" access="public" output="true" hint="Update the record for an objectID including array properties.  Pass in a structure of property values; arrays should be passed as an array.">
		<cfargument name="stProperties" required="true">
		<cfargument name="user" type="string" required="true" hint="Username for object creator" default="">
		<cfargument name="auditNote" type="string" required="true" hint="Note for audit trail" default="Updated">
		<cfargument name="bAudit" type="boolean" required="No" default="1" hint="Pass in 0 if you wish no audit to take place">
		<cfargument name="dsn" required="No" default="#application.dsn#">
		<cfargument name="bSessionOnly" type="boolean" required="false" default="false"><!--- This property allows you to save the changes to the Temporary Object Store for the life of the current session. ---> 
		<cfargument name="bAfterSave" type="boolean" required="false" default="true" hint="This allows the developer to skip running the types afterSave function.">	
		<cfargument name="bSetDefaultCoreProperties" type="boolean" required="false" default="true" hint="This allows the developer to skip defaulting the core properties if they dont exist.">	
		<cfargument name="previousStatus" type="string" required="false" />
		
		<!--- if a credit card number is part of this update, sanitize it --->
		<cfif structkeyexists(arguments.stProperties,"creditcardnumber") and len(arguments.stProperties.creditcardnumber)>
			<cfset arguments.stProperties.creditcardnumber = repeatstring("*",len(arguments.stProperties.creditcardnumber)-4) & right(arguments.stProperties.creditcardnumber,4) />
		</cfif>
		
		<!--- if messages or items are arrays, convert them to wddx --->
		<cfif structkeyexists(arguments.stProperties,"messages") and isarray(arguments.stProperties.messages)>
			<cfwddx action="cfml2wddx" input="#arguments.stProperties.messages#" output="#arguments.stProperties.messages#" />
		</cfif>
		<cfif structkeyexists(arguments.stProperties,"items") and isarray(arguments.stProperties.items)>
			<cfwddx action="cfml2wddx" input="#arguments.stProperties.items#" output="#arguments.stProperties.items#" />
		</cfif>
		
		<cfreturn super.setData(argumentCollection=arguments) />
	</cffunction>
	
	
	
	<cffunction name="ftDsiplayMessages" access="public" output="true" returntype="string" hint="his will return a string of formatted HTML text to enable the user to edit the data">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">

		<cfset var html = "None" />
		<cfset var aData = "" />
		
		<cfif len(arguments.stMetadata.value)>
			<cfwddx action="wddx2cfml" input="#arguments.stMetadata.value#" output="aData" />
			
			<cfsavecontent variable="html"><cfoutput>
				<ul>
					<cfloop from="1" to="#arraylen(aData)#" index="i">
						<li>#aData[i].shortmessage# [#aData[i].errorcode#]: #aData[i].longmessage#</li>
					</cfloop>
				</ul>
			</cfoutput></cfsavecontent>
		</cfif>
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="ftDisplayItems" access="public" output="true" returntype="string" hint="his will return a string of formatted HTML text to enable the user to edit the data">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">

		<cfset var html = "None" />
		<cfset var aData = "" />
		
		<cfif len(arguments.stMetadata.value)>
			<cfwddx action="wddx2cfml" input="#arguments.stMetadata.value#" output="aData" />
			
			<cfsavecontent variable="html"><cfoutput>
				<ul>
					<cfloop from="1" to="#arraylen(aData)#" index="i">
						<cfparam name="aData[i].name" default="" />
						<cfparam name="aData[i].description" default="" />
						<cfparam name="aData[i].amount" default="0.00" />
						<cfparam name="aData[i].number" default="" />
						<cfparam name="aData[i].quantity" default="" />
						<cfparam name="aData[i].taxAmount" default="" />
						
						<li><a href><span title="#aData[i].description#">#aData[i].name#<cfif len(aData[i].number)> [#aData[i].number#]</cfif><cfif len(aData[i].quantity)> x #aData[i].quantity#</cfif>: #aData[i].amount#<cfif len(aData[i].taxAmount)> (tax #aData[i].taxAmount#)</cfif></li>
					</cfloop>
				</ul>
			</cfoutput></cfsavecontent>
		</cfif>
		
		<cfreturn html />
	</cffunction>
	
</cfcomponent>