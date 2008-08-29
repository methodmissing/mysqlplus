require 'rubygems'
require 'mysqlplus'

$count = 10

$start = Time.now

$connections = []
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

puts Time.now - $start