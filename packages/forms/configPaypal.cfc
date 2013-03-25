<cfcomponent displayname="PayPal" hint="PayPal payments configuration" extends="farcry.core.packages.forms.forms" output="false" key="paypal">
	
	<cfproperty ftSeq="1" ftFieldset="API Access" ftLabel="PayPal Server"
				name="server" type="string"
				ftType="list" ftList="api-3t.sandbox.paypal.com/nvp:Sandbox,api-3t.paypal.com/nvp:Production" />
	
	<cfproperty ftSeq="2" ftFieldset="API Access" ftLabel="Username"
				name="username" type="string"
				ftHelpSection="The PayPal plugins uses the PayPal Payments Pro product (also called Website Payments Pro), and requires a username, password, and signature" />
	
	<cfproperty ftSeq="3" ftFieldset="API Access" ftLabel="Password"
				name="password" type="string" />
	
	<cfproperty ftSeq="4" ftFieldset="API Access" ftLabel="Signature"
				name="signature" type="string" />
	
	<cfproperty ftSeq="5" ftFieldset="API Access" ftLabel="Proxy"
				name="proxy" type="string" 
				ftHint="If internet access is only available through a proxy, set here. Use the format '[username:password@]domain[:port]'." />
		
</cfcomponent>