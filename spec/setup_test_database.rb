require 'pg'

def setup_test_database
  connection = PG.connect(dbname: 'bnb_test')
  # This stops the cascade warning message
  connection.exec("set client_min_messages='warning';")
  # Clear test table
  connection.exec("TRUNCATE users CASCADE;")
end
