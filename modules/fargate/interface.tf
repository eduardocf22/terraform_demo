

variable "vpc_id" {
    description = "VPC ID where fargate will be deployed"
}

variable "public_subnet_id_list" {
    description = "Public subnet for ALBs"
}

variable "private_subnet_id_list" {
    description = "Public subnet for ALBs"
}

variable "fargate_cpu" {
    description = "CPU soft limit for Fargate tasks"
}

variable "fargate_memory" {
    description = "Memory soft limit for Fargate tasks"
}

variable "docker_image" {
    description = "docker image path/name to be deployed in Fargate task"
}

variable "app_name" {
    description = "APP name to define on task"
}

variable "app_port" {
    description = "App tcp port to be used on task"
}

variable "alb_ext_port" {
    description = "ALB external port"
}

variable "number_of_containers" {
    description = "Number of containers to run"
    default = 2
}