resource "aws_security_group" "ingress-dev-k8s-consort-it-de" {
  name        = "ingress.dev.k8s.consort-it.de"
  vpc_id      = "${aws_vpc.dev-k8s-consort-it-de.id}"
  description = "ingress.dev.k8s.consort-it.de"

  tags = {
    KubernetesCluster                             = "dev.k8s.consort-it.de"
    Name                                          = "ingress.dev.k8s.consort-it.de"
    "kubernetes.io/cluster/dev.k8s.consort-it.de" = "owned"
    "kubernetes:application"                      = "kube-ingress-aws-controller"
  }
}

resource "aws_security_group_rule" "http-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.ingress-dev-k8s-consort-it-de.id}"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.ingress-dev-k8s-consort-it-de.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all-ingress-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-dev-k8s-consort-it-de.id}"
  source_security_group_id = "${aws_security_group.ingress-dev-k8s-consort-it-de.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-lb-to-cidr" {
  type              = "egress"
  security_group_id = "${aws_security_group.ingress-dev-k8s-consort-it-de.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["172.20.0.0/16"]
}
