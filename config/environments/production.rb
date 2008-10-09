Merb.logger.info("Loaded PRODUCTION Environment...")
Merb::Config.use { |c|
  c[:exception_details] = false
  c[:reload_classes] = false
  c[:log_level] = :error
  c[:log_file] = Merb.log_path + "/production.log"
}

Merb::Mailer.config = {:sendmail_path => '/usr/sbin/sendmail'}
Merb::Mailer.delivery_method = :sendmail