resource "aws_s3_bucket" "tcl-s3" {
  bucket        = "${var.BUCKETNAME}"
  acl           = "private"
  force_destroy = "true"

  tags {
    Name        = "tcl-bucket"
    Environment = "Dev"
  }
}

resource "aws_launch_configuration" "tcl-launchconfig" {
  name_prefix          = "tcl-lc"
  image_id             = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type        = "t2.micro"
  key_name             = "${var.KEYNAME}"
  iam_instance_profile = "${var.IAMPROFILE}"
  user_data            = "${file("script.sh")}"
}

resource "aws_autoscaling_group" "tcl-autoscaling-group" {
  name                      = "tcl-asg"
  vpc_zone_identifier       = ["${var.VPC-ZONE-AZ1}", "${var.VPC-ZONE-AZ2}"]
  launch_configuration      = "${aws_launch_configuration.tcl-launchconfig.name}"
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "TCL-ASG-VM"
    propagate_at_launch = "true"
  }
}

resource "aws_autoscaling_policy" "tcl-asg-policy-su" {
  name                   = "tcl-asg-policy-su"
  autoscaling_group_name = "${aws_autoscaling_group.tcl-autoscaling-group.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "tcl-asg-policy-sd" {
  name                   = "tcl-asg-policy-sd"
  autoscaling_group_name = "${aws_autoscaling_group.tcl-autoscaling-group.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "tcl-cpu-up" {
  alarm_name          = "tcl-cpu-up"
  alarm_description   = "Check CPU Utilization if its greater than 30% for 3 mins"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.tcl-autoscaling-group.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.tcl-asg-policy-su.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "tcl-cpu-down" {
  alarm_name          = "tcl-cpu-down"
  alarm_description   = "Check CPU Utilization if its less than 10% for 3 mins"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.tcl-autoscaling-group.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.tcl-asg-policy-sd.arn}"]
}
