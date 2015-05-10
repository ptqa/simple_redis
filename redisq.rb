require 'redis'

GENID = 'gen_id'
QUEUE = 'msg_queue'
EQUEUE = 'error_queue'
r = Redis.new

# check if there is generator
# if no we should become it
am_i_gen = lambda do
  if r.exists GENID
    r[GENID].to_i == r.hash.to_i ? true : false
  else
    r[GENID] = r.hash.to_i
    true
  end
end

# generate message
msg_gen = lambda do |msg|
  r.multi do
    r[GENID] = r.hash.to_i
    r.expire GENID, 5
    q = rand > 0.85 ? EQUEUE : QUEUE
    r.lpush q, msg
  end
end

# get message
msg_get = -> { puts r.lpop QUEUE }

# get errors
errors_get = lambda do
  (r.llen EQUEUE).times { puts r.lpop EQUEUE }
end

# main loop
loop do
  if am_i_gen.call
    msg = "This msg generated at #{Time.now}"
    puts "Generated: #{msg}"
    msg_gen.call(msg)
    sleep 1
  else
    msg_get.call
    sleep 0.5
  end
end unless ARGV.first == '--errors'

# get errors if started with --errors option
errors_get.call if ARGV.first == '--errors'
