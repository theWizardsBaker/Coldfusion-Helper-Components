<cfcomponent>

	<!--- 
		an easy-ish way to setup readable links in coldfusion without using forms
		
		since there is no link_to, you can simply supply a structure of keys and the base URL

		example:

				<cfset variables.link_keys = {
						name : "John",
						age : "43",
						occupation : "Farmer"
				}/>

				<a href="#variables.formatURL.encodeToURL(keys=variables.link_keys, URL="testfolder/testpage.cfm")#" title="test">
					Just a Test Link
				</a>

	 --->
	<cffunction name="encodeToURL" returnformat="plain" returntype="String">
		<cfargument name="keys" type="struct" required="true"/>
		<cfargument name="URL" type="string" required="false" default=""/>
		<cfset resultURL = LEN(arguments.URL) GT 0 ? "#trim(URL)#?" : "" />
		<cfloop collection="#keys#"  item="param" >
		    <cfset resultURL &= "#EncodeForURL(param)#=#EncodeForURL(structFind(keys, param))#&" />
		</cfloop>
		<cfreturn resultURL />
	</cffunction>
</cfcomponent>