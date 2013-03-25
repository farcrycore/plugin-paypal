<cfcomponent displayname="Credit Card Payment" hint="Credit card payment form" extends="farcry.core.packages.forms.forms" output="false">
	
	<cfproperty ftFieldset="Customer Details" ftLabel="First Name"
				name="firstname" type="string"
				ftValidation="required" />
	
	<cfproperty ftFieldset="Customer Details" ftLabel="Last Name"
				name="lastname" type="string"
				ftValidation="required"  />
	
	<cfproperty ftFieldset="Customer Details" ftLabel="Email"
				name="email" type="string" />
	
	<cfproperty ftFieldset="Customer Details" ftLabel="Street"
				name="street" type="string"
				ftValidation="required" />
	
	<cfproperty ftFieldset="Customer Details" ftLabel="Street 2"
				name="street2" type="string" />
	
	<cfproperty ftFieldset="Customer Details" ftLabel="City"
				name="city" type="string"
				ftValidation="required" />
	
	<cfproperty ftFieldset="Customer Details" ftLabel="Country"
				name="country" type="string" ftDefault="AU"
				ftType="country" ftValue="code"
				ftValidation="required" />
	
	<cfproperty ftFieldset="Customer Details" ftLabel="State"
				name="state" type="string"
				ftType="state" ftWatch="country"
				ftValidation="required" />
	
	<cfproperty ftFieldset="Customer Details" ftLabel="Postcode"
				name="zip" type="string"
				ftValidation="required" />
	
	<cfproperty ftFieldset="Customer Details" ftLabel="Phone number"
				name="phone" type="string" />
	
	
	<cfproperty ftFieldset="Credit Card" ftLabel="Credit Card Number"
				name="creditcardnumber" type="string" ftType="creditcardnumber" 
				ftValidation="required" />
	
	<cfproperty ftFieldset="Credit Card" ftLabel="Credit Card Type"
				name="creditcardtype" type="string" ftType="creditcardtype"
				ftWatch="creditcardnumber" ftAcceptTypes="visa,mastercard,discover,amex" />
	
	<cfproperty ftFieldset="Credit Card" ftLabel="Credit Card Expiry"
				name="creditcardexpiry" type="string" ftType="creditcardexpiry"
				ftValidation="required" />
	
	<cfproperty ftFieldset="Credit Card" ftLabel="CVV"
				name="creditcardcvv2" type="string" ftType="creditcardcvv"
				ftValidation="required" />
	
	
</cfcomponent>