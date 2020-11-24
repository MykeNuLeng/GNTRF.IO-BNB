require './lib/database_connection'

if ENV['ENVIRONMENT'] == 'test'
  DatabaseConnection.setup('bnb_test')
else
  DatabaseConnection.setup('bnb')
end