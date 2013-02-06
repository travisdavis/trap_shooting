module NewbigBoardHelper
  include Logic::Results

  def get_shooter_result_info shooter, result
  	return Shooter_info.new(shooter, result)
  end
end