# 次の仕様を満たす、SimpleModelモジュールを作成してください
#
# 1. include されたクラスがattr_accessorを使用すると、以下の追加動作を行う
#   1. 作成したアクセサのreaderメソッドは、通常通りの動作を行う
#   2. 作成したアクセサのwriterメソッドは、通常に加え以下の動作を行う
#     1. 何らかの方法で、writerメソッドを利用した値の書き込み履歴を記憶する
#     2. いずれかのwriterメソッド経由で更新をした履歴がある場合、 `true` を返すメソッド `changed?` を作成する
#     3. 個別のwriterメソッド経由で更新した履歴を取得できるメソッド、 `ATTR_changed?` を作成する
#       1. 例として、`attr_accessor :name, :desc`　とした時、このオブジェクトに対して `obj.name = 'hoge` という操作を行ったとする
#       2. `obj.name_changed?` は `true` を返すが、 `obj.desc_changed?` は `false` を返す
#       3. 参考として、この時 `obj.changed?` は `true` を返す
# 2. initializeメソッドはハッシュを受け取り、attr_accessorで作成したアトリビュートと同名のキーがあれば、自動でインスタンス変数に記録する
#   1. ただし、この動作をwriterメソッドの履歴に残してはいけない
# 3. 履歴がある場合、すべての操作履歴を放棄し、値も初期状態に戻す `restore!` メソッドを作成する

module SimpleModel
  def initialize(attr_hash)
    attr_hash.keys.each do |key|
      # attr_accessorで作成したアトリビュートと同名のキーがあるとき
      if methods.include?(key)
        # @{attr} に初期値をセット
        instance_variable_set("@#{key.to_s}", attr_hash[key])
        # @{attr}_changed_history に初期値をセット
        instance_variable_set("@#{key.to_s}_changed_history", [].push(attr_hash[key]))
      end
    end
  end

  def changed?
    # @{attr}_changed_history というインスタンス変数を列挙
    changed_histories = instance_variables.select { |v| v.to_s.end_with?("_changed_history") }
    # changed_historiesの各インスタンス変数の配列の操作履歴に一個でも2以上があれば変更されているとみなす
    changed = changed_histories.select { |v| instance_variable_get(v).count >= 2 }
    !changed.empty?
  end

  def restore!
    return unless changed? # 履歴がない場合は早期リターン
    changed_histories = instance_variables.select { |v| v.to_s.end_with?("_changed_history") }
    changed_histories.each do |changed_history|
      # @{attr}_changed_history に初期値をセット
      default_value = instance_variable_get(changed_history).first
      instance_variable_set(changed_history, [].push(default_value))
      # @{attr} に初期値をセット
      attr_name = changed_history.to_s.slice(/@[^_]*/)
      instance_variable_set(attr_name, default_value)
    end
  end

  # SimpleModelがincludeされたとき、ClassMethodsを特異メソッドとして追加
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor(*attrs)
      attrs.each do |attr|
        # setter
        define_method "#{attr}=" do |value|
          # @{attr} に値をセット
          instance_variable_set("@#{attr}", value)
          # @{attr}_changed_history の操作履歴の最後に値を追加
          attr_changed_history = instance_variable_get("@#{attr}_changed_history")
          instance_variable_set("@#{attr}_changed_history", attr_changed_history.push(value))
        end

        # getter
        define_method "#{attr}" do
          instance_variable_get("@#{attr}")
        end

        # #{attr}_changed?
        define_method "#{attr}_changed?" do
          # @{attr}_changed_historyの要素が2以上あれば変更されているとみなす
          instance_variable_get("@#{attr}_changed_history").count >= 2
        end
      end
    end
  end
end
