module TasksHelper
  include ActsAsTaggableOn::TagsHelper
public
def separate_by_state(tasks)
    out = {
      new: [],
      analyze: [],
      work: [],
      realized: [],
      closed: []
    }

    tasks.each do |t|
      out[t.state_name].push(t)
    end

    out
  end

end