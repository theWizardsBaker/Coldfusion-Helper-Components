/**
*
* @file  soap_service.cfc
* @author  Justin Le Tourneau
* @description Creates SOAP Request Component. Used with PeopleSoft / Oracle 's integration broker
*/

component output="false" displayname="soap"  {

	//private protected variables 
	xmlString = '';
	urlString = '';
	action = '';
	componentInterface = '';
	timeout = 0;

	/**
	* @description: returns the soap component
	* */
	public function init(){
		return this;
	}

	/**
	* @description: sets parameters and creates XML to send
	* */
	public void function createSOAP(required string instance, required string action, 
									required string componentInterface, required struct valueCollection, numeric timeout = 30) {
			variables.componentInterface = componentInterface;
			variables.urlString = getURL(instance);
			variables.xmlString = createXML(valueCollection, action, componentInterface);
			variables.timeout = timeout;
	}
	
	/**
	* @description: send the soap request and returns the result SOAP XML in a cold fusion structure
	* */
	public struct function sendSOAP(){
		return sendXML(variables.action, variables.componentInterface, variables.urlString, variables.xmlString, variables.timeout);
	}

	/**
	*@description: creates the XML request
	*/
	private string function createXML(required struct valueCollection, required string action, required string compnentInterface){
		var parameters = [];

		//Key value pairs to send as XML children elements
		structEach(valueCollection, function(key, value){
			arrayAppend(parameters, '<#key#>#value#</#key#>');
		});

		// save xml string
		xmlStr = '<?xml version="1.0" ?>
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
			   <soapenv:Body>
				  <#action#__CompIntfc__#compnentInterface#>
					 #arrayToList(parameters, '')#
				  </#action#__CompIntfc__#compnentInterface#>
			   </soapenv:Body>
			</soapenv:Envelope>';

		//return xml string
		return xmlStr;
	}

	/**
	* @description: sends the XML to our SOAP URL
	*/
	private struct function sendXML(action, componentInterface, urlString, xmlString, timeout){

		//set url as header
		var httpReq = new http(timeout=timeout);
		//setup url
		httpReq.setMethod("post");
		httpReq.setUrl(urlString);

		//add parameters to URL obj
		// V1 is the version of the component interface
		httpReq.addParam(type="header", name="SOAPAction", value="#componentInterface#.V1" );
		httpReq.addParam(type="xml", value="#trim( xmlString )#");

		//send http request, get result
		httpResult = httpReq.send().GetPrefix();

		//if the result returned successful, format the result
		if(find('200', httpResult.statusCode)){
			// find the body / response element of the XML
			return formatSOAP(XMLSearch(httpResult.Filecontent, "//soapenv:Envelope/soapenv:Body/*:#action#__CompIntfc__#componentInterface#Response/*"));
		} else {
			//else, return empty structure
			return structNew();
		}

	}
	/**
	*@description: Parses XML Data and formats the result into an Array of Structs (removing the prefix ex, m97:) 
	*/
	private struct function formatSOAP(SOAP_Result){

		//creat structure for returning XML
		var SOAP_Data = structNew();

		//loop through each XML child element returned
		arrayEach(SOAP_Result, function(xmlObj){
			var prefix = xmlObj.XmlNsPrefix & ':';
			//remove prefix from name
			var name = Replace(xmlObj.XmlName, prefix, '');
			var childElm = structNew();

			//if the key doesn't already exists, add it to SOAP_Data
			if(!structKeyExists(SOAP_Data, name))
				structInsert(SOAP_Data, name, arrayNew(1), false);

			//for each child element in this xml element...
			ArrayEach(xmlObj.XmlChildren, function(xmlChild){
				//...add them to a new structure. Sans prefix
				StructInsert(childElm, Replace(xmlChild.XmlName, prefix, ''), xmlChild.XmlText);
			});

			//append the childElm struct to the array element located inside the struct to return.
			arrayAppend(SOAP_Data[name], childElm);
		});

		return SOAP_Data;
	}

	private string function getURL(required string instance){

		var url = '';
		//find the URL to send the soap request to
		switch(uCase(instance)){
			case 'DEV':
				url = 'https://devserver';
			break;

			case 'TST':
				url = 'https://testserver';
			break;				

			case 'PRD':
				url = 'https://productionserver';
			break;
		}

		return url;
	}

}