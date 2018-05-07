output "cluster_name" {
  value = "dev.k8s.consort-it.de"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-dev-k8s-consort-it-de.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-dev-k8s-consort-it-de.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-dev-k8s-consort-it-de.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-dev-k8s-consort-it-de.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.eu-central-1b-dev-k8s-consort-it-de.id}", "${aws_subnet.eu-central-1c-dev-k8s-consort-it-de.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-dev-k8s-consort-it-de.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-dev-k8s-consort-it-de.name}"
}

output "region" {
  value = "eu-central-1"
}

output "vpc_id" {
  value = "${aws_vpc.dev-k8s-consort-it-de.id}"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_autoscaling_group" "master-eu-central-1b-masters-dev-k8s-consort-it-de" {
  name                 = "master-eu-central-1b.masters.dev.k8s.consort-it.de"
  launch_configuration = "${aws_launch_configuration.master-eu-central-1b-masters-dev-k8s-consort-it-de.id}"
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1b-dev-k8s-consort-it-de.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "dev.k8s.consort-it.de"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-eu-central-1b.masters.dev.k8s.consort-it.de"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-eu-central-1b"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "kubernetes.io/cluster/dev.k8s.consort-it.de"
    value               = "owned"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-dev-k8s-consort-it-de" {
  name                 = "nodes.dev.k8s.consort-it.de"
  launch_configuration = "${aws_launch_configuration.nodes-dev-k8s-consort-it-de.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1b-dev-k8s-consort-it-de.id}", "${aws_subnet.eu-central-1c-dev-k8s-consort-it-de.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "dev.k8s.consort-it.de"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.dev.k8s.consort-it.de"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "kubernetes.io/cluster/dev.k8s.consort-it.de"
    value               = "owned"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_ebs_volume" "b-etcd-events-dev-k8s-consort-it-de" {
  availability_zone = "eu-central-1b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                             = "dev.k8s.consort-it.de"
    Name                                          = "b.etcd-events.dev.k8s.consort-it.de"
    "k8s.io/etcd/events"                          = "b/b"
    "k8s.io/role/master"                          = "1"
    "kubernetes.io/cluster/dev.k8s.consort-it.de" = "owned"
  }
}

resource "aws_ebs_volume" "b-etcd-main-dev-k8s-consort-it-de" {
  availability_zone = "eu-central-1b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                             = "dev.k8s.consort-it.de"
    Name                                          = "b.etcd-main.dev.k8s.consort-it.de"
    "k8s.io/etcd/main"                            = "b/b"
    "k8s.io/role/master"                          = "1"
    "kubernetes.io/cluster/dev.k8s.consort-it.de" = "owned"
  }
}

resource "aws_iam_instance_profile" "masters-dev-k8s-consort-it-de" {
  name = "masters.dev.k8s.consort-it.de"
  role = "${aws_iam_role.masters-dev-k8s-consort-it-de.name}"
}

resource "aws_iam_instance_profile" "nodes-dev-k8s-consort-it-de" {
  name = "nodes.dev.k8s.consort-it.de"
  role = "${aws_iam_role.nodes-dev-k8s-consort-it-de.name}"
}

resource "aws_iam_role" "masters-dev-k8s-consort-it-de" {
  name               = "masters.dev.k8s.consort-it.de"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.dev.k8s.consort-it.de_policy")}"
}

resource "aws_iam_role" "nodes-dev-k8s-consort-it-de" {
  name               = "nodes.dev.k8s.consort-it.de"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.dev.k8s.consort-it.de_policy")}"
}

resource "aws_iam_role_policy" "additional-nodes-dev-k8s-consort-it-de" {
  name   = "additional.nodes.dev.k8s.consort-it.de"
  role   = "${aws_iam_role.nodes-dev-k8s-consort-it-de.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_additional.nodes.dev.k8s.consort-it.de_policy")}"
}

resource "aws_iam_role_policy" "masters-dev-k8s-consort-it-de" {
  name   = "masters.dev.k8s.consort-it.de"
  role   = "${aws_iam_role.masters-dev-k8s-consort-it-de.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.dev.k8s.consort-it.de_policy")}"
}

resource "aws_iam_role_policy" "nodes-dev-k8s-consort-it-de" {
  name   = "nodes.dev.k8s.consort-it.de"
  role   = "${aws_iam_role.nodes-dev-k8s-consort-it-de.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.dev.k8s.consort-it.de_policy")}"
}

resource "aws_internet_gateway" "dev-k8s-consort-it-de" {
  vpc_id = "${aws_vpc.dev-k8s-consort-it-de.id}"

  tags = {
    KubernetesCluster                             = "dev.k8s.consort-it.de"
    Name                                          = "dev.k8s.consort-it.de"
    "kubernetes.io/cluster/dev.k8s.consort-it.de" = "owned"
  }
}

resource "aws_key_pair" "kubernetes-dev-k8s-consort-it-de-ea3d7d905544d6166ec85d0ec59a4bd0" {
  key_name   = "kubernetes.dev.k8s.consort-it.de-ea:3d:7d:90:55:44:d6:16:6e:c8:5d:0e:c5:9a:4b:d0"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.dev.k8s.consort-it.de-ea3d7d905544d6166ec85d0ec59a4bd0_public_key")}"
}

