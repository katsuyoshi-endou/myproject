■ファイル構成
 ### 定義ファイル ###
  build.xml
    変更必要なし。
    
 ### 設定ファイル ###
  build-sample.properties
    このファイルをコピーし、"build.properties"を作成する。
    j2ee.home, xdoclet.home, oracle.jdbc.jar の修正が必要。

 ### バッチプログラム ###
  config.bat
    その他バッチプログラムのための共通設定。
    各環境変数の修正が必要。
    
  gen_src.bat
    ソースコードの自動生成を行う。
    ビルドを行うためには１度は実行する必要がある。
    
  build.bat
    ビルドを行う本体。build.xmlに定義されたtargetを、
    実行時のパラメータに指定することができる。
    パラメータを指定しなければ、earファイルと各種jarファイル
    の作成を行う。
    
■バッチの使用方法
  1. 上記ファイルの設定を行う。
  2. gen_src.bat を実行する（初めて実行する場合 or 再び自動生成を行う場合）。
  3. build.bat を実行する。（%SRC_HOME%\lib が作成される）

（2009/05/13 小野田）
