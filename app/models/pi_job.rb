class PiJob
  include Mongoid::Document

  field :num,      type: Integer
  field :pi_value, type: String
  field :status,   type: String
  field :success,  type: Boolean
end

class PiJobSerializer
  def initialize(piJob)
    @piJob = piJob
  end

  def as_json(*)
    data = {
      id:@piJob.id.to_s,
      num:@piJob.num,
      pi_value:@piJob.pi_value,
      status:@piJob.status,
      success:@piJob.success
    }
    data[:errors] = @piJob.errors if@piJob.errors.any?
    data
  end
end
