class AbandonedCartWorker
  include Sidekiq::Worker if defined?(Sidekiq)

  def perform
    AbandonedCartService.perform

    if self.class.respond_to?(:perform_in)
      next_run = SpreeAbandonedCarts::Config.worker_frequency_minutes
      self.class.perform_in(next_run.minutes) if next_run > 0
    end
  end
end
