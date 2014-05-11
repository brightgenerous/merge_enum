# encoding: utf-8
module Enumerable

  def merge_enum *args
    MergeEnum::MergeEnumerable.new self, *args
  end

end

