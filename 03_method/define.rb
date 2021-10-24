# Q1.
# 次の動作をする A1 class を実装する
# - "//" を返す "//"メソッドが存在すること
class A1
  define_method "//" do
    "//"
  end
end

class A1
  def test
    p "test"
  end
end

# Q2.
# 次の動作をする A2 class を実装する
# - 1. "SmartHR Dev Team"と返すdev_teamメソッドが存在すること
# - 2. initializeに渡した配列に含まれる値に対して、"hoge_" をprefixを付与したメソッドが存在すること
# - 2で定義するメソッドは下記とする
#   - 受け取った引数の回数分、メソッド名を繰り返した文字列を返すこと
#   - 引数がnilの場合は、dev_teamメソッドを呼ぶこと
# - また、2で定義するメソッドは以下を満たすものとする
#   - メソッドが定義されるのは同時に生成されるオブジェクトのみで、別のA2インスタンスには（同じ値を含む配列を生成時に渡さない限り）定義されない


# 1)クラスメソッドで動的メソッド定義
#   この方法だとA2クラスのインスタンスメソッドとして定義される。
#   A2.new(["hoge"])とした後に、新しく別のA2.new(["fuga"])とインスタンスを生成すると最初のhoge_hogeメソッドが残る。
#   そのため、この方法では最後の要件がクリアできない

# class A2
#   def self.add_prefix_hoge_method(method_name)
#     define_method "hoge_#{method_name}" do |number|
#       return dev_team if number.nil?
#       "hoge_#{method_name}" * number
#     end
#   end

#   def initialize(array)
#     array.each do |arr|
#       A2.add_prefix_hoge_method(arr)
#     end
#   end

#   def dev_team
#     "SmartHR Dev Team"
#   end
# end

# 2)ゴーストメソッドを使う
#   辛み：実装中にtypeするとNoMethodErrorで無限ループして辛かった。デバッグが大変、自分ではまだ扱える方法ではなかった。。

class A2
  def initialize(array)
    @array = array.map(&:to_s) # test_answer_a2_numberのテストで数字が渡ってきた場合を考慮
  end

  def dev_team
    "SmartHR Dev Team"
  end

  def method_missing(name, *args)
    prefix_method_name = name.to_s
    number = args[0]
    # 先頭のprefixを除外したメソッド名を取得
    exclusion_prefix_method_name = prefix_method_name.gsub("hoge_", "")
    # インスタンス生成時に渡されたメソッド名以外の場合、superでNoMethodErrorとする
    super unless @array.include?(exclusion_prefix_method_name)
    return dev_team if number.nil?
    prefix_method_name * number
  end
end

# Q3.
# 次の動作をする OriginalAccessor モジュール を実装する
# - OriginalAccessorモジュールはincludeされたときのみ、my_attr_accessorメソッドを定義すること
# - my_attr_accessorはgetter/setterに加えて、boolean値を代入した際のみ真偽値判定を行うaccessorと同名の?メソッドができること

# 3章で出てきた方法ではない？？ => P135(5章)、P167(6章)に書いてあった。
# moduleのクラスメソッドをインクルードする方法分からず下記を参照した。
# https://takayukinakata.hatenablog.com/entry/2017/03/04/183546
module OriginalAccessor
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def my_attr_accessor attr_name
      # setter
      define_method "#{attr_name}=" do |value|
        # 真偽値が渡ってきた場合のみメソッド定義
        if value.is_a?(TrueClass) || value.is_a?(FalseClass)
          # 真偽値判定を行うメソッドが定義できたが、A3クラスのインスタンスメソッドとなり一度定義されると、
          # その後のインスタンス作成時にもすでにhoge?メソッドが存在してしまうため、テストが落ちてしまう…
          # 落ちるテスト：test_answer_a3_string、test_answer_a3_number、test_answer_a3_array
          self.class.add_boolean_check_method(attr_name)
        end

        instance_variable_set("@#{attr_name}", value)
      end

      # getter
      define_method attr_name do
        instance_variable_get "@#{attr_name}"
      end
    end

    def add_boolean_check_method(attr_name)
      define_method "#{attr_name}?" do
        boolean = instance_variable_get("@#{attr_name}")
        boolean
      end
    end
  end
end
