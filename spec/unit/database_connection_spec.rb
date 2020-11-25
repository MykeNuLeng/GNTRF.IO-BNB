require 'database_connection'

describe DatabaseConnection do

  describe '.setup' do
    it 'sets up a connection to the database via PG' do
      expect(PG).to receive(:connect).with(dbname: 'bnb_test')
      DatabaseConnection.setup('bnb_test')
    end
  end

  describe '.connection' do
    it 'connection is persisted' do
      connection = DatabaseConnection.setup('bnb_test')
      expect(DatabaseConnection.connection).to eq connection
    end
  end

  describe '.query' do
    it 'executes a query via PG' do
      connection = DatabaseConnection.setup('bnb_test')
      expect(connection).to receive(:exec).with("SELECT * FROM orders;")
      DatabaseConnection.query("SELECT * FROM orders;")
    end
  end

end
