if true | openssl s_client -connect www.exagrid.com:443 2>/dev/null | \
  openssl x509 -noout -checkend 0; then
  echo "Certificate is not expired"
else
  echo "Certificate is expired"
fi
