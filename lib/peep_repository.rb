require_relative 'peep'

class PeepRepository

    def all
      sql = 'SELECT * FROM peeps ORDER BY timestamp DESC;'
      result_set = DatabaseConnection.exec_params(sql, [])

      peeps = []

      result_set.each do |record|
        peep = Peep.new
        peep.content = record['content']
        peep.timestamp = record['timestamp']
        peep.username = record['username']
        peep.user_id = record['user_id'].to_i
        peeps << peep
      end
      return peeps
    end


    def create(peep)
      sql = 'INSERT INTO peeps (content, timestamp, username) VALUES ($1, $2, $3);'
      params = [peep.content, peep.timestamp, peep.username]

      DatabaseConnection.exec_params(sql, params)
    end
end


