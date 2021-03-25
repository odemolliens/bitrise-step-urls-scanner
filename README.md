<img align="right" src="assets/icon.svg" width="150" height="150" >

# Bitrise step - Mobile apps URLS scanner

This step will scan the source code of the repository to extract all HTTP/HTTPS urls and execute an analyze of those HTTPS urls with [SSLLabs](https://github.com/ssllabs/ssllabs-scan)


All extracted URLs & analysis (SSLlabs) will be available into the artifacts folder ($BITRISE_DEPLOY_DIR/urls-scanner/urls-found & $BITRISE_DEPLOY_DIR/urls-scanner/ssllabs-scans)

<br/>

## Usage

Add this step using standard Workflow Editor and provide required input environment variables.

<br/>

You can launch this step:
- directly in the step where you generate your APK/IPA, in that case, you have to launch it necessarily after these build steps
  - `Android Build` for android
  - `Xcode Archive` for iOS
- **OR** in another Bitrise build than where you generate your APK/IPA, in that case, you have to setup `outside_build_slug` to download your APK/IPA to do quality checks

<br/>

## Inputs

The asterisks (*) mean mandatory keys

|Key             |Value type                     |Description    |Default value        
|----------------|-------------|--------------|--------------|
|ssl_labs_scan* |yes/no |Setup - Set yes if want to analyze HTTPS urls with SSSLLabs|no|
|black_list* |String |Setup - Define a list a domains blacklisted|url;url;url]|
