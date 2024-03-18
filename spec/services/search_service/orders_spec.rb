require 'rails_helper'

RSpec.describe SearchService::Orders do
  describe '.call' do
    subject { described_class.call(params) }

    context 'with state filter' do
      let(:params) { { state: Order::STATES.last } }
      let!(:second_order) do
        create(:order, name: 'Bbbb Second Name', state: Order::STATES.last,
               order_items: create_list(:order_item, 1))
      end
      let!(:first_order) do
        create(:order, name: 'Aaaaa First Name', state: Order::STATES.last,
               order_items: create_list(:order_item, 1))
      end

      before do
        create_list(:order, 10, name: 'C Third Name', state: Order::STATES.last, order_items: create_list(:order_item, 3))
        create_list(:order, 10, name: 'AA First Name', state: Order::STATES.first, order_items: create_list(:order_item, 3))
      end

      it 'returns orders with the given state' do
        expect(subject.value.count).to eq(5)
        expect(subject.value.first).to eq(first_order)
        expect(subject.value.second).to eq(second_order)
      end
    end

    context 'with cancelation_date filter' do
      let(:params) { { cancelation_date_from: 1.day.ago.to_s, cancelation_date_to: 2.day.from_now.to_s } }
      let!(:first_order) do
        create(:order, name: 'A First Name', cancelation_date: 1.day.from_now,
               order_items: create_list(:order_item, 1))
      end

      before do
        create_list(:order, 10, name: 'AA First Name', cancelation_date: 1.year.ago,
                     order_items: create_list(:order_item, 3))
        create_list(:order, 3, name: 'B Second Names', cancelation_date: 1.day.from_now,
                     order_items: create_list(:order_item, 3))
      end

      it 'returns orders with the given cancelation_date range' do
        expect(subject.value.count).to eq(4)
        expect(subject.value.first).to eq(first_order)
      end
    end

    context 'with state and cancelation_date filters' do
      let(:params) do
        {
          state: Order::STATES.last,
          cancelation_date_from: 1.day.ago.to_s, cancelation_date_to: 2.day.from_now.to_s
        }
      end
      let!(:first_order) do
        create(:order, name: 'A First Name', state: Order::STATES.last, cancelation_date: 1.day.from_now,
               order_items: create_list(:order_item, 1))
      end

      before do
        create_list(:order, 10, name: 'AA First Name', state: Order::STATES.last, cancelation_date: 1.year.ago,
                    order_items: create_list(:order_item, 3))
        create_list(:order, 10, name: 'AA First Name', state: Order::STATES.first, cancelation_date: 1.day.from_now,
                    order_items: create_list(:order_item, 3))

        create_list(:order, 3, name: 'B Second Names', state: Order::STATES.last, cancelation_date: 1.day.from_now,
                    order_items: create_list(:order_item, 3))
      end

      it 'returns orders with the given state and cancelation_date range' do
        expect(subject.value.count).to eq(4)
        expect(subject.value.first).to eq(first_order)
      end
    end

    context 'without filters' do
      let(:params) { {} }
      let!(:first_order) { create(:order, name: 'A First Name', order_items: create_list(:order_item, 1)) }
      let!(:second_order) { create(:order, name: 'B Second Name', order_items: create_list(:order_item, 1)) }

      before do
        create_list(:order, 10, name: 'C Third Name', order_items: create_list(:order_item, 10))
      end

      it 'returns all orders' do
        expect(subject.value.count).to eq(5)
        expect(subject.value.first).to eq(first_order)
        expect(subject.value.second).to eq(second_order)
      end

      context 'with pagination' do
        let(:params) { { page: 3 } }

        it 'returns orders from the given page' do
          expect(subject.value.count).to eq(2)
        end
      end
    end
  end
end
