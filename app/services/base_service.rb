# frozen_string_literal: true

class BaseService
  include ActiveSupport::Concern

  class << self
    def execute!(*args)
      new.execute!(*args)
    end
  end

  def execute!(*_args)
    raise NotImplementedError
  end

  private

  def logger
    @logger ||= Logger.new(path_to_log_file)
  end

  def path_to_log_file
    Rails.root.join('log', "#{service_tmp_working_name}.log")
  end

  def service_tmp_working_name
    self.class.name.underscore.gsub('/', '-')
  end

  def with_error_logger(args: nil)
    logger.info({ class: self.class.name, args: args }.to_json)
    yield if block_given?
  rescue StandardError => e
    log_error(e, args)
    raise e
  end

  def log_error(exception, args = nil)
    if exception
      logger.error(exception.message)
      logger.error(exception.backtrace.to_a.join("\n"))
    end
    logger.error({ args: args }.to_json)
  end
end
