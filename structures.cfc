<cfcomponent output="false">
	
	<!--- Takes two structure and tries to add all the common key's values --->
	<!--- ex: { bob : 20 , joe : 23 } + { bob : 40, joe : 4 } = { bob : 60, joe : 27 } --->
	<cffunction name="addStructValues" access="public" returntype="Struct">
		<cfargument name="structOne" type="struct" required="true"/>
		<cfargument name="structTwo" type="struct" required="true"/>
		<cfargument name="copyAll" type="boolean" required="false" default="false"/>

		<cfloop list="#structKeyList(structTwo)#" index="key">
			<cfif structKeyExists(structOne, "#key#")>
				<cfset structOne[key] += structTwo[key] />
			<cfelseif copyAll>
				<cfset structInsert(structOne, key, structTwo[key], false) />
			</cfif>
		</cfloop>

		<cfreturn structOne />
	</cffunction>	

	<cffunction name="subtractStructValues" access="public" returntype="Struct">
		<cfargument name="structOne" type="struct" required="true"/>
		<cfargument name="structTwo" type="struct" required="true"/>
		<cfargument name="copyAll" type="boolean" required="false" default="false"/>

		<cfloop list="#structKeyList(structTwo)#" index="key">
			<cfif structKeyExists(structOne, "#key#")>
				<cfset structOne[key] -= structTwo[key] />
			<cfelseif copyAll>
				<cfset structInsert(structOne, key, structTwo[key], false) />
			</cfif>
		</cfloop>

		<cfreturn structOne />
	</cffunction>

</cfcomponent>