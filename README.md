# MergeEnum

複数のEnumeraleを連結（合成）するEnumerableです。  
要素が必要になった時点で追加するように動作します。  
効率的なはずです。

## Installation

Add this line to your application's Gemfile:

    gem 'merge_enum'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install merge_enum

## Usage

    > m_enum = MergeEnum::MergeEnumerable.new(
           [0,1,2,3,4,5,6,7,8,9],
           10...20,
           -> { 20...30 },
           -> (c) { 30...40 },       # c => 25
           Proc.new { 40...50 },
           Proc.new { |c| 50...60 }, # c => 5
           Proc.new { 60...70 },     # => never called
           first: 55
         )
    > m_enum.is_a? Enumerable
      => true
    > m_enum.count
      => 55

## Contributing

1. Fork it ( http://github.com/<my-github-username>/merge_enum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
