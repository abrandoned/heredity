class Class
  def inherited(klass)
    # Check the class instance variable so we don't eagerly initialize empty
    # arrays for every class (i.e. object).
    return if @inherited_hooks.nil?

    inherited_hooks.each do |block|
      klass.class_eval(&block)
    end
  end

  def inherited_hooks
    @inherited_hooks ||= []
  end

  def on_inherit(&block)
    inherited_hooks << block
  end
end
