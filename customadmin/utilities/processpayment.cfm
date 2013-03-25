<cfsetting enablecfoutputonly="true" requesttimeout="60" />

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset stResult = structnew() />

<ft:processform action="Process">
	<ft:processformobjects typename="creditcardpayment">
		<cfset stProperties.amount = form.amount />
		<cfset stProperties.invoiceNo = form.invoiceNo />
		
		<cftry>
			<cfset stResult = application.fc.lib.paypal.makeDirectPayment(argumentCollection=stProperties) />
			
			<cfif stResult.Ack eq "Failure" or stResult.Ack eq "FailureWithWarning">
				<skin:bubble message="Transaction failed: #stResult.errors[1].longmessage# [#stResult.errors[1].errorcode#]" tags="error" />
			<cfelseif stResult.Ack eq "Success" or stResult.Ack eq "SuccessWithWarning">
				<skin:bubble message="Transaction successful (transcaction## #stResult.transactionID#, correlation id #stResult.correlationID#)" tags="success" />
			</cfif>
			
			<cfcatch>
				<skin:bubble message="Library error: #cfcatch.message#" tags="error" />
			</cfcatch>
		</cftry>
	</ft:processformobjects>
</ft:processform>


<admin:header>

<cfoutput>
	<h1>Process a Payment</h1>
	<p>You can use this form to manually push through a payment.</p>
</cfoutput>

<ft:form>
	<skin:pop tags="error" start="<ul id='errorMsg'>" end="</ul>"><cfoutput>
		<li>
			<cfif len(trim(message.title))><strong>#message.title#</strong></cfif><cfif len(trim(message.title)) and len(trim(message.message))>: </cfif>
			<cfif len(trim(message.message))>#message.message#</cfif>
		</li>
	</cfoutput></skin:pop>
	
	<skin:pop tags="success" start="<ul id='OKMsg'>" end="</ul>"><cfoutput>
		<li>
			<cfif len(trim(message.title))><strong>#message.title#</strong></cfif><cfif len(trim(message.title)) and len(trim(message.message))>: </cfif>
			<cfif len(trim(message.message))>#message.message#</cfif>
		</li>
	</cfoutput></skin:pop>
	
	<ft:field label="Amount"><cfoutput><input type="text" class="textInput" name="amount" /></cfoutput></ft:field>
	<ft:field label="Invoice ##"><cfoutput><input type="text" class="textInput" name="invoiceNo" /></cfoutput></ft:field>
	
	<ft:object typename="creditcardpayment" key="manualpayment" prefix="manualpayment" lFields="firstname,lastname,email,street,street2,city,country,state,zip,phone" legend="Customer Details" />
	<ft:object typename="creditcardpayment" key="manualpayment" prefix="manualpayment" lFields="creditcardnumber,creditcardtype,creditcardexpiry,creditcardcvv2" legend="Credit Card Details" />
	
	<ft:buttonPanel>
		<ft:button value="Process" />
	</ft:buttonPanel>
</ft:form>

<admin:footer>

<cfsetting enablecfoutputonly="false" />