# MergeEnum
###### ver 0.7.0

複数のEnumerale(*1)を連結（合成）するEnumerableです。  
要素が必要になった時点で追加するように動作します。  
効率的です。

(*1) `each`,`first`メソッドが定義されていればEnumerableでなくてもよく、それを返すProc, Lambdaでもよい。

## Installation

Add this line to your application's Gemfile:

    gem 'merge_enum'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install merge_enum

## Usage

    > require 'merge_enum'

#### 基本的な使い方

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

#### `Enumerable#merge_enum` から生成

    > m_enum = (0...10).merge_enum(first: 13)
      => #<MergeEnum::MergeEnumerable:0x007fa...>

#### `concat`, `concat!` で連結

    > m_enum = (0...10).merge_enum(first: 13)
    > m_enum = m_enum.concat(10...15)
    > m_enum.to_a
      => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    > m_enum = (0...10).merge_enum(first: 13)
    > m_enum.concat!(10...15)
    > m_enum.to_a
      => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

#### `options`(alias: `merge_options`), `options!`(alias: `merge_options!`) でoptionsを追加

    > m_enum = MergeEnum::MergeEnumerable.new(0...100, { first: 10, select: -> (c) { c.odd? } })
    > m_enum = m_enum.merge_options({ first: 5 })
    > m_enum.to_a
      => [1, 3, 5, 7, 9]
    
    > m_enum = MergeEnum::MergeEnumerable.new(0...100, { first: 10, select: -> (c) { c.odd? } })
    > m_enum.merge_options!({ first: 5 })
    > m_enum.to_a
      => [1, 3, 5, 7, 9]

#### `replace_options`, `replace_options!` でoptionsを変更

    > m_enum = MergeEnum::MergeEnumerable.new(0...100, { first: 10, select: -> (c) { c.odd? } })
    > m_enum = m_enum.replace_options({ first: 5 })
    > m_enum.to_a
      => [0, 1, 2, 3, 4]
    
    > m_enum = MergeEnum::MergeEnumerable.new(0...100, { first: 10, select: -> (c) { c.odd? } })
    > m_enum.replace_options!({ first: 5 })
    > m_enum.to_a
      => [0, 1, 2, 3, 4]

### メソッド定義

* `MergeEnum::MergeEnumerable.new(enum_1, enum_2, ... , options = {})`  
    `enum_x`  : Enumerable(*1)、もしくは、Enumerable(*1)を返すProcオブジェクト  
    `options` : ハッシュ形式のオプション  
            　- `:first`   : `Integer`: 要素を取得する最大サイズ  
            　- `:compact` : `Proc|bool`: nilを判定して除去する  
            　- `:select`  : `Proc`: nil,falseを返す要素を除去する  
            　- `:map`     : `Proc`: 要素を変換する  
            　- `:cache`   : `bool`: 要素をキャッシュする  
            　- `:fill`    : `enum`: 最後のenum  

* `Enumerable#merge_enum(enum_2, enum_3, ... , options = {})`  
    レシーバ自身を`enum_1`として、`MergeEnumerable.new(enum_1, enum_2, enum_3, ... , options)`を返します

* `MergeEnumerable#concat(enum)`  
    末尾に`enum`を追加した`MergeEnumerable`を生成して返します

* `MergeEnumerable#concat!(enum)`  
    末尾に`enum`を追加し、`self`を返します

* `MergeEnumerable#options(opts)`  
    オプションに`opts`をマージした`MergeEnumerable`を生成して返します

* `MergeEnumerable#options!(opts)`  
    オプションに`opts`をマージし、`self`を返します

* `MergeEnumerable#merge_options(opts)`  
    `#options`のエイリアスです

* `MergeEnumerable#merge_options!(opts)`  
    `#options!`のエイリアスです

* `MergeEnumerable#replace_options(opts)`  
    オプションを`opts`に置き換えた`MergeEnumerable`を生成して返します

* `MergeEnumerable#replace_options!(opts)`  
    オプションを`opts`に置き換え、`self`を返します

## Contributing

1. Fork it ( http://github.com/<my-github-username>/merge_enum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
