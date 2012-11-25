require 'geocoder'

class Coordinate < Struct.new(:lat, :long)
  def radians
    @radians ||= Geocoder::Calculations.to_radians(to_a)
  end

  def distance_from(*coordinate)
    coordinate = coordinate.size == 1 ? coordinate.first : Coordinate.new(*coordinate)
    (Geocoder::Calculations.distance_between(coordinate.to_a, to_a) * 1_000).to_f
  end

end
