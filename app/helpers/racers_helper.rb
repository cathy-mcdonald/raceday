module RacersHelper
  def to_racer(value)
    value.is_a?(Racer) ? value : Racer.new(value)
  end
end
