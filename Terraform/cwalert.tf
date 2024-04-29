resource "aws_cloudwatch_metric_alarm" "eks_cpu_alarm" {
  alarm_name          = "eks-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EKS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80% for 2 consecutive periods"
  alarm_actions       = [aws_sns_topic.eks_alerts_topic.arn] // Use square brackets to define a set
  dimensions = {
    ClusterName = aws_eks_cluster.my_cluster.name // Remove quotes to reference output value
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_memory_alarm" {
  alarm_name          = "eks-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EKS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when memory exceeds 80% for 2 consecutive periods"
  alarm_actions       = [aws_sns_topic.eks_alerts_topic.arn] // Use square brackets to define a set
  dimensions = {
    ClusterName = aws_eks_cluster.my_cluster.name // Remove quotes to reference output value
  }
}
