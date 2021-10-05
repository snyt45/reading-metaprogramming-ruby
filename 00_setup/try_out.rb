class TryOut
  # このクラスの仕様
  attr_accessor :first_name
  attr_reader :middle_name, :last_name
  # コンストラクタは、2つまたは3つの引数を受け付ける。引数はそれぞれ、ファーストネーム、ミドルネーム、ラストネームの順で、ミドルネームは省略が可能。
  def initialize(first_name, middle_name=nil, last_name)
    @first_name = first_name
    @middle_name = middle_name
    @last_name = last_name
  end

  # full_nameメソッドを持つ。これは、ファーストネーム、ミドルネーム、ラストネームを半角スペース1つで結合した文字列を返す。ただし、ミドルネームが省略されている場合に、ファーストネームとラストネームの間には1つのスペースしか置かない
  def full_name
    return "#{first_name} #{last_name}" if middle_name.nil?
    "#{first_name} #{middle_name} #{last_name}"
  end

  # first_name=メソッドを持つ。これは、引数の内容でファーストネームを書き換える。

  # upcase_full_nameメソッドを持つ。これは、full_nameメソッドの結果をすべて大文字で返す。このメソッドは副作用を持たない。
  def upcase_full_name
    full_name.upcase
  end

  # upcase_full_name! メソッドを持つ。これは、upcase_full_nameの副作用を持つバージョンで、ファーストネーム、ミドルネーム、ラストネームをすべて大文字に変え、オブジェクトはその状態を記憶する
  def upcase_full_name!
    first_name.upcase!
    middle_name&.upcase!
    last_name.upcase!
    full_name
  end
end
