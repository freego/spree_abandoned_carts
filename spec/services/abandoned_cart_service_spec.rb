RSpec.describe Spree::AbandonedCartService do
  let!(:abandoned_order) { create(:order, item_total: 1_00) }

  describe '#perform' do
    let(:future) { Time.current + SpreeAbandonedCarts::Config.abandoned_after_minutes.minutes + 1.second }

    it 'should touch abandoned order' do
      travel_to future do
        expect(Spree::AbandonedCartMailer).to receive(:abandoned_cart_email).with(abandoned_order).and_call_original

        expect { described_class.perform }.to change { abandoned_order.reload.abandoned_cart_email_sent_at }
      end
    end
  end
end
