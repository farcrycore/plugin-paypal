<cfsetting enablecfoutputonly="true" />
<!--- @@viewstack: page --->
<!--- @@viewbinding: object --->

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<admin:header>

<skin:view stObject="#stObj#" webskin="#url.bodyView#" />

<admin:footer>

<cfsetting enablecfoutputonly="false" />