# run with:  god -c ~/conf/config.god

MERB_ROOT = "/home/deploy/joe/current"

PORTS = %w{4000}
PORTS.each do |port|
  God.watch do |w|

    w.uid = 'deploy'

    w.name =          "fightinjoe-mongrel-#{port}" # "gravatar2-mongrel-#{port}"
    w.interval =      30.seconds # default
    w.start =         "merb -e production -m #{ MERB_ROOT } -p #{ port }" # "mongrel_rails start -c #{RAILS_ROOT} -p #{port} -P #{RAILS_ROOT}/log/mongrel.#{port}.pid  -d"
    w.stop =          "ruby #{ MERB_ROOT }/script/stop_merb #{ port }" # "mongrel_rails stop -P #{RAILS_ROOT}/log/mongrel.#{port}.pid"
    w.restart =       "ruby #{ MERB_ROOT }/script/stop_merb #{ port } && merb -e production -p #{ port }" # "mongrel_rails restart -P #{RAILS_ROOT}/log/mongrel.#{port}.pid"
    w.start_grace =   10.seconds
    w.restart_grace = 10.seconds
    w.pid_file =      File.join(MERB_ROOT, "log/merb.#{port}.pid")

    w.behavior(:clean_pid_file)

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end

    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 150.megabytes
        c.times = [3, 5] # 3 out of 5 intervals
      end

      restart.condition(:cpu_usage) do |c|
        c.above = 50.percent
        c.times = 5
      end
    end

    # lifecycle
    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state =     [:start, :restart]
        c.times =        5
        c.within =       5.minute
        c.transition =   :unmonitored
        c.retry_in =     10.minutes
        c.retry_times =  5
        c.retry_within = 2.hours
      end
    end
  end
end
