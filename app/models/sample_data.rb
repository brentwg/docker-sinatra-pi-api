require_relative 'user'

User.delete_all

User.create(
  user_id: "001",
  firstname: "Test",
  lastname: "User",
  email: "test.user@demo.com"
)
