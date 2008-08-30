require 'rubygems'
require 'mysqlplus'

def with_time( header = nil )
  puts header if header
  start = Time.now
  yield
  puts Time.now - start
end

$count = 10

$connections = []

with_time do
  $count.times do  
    $connections << Mysql.real_connect('localhost','root')
  end

  puts 'connection pool ready'

  $threads = []
  $count.times do |i|
    $threads << Thread.new do
     sleep_timeout = rand()
     puts "sending query on connection #{i} (#{sleep_timeout})"

      $connections[i].async_query("select sleep(#{sleep_timeout})").each{ |r|
        puts "connection #{i} (#{sleep_timeout}) done"
      }

    end
  end

  puts 'waiting on threads'
  $threads.each{|t| t.join }

end

connection = Mysql.real_connect('localhost','root')

with_time "Send long query, within timeout range" do
  connection.async_query("select sleep(10)",11)
end

with_time "Send long query, times out" do
  connection.async_query("select sleep(10)",9)
end  