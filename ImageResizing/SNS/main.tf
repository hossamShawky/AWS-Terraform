locals {
  emails = ["hossamshawky288@gmail.com"]
}

resource "aws_sns_topic" "sns_topic" {
  name            = "${var.project}-sns"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": ${var.numRetries},
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF

}



resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  count     = length(local.emails)
  protocol  = var.protocol
  endpoint  = local.emails[count.index]
}

#Check
resource "null_resource" "publish_msg" {
  triggers = {
    topic_arn = aws_sns_topic.sns_topic.arn
  }

  provisioner "local-exec" {
    command = <<EOT
aws --profile "${var.profile}" sns publish --topic-arn "${aws_sns_topic.sns_topic.arn}" --message "Hello, ImageResizing"
  EOT
  }

}
