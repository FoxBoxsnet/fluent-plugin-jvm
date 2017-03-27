# coding: utf-8
module Fluent
  class JvmInput < Fluent::Input
    Fluent::Plugin.register_input('jvm', self)

    config_param :tag,        :string,  default: 'jvm'
    config_param :interval,   :integer, default: 60
    config_param :url,        :string,  default: 'http://127.0.0.1:8778/jolokia'
    config_param :mbean,      :string,  default: 'java.lang:type=Memory'
    config_param :attribute,  :string,  default: 'HeapMemoryUsage'

    def initialize
      super
      require 'net/http'
      require 'uri'
      require 'json'
    end

    def configure(conf)
      super
    end

    def start
      @loop = Coolio::Loop.new
      @tw = TimerWatcher.new(interval, true, log, &method(:execute))
      @tw.attach(@loop)
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      @tw.detach
      @loop.stop
      @thread.join
    end

    def run
      @loop.run
    rescue => e
      log.error 'unexpected error', error: e.to_s
      log.error_backtrace
    end

    private

    def execute
      @time = Engine.now
      record = _get_record
      log.debug(record)
      Engine.emit(@tag, @time, record)
    rescue => e
      log.error('faild to run', error: e.to_s, error_class: e.class.to_s)
      log.error_backtrace
    end

    def _get_record
      record = Hash.new(0)
      uri = URI.parse("#{@url}/read/#{@mbean}/#{@attribute}")
      log.debug(uri)

      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        http.request(request) do |response|
          record = JSON.parse(response.body) rescue next
          record = record['value']
          log.debug(response.body)
        end
      end
      record
    end

    class TimerWatcher < Coolio::TimerWatcher
      def initialize(interval, repeat, log, &callback)
        log = log
        @callback = callback
        super(interval, repeat)
      end

      def on_timer
        @callback.call
      rescue => e
        log.error e.to_s
        log.error_backtrace
      end
    end
  end
end