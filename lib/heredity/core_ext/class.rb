class Class
  def inherited(klass)
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
