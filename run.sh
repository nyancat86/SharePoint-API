#!/bin/bash
echo "#############################################################"
echo "               Share Point API-REFRESH                       "
echo "                                  --   Powerd by nyancat86 --"
echo "Dependency Resolution                                        "
echo "Ansible : latest                                             "
echo "#############################################################"
echo ""
echo ""



## Please configure This area
aduser=""
echo aduser:$aduser
adpass=""
echo adpass:$adpass
# set your tenant (ex. https://nyancat86.sharepoint.com = nyancat86 is tenant name)
tenant=""
## path and enviroment setting
path=/root/auto-bots/SharePointAPI
#echo path:$path

dat=`date +%G%m`

## error notification bot
info_uri=""
## password notification bot
pass_uri=""




## main
  echo ""
  echo "#############################################################" 
  echo "01_get_token"
  echo "#############################################################"
  echo ""

  #curl -i -X POST -H "Content-Length:0" -c cookie.txt "https://your-tenant.sharepoint.com/_layouts/Authenticate.aspx?Source="
  
  curl -i -X POST -H "Content-Length:0" -c $path/apis/cookie "https://${tenant}.sharepoint.com/_layouts/Authenticate.aspx?Source="
  cat $path/apis/cookie
  cat $path/apis/token


  echo ""
  echo "#############################################################"
  echo "02_get_BinarySecurityToken                                   "
  echo "#############################################################"
  echo ""

 # curl -i -X POST -b token.txt -d "<s:Envelope xmlns:s='http://www.w3.org/2003/05/soap-envelope' xmlns:a='http://www.w3.org/2005/08/addressing' xmlns:u='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'><s:Header><a:Action s:mustUnderstand='1'>http://schemas.xmlsoap.org/ws/2005/02/trust/RST/Issue</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand='1'>https://login.microsoftonline.com/extSTS.srf</a:To><o:Security s:mustUnderstand='1' xmlns:o='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'><o:UsernameToken><o:Username>$1@jbs.com</o:Username><o:Password>$2</o:Password></o:UsernameToken></o:Security></s:Header><s:Body><t:RequestSecurityToken xmlns:t='http://schemas.xmlsoap.org/ws/2005/02/trust'><wsp:AppliesTo xmlns:wsp='http://schemas.xmlsoap.org/ws/2004/09/policy'><a:EndpointReference><a:Address>https://your-tenant.sharepoint.com/</a:Address></a:EndpointReference></wsp:AppliesTo><t:KeyType>http://schemas.xmlsoap.org/ws/2005/05/identity/NoProofKey</t:KeyType><t:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</t:RequestType><t:TokenType>urn:oasis:names:tc:SAML:1.0:assertion</t:TokenType></t:RequestSecurityToken></s:Body></s:Envelope>" "https://login.microsoftonline.com/extSTS.srf"
   curl -i -X POST -b $path/apis/token -d "<s:Envelope xmlns:s='http://www.w3.org/2003/05/soap-envelope' xmlns:a='http://www.w3.org/2005/08/addressing' xmlns:u='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'><s:Header><a:Action s:mustUnderstand='1'>http://schemas.xmlsoap.org/ws/2005/02/trust/RST/Issue</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand='1'>https://login.microsoftonline.com/extSTS.srf</a:To><o:Security s:mustUnderstand='1' xmlns:o='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'><o:UsernameToken><o:Username>"$aduser"</o:Username><o:Password>"$adpass"</o:Password></o:UsernameToken></o:Security></s:Header><s:Body><t:RequestSecurityToken xmlns:t='http://schemas.xmlsoap.org/ws/2005/02/trust'><wsp:AppliesTo xmlns:wsp='http://schemas.xmlsoap.org/ws/2004/09/policy'><a:EndpointReference><a:Address>https://${tenant}.sharepoint.com/</a:Address></a:EndpointReference></wsp:AppliesTo><t:KeyType>http://schemas.xmlsoap.org/ws/2005/05/identity/NoProofKey</t:KeyType><t:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</t:RequestType><t:TokenType>urn:oasis:names:tc:SAML:1.0:assertion</t:TokenType></t:RequestSecurityToken></s:Body></s:Envelope>" "https://login.microsoftonline.com/extSTS.srf" > $path/apis/bs_token
 # cat $path/apis/cookie
 # cat $path/apis/token



  echo ""
  echo "#############################################################"
  echo "03_get_auth"
  echo "#############################################################"
  echo ""


  token=`tail -n 1 $path/apis/bs_token | sed -e "s/>/>\n/g" | sed -e "s/</\n</g" | grep "t=" | tail -n 1`
  echo $token
  
  #curl -i -X POST -d $1 -c token.txt "https://your-tenant.sharepoint.com/_forms/default.aspx?wa=wsignin1.0"
  curl -i -X POST -d $token -c $path/apis/token "https://${tenant}.sharepoint.com/_forms/default.aspx?wa=wsignin1.0"


  # cat $path/apis/cookie
  cat $path/apis/token

 
#  echo ""
#  echo "#############################################################"
#  echo "Teams message"
#  echo "#############################################################"
#  echo ""


  #echo -nE '{"text": "Token was renewed."}'| tr -d '\r' | curl -H 'Content-type: application/json' -d @- $pass_uri
