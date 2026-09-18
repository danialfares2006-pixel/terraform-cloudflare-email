terraform {
  required_version = ">= 1.5.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "domains" {
  description = "Per-domain email DNS configuration. Replace placeholders with real provider-issued values."
  type = map(object({
    account_id = string
    zone_id    = string

    mx = map(number)

    spf_terms = list(string)

    dmarc_policy = optional(string, "none")
    dmarc_rua    = list(string)

    tlsrpt_rua = optional(list(string), [])

    domainkeys = optional(map(object({
      type  = string
      value = string
    })), {})
  }))
}

module "email" {
  for_each = var.domains

  source = "../../"

  account_id = each.value.account_id
  zone_id    = each.value.zone_id

  mx        = each.value.mx
  spf_terms = each.value.spf_terms

  dmarc_policy = each.value.dmarc_policy
  dmarc_rua    = each.value.dmarc_rua

  tlsrpt_rua = length(each.value.tlsrpt_rua) > 0 ? each.value.tlsrpt_rua : each.value.dmarc_rua

  domainkeys = each.value.domainkeys

  mta_sts_mode = "testing"
}
