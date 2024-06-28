resource "aws_wafv2_ip_set" "ip_blacklist" {

  name               = "${var.project}-IPSET"
  description        = "WAF IP set"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = [var.ip]

  tags = {
    "Name" = "${var.project}-IPSET"
  }
}

resource "aws_wafv2_web_acl" "waf" {
  name  = "${var.project}-WAF"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "ip-blacklist"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_blacklist.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlacklistedIP"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "Allowed"
    sampled_requests_enabled   = true
  }
  tags = {
    "Name" = "${var.project}-WAF"
  }
}




resource "aws_wafv2_web_acl_association" "waf_alb" {
  resource_arn = var.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}