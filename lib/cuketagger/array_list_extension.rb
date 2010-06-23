require 'java'

class Java::JavaUtil::ArrayList
  alias_method :delete, :remove
  alias_method :push, :add

  def index(obj)
    idx = indexOf(obj)
    return if idx == -1
    idx
  end
end

