Merb.logger.info("Loaded PRODUCTION Environment...")
Merb::Config.use { |c|
  c[:exception_details] = false
  c[:reload_classes] = true
  c[:reload_time] = 0.5
}

Merb::Mailer.config = {:sendmail_path => '/usr/sbin/sendmail'}
Merb::Mailer.delivery_method = :sendmail