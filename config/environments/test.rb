Merb.logger.info("Loaded TEST Environment...")
Merb::Config.use { |c|
  c[:testing] = true
  c[:exception_details] = true
  c[:reload_classes] = false
}

class Merb::Mailer
  self.delivery_method = :test_send
end