module Rapidfire
  class Question < ActiveRecord::Base
    belongs_to :question_group, :inverse_of => :questions
    default_scope order(:position)

    validates :question_group, :question_text, :presence => true
    serialize :validation_rules

    def self.inherited(child)
      child.instance_eval do
        def model_name
          Question.model_name
        end
      end

      super
    end

    def rules
      validation_rules || {}
    end

    VALIDATION_OPTIONS = %w[
      presence  minimum_length  maximum_length
      greater_than_or_equal_to  less_than_or_equal_to
    ]

    def validate_answer(answer)
      if rules[:presence]
        answer.validates_presence_of :answer_text
      end

      if rules[:mininum].present? || rules[:maximum].present?
        answer.validates_length_of :answer_text, rules.slice(:mininum, :maximum)
      end
    end
  end
end
