# encoding: utf-8

require 'spec_helper'

describe Reference do
  subject { Reference.new }

  let(:value) { double('value') }
  let(:other_value) { double('other_value') }

  let(:backtrace) { caller }
  let(:reason) do
    StandardError.new('reason').tap { |ex| ex.set_backtrace(backtrace) }
  end
  let(:other_reason) do
    StandardError.new('other_reason').tap { |ex| ex.set_backtrace(backtrace) }
  end

  describe '3.1.1 pending' do
    it 'transitions to fulfilled' do
      subject.fulfill(value)
      expect(subject).to be_fulfilled
    end

    it 'transitions to rejected' do
      subject.reject(reason)
      expect(subject).to be_rejected
    end
  end

  describe '3.1.2 fulfilled' do
    it 'does not transition to other states' do
      subject.fulfill(value)
      subject.reject(reason)
      expect(subject).to be_fulfilled
    end

    it 'has a value' do
      subject.fulfill(value)
      expect(subject.value).to eq(value)

      subject.fulfill(other_value)
      expect(subject.value).to eq(value)
    end
  end

  describe '3.1.3 rejected' do
    it 'does not transition to other states' do
      subject.reject(reason)
      subject.fulfill(value)
      expect(subject).to be_rejected
    end

    it 'has a reason' do
      subject.reject(reason)
      expect(subject.reason).to eq(reason)

      subject.reject(other_reason)
      expect(subject.reason).to eq(reason)
    end
  end

  describe '3.2.5' do
    it 'calls multiple on_fulfill callbacks in order of definition' do
      order = []

      subject.on_fulfill do |val|
        order << 1
        expect(val).to eq(value)
      end

      subject.on_fulfill do |val|
        order << 2
        expect(val).to eq(value)
      end

      subject.fulfill(value)

      subject.on_fulfill do |val|
        order << 3
        expect(val).to eq(value)
      end

      expect(order).to eq([1, 2, 3])
    end

    it 'calls multiple on_reject callbacks in order of definition' do
      order = []
      on_reject = lambda do |i|
        order << i

        return lambda do |reas|
                 expect(reas).to eq(reason)
               end
      end

      subject.on_reject do |reas|
        order << 1
        expect(reas).to eq(reason)
      end

      subject.on_reject do |reas|
        order << 2
        expect(reas).to eq(reason)
      end

      subject.reject(reason)

      subject.on_reject do |reas|
        order << 3
        expect(reas).to eq(reason)
      end

      expect(order).to eq([1, 2, 3])
    end
  end

  describe 'extras' do
    describe '#fulfill' do
      it 'does not return anything' do
        expect(subject.fulfill(nil)).to eq(nil)
      end

      it 'does not require a value' do
        subject.fulfill
        expect(subject.value).to be(nil)
      end
    end

    describe '#reject' do
      it 'does not return anything' do
        expect(subject.reject(nil)).to eq(nil)
      end

      it 'does not require a reason' do
        subject.reject
        expect(subject.reason).to be(Reference::Error)
      end
    end
  end
end
