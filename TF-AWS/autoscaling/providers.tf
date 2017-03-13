provider "aws" {
  access_key = "${var.AWS_A_KEY}"
  secret_key = "${var.AWS_S_KEY}"
  region     = "${var.AWS_REGION}"
}
