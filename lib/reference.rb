# encoding: utf-8

class Reference
  Error = Class.new(RuntimeError)

  attr_reader :state, :value, :reason

  def initialize
    @state = :pending
    @on_fulfill_callbacks = []
    @on_reject_callbacks = []
    @backtrace
  end

  def pending?
    @state.equal?(:pending)
  end

  def fulfilled?
    @state.equal?(:fulfilled)
  end

  def rejected?
    @state.equal?(:rejected)
  end

  def on_fulfill(&callback)
    @on_fulfill_callbacks << callback
    if fulfilled?
      run_fulfill_callback(callback)
    end
  end

  def on_reject(&callback)
    @on_reject_callbacks << callback
    if rejected?
      run_reject_callback(callback)
    end
  end

  def fulfill(value = nil, backtrace = nil)
    return unless pending?

    @state = :fulfilled
    @value = value
    @backtrace = backtrace

    run_fulfill_callbacks
    value
  end

  def reject(reason = nil, backtrace = nil)
    return unless pending?

    @state = :rejected
    @reason = reason || Error
    @backtrace = backtrace

    run_reject_callbacks
    reason
  end

  private

  def run_fulfill_callbacks
    @on_fulfill_callbacks.each { |callback| run_fulfill_callback(callback) }
  end

  def run_reject_callbacks
    @on_reject_callbacks.each { |callback| run_reject_callback(callback) }
  end

  def run_fulfill_callback(callback)
    callback.call(@value)
  end

  def run_reject_callback(callback)
    callback.call(@reason)
  end
end
