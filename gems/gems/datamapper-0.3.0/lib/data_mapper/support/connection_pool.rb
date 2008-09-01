# See 'fastthread' dependency in data_mapper.rb
# require 'thread' 

module DataMapper
  module Support
    
    # A ConnectionPool manages access to database connections by keeping
    # multiple connections and giving threads exclusive access to each
    # connection.
    #
    # CREDIT: Sharon Rosner, maintainer of the Sequel (http://sequel.rubyforge.org)
    # project an "ORM framework for Ruby" contributed this class.
    class ConnectionPool
      attr_reader :mutex

      # The maximum number of connections.
      attr_reader :max_size
      
      # Returns the number of created connections.
      attr_reader :created_count
      alias :size :created_count

      # The proc used to create a new connection.
      attr_accessor :connection_proc

      attr_reader :available_connections, :allocated

      # Constructs a new pool with a maximum size. If a block is supplied, it
      # is used to create new connections as they are needed.
      #
      #   pool = ConnectionPool.new(10) {MyConnection.new(opts)}
      #
      # The connection creation proc can be changed at any time by assigning a 
      # Proc to pool#connection_proc.
      #
      #   pool = ConnectionPool.new(10)
      #   pool.connection_proc = proc {MyConnection.new(opts)}
      def initialize(max_size = 4, &block)
        @max_size = max_size
        @mutex = Mutex.new
        @connection_proc = block

        @available_connections = []
        @allocated = {}
        @created_count = 0
      end

      # Assigns a connection to the current thread, yielding the connection
      # to the supplied block.
      # 
      #   pool.hold {|conn| conn.execute('DROP TABLE posts;')}
      # 
      # Pool#hold is re-entrant, meaning it can be called recursively in
      # the same thread without blocking.
      #
      # If no connection is available, Pool#hold will block until a connection
      # is available.
      def hold
        t = Thread.current
        if (conn = owned_connection(t))
          return yield(conn)
        end
        while !(conn = acquire(t))
          sleep 0.001
        end
        begin
          yield conn
        ensure
          release(t)
        end
      rescue Exception => e
        # if the error is not a StandardError it is converted into RuntimeError.
        raise e.is_a?(StandardError) ? e : e.message
      end

      private
        # Returns the connection owned by the supplied thread, if any.
        def owned_connection(thread)
          @mutex.synchronize {@allocated[thread]}
        end

        # Assigns a connection to the supplied thread, if one is available.
        def acquire(thread)
          @mutex.synchronize do
            if conn = available
              @allocated[thread] = conn
            end
          end
        end

        # Returns an available connection. If no connection is available,
        # tries to create a new connection.
        def available
          @available_connections.pop || make_new
        end

        # Creates a new connection if the size of the pool is less than the
        # maximum size.
        def make_new
          if @created_count < @max_size
            @created_count += 1
            @connection_proc.call
          end
        end

        # Releases the connection assigned to the supplied thread.
        def release(thread)
          @mutex.synchronize do
            @available_connections << @allocated[thread]
            @allocated.delete(thread)
          end
        end
        
    end # class ConnectionPool    
    
  end # module Support
end # module DataMapper