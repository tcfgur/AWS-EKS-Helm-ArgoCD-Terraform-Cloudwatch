resource "aws_cloudwatch_metric_alarm" "eks_cpu_alarm" {
  alarm_name          = "eks-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "pod_cpu_utilization_over_pod_limit"
  namespace           = "ContainerInsights"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80% for 2 consecutive periods"
  alarm_actions       = [aws_sns_topic.eks_alerts_topic.arn]
  dimensions = {
    ClusterName = aws_eks_cluster.my_cluster.name 
  }
}


resource "aws_cloudwatch_metric_alarm" "eks_memory_alarm" {
  alarm_name          = "eks-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "pod_memory_utilization"
  namespace           = "ContainerInsights"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Alarm when memory exceeds 80% for 1 datapoint within 5 minutes"
  alarm_actions       = [aws_sns_topic.eks_alerts_topic.arn] 
  dimensions = {
    ClusterName = "my-eks-cluster" 
    PodName     = "backend"
    Namespace   = "default"
  }
}