resource "aws_launch_configuration" "master-eu-central-1b-masters-dev-k8s-consort-it-de" {
  name_prefix                 = "master-eu-central-1b.masters.dev.k8s.consort-it.de-"
  image_id                    = "ami-6b204704"
  instance_type               = "m3.medium"
  key_name                    = "${aws_key_pair.kubernetes-dev-k8s-consort-it-de-ea3d7d905544d6166ec85d0ec59a4bd0.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-dev-k8s-consort-it-de.id}"
  security_groups             = ["${aws_security_group.masters-dev-k8s-consort-it-de.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-eu-central-1b.masters.dev.k8s.consort-it.de_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-dev-k8s-consort-it-de" {
  name_prefix                 = "nodes.dev.k8s.consort-it.de-"
  image_id                    = "ami-6b204704"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-dev-k8s-consort-it-de-ea3d7d905544d6166ec85d0ec59a4bd0.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-dev-k8s-consort-it-de.id}"
  security_groups             = ["${aws_security_group.nodes-dev-k8s-consort-it-de.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.dev.k8s.consort-it.de_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.dev-k8s-consort-it-de.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.dev-k8s-consort-it-de.id}"
}

resource "aws_route_table" "dev-k8s-consort-it-de" {
  vpc_id = "${aws_vpc.dev-k8s-consort-it-de.id}"

  tags = {
    KubernetesCluster                             = "dev.k8s.consort-it.de"
    Name                                          = "dev.k8s.consort-it.de"
    "kubernetes.io/cluster/dev.k8s.consort-it.de" = "owned"
  }
}

resource "aws_route_table_association" "eu-central-1b-dev-k8s-consort-it-de" {
  subnet_id      = "${aws_subnet.eu-central-1b-dev-k8s-consort-it-de.id}"
  route_table_id = "${aws_route_table.dev-k8s-consort-it-de.id}"
}

resource "aws_route_table_association" "eu-central-1c-dev-k8s-consort-it-de" {
  subnet_id      = "${aws_subnet.eu-central-1c-dev-k8s-consort-it-de.id}"
  route_table_id = "${aws_route_table.dev-k8s-consort-it-de.id}"
}

resource "aws_security_group" "masters-dev-k8s-consort-it-de" {
  name        = "masters.dev.k8s.consort-it.de"
  vpc_id      = "${aws_vpc.dev-k8s-consort-it-de.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "dev.k8s.consort-it.de"
    Name              = "masters.dev.k8s.consort-it.de"
  }
}

resource "aws_security_group" "nodes-dev-k8s-consort-it-de" {
  name        = "nodes.dev.k8s.consort-it.de"
  vpc_id      = "${aws_vpc.dev-k8s-consort-it-de.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "dev.k8s.consort-it.de"
    Name              = "nodes.dev.k8s.consort-it.de"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  source_security_group_id = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  source_security_group_id = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  source_security_group_id = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  source_security_group_id = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  source_security_group_id = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  source_security_group_id = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  source_security_group_id = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-dev-k8s-consort-it-de.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "eu-central-1b-dev-k8s-consort-it-de" {
  vpc_id            = "${aws_vpc.dev-k8s-consort-it-de.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "eu-central-1b"

  tags = {
    KubernetesCluster                             = "dev.k8s.consort-it.de"
    Name                                          = "eu-central-1b.dev.k8s.consort-it.de"
    SubnetType                                    = "Public"
    "kubernetes.io/cluster/dev.k8s.consort-it.de" = "owned"
    "kubernetes.io/role/elb"                      = "1"
  }
}

resource "aws_subnet" "eu-central-1c-dev-k8s-consort-it-de" {
  vpc_id            = "${aws_vpc.dev-k8s-consort-it-de.id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "eu-central-1c"

  tags = {
    KubernetesCluster                             = "dev.k8s.consort-it.de"
    Name                                          = "eu-central-1c.dev.k8s.consort-it.de"
    SubnetType                                    = "Public"
    "kubernetes.io/cluster/dev.k8s.consort-it.de" = "owned"
    "kubernetes.io/role/elb"                      = "1"
  }
}

resource "aws_vpc" "dev-k8s-consort-it-de" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                             = "dev.k8s.consort-it.de"
    Name                                          = "dev.k8s.consort-it.de"
    "kubernetes.io/cluster/dev.k8s.consort-it.de" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "dev-k8s-consort-it-de" {
  domain_name         = "eu-central-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster                             = "dev.k8s.consort-it.de"
    Name                                          = "dev.k8s.consort-it.de"
    "kubernetes.io/cluster/dev.k8s.consort-it.de" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "dev-k8s-consort-it-de" {
  vpc_id          = "${aws_vpc.dev-k8s-consort-it-de.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dev-k8s-consort-it-de.id}"
}

terraform = {
  required_version = ">= 0.9.3"
}
