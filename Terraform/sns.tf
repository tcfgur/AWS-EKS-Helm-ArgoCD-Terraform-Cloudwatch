resource "aws_sns_topic" "eks_alerts_topic" {
  name = "eks-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.eks_alerts_topic.arn
  protocol  = "email"
  endpoint  = "fatihgur1991@gmail.com" 
}
