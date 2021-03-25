<img align="right" src="assets/icon.svg" width="150" height="150" >

# Bitrise step - Mobile apps URLS scanner

This step will scan the source code of the repository to extract all HTTP/HTTPS urls and execute an analyze of those HTTPS URLs with [SSLLabs](https://github.com/ssllabs/ssllabs-scan)


All extracted URLs & analysis (SSLLabs) will be available into a zip folder (urls-scanner.zip):
* urls-scanner/urls-found: all http & https URLs found& $BITRISE_DEPLOY_DIR/urls-scanner/ssllabs-scans)
* urls-scanner/ssllabs-scans: all https domains analyzed with SSLLabs


<br/>

## Usage

Add this step using standard Workflow Editor and provide required input environment variables.

<br/>

## Inputs

The asterisks (*) mean mandatory keys

|Key             |Value type                     |Description    |Default value        
|----------------|-------------|--------------|--------------|
|ssl_labs_scan* |yes/no |Setup - Set yes if want to analyze HTTPS urls with SSLLabs|no|
|black_list* |String |Setup - Define a list of HTTPS domains that will not analyzed by SSLLabs|url;url;url|
