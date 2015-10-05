class Task < ActiveRecord::Base
	STATES = {
    new: 0,
    analyze: 1,
    work: 2,
    realized: 3,
    closed: 4,
  }

  state_machine :state, initial: :new do
    STATES.each { |s, v| state s, value: v }

    event :get_analyze do transition :new => :analyze; end
    event :get_work do transition [:new, :analyze] => :work; end
    event :get_realized do transition [:new, :work] => :realized; end
    event :get_closed do transition [:new, :realized] => :closed; end
   end

    has_and_belongs_to_many :users

  belongs_to :project
  belongs_to :creator, class_name: "User"
  belongs_to :executor, class_name: "User"

  acts_as_taggable_on :tags
  validates(:title, presence: true)

  
end
