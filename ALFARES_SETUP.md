# Alfares multi-domain email DNS setup

This branch adds a safe starting point for provisioning multiple Alfares outreach domains on Cloudflare.

## What this does

For each domain, configure:

- MX
- SPF
- DMARC
- DKIM/domain keys
- optional MTA-STS
- optional TLS reporting

## What this does NOT do

- It does not buy domains.
- It does not create mailboxes.
- It does not send email.
- It does not store API tokens in Git.

## Required per domain

Collect these values before applying Terraform:

1. Cloudflare Zone ID
2. Mail provider MX records
3. SPF include/terms
4. DKIM selector + key/CNAME
5. DMARC reporting mailbox

## Recommended rollout

Start with one test domain. Apply DNS, validate SPF/DKIM/DMARC, connect one mailbox, send only test mail, then repeat for the rest.

Do not apply records copied from another provider or another domain.

## Secrets

Use environment variables for Cloudflare credentials:

```bash
export CLOUDFLARE_API_TOKEN="..."
```

Never commit tokens, mailbox passwords, app passwords, private keys, or OAuth credentials.

## Example structure

Use `examples/alfares-multi-domain/` as the working template. Replace placeholder values only after the mail provider has issued the actual DNS records for each domain.
