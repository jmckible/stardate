require 'is_taggable'
ActiveRecord::Base.class_eval { include IsTaggable }