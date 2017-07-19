# http://dev.mensfeld.pl/2013/10/state-machine-gem-undefined-method-underscore-for-activemodelname/
# It seems that there is no underscore method on ActiveModel name
# It is added here, so it will be accessible and state machine
# can work. It should be removed after this is fixed
class ActiveModel::Name
  def underscore
    to_s.underscore
  end
end

# to suppress warning message about the 'MerchantAccount#fail'
StateMachine::Machine.ignore_method_conflicts = true