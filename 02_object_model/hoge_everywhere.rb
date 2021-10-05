# 次に挙げるクラスのいかなるインスタンスからも、hogeメソッドが呼び出せる
# それらのhogeメソッドは、全て"hoge"という文字列を返す
# - String
# - Integer
# - Numeric
# - Class
# - Hash
# - TrueClass

# irb(main):001:0> String.ancestors
# => [String, Comparable, Object, Kernel, BasicObject]
# irb(main):002:0> Integer.ancestors
# => [Integer, Numeric, Comparable, Object, Kernel, BasicObject]
# irb(main):003:0> Numeric.ancestors
# => [Numeric, Comparable, Object, Kernel, BasicObject]
# irb(main):004:0> Class.ancestors
# => [Class, Module, Object, Kernel, BasicObject]
# irb(main):005:0> Hash.ancestors
# => [Hash, Enumerable, Object, Kernel, BasicObject]
# irb(main):006:0> TrueClass.ancestors
# => [TrueClass, Object, Kernel, BasicObject]

# module KernelRefinements
#   refine Kernel do
#     def hoge
#       "hoge"
#     end
#   end
# end

# using KernelRefinements

class String
  def hoge
    "hoge"
  end
end

class Integer
  def hoge
    "hoge"
  end
end

class Numeric
  def hoge
    "hoge"
  end
end

class Class
  def hoge
    "hoge"
  end
end

class Hash
  def hoge
    "hoge"
  end
end

class TrueClass
  def hoge
    "hoge"
  end
end
