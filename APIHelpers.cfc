/**
*
* @file  /C/inetpub/wwwroot/cfPlayground.local/wwwroot/mailchimp/APIHelpers.cfc
* @author  
* @description
*
*/

component accessors=true {
	property name="serviceURL" type="string" setter="true";
	property name="apiKey" type="string" setter="true";
	property name="httpTimeout" type="numeric" setter="true";

	public function init(){
		return this;
	}
	private struct function apiCall(required string RESTEndPoint,required string method,boolean debug){
		var loc={};		
		loc.httpRequest = new http(	url="#getServiceURL()#/#arguments.RESTEndPoint#",
									method=arguments.method,
									timeout=getHttpTimeout()
									);

		loc.httpRequest.addParam(type="header",name="Authorization", value="apikey #getApiKey()#");
		loc.result = loc.httpRequest.send();
		if (isRequestSuccesful( loc.result ) ){
			return deserializeJSON(loc.result.getPrefix().filecontent);
		}
		else {
			loc.errorLabel="Your #Arguments.method# request for the REST API Endpoint: #Arguments.RESTEndPoint# failed with: #loc.result.getPrefix().errordetail#";
			if (Arguments.debug){
				writeDump(var=loc.result.getPrefix(),label=loc.errorLabel);
			}
			throw(message="HTTP Error #loc.result.getPrefix().statuscode#",detail="ERROR: #loc.errorLabel#");
		}
	}
	private void function writeDebugOutput(httpResult){
		writeOutputLn("Error Detail: " & arguments.httpResult.errordetail );	
		writeOutputLn("STATUS CODE: " & arguments.httpResult.statuscode );
		writeOutputLn("RESP:");
		writeDump(deserializeJSON(arguments.httpResult.filecontent));
	}
	private void function writeOutputLn(any t){
		writeOutput(t & "<BR>");
	}
	private boolean function isRequestSuccesful(httpResult:org.railo.cfml.Result){
		if ( Val(arguments.httpResult.getPrefix().statuscode) eq 200 ){
			return true;
		}
		return false;
	}

}