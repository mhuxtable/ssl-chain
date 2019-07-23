#!/bin/bash

chain_pem="${1}"

if [[ "x${chain_pem}" = "x-" ]]; then
    chain_pem=/dev/stdin
elif [[ ! -f "${chain_pem}" ]]; then
    echo "Usage: $0 BASE64_CERTIFICATE_CHAIN_FILE" >&2
    exit 1
fi

CERT=$(cat "${chain_pem}")

if ! (echo "$CERT" | openssl x509 -noout 2>/dev/null) ; then
    echo "${chain_pem} is not a certificate" >&2
    exit 1
fi

echo "$CERT" | awk -F'\n' '
        BEGIN {
            showcert = "openssl x509 -noout -subject -issuer"
        }

        /-----BEGIN CERTIFICATE-----/ {
            printf "%2d: ", ind
        }

        {
            printf $0"\n" | showcert
        }

        /-----END CERTIFICATE-----/ {
            close(showcert)
            ind ++
        }
    '

echo
openssl verify -untrusted <(echo "$CERT") <(echo "$CERT")
