module Votes
  extend ActiveSupport::Concern 
  
  def overall_standing
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote_type: true).size
  end

  def down_votes
    self.votes.where(vote_type: false).size
  end
end