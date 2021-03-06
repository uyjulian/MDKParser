# Minaduki シナリオスクリプト文法

Minaduki の文法は、"["と"]"で囲まれたタグとMarkdownのような記法が使われています。  
なお本システムは開発中につき変更される可能性があります。   

# 要素
以下の要素が存在する。
* 通常文
* タグ
* キャラクター指定
* コメント行
* エスケープ
* ラベル行
* 選択肢行
* ルビ
* シナリオファイル移動
* 文字の装飾
* 改行待ち
* トランジション
* 画像埋め込み、絵文字
* 対象固定

## 通常文
他の要素に該当しない文字列はシナリオ文として解釈される。  
シナリオ文は、キャラクターのセリフや地の文を表す。  
通常分が1文字以上存在し、空行があるところまでを1ページとして扱う。  
タグが連続し、その間に空行が存在していてもページとしては扱われない。  

## タグ(コマンド)
\[と\]で囲まれたものをタグとして認識する。  
この場合\]で閉じなければ複数行にわたって記述しても問題ない。  
タグをどう解釈するかはシステムに依存する。

## キャラクター指定
行頭からの「@キャラ名」で指定する。  
キャラ名にスペースなどを含めたい場合は、"キャラ名"のように"か'で括る必要がある。  
名前欄にキャラ名と異なる名前を表示したい時は、@みなづき/？？？ のように/で区切って表示する文字列を指定する。  
\/の後に何も記述されていない時は、空文字列として扱い、名前欄に何も表示しない。  
この代替表示名はそのまま書くと記号はスペースなどを含めないので、好きな文字を入れたい場合は、"？ ？"等のように"で括れば、任意の文字列を指定できる。  
代替表示名の後に、スペースを開けてvoice="filename"として、そのキャラクターのボイスを指定可能。  

## コメント行
//で始まる行はコメントとみなす。  
コメントは無視される。  

## エスケープ
タグや行頭からの記号等を通常文で使用する場合は、\\を記号の前に書き、エスケープする。  

## ラベル行
行頭から#で始まる行はラベル行。  
最初にラベル名を書き|の後にシーン名を書く。  

## 選択肢行
行頭に数値+.を書き、その後に選択肢に表示する文字列、\|を書いた後に移動先シナリオファイル名を書く。  
テキストの代わりに専用画像を表示する場合は、文字列を省略し、\|を書いて画像ファイル名を書く。  
この場合は「1.\|image.png\|target.ms」のような記述となる。(※初期未実装)  
更に属性を書く場合は、移動先シナリオファイル名の後に\|を書いて属性を書く。  
移動先を指定しない場合は、そのまま以降の行が続行される。  
その場合は移動先シナリオファイル指定を空にする。  
例) 1.青い扉||name="bluedoor"  

行頭の数値が途切れた行が現れたら選択肢は終了する、その場合、その行に書かれていることが選択肢のオプション属性となる。  
選択肢全体のオプション指定ではタグの[]は必要ない。  
[]を記述しなくても強制的に属性として認識される。  
設定する属性がない場合はただの空行にする。  
属性と空行以外のタグなど意味のある文を書くことは出来ない。  

## ルビ
ルビを振る文字の始点に\|を記述し、終点に《》を入力、ルビを《》内に記述する。  
例 : このシステムは\|吉里吉里《きりきり》Z上で動きます。  
もし、\|だけがあり、それ以降に《》か{}が現れない場合は、文法違反。  
《》も同様に、前方に\|がない場合、文法違反。  
\|や《》を表示したい場合は、半角¥マークを前方に記述してエスケープする必要がある。  
> 《》の入力はやや手間なので、半角のエイリアスを追加する可能性がある。

### ルビ辞書ファイル
最初の1回だけでなく、特定の文字列に毎回同じルビを振りたいような場合、ルビ辞書ファイルを使用できる。  
ルビ辞書からルビを振りたい場合、\|と》で囲んでおく必要がある。  
例 : \|吉里吉里》

## シナリオファイル移動
行頭から>+ファイル名で指定ファイルに移動する。  
基本的にシナリオファイルの末尾に用いる。  
フラグ等による分岐は後置ifのような記法を使用する。   
例 : > next.ms if flag == true  

## 文字の装飾
ルビに近い文法で、|から{}で囲った間の文字を装飾する。  
一文にルビと装飾がある場合はネストして適用される。  
エスケープルールもルビと同様。  
例えば太字にしたい時は、  
例: このシステムは|吉里吉里Z{b}で動きます。  
のように記述する。  
複数指定したい場合は、半角スペースで区切って指定する{b i}等。  
0xで始まる数値は色指定であるとみなす。  

## 改行待ち
文の途中、もしくは末尾で>が現れた場合、改行待ちとする。  

## トランジション
行頭から>>>と記述するとその行以降は即座には画面に反映されず、トランジション先とみなされる。  
その後行頭から<<<と記述して、その後にトランジション属性を記述することで任意のトランジションを行うことができる。  
<<< 直後はトランジション名を記述し、それ以降はタグ属性のルールに従う。  
例 : <<< normal <1000> // [endtrans tarns="narmal" time=1000] と等価  
例 : <<< universal "rule.png" <1000> // [endtrans trans="universal" storage="rule.png" time=1000] と等価  

## 画像埋め込み、絵文字
\:と\:で絵文字名を入れると絵文字を入力できる(初期未対応)。  
例、\:emoji\:  
\:(画像ファイル名)と入力すると画像を埋め込める。  
例、\:(face.png)  
絵文字については、絵文字表示できるエディタでそのままま入力してUTF-8で保存しても問題ない(初期未実装)。  

## 対象固定
行頭から<=を書き、その後に文字列を記述すると、それ以降のタグの最初にこの文字列が指定されているものとして扱う。  
キャラクター等を連続的に動かす場合を想定したものであるが、それらに限定されず、タグ名でも同じように機能する。  
\=>の後に何も書かず改行することで指定解除する。  
\=>を書かずに、連続して\<=を記述した場合、ネストではなく、入れ替えが行われ、移行新たに記述された対象が指定されているものとして扱う。  
シナリオファイルをまたがった場合は指定は解除され、継続されることはない。  
例:  
\<=みなづき  
\[標準\]  
\[左向き\]  
\[通常\]  
\=>  
