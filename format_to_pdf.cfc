<cfcomponent>
	<cffunction name="writePDFOutput">
		<cfargument name="documentTitle" 
					hint="PDF File Title"
					type="any" 
					required="false" 
					default=" "
					/>
		<cfargument name="style" 
					hint="inline styles"
					type="string" 
					required="false" 
					default=""
					/>
		<cfargument name="styleSheets" 
					hint="style sheets to include"
					type="string" 
					required="false" 
					default=""
					/>
		<cfargument name="headding" 
					hint="document headding"
					type="string" 
					required="false" 
					default=" "
					/>
		<cfargument name="data" 
					hint="body of document"
					type="any" 
					required="true"
					/>
		<cfargument name="orientation"
					hint="page orientation (portrait / landscape)" 
					type="string" 
					required="false" 
					default="landscape"
					/>

		<cfcontent type="application/pdf" reset="true">

		<cfdocument format="PDF" 
					localUrl="yes" 
					marginTop=".25" 
					marginLeft=".25" 
					marginRight=".25" 
					marginBottom=".25" 
					pageType="letter" 
					orientation="#arguments.orientation#" 
					saveAsName="#Replace(arguments.documentTitle, ' ', '_', 'ALL')#"
					>
			<cfdocumentsection>
				<cfdocumentitem evalAtPrint="true" type="header">
					<cfoutput> #cfdocument.currentpagenumber# of #cfdocument.totalpagecount# </cfoutput>
				</cfdocumentitem>
				<cfoutput>
					<style>
						<cfloop list="#arguments.styleSheets#" index="styleURL">
							<!--- include any added styles --->
							<cfinclude template="#styleURL#">
						</cfloop>
						<!--- include bass styles --->
						<cfinclude template="/styles/pdf_style.css"/>
						#arguments.style#
					</style>
					<p>
					#arguments.headding#
					</p>
					#arguments.data#
				</cfoutput>
			</cfdocumentsection>
		</cfdocument>
	</cffunction>
</cfcomponent>