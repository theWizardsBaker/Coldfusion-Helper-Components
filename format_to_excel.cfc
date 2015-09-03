<cfcomponent displayname="format_to_excel">
	<!--- quick way to dump an HTML page to excel --->

	<cffunction name="writeExcelOutput">
		<cfargument name="headding" 
				    hint="page headding" 
				    type="any" 
				    required="false" 
				    default=" "
				    />
		<cfargument name="style" 
					hint="Inline styles"
					type="string" 
					required="false" 
					default=" "
					/>
		<cfargument name="styleSheets" 
					hint="pre-defined style sheets"
					type="string" 
					required="false" 
					default=""
					/>
		<cfargument name="fileName" 
					hint="title of the excel file"
					type="string" 
					required="false" 
					default="document"
					/>
		<cfargument name="data" 
					hint="main page data"
					type="any" 
					required="true"
					/>

		<cfcontent type="application/pdf" reset="true">
		<cfheader name="Content-Disposition" value="inline; filename=#Replace(arguments.fileName, ' ', '_', 'ALL')#.xls">
		<cfcontent type="application/vnd.ms-excel">
		<HTML xmlns:x="urn:schemas-microsoft-com:office:excel">
			<style>
				<cfloop list="#arguments.styleSheets#" index="style_url">
					<!--- include each path to custom style sheets --->
					<cfinclude template="#style_url#"/>
				</cfloop>
				<!--- include path to styles --->
				<cfinclude template="/styles/excel_style_sheet.css"/>
			<cfoutput>
				#arguments.style#
			</cfoutput>
			</style>
			<cfoutput>
				#arguments.headding#
				#arguments.data#
			</cfoutput>
	</cffunction>

	<!--- format columns with MSOFormatting to keep leading 0's on order numbers, ect --->
	<cffunction name="MSOFormat">
		<cfscript>
			return function(column){
				return " mso-number-format:'#reReplace(column, '.', "0", 'ALL')#' ";
			};
		</cfscript>
	</cffunction>
</cfcomponent>