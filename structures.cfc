<cfcomponent output="false">
	
	<!--- Takes two structure and tries to add all the common key's values --->
	<!--- ex: { bob : 20 , joe : 23 } + { bob : 40, joe : 4 } = { bob : 60, joe : 27 } --->
	<cffunction name="addStructValues" access="public" returntype="Struct">
		<cfargument name="structOne" type="struct" required="true"/>
		<cfargument name="structTwo" type="struct" required="true"/>
		<cfargument name="copyAll" type="boolean" required="false" default="false"/>

		<cfloop list="#structKeyList(structTwo)#" index="key">
			<cfif structKeyExists(structOne, "#key#")>
				<!--- if we've got two structures, go recursive! --->
				<cfif isStruct(structOne[key]) AND isStruct(structTwo[key])>
					<cfset structOne[key] = addStructValues(structOne[key], structTwo[key], arguments.copyAll) />
				<!--- if we have two arrays, add all the values --->
				<cfelseif isArray(structOne[key]) AND isArray(structTwo[key]) >
					<!--- test to make sure we're not accessing null params --->
					<cfset var len = arrayLen(structOne[key]) GT arrayLen(structTwo[key]) ? arrayLen(structTwo[key]) : arrayLen(structOne[key])>
					<!--- add each array value --->
					<cfloop from="1" to="#len#" index="i" >
						<cfset structOne[key][i] += structTwo[key][i] />
					</cfloop>
				<!--- otherwise just add em --->
				<cfelse>
					<cfset structOne[key] += structTwo[key] />
				</cfif>
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
				<!--- if we've got two structures, go recursive! --->
				<cfif isStruct(structOne[key]) AND isStruct(structTwo[key])>
					<cfset structOne[key] = subtractStructValues(structOne[key], structTwo[key], arguments.copyAll) />
				<!--- if we have two arrays, add all the values --->
				<cfelseif isArray(structOne[key]) AND isArray(structTwo[key]) >
					<!--- test to make sure we're not accessing null params --->
					<cfset var len = arrayLen(structOne[key]) GT arrayLen(structTwo[key]) ? arrayLen(structTwo[key]) : arrayLen(structOne[key])>
					<!--- add each array value --->
					<cfloop from="1" to="#len#" index="i" >
						<cfset structOne[key][i] -= structTwo[key][i] />
					</cfloop>
				<!--- otherwise just add em --->
				<cfelse>
					<cfset structOne[key] -= structTwo[key] />
				</cfif>
			<cfelseif copyAll>
				<cfset structInsert(structOne, key, structTwo[key], false) />
			</cfif>
		</cfloop>

		<cfreturn structOne />
	</cffunction>

</cfcomponent>