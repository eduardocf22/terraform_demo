

resource "aws_security_group" "fargate_alb_sg" {
    name = "fargate-demo-alb-sg"
    description = "controls traffic flow to Fargate ALB"
    vpc_id = "${var.vpc_id}"

    ingress  {
        protocol = "tcp"
        from_port = "${var.alb_ext_port}"
        to_port = "${var.alb_ext_port}"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        to_port = 0
        protocol  = "-1"
        from_port  = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ecs_tasks_sg" {
    name = "ecs-tasks-sg"
    description = "allow inbound from ALB only"
    vpc_id = "${var.vpc_id}"

    ingress {
        protocol = "tcp"
        from_port = "${var.app_port}"
        to_port = "${var.app_port}"
        security_groups = ["${aws_security_group.fargate_alb_sg.id}"]
    }
    egress {
        to_port = 0
        protocol  = "-1"
        from_port  = 0
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "aws_alb" "main" {
    name = "ecs-alb"
    subnets = ["${split(",",var.public_subnet_id_list)}"]
    security_groups = ["${aws_security_group.fargate_alb_sg.id}"]
}

resource "aws_alb_target_group" "app" {
    name = "ecs-alb-tg"
    port = "${var.alb_ext_port}"
    protocol = "HTTP"
    vpc_id = "${var.vpc_id}"
    target_type = "ip"
}

resource "aws_alb_listener" "front_end_listener" {
    load_balancer_arn = "${aws_alb.main.id}"
    port = "${var.alb_ext_port}"

    default_action {
        target_group_arn = "${aws_alb_target_group.app.id}"
        type = "forward"
    }
}

resource "aws_ecs_cluster" "main" {
    name = "tf-demo-ecs-cluster"
}

resource "aws_ecs_task_definition" "app" {
    family = "${var.app_name}"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "${var.fargate_cpu}"
    memory = "${var.fargate_memory}"

    container_definitions = <<DEFINITION
    [
    {
        "cpu": ${var.fargate_cpu},
        "image": "${var.docker_image}",
        "memory": ${var.fargate_memory},
        "name": "${var.app_name}",
        "networkMode": "awsvpc",
        "environment": [{
            "name": "NGINX_PORT",
            "value": "80"
            }
        ],
        "portMappings": [
        {
            "containerPort": ${var.app_port},
            "hostPort": ${var.alb_ext_port}
        }
        ]
    }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
    name = "tf-demo-service"
    cluster = "${aws_ecs_cluster.main.id}"
    task_definition = "${aws_ecs_task_definition.app.arn}"
    desired_count = "${var.number_of_containers}"
    launch_type = "FARGATE"

    network_configuration {
        security_groups = ["${aws_security_group.ecs_tasks_sg.id}"]
        subnets = ["${split(",",var.private_subnet_id_list)}"]
    }
    load_balancer {
        target_group_arn = "${aws_alb_target_group.app.id}"
        container_name = "${var.app_name}"
        container_port = "${var.app_port}"
    }

    depends_on = [
        "aws_alb_listener.front_end_listener",
    ]
}

output "ecs_service_endpoint" {
    value = "${aws_alb.main.dns_name}"
}
