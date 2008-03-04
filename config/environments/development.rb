Merb.logger.info("Loaded DEVELOPMENT Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5
}

class Merb::Mailer
  self.delivery_method = :test_send
end