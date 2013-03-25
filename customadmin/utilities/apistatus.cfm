<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<admin:header>

<skin:loadJS id="jquery" />
<skin:htmlHead><cfoutput>
	<style type="text/css">
		table { width:99%; }
		td, th { padding:5px; }
		th { font-weight:bold; }
		.status-good { font-weight:bold;color:##00CC00; }
		.status-bad { font-weight:bold;color:##FF0000; }
	</style>
</cfoutput></skin:htmlHead>

<cfoutput><h1>PayPal API Status</h1></cfoutput>

<cfif not isdefined("application.config.paypal.server") or not len(application.config.paypal.server) 
	or not isdefined("application.config.paypal.username") or not len(application.config.paypal.username) 
	or not isdefined("application.config.paypal.password") or not len(application.config.paypal.password)
	or not isdefined("application.config.paypal.signature") or not len(application.config.paypal.signature)>
	
	<cfoutput>
		<p>Status: <span class="status-bad">not set up</span></p>
		<br>
		<p>Before you can accept payments, you need to add the API credentials to the PayPal config (Admin -> Config).</p>
		<p>If you will need to <a href="https://developer.paypal.com/webapps/developer/applications">register with PayPal</a> to get these credentials.</p>
		<table class="status">
			<tr>
				<td>Server:</td>
				<cfif not isdefined("application.config.paypal.server") or not len(application.config.paypal.server)>
					<td class="status-bad">missing</td>
				<cfelse>
					<td class="status-good">entered</td>
				</cfif>
			</tr>
			<tr>
				<td>Username:</td>
				<cfif not isdefined("application.config.paypal.username") or not len(application.config.paypal.username)>
					<td class="status-bad">missing</td>
				<cfelse>
					<td class="status-good">entered</td>
				</cfif>
			</tr>
			<tr>
				<td>Password:</td>
				<cfif not isdefined("application.config.paypal.password") or not len(application.config.paypal.password)>
					<td class="status-bad">missing</td>
				<cfelse>
					<td class="status-good">entered</td>
				</cfif>
			</tr>
			<tr>
				<td>Signature:</td>
				<cfif not isdefined("application.config.paypal.signature") or not len(application.config.paypal.signature)>
					<td class="status-bad">missing</td>
				<cfelse>
					<td class="status-good">entered</td>
				</cfif>
			</tr>
		</table>
	</cfoutput>
	
<cfelseif application.fc.lib.db.isDeployed(typename=attributes.typename,dsn=application.dsn)>

	<cfoutput>
		<p>Status: <span class="status-bad">transaction log undeployed</span></p>
		<br>
		<p>Before you can accept payments, you need to deploy the PayPal transaction log table (Admin -> Developer Utilties -> COAPI Tools -> COAPI Content Types).</p>
	</cfoutput>
	
<cfelse>
	
	<cftry>
		<cfset noerror = false />
		<cfset stResult = application.fc.lib.paypal.searchTransactions(startDate=now()-7,endDate=now()) />
		<cfset noerror = true />
		
		<cfcatch>
			<cfoutput>
				<p>Status: <span class="status-bad">error accessing API</span></p>
				<br>
				<p>There was an error while attempting to access recent transactions. There may be a problem with your credentials. [<a href="##more" onclick="$j('##more').toggle();return false;">more information</a>]</p>
				<div id="more" style="display:none;"><cfdump var="#cfcatch#"></div>
			</cfoutput>
		</cfcatch>
	</cftry>
	
	<cfif noerror>
		<cfoutput>
			<p>Status: <span class="status-good">good</span></p>
			<h2>Recent Transactions</h2>
			<table>
				<thead>
					<tr>
						<th>Date</th>
						<th>Type</th>
						<th>Name</th>
						<th>Email</th>
						<th>Amount</th>
						<th>Fee Amount</th>
						<th>Net Amount</th>
						<th>Transaction ID</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<cfloop from="1" to="#arraylen(stResult.transactions)#" index="i">
						<tr>
							<td>#stResult.transactions[i].timestamp#</td>
							<td>#stResult.transactions[i].type#</td>
							<td>#stResult.transactions[i].name#</td>
							<td>#stResult.transactions[i].email#</td>
							<td>#stResult.transactions[i].amt#</td>
							<td>#stResult.transactions[i].feeamt#</td>
							<td>#stResult.transactions[i].netamt#</td>
							<td>#stResult.transactions[i].transactionid#</td>
							<td>#stResult.transactions[i].status#</td>
						</tr>
					</cfloop>
					<cfif not arraylen(stResult.transactions)>
						<tr><td colspan="9">No transactions in the last week</td></tr>
					</cfif>
				</tbody>
			</table>
		</cfoutput>
	</cfif>
	
</cfif>

<admin:footer>

<cfsetting enablecfoutputonly="false">