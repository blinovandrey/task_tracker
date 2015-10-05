	class TasksPresenter
  attr_reader :tasts

  def separate_by_state
    out = {
      new: [],
      analyze: [],
      work: [],
      realized: [],
      closed: []
    }

    @tasks.each do |t|
      out[t.state_name] << t
    end

    out
  end

  def method_missing(method, *args, &block)
    @tasks.send(method, *args, &block)
  end
end