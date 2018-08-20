variable "location" {
  type    = "string"
  default = "UK South"
}

variable "env" {
  type = "string"
}

variable "subscription" {
  type = "string"
}

variable "publisher_email" {
  type    = "string"
  default = "professional-api@hmcts.net"
}

variable "publisher_name" {
  type    = "string"
  default = "HMCTS Reform Platform Engineering"
}

variable "notification_sender_email" {
  type    = "string"
  default = "papi-noreply@mail.windowsazure.com"
}
