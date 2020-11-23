require 'pg'

def setup_test_database
  p "Setting up test database..."

  connection = PG.connect(dbname: 'bnb_test')

  # Clear test table
  connection.exec("TRUNCATE users;")
end
