# Overview

The purpose of this plugin is to provide credit card processing functionality via 
PayPal. It is designed so that transactions can be handled with a minimum of fuss,
and so that other processing gateways could expose equivalent interfaces.

NOTE: The plugin used the [Payflow Pro][payflowpro] API.

# Setup

1. Setup PayPal (see below) and make a note of the API credentials
2. Install this plugin (copy files into /farcry/plugins/paypal, updateapp, and 
   deploy schema changes)
3. Make sure you have the correct PayPal server selected - Production or Sandbox
4. Add the API credentials to the PayPal config (Admin -> Configuration -> Edit 
   Config -> PayPal)
5. Check that the credentials are working by going to the PayPal tab and opening 
   the API Status menu item

## Testing Account

1. Sign up on [PayPal Developer][paypaldeveloper]
2. Create a sandbox test account under [Applications -> Sandbox accounts][paypalsandbox]
3. Copy the API credentials (Click the > next to the new account, then Profile, 
   then the API Credentials tab)

NOTE: the sandbox server has a great deal of non-standard behaviour, some of
which can make testing easier. The first gotcha is that it only handles a small
set of credit card numbers. You can read more about this in the documentation[payflowpropdf]

## Production Account

TBD

# Development

The plugin includes a lib to simplify access to the PayPal API (see below for 
reference). The key method is `makeDirectPayment`. A basic form `creditcardpayment`
is also included in the plugin - the simplest payment code would use that form,
add an amount on form submit, then pass that information to the payment method.

	<ft:processform action="Process">
		<ft:processformobjects typename="creditcardpayment">
			<cfset stProperties.amount = 0.01 />
			<cfset stResult = application.fc.lib.paypal.makeDirectPayment(argumentCollection=stProperties) />
			
			<cfif stResult.Ack eq "Failure" or stResult.Ack eq "FailureWithWarning">
				<!--- transaction failed --->
			<cfelseif stResult.Ack eq "Success" or stResult.Ack eq "SuccessWithWarning">
				<!--- transaction succeeded --->
			</cfif>
		</ft:processformobjects>
	</ft:processform>
	
	<ft:form>
		<ft:object typename="creditcardpayment" key="manualpayment" prefix="manualpayment" lFields="firstname,lastname,email,street,street2,city,country,state,zip,phone" legend="Customer Details" />
		<ft:object typename="creditcardpayment" key="manualpayment" prefix="manualpayment" lFields="creditcardnumber,creditcardtype,creditcardexpiry,creditcardcvv2" legend="Credit Card Details" />
		
		<ft:buttonPanel>
			<ft:button value="Pay" />
		</ft:buttonPanel>
	</ft:form>

# Administration

There are a number of utilities in the webtop to help make administration easier.

## API Status

This page will show you if the plugin isn't configured, or there are undeployed 
content types. As a test of the API (and your credentials) it also retrieves
a list of the most recent transactions from PayPal. 

## Manual Payment

This utility allows you to test credit card processing, and make payments on
behalf of others. It doesn't make you enter every field that the `makeDirectPayment` 
method will accept, only those that are required.

## Transaction Log

PayPal has it's own log, but it only stores specific information, and doesn't
store transactions that have certain errors.

This log stores information about *every* transaction that is attempted by the
plugin, including 

- much of the information submitted to the gateway, 
- the username of the person who submitted the transaction,
- the time the transaction was *sent* to PayPal and the time PayPal *responded*
- the success / failure of the transaction
- any errors / information returned by PayPal

*NOTE: the log only stores the last 4 digits of credit card numbers and does 
NOT store CVV2 values.* 

[payflowpro] https://www.paypal.com/us/webapps/mpp/referral/paypal-payflow-pro
[paypaldeveloper] https://developer.paypal.com/
[paypalsandbox] https://developer.paypal.com/webapps/developer/applications/accounts
[payflowpropdf] https://www.paypalobjects.com/webstatic/en_US/developer/docs/pdf/pp_payflowpro_guide.pdf