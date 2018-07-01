require_relative 'user'

PiJob.delete_all

PiJob.create(
  num: "123",
  pi_value: "3.14",
  status: "complete",
  success: "true"
)
