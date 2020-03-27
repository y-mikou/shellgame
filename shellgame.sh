#!/bin/bash
: '■内部処理系' && {
	: '初期処理' && {
		###########################################
		## 初期処理
		##  主に定数定義など
		###########################################
		initDef(){
			: '画面レイアウト系コンスタント値定義' && {
				##座標							   XX YY
				declare -r -g     CNST_POS_CMDWIN='20 10' #コマンド入力ウィンドウ
				declare -r -g    CNST_POS_CMDWIN2='20 11' #コマンド入力ウィンドウ
				declare -r -g CNST_POS_MAPTIPFOOT='20 47' #現在マップチップ表示窓
				declare -r -g       CNST_POS_WKMK='26 97' #キー待ち記号表示位置
				declare -r -g      CNST_CSR_DIR_1='69 9'  #メニュー2用方向指示カーソル位置_↙
				declare -r -g      CNST_CSR_DIR_2='75 9'  #メニュー2用方向指示カーソル位置_↓
				declare -r -g      CNST_CSR_DIR_3='81 9'  #メニュー2用方向指示カーソル位置_➘
				declare -r -g      CNST_CSR_DIR_4='69 7'  #メニュー2用方向指示カーソル位置_←
				declare -r -g      CNST_CSR_DIR_5='75 7'  #メニュー2用方向指示カーソル位置_・
				declare -r -g      CNST_CSR_DIR_6='81 7'  #メニュー2用方向指示カーソル位置_→
				declare -r -g      CNST_CSR_DIR_7='69 5'  #メニュー2用方向指示カーソル位置_↖
				declare -r -g      CNST_CSR_DIR_8='75 5'  #メニュー2用方向指示カーソル位置_↑
				declare -r -g      CNST_CSR_DIR_9='81 5'  #メニュー2用方向指示カーソル位置_➚
				declare -r -g      CNST_CSR_DIR_0='69 11' #メニュー2用方向指示カーソル位置_Cancel

				declare -r -g    CNST_POS_STS_STR='11 2 3' #腕力ステータス表示位置
				declare -r -g    CNST_POS_STS_INT='12 2 3' #知能ステータス表示位置
				declare -r -g    CNST_POS_STS_VIT='13 2 3' #体力ステータス表示位置
				declare -r -g    CNST_POS_STS_MID='14 2 3' #精神ステータス表示位置
				declare -r -g    CNST_POS_STS_SNS='15 2 3' #知覚ステータス表示位置
				declare -r -g    CNST_POS_STS_DEX='16 2 3' #器用ステータス表示位置
				declare -r -g    CNST_POS_STS_AGI='17 2 3' #敏捷ステータス表示位置
				declare -r -g    CNST_POS_STS_LUK='18 2 3' #幸運ステータス表示位置

				##マップサイズ[MAP_SIZ]
				declare -r -g CNST_MAP_SIZ_X=60 #横
				declare -r -g CNST_MAP_SIZ_Y=15 #縦

				##メッセージウィンドウサイズ[MSG_SIZ]
				declare -r -g CNST_MSG_SIZ_X=99 #横
				declare -r -g CNST_MSG_SIZ_Y=5 #縦

				##全体サイズ[ALL_SIZ]
				declare -r -g CNST_ALL_SIZ_X=100 #横
				declare -r -g CNST_ALL_SIZ_Y=28 #縦

				##コマンドログ小窓の開始位置[CMDLGW_IDX]
				declare -r -g CNST_CMDLGW_IDX=50 #横

				##コマンド受付モード
				declare -r -g CNST_CMDMODE_NRML0='0' #通常
				declare -r -g CNST_CMDMODE_MENU1='1' #メニュー内の選択
				#declare -r -g CNST_CMDMODE_MENU2='2' #メニュー内の方向選択など

				##メニュー内カーソル移動方向
				declare -r -g CNST_CSR_MVTO_UP='8'
				declare -r -g CNST_CSR_MVTO_DN='2'
			}
			: 'マップチップ系コンスタント値' && {
				#00:表示         英記号1桁(マップ上表記)
				#01:大分類       英字3桁(意味を持った略称)
				#02:小分類       数字2桁(実質的なID)
				#03:細分類       数字1桁(状態変化を持つ場合の状態)
				#04:進入可否     0:不可 1:可能  8:条件            /CNST_YN
				#05:進入後残留   0:消滅 1:残留  8:条件            /CNST_YN                      
				#06:開示方式     0:足元 1:眼前  8:条件 9:連鎖開示 /CNST_AMNT
				#07:破壊可否     0:不能 1:可能  8:条件            /CNST_YN
				#08:イベント     0:進入 1:接触  8:条件 9:接触戦闘 /CNST_EVT
				#09:和名         メッセージ表示が必要な場合の呼称

												#0   1     2    3   4   5   6   7   8   9   
												#DSP CNM   CID  STS ENT STY OPN DST EVE NME
				declare -r -g -a  CNST_MAPTIP_0=('-' 'WAL' '00' '0' '0' '1' '1' '0' '1' '壁')
				declare -r -g -a  CNST_MAPTIP_1=('+' 'WAL' '01' '0' '0' '1' '1' '0' '1' '壁')
				declare -r -g -a  CNST_MAPTIP_2=('=' 'WAL' '02' '0' '0' '1' '1' '0' '1' '壁')
				declare -r -g -a  CNST_MAPTIP_3=('|' 'WAL' '03' '0' '0' '1' '1' '0' '1' '壁')
				declare -r -g -a  CNST_MAPTIP_4=('X' 'WAL' '04' '0' '0' '1' '1' '0' '1' '壁') #壁に囲まれた土の中
				declare -r -g -a  CNST_MAPTIP_5=('F' 'FLR' '00' '0' '1' '0' '9' '0' '0' 'ただの床') #' 'は意図通りに動かないため’F’に読み替える
				declare -r -g -a  CNST_MAPTIP_6=('.' 'FLR' '01' '0' '1' '0' '0' '0' '0' 'ただの床') #部屋同士の道に使う、かも
				declare -r -g -a  CNST_MAPTIP_7=('#' 'JNT' '02' '0' '1' '1' '1' '0' '0' '隣の部屋への道') #マップ接続用の表示
				declare -r -g -a  CNST_MAPTIP_8=('D' 'DOR' '00' '0' '0' '1' '1' '1' '1' '扉')
				declare -r -g -a  CNST_MAPTIP_9=('[' 'DOR' '00' '1' '1' '1' '1' '1' '1' '開いてる扉')
				declare -r -g -a CNST_MAPTIP_10=('v' 'STD' '00' '0' '1' '1' '1' '1' '1' '下り階段')
				declare -r -g -a CNST_MAPTIP_11=('^' 'STU' '00' '0' '1' '1' '1' '1' '1' '上り階段')
				declare -r -g -a CNST_MAPTIP_12=('o' 'ITM' '00' '0' '1' '1' '0' '1' '1' '未抽選消耗品')
				declare -r -g -a CNST_MAPTIP_13=('O' 'ITM' '00' '1' '1' '1' '0' '1' '1' '抽選済消耗品')
				declare -r -g -a CNST_MAPTIP_14=('a' 'ITM' '10' '0' '1' '1' '0' '1' '1' '未抽選腕装備')
				declare -r -g -a CNST_MAPTIP_15=('A' 'ITM' '10' '1' '1' '1' '0' '1' '1' '抽選済腕装備')
				declare -r -g -a CNST_MAPTIP_99=('e' 'ERR' 'ee' 'e' 'e' 'e' 'e' 'e' 'e' 'エラー')
				#declare -r -g -a  CNST_MAPTP_XX=('#' 'UNX' '00' '0' '0' '0' '0' '0' '0' 'Unexplored')
			}
			: '属性値設定' && {
				declare -r -g DSP=0
				declare -r -g CNM=1
				declare -r -g CID=2
				declare -r -g STS=3
				declare -r -g ENT=4
				declare -r -g STY=5
				declare -r -g OPN=6
				declare -r -g DST=7
				declare -r -g EVE=8
				declare -r -g NME=9
			}
			: '拾得物抽選テーブル' && {
				#形式 TBL_LOTITM_XXX_88[9]
				#                種 _Lv[slot]
				#XXX:種類
				#CSM:薬系
				#ARM:腕
				#SUT:シャツ
				#BTM:ズボン
				#MNT:マント
				#ANT:触覚
				#ACS:アクセサリ
				#MAG:符
				#OTH:他
				
				##薬系
				#抽選テーブルは暫定。
				##Lv00_0-2の3種類
				declare -g -a TBL_LOTITM_CSM_00=(
				  '  1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100'
				  '  3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100 100 100'
				  '  5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100 100 100 100 100'
				)

				##腕
				##Lv00_0-2の3種類
				declare -g -a TBL_LOTITM_ARM_00=(
				  '  1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100'
				  '  3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100 100 100'
				  '  5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100 100 100 100 100'
				)
			}
			: 'アイテムテーブル' && {
				#暫定
				##アイテムテーブルはn個の半角スペースで区切られた要素で構成される。
				##各要素に半角スペースを含めることはできない(区切れてしまうので)。
				##あくまでも暫定なのでもうちょっとちゃんとした形に変わるかも。
				###アイテムIDは0000～FFFFとする。
				
				#薬系
				declare -g -a TBL_ITM_INFO=()
							#  0    1   2    3                    4                    5
							#  ID   CAT CRR  修飾_全角10文字      名称_全角10文字      説明_全角22文字
			   #TBL_ITM_INFO+=('FFFF CSM +00 １２３４５６７８９０ １２３４５６７８９０ １２３４５６７８９０１２３４５６７８９０１２')
			    TBL_ITM_INFO+=('0000 CSM 000 nomod                八卦炉               激しくマーライオンする'                      )
				TBL_ITM_INFO+=('0001 CSM 000 永遠亭謹製の         おくすり             あなたはもう死ねなくなる'                    )
				TBL_ITM_INFO+=('0002 CSM +02 nomod                毒弁当               瀟洒！'                                      )
				TBL_ITM_INFO+=('0003 CSM +01 魔法の森でとれた     キノコ               エッチな形をしている＋１'                    )
				TBL_ITM_INFO+=('0004 CSM +02 魔法の森でとれた     キノコ               エッチな形をしている＋２'                    )
				TBL_ITM_INFO+=('0005 CSM +03 魔法の森でとれた     キノコ               エッチな形をしている＋３'                    )
				TBL_ITM_INFO+=('0006 CSM +04 魔法の森でとれた     キノコ               エッチな形をしている＋４'                    )
				TBL_ITM_INFO+=('0007 CSM -10 アロマ臭のする       陰陽玉               いいにおいがする。霊夢愛用。'                )
				TBL_ITM_INFO+=('0008 CSM 000 七色に光る           壊れた人形           血がついている'                              )
				TBL_ITM_INFO+=('0009 CSM 000 nomod                宝塔                 おでん'                                      )


				#エラーアイテム
			 TBL_ITM_INFO_ERR=('ZZZZ ERR +99 該当アイテムなし     該当アイテムなし     該当ＩＤのアイテムは登録されていません')


			}
			: '汎用コード値' && {
				#可否
				declare -r -g CNST_YN_Y='1' #肯定/可能
				declare -r -g CNST_YN_N='0' #否定/不可能
				declare -r -g CNST_YN_C='8' #/条件次第

				#固定的な数値
				declare -r -g CNST_AMNT_MIN='0' #無もしくは十分に小さい値
				declare -r -g CNST_AMNT_STP1='1' #数量1
				#declare -r -g CNST_AMNT_STEP2='2' #数量2
				declare -r -g CNST_AMNT_CND='8' #他の条件
				declare -r -g CNST_AMNT_MAX='9' #十分に大きい値

				#イベント判定
				declare -r -g CNST_EVT_ENTR='0' #上に乗ったとき
				declare -r -g CNST_EVT_TUCH='1' #隣接したとき
				declare -r -g CNST_EVT_COND='8' #他の条件
				declare -r -g CNST_EVT_BTTL='9' #隣接時戦闘
			}
			: 'その他コンスタント値定義' && { 
				##sayRnd関数の種別
				declare -r -g  CNST_RND_WALL='1' #壁激突音
				declare -r -g  CNST_RND_DOOR='2' #扉じゃないところを扉
				declare -r -g CNST_RND_WEMEN='3' #女性接触声
				declare -r -g  CNST_RND_DASH='4' #ダッシュ音				
			}
			: 'GLOBAL変数定義' && {
				##キー入力受付用
				declare -g  inKey=''
				declare -g inKey2=''
				
				##右上の領域は初期状態ではステータス表示
				declare -g cmdMode=$CNST_CMDMODE_NRML0

				##メニュー表示時の現在座標退避
				declare -g posEsc=''

				##メニューID
				declare -g selMenuId=''

				##足元マップチップ
				#declare -g maptipFoot=''

				#CONSTANT値
				##IFS
				###IFS=$' \t\n'
				declare -r -g CNST_IFS_DEFAULT="$IFS"

				## 所持アイテム格納配列
				### アイテムID で保持
				declare -a -g psnItemList


			}
		}
		}
	: '終了処理' && { 
		##################################################
		##quitGame
		## 終了処理
		##################################################
		function quitGame(){
			#終了時に文字修飾を除去し、画面をクリアする
			tput cvvis
			tput sgr0
			IFS=$CNST_IFS_DEFAULT
			clear
			echo 'exit'
			exit
		}
		}
	: '半角相当何文字か判定' && { 
		##################################################
		##getCntSingleWidth
		## 与えられた文字列が、半角文字相当で何文字分に当たるか判定する。
		## マルチバイト文字を2、それ以外を1としたいがよくわからないので、可能そうな記号のみ
		##  $1:カウント対象の文字
		##################################################
		function getCntSingleWidth(){

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] ; then
				sysOut 'e' $LINENO '引数は1つ設定してください。'
				return
			fi

			declare cntStr="$1"

			#半角英数記号以外の文字以外を消す=半角文字数
			declare cntS=$(echo -n "$cntStr" | sed -e 's@[^A-Za-z0-9~!@#$%&_=:;><,*+.?{}()\ -|¥]@@g' | wc -m)

			#半角英数記号の文字を消す=全角文字数
			declare cntW=$(echo -n "$cntStr" | sed -e 's@[A-Za-z0-9~!@#$%&_=:;><,*+.?{}()\ -|¥]@@g' | wc -m)

			#全角文字数を示すcntWは二倍して、2つを足す
			echo -n "$(((cntW * 2)+cntS))"
		}
		}
	: '半角カナ置換' && {
		##################################################
		##repMonoKana
		## 半角カタカナを全角カタカナに置換する
		##  返却は標準出力
		##   $1:入力文字
		##################################################
		function repMonoKana(){

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] ; then
				sysOut 'e' $LINENO '引数は1設定してください。'
				return
			fi

			declare cnvstr=$1

			declare tgtDakuten=('ｶﾞ' 'ｷﾞ' 'ｸﾞ' 'ｹﾞ' 'ｺﾞ' 'ｻﾞ' 'ｼﾞ' 'ｽﾞ' 'ｾﾞ' 'ｿﾞ' 'ﾀﾞ' 'ﾁﾞ' 'ﾂﾞ' 'ﾃﾞ' 'ﾄﾞ' 'ﾊﾞ' 'ﾋﾞ' 'ﾌﾞ' 'ﾍﾞ' 'ﾎﾞ' 'ｳﾞ' 'ﾊﾟ' 'ﾋﾟ' 'ﾌﾟ' 'ﾍﾟ' 'ﾎﾟ')
			declare dstDakuten=('ガ' 'ギ' 'グ' 'ゲ' 'ゴ' 'ザ' 'ジ' 'ズ' 'ゼ' 'ゾ' 'ダ' 'ヂ' 'ヅ' 'デ' 'ド' 'バ' 'ビ' 'ブ' 'ベ' 'ボ' 'パ' 'ピ' 'プ' 'ペ' 'ポ')

			declare tgtAll=('ｱ' 'ｲ' 'ｳ' 'ｴ' 'ｵ' 'ｶ' 'ｷ' 'ｸ' 'ｹ' 'ｺ' 'ｻ' 'ｼ' 'ｽ' 'ｾ' 'ｿ' 'ﾀ' 'ﾁ' 'ﾂ' 'ﾃ' 'ﾄ' 'ﾅ' 'ﾆ' 'ﾇ' 'ﾈ' 'ﾉ' 'ﾊ' 'ﾋ' 'ﾌ' 'ﾍ' 'ﾎ' 'ﾏ' 'ﾐ' 'ﾑ' 'ﾒ' 'ﾓ' 'ﾔ' 'ﾕ' 'ﾖ' 'ﾗ' 'ﾘ' 'ﾙ' 'ﾚ' 'ﾛ' 'ﾜ' 'ｦ' 'ﾝ' 'ｧ' 'ｨ' 'ｩ' 'ｪ' 'ｫ' 'ｯ' 'ｬ' 'ｭ' 'ｮ')
			declare dstAll=('ア' 'イ' 'ウ' 'エ' 'オ' 'カ' 'キ' 'ク' 'ケ' 'コ' 'サ' 'シ' 'ス' 'セ' 'ソ' 'タ' 'チ' 'ツ' 'テ' 'ト' 'ナ' 'ニ' 'ヌ' 'ネ' 'ノ' 'ハ' 'ヒ' 'フ' 'ヘ' 'ホ' 'マ' 'ミ' 'ム' 'メ' 'モ' 'ヤ' 'ユ' 'ヨ' 'ラ' 'リ' 'ル' 'レ' 'ロ' 'ワ' 'ヲ' 'ン' 'ァ' 'ィ' 'ゥ' 'ェ' 'ォ' 'ッ' 'ャ' 'ュ' 'ョ')

			#2文字結合の必要があるので、先に濁点半濁点を殺す
			for i in ${!tgtDakuten[@]}
			do
				cnvstr=${cnvstr//"${tgtDakuten[i]}"/"${dstDakuten[i]}"}
			done
			#半角カタカナ平音を殺す
			for i in ${!tgtAll[@]}
			do
				cnvstr=${cnvstr//"${tgtAll[i]}"/"${dstAll[i]}"}
			done
			echo "$cnvstr"
		}
	}
	: '不正文字個別置換' && {
		##################################################
		##crrctStr
		## 使用頻度が高い障害文字を置換するためのもの。
		## 【できれば必須呼び出しにしたいがどうするか】
		## ・半角カタカナは全角カタカナにする(別関数)。
		## ・「…(三点リーダ)」の表示が詰まってしまうことがあるため、「...」(ピリオド3つ)にする
		## ・「[」「]」はbashでブラケットとして判断されるためそれぞれ「［」「］」へ置換する。
		## ・「¥」は動きが怪しいので「￥」へ置換する。
		## ・全角スペースは半角スペース2つへ置換する。
		## ・タブは半角スペース2つへ置換する。
		## ・ハイフンに似たいくつかの半角文字を半角ハイフンに置換する。
		##  返却は標準出力
		##   $1:入力文字
		##################################################
		function crrctStr(){

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] ; then
				sysOut 'e' $LINENO '引数は1つ設定してください。'
				return
			fi
		
			declare cnvstr="$1"

			cnvstr=${cnvstr//'¥'/'￥'}      #¥
			cnvstr=$(repMonoKana $cnvstr)   #半角カナ
			cnvstr=${cnvstr//'['/'［'}		#[
			cnvstr=${cnvstr//']'/'］'}		#]
			cnvstr=${cnvstr//'…'/'...'}		#三点リーダ
			cnvstr=${cnvstr//'　'/'  '}		#全角sp
			cnvstr=${cnvstr//'	'/'  '}		#タブ文字
			cnvstr=${cnvstr//'-'/'-'}		#ハイフンに似た文字
			cnvstr=${cnvstr//'‑'/'-'}		#ハイフンに似た文字
			cnvstr=${cnvstr//'–'/'-'}		#ハイフンに似た文字
			cnvstr=${cnvstr//'—'/'-'}		#ハイフンに似た文字
			cnvstr=${cnvstr//'—'/'-'}		#ハイフンに似た文字
			cnvstr=${cnvstr//'ｰ'/'-'}		#ハイフンに似た文字

			echo "$cnvstr"
		}
		}
	: '任意長入力受付' && {
		###########################################
		##getChrV
		## 任意の文字数入力受付(エコーバックあり)。
		## mainで定義しているグローバルinKeyをクリアしてから、入力値で上書き
		###########################################
		function getChrV(){
			inKey=''
			read inKey
		}
		}
	: '1文字入力受付' && {
		###########################################=
		##getChrH
		## なんか1文字の入力受付(エコーバックなし)。
		## mainで定義しているグローバルinKeyをクリアしてから、入力値で上書き
		###########################################
		function getChrH(){
			inKey=''
			read -s -n 1 inKey
		}
		}
	: 'ステータス値取得' && {
		###########################################=
		##getStsVal
		## 引数で受け取ったステータス値をlnStsInfoから取得し、
		## 標準出力で返却する。
		##  $1:ステータス名(STR,VITなど)
		###########################################
		function getStsVal(){

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] ; then
				sysOut 'e' $LINENO '引数は1つ設定してください。'
				return
			fi

			eval 'args=($(echo $CNST_POS_STS_'$1'|xargs))'
			eval 'echo ${lnStatusInfo['${args[0]}']:'${args[1]}':'${args[2]}'}'
		}
		}
	: 'コマンド入力受付' && {
		###########################################
		##getCmd
		## コマンドを受け取る
		##  ただの getChrVのラッピング
		###########################################
		function getCmd(){
			tput cup $CNST_POS_CMDWIN
			getChrV
		}
		}
	: 'キー待ち' && {
		##################################################
		##wk
		## キー待ち
		##  キー待ち記号を天っ滅表示し、SPACEかENTERを待つ
		##################################################
		function wk() {

			tput civis
			tput cup $CNST_POS_WKMK
			tput blink
			
			echo -n '🐛'

			while :
			do
				getChrH
				if [ "$inKey" = '' ] || [ "$inKey" = ' ' ]; then
					break
				fi
			done

			tput sgr0
			tput cvvis

			}
		}
	: 'マップチップ判定' && {
		###########################################
		##getMapInfo
		## 指示マスのマップチップ情報取得
		## 対象のマスと判別種類ごとに応じた値を返却する
		##  $1:X座標
		##  $2:Y座標
		##  $3:取得情報
		##   ※詳細はマップチップ系コンスタント値の設定箇所を参照
		###########################################
		function getMapInfo(){

			#バリデーション
			##引数の個数
			if [ $# -ne 3 ] ; then
				sysOut 'e' $LINENO '引数は3つ設定してください。'
				return
			fi

			declare tgtchip=''
			declare rslt=''

			declare objDrction="${lnMapInfo[$((10#$2))]:$((10#$1)):1}"
			declare idx=99

			#対象マップチップとして’ ’が渡された場合、想定通りの動きをしないため
			#' 'の代わりに’F’とみなす。
			if [ "$objDrction" = ' ' ] ; then
				objDrction='F'
			fi

			for ((i = 0; i < 99; i++)) {
				if [ "$(eval 'echo ${CNST_MAPTIP_'$i'[0]}')" = "$objDrction" ] ; then
					idx=i
					break
				fi
			}

			rslt=$(eval 'echo ${CNST_MAPTIP_'$((idx))'[$(($3))]}')

			#表示内容を返すことはないと思うが、結果が’F’だった場合は、’ ’へ戻す。
			if [ "$rslt" = 'F' ] ; then
				echo ' '
			else
			
				echo "$rslt"
			fi

			}
		}
	: 'アイテム抽選' && {
		###########################################
		##lotItem
		## アイテム最初に拾ったとき抽選する
		## $1:アイテム種別(CSM,ARM,...)
		## $2:アイテムレベル(キャラレベルで上下する？)
		## $3:テーブルバリエーション(信仰心的なもので上下する？)
		##  標準出力にてアイテム名を返却する。
		##  また、該当アイテムの座標を保持する。
		###########################################
		function lotItem(){

			#バリデーション
			##引数の個数
			if [ $# -ne 3 ] ; then
				sysOut 'e' $LINENO '引数は3つ設定してください。'
				return
			fi
			##引数の種類
			if [[ ! $1 =~ (CSM|ARM|SUT|BTM|MNT|ANT|ACS|MAG|OTH) ]] ; then
				sysOut 'e' $LINENO 'アイテム種別が不正です'
				return
			fi
			##引数の範囲
			if [ $2 -lt 0 ] || [ $2 -gt 99 ] ; then
				sysOut 'e' $LINENO '第2引数の範囲が誤っています。$2'
				return
			fi


			declare itemCat="$1"
			declare itemLev="$2"
			declare lotSlot="$3"

			declare stsLuk=$(getStsVal 'LUK')
			declare stsSns=$(getStsVal 'SNS')

			declare loPrm=0
			declare hiPrm=0
			declare dfPrm=0

			declare tgtElm=0
			declare tgtSlot=''
			declare lotArry=()
			declare lotArry2=()
			declare itemName=''
			
			#受け取った引数と
			#現在のDexとLukの低い方と-10と合計の間で
			#抽選用集合と乱数を作成
			##数値的準備
			if [ $stsSns -ge $stsLuk ] ; then
				loPrm=$((stsLuk-10))
				hiPrm=$stsSns-1
			else
				loPrm=$((stsSns-10))
				hiPrm=$stsLuk-1
			fi
			
			#loは最低0且つhiPrm-20未満はhiPrm-20扱い
			#hiは99超えたら99扱い
			if [ $((loPrm)) -le 0 ] ; then
				loPrm=0
			fi
			hiPrm=$((stsLuk+stsSns))
			if [ $((hiPrm)) -gt 99 ] ; then
				hiPrm=99
			fi
			if [ $(($loPrm)) -lt $((hiPrm-20)) ] ; then
				loPrm=$((hiPrm-20))
			fi

			##抽選用list作成
			##対象抽選スロットのloPrmからhiPrmの範囲を抜き出して、抽選用Listとする
			eval 'tgtSlot=${TBL_LOTITM_'$itemCat'_'$itemLev'['$lotSlot']}'
			lotArry=( $(echo $tgtSlot | xargs) )
			for i in $( seq $loPrm $hiPrm ) ;
			do 
				lotArry2+=(${lotArry[i]})
			done
			
			#抽選用listから等確率でひとつ抽出し、返却する
			##抽出用listの長さで乱数を発生して、要素を指定・取得
			tgtElm=$(($RANDOM % $(($hiPrm-$loPrm))))
			##アイテム抽選結果をもとにアイテム情報取得。IDを返却。
			itemID=${lotArry2[$tgtElm]}
			echo "$itemID"


		}
		}
	: 'アイテム表示取得' && {
		###########################################
		##getItemDisp
		## アイテムの表示を編集して標準出力で返却する。
		##  $1:表示区分(0:名称/1:説明)
		##  $2:アイテムID
		###########################################
		function getItemDisp(){

			##引数の個数
			if [ $# -ne 2 ] ; then
				sysOut 'e' $LINENO '引数は2つ指定してください。'
				return
			fi

			declare   mode=$1
			declare itemId=$2
			declare retStr=''

			declare args=()

			args=($(echo "$(getItemInfo $itemID)"|xargs))

			case $mode in
				'0')
					if [ "${args[1]}" = 'ERR' ] ; then
						retStr="エラーアイテム:ID:${args[0]}"
					else
						#補正値が000の時、名称に含めない
						if [ "${args[2]}" = '000' ] ; then
							retStr='   '
						else
							retStr="${args[2]}"
						fi
						#補正値が000の時、名称に含めない
						if [ "${args[3]}" != 'nomod' ] ; then
							retStr="$retStr${args[3]}"
						fi
						retStr="$retStr${args[4]}"
					fi
					;;
				'1')
					retStr="$retStr${args[5]}"
					;;
			esac

			echo "$retStr"
		}		
	}

	: 'アイテム情報取得' && {
		###########################################
		##getItemInfo
		## アイテムIDをもとにアイテムテーブルの行内容を取得し、
		## 標準出力で返却する。受け取り側で、xargsなど使用してパースすること。
		## 該当IDのアイテムが登録されていなければ、エラーアイテムが返却される。
		##  $1:アイテムID
		###########################################
		function getItemInfo(){
			declare itemID="$(printf "%04d" $1)"
			declare cntTblItem=0
			declare tmpArr
			declare retItemInfo
			declare args

			##引数の個数
			if [ $# -ne 1 ] ; then
				sysOut 'e' $LINENO '引数は1つ指定してください。'
				return
			fi

			#アイテムテーブルは全部で何件あるか確認
			cntTblItem=${#TBL_ITM_INFO[@]}

			#アイテムIDとアイテムテーブルのインデクスが一致するとは限らないため
			#アイテムテーブルをなめる(性能確認はしていない)。
			for ((i=0; i<$cntTblItem; i++)) {
				retItemInfo="${TBL_ITM_INFO[i]}"

				#アイテムテーブルの行を半角スペースでパースして1要素目(アイテムID)を取得する
				args=($(echo "${retItemInfo}"|xargs))

				#引数のアイテムIDとアイテムテーブル内のIDが一致したら
				#必要な修正を施して返却
				if [ "${args[0]}" = "$itemID" ] ; then
					#標準出力で返却、関数を抜ける
					echo "$retItemInfo"
					break #要る？
				fi
			}
			#渡されたアイテムIDがアイテムテーブルに存在しないとき、
			#エラーアイテムを返却する(エラーアイテムIDを対象のアイテムIDに置換する)
			echo "${TBL_ITM_INFO_ERR/ZZZZ/$itemID}"
		}
		}
	: '足元マップ分岐' && {
		###########################################
		##divActByFoot
		## 足元のマップチップを判定し、必要な分岐と処理を行う。
		## アイテムの抽選はここからで呼び出すこと
		###########################################
		function divActByFoot(){

			declare maptipFoot="${lnSeed[20]:47:1}"
			declare msg=''
			declare itemCat=''
			declare pickItemInfo=''

			case "$maptipFoot" in
				[oa] )  ##アイテムは拾う。
						case "$maptipFoot" in
							'a'	)	#アイテム_武器系
									itemCat='ARM'
									;;									
							'o'	)	#アイテム_薬系
									itemCat='CSM'
									;;
						esac

						#暫定Lv00s0アイテム
						itemID=$(lotItem "$itemCat" 00 0)
						pickItem "itemID"
						;;
			
				[#^v] ) ##未実装マップチップ
						case "$maptipFoot" in
							'#'	)	msg='マップ切り替え';;
							'^'	)	msg='上り階段';;
							'v'	)	msg='下り階段';;
						esac

						modMsg 1 1 "$msg"
						;;
			esac
				
			}
		}
	: '指示マス座標計算' && {
		###########################################
		##clcDirPos
		## 進入マスの座標計算
		##  $1:方向指示(1-9,zxcasdqwe)
		###########################################
		function clcDirPos(){
			declare posX=$((10#${lnSeed[1]:1:2}-1))
			declare posY=$((10#${lnSeed[2]:1:2}-1))
			declare dirct=$1
			declare dirX=0
			declare dirY=0
			declare tgtX=0
			declare tgtY=0

			case "$dirct" in
				[1Zz]	)	#↙
						dirX=-1
						dirY=1
						;;
				[2Xx]	)	#↓
						dirX=0
						dirY=1
						;;
				[3Cc]	)	#↘
						dirX=1
						dirY=1
						;;
				[4Aa]	)	#←
						dirX=-1
						dirY=0
						;;
				[5Ss]	);;
				[6Dd]	)	#→
						dirX=1
						dirY=0
						;;
				[7Qq]	)	#↖
						dirX=-1
						dirY=-1
						;;
				[8Ww]	)	#↑
						dirX=0
						dirY=-1
						;;
				[9Ee]	)	#↗
						dirX=1
						dirY=-1
						;;
				"0"		)	#キャンセル
						dspCmdLog 'キャンセルしました。'
						dispAll $CNST_YN_Y 
						return
						;;
				*		)	sysOut 'e' $LINENO '方向指示エラーです。'
			esac

			tgtX=$((10#$posX+dirX))
			tgtY=$((10#$posY+dirY))

			echo "$tgtX,$tgtY"

			}
		}
	: 'ドア開ける' && {
		###########################################
		##openDoor
		## ドアを消す
		##  $1:X座標
		##  $2:Y座標
		##   $1$2が指す座標が閉じドアマスであることが確定してから呼ぶこと
		###########################################
		function openDoor(){

			##引数の個数
			if [ $# -ne 2 ] ; then
				sysOut 'e' $LINENO '引数は2つ指定してください。'
				return
			fi

			declare mapX=$((10#$1))
			declare mapY=$((10#$2))

			#表示情報の更新
			declare lStrD="${lnSeed[$((mapY+4))]:0:$((mapX+4))}"
			declare rStrD="${lnSeed[$((mapY+4))]:$((mapX+5))}"
			#正解マップ情報への反映
			declare lStrM="${lnMapInfo[$((mapY))]:0:$((mapX))}"
			declare rStrM="${lnMapInfo[$((mapY))]:$((mapX+1))}"

			#ドアなど変化情報をセーブデータに残す必要のあるマップチップは、
			#lnSeedとlnMapInfoの両方を更新する必要がある。
			lnSeed[$((mapY+4))]="${lStrD}[${rStrD}"
			lnMapInfo[$((mapY))]="${lStrM}[${rStrM}"
			
			dispAll $CNST_YN_Y 

			}
		}
	: '足元のものを拾う' && {
		###########################################
		##pickItem
		## 拾う
		##  $1:アイテムID
		###########################################
		function pickItem(){

			##引数の個数
			if [ $# -ne 1 ] ; then
				sysOut 'e' $LINENO '引数は1つ指定してください。'
				return
			fi

			itemName="$(getItemDisp 0 $1)"

			if [ ${#psnItemList[*]} -le 15 ] ; then
				modMsg 1 1 "$itemNameを拾った"
				psnItemList+=($itemID)
			else
				modMsg 1 1 "$itemNameが落ちている...が持ち物がいっぱいで持てない。"
			fi
		}
		}
	: 'ドア閉じる' && {
		###########################################
		##closeDoor
		## ドアを出す
		##  $1:X座標
		##  $2:Y座標
		##   $1$2が指す座標が開きドアマスであることが確定してから呼ぶこと
		###########################################
		function closeDoor(){

			##引数の個数
			if [ $# -ne 2 ] ; then
				sysOut 'e' $LINENO '引数は2つ指定してください。'
				return
			fi

			declare mapX=$((10#$1))
			declare mapY=$((10#$2))

			#表示情報の更新
			declare lStrD="${lnSeed[$((mapY+4))]:0:$((mapX+4))}"
			declare rStrD="${lnSeed[$((mapY+4))]:$((mapX+5))}"
			#正解マップ情報への反映
			declare lStrM="${lnMapInfo[$((mapY))]:0:$((mapX))}"
			declare rStrM="${lnMapInfo[$((mapY))]:$((mapX+1))}"

			#ドアなど変化情報をセーブデータに残す必要のあるマップチップは、
			#lnSeedとlnMapInfoの両方を更新する必要がある。
			lnSeed[$((mapY+4))]="${lStrD}D${rStrD}"
			lnMapInfo[$((mapY))]="${lStrM}D${rStrM}"
			
			dispAll $CNST_YN_Y 

			}
		}
	: '対象マスへ移動' &&{
		###########################################
		##jmpPosWrgl
		## Wriggleの位置をx,y指定で移動する
		## この関数は強制的に画面を再描画する。
		##  $1 X座標(1 〜 CNST_MAP_SIZ_X)
		##  $2 Y座標(1 〜 CNST_MAP_SIZ_Y) 
		###########################################
		function jmpPosWrgl(){

			#バリデーション
			##引数の個数
			if [ $# -ne 2 ]; then
				sysOut 'e' $LINENO '引数は2つ指定してください。'
				return
			fi
			##$1の範囲
			if [ $1 -lt 0 ] || [ $1 -gt $CNST_MAP_SIZ_X ]; then
				sysOut 'e' $LINENO "X座標は1〜$CNST_MAP_SIZ_Xで指定してください。"'$1'"=$1"
				return
			fi
			##$2の範囲
			if [ $2 -lt 0 ] || [ $2 -gt $CNST_MAP_SIZ_Y ]; then
				sysOut 'e' $LINENO "Y座標は1〜$CNST_MAP_SIZ_Yで指定してください。"'$2'"=$2"
				return
			fi

			declare mapX=$((10#$1))
			declare mapY=$((10#$2))

			maptipFoot="$(getMapInfo $mapX $mapY 'DSP')"

			modDspWrglPos $(($1+1)) $(($2+1)) "$maptipFoot"
			opnArndMaptip

			}
		}
	: 'ダッシュ用移動' &&{
		###########################################
		##goAheadWrgl
		## jmpPosWrgl+modDspWrglPosのダッシュ用略式
		## Wriggleの位置をx,y指定で移動する
		## この関数は画面を描画しない。
		##  $1 X座標(1 〜 CNST_MAP_SIZ_X)
		##  $2 Y座標(1 〜 CNST_MAP_SIZ_Y) 
		###########################################
		function goAheadWrgl(){

			##引数の個数
			if [ $# -ne 2 ] ; then
				sysOut 'e' $LINENO '引数は2つ指定してください。'
				return
			fi

			declare mapX=$((10#$1))
			declare mapY=$((10#$2))

			declare lStr="${lnSeed[$((mapY+4))]:0:$((mapX+4))}"
			declare rStr="${lnSeed[$((mapY+4))]:$((mapX+5))}"

			declare X=$(printf "%02d" $(($1+1)))
			declare Y=$(printf "%02d" $(($2+1)))

			declare row1Right="${lnSeed[1]:3}"
			declare row2Right="${lnSeed[2]:3}"

			lnSeed[1]="|$X$row1Right"
			lnSeed[2]="|$Y$row2Right"

			#ダッシュ移動中のマス開示は足元のマスのみ?
			opnArndMaptip

			}
		}
	: 'ランダム出力生成' && {
		##################################################
		##sayRnd
		## ランダム出力表現生成
		##  何度も繰り返すことができる行動に対する出力を
		##  ランダム生成する。10パターン固定、減らす場合は結果重複で制限する
		##   $1:出力するタイプ(CNST_RND_????)
		##################################################
		function sayRnd(){

			##引数の個数
			if [ $# -ne 1 ] ; then
				sysOut 'e' $LINENO '引数は1つ指定してください。'
				return
			fi

			declare rslt=$(($RANDOM % 10))
			
			case "$1" in
				$CNST_RND_WALL	)	#ぶつかる音
						case "$rslt" in
							'0'	)	echo 'いてて';;
							'1'	)	echo 'ぶつかった...';;
							'2'	)	echo 'ゴンッ';;
							'3'	)	echo '壁...';;
							'4'	)	echo 'いたいっ＞＜';;
							'5'	)	echo 'これ以上進めないよ';;
							'6'	)	echo '押さないで！';;
							'7'	)	echo 'ぶつかった';;
							'8'	)	echo '壁！';;
							'9'	)	echo '行けないよ';;
							*	)	sysOut 'e' $LINENO '<sayRnd> Arg Error.'
						esac
						;;
				$CNST_RND_DOOR	)	#扉じゃないところを開けようとする
						case "$rslt" in
							'0'	)	echo '社会の窓でも開けるの...?';;
							'1'	)	echo '扉なんてないよ。';;
							'2'	)	echo '扉なんてないよ。';;
							'3'	)	echo '扉なんてないよ。';;
							'4'	)	echo '扉なんてないよ。';;
							'5'	)	echo '扉なんてないよ。';;
							'6'	)	echo '扉なんてないよ。';;
							'7'	)	echo '扉なんてないよ。';;
							'8'	)	echo '扉なんてないよ。';;
							'9'	)	echo '扉なんてないよ。';;
							*	)	sysOut 'e' $LINENO '<sayRnd> Arg Error.'
						esac
						;;
				$CNST_RND_WEMEN	)	#おさわり反応
						case "$rslt" in
							'0'	)	echo '';;
							'1'	)	echo '';;
							'2'	)	echo '';;
							'3'	)	echo '';;
							'4'	)	echo '';;
							'5'	)	echo '';;
							'6'	)	echo '';;
							'7'	)	echo '';;
							'8'	)	echo '';;
							'9'	)	echo '';;
							*	)	sysOut 'e' $LINENO '<sayRnd> 引数エラーです。'
						esac
						;;
				$CNST_RND_DASH	)	#ダッシュ音
						case "$rslt" in
							'0'	)	echo 'カサカサカサ...';;
							'1'	)	echo 'ぴゅーん！';;
							'2'	)	echo 'はしれー';;
							'3'	)	echo 'カサカサカサ...';;
							'4'	)	echo 'びゅーーーーーーん';;
							'5'	)	echo 'びゅ〜〜〜〜ん！！';;
							'6'	)	echo 'カサカサカサ...';;
							'7'	)	echo 'カサカサカサ...';;
							'8'	)	echo 'だーっしゅ!';;
							'9'	)	echo 'Go!Go!Go!';;
							*	)	sysOut 'e' $LINENO '<sayRnd> 引数エラーです。'
						esac
						;;
				*				)	sysOut 'e' $LINENO '<sayRnd> 引数エラーです。'
			esac
			}
		}
	: 'メニューカーソル移動' && {
		##################################################
		##movMenuCsr
		## メニュー画面のカーソルを移動する
		##   $1:方向指示。8=上、2=下
		##################################################
		function movMenuCsr(){
			declare dir="$1"

			case $dir in

				#上移動
				$CNST_CSR_MVTO_UP)
					#現在のカーソル位置から*マークを消去
					lnSeed[$selMenuId]=${lnSeed[$selMenuId]:0:67}' '${lnSeed[$selMenuId]:68}

					#現在のメニューID(カーソル位置)が1の場合は、一番下の行(メニューID18)に*マークを表示する
					if [ $selMenuId -eq 1 ] ; then
						lnSeed[18]=${lnSeed[18]:0:67}'>'${lnSeed[18]:68}
						selMenuId=18

					else
					#1じゃなければ、普通通りにメニューIDを1つデクリメントして*を表示する
						lnSeed[$((selMenuId-1))]=${lnSeed[$((selMenuId-1))]:0:67}'>'${lnSeed[$((selMenuId-1))]:68}
						selMenuId=$((selMenuId-1))
					fi;;

				$CNST_CSR_MVTO_DN)
					lnSeed[$selMenuId]=${lnSeed[$selMenuId]:0:67}' '${lnSeed[$selMenuId]:68}

					#現在のメニューID(カーソル位置)が一番下(メニューIDが18)の場合は、一番上の行に*マークを表示する
					if [ $selMenuId -eq 18 ] ; then
						lnSeed[1]=${lnSeed[1]:0:67}'>'${lnSeed[1]:68}
						selMenuId=1

					else
					#18じゃなければ、普通通りにメニューIDを1つインクリメントして*を表示する
						lnSeed[$((selMenuId+1))]=${lnSeed[$((selMenuId+1))]:0:67}'>'${lnSeed[$((selMenuId+1))]:68}
						selMenuId=$((selMenuId+1))
					fi;;

				#エラー
				*) 	dspCmdLog "[MenuCsrMvERR]dir:$dir/no:$selMenuId";;
			esac
			}
		}
	: 'メニュー2方向指示カーソル移動' && {
		##################################################
		##movDirCsr
		## メニュー2画面の方向指示用カーソルを移動する
		##  メニュー2画面表示中に呼び出すこと
		##################################################
		function movDirCsr(){

			#初期は左上にセット
			declare chcDir='7'
			declare posLX="${CNST_CSR_DIR_7:0:2}"
			declare posRX="$((posLX+4))"
			declare posY="${CNST_CSR_DIR_7:3}"

			lnSeed[$posY]="${lnSeed[$posY]:0:$posLX}[${lnSeed[$posY]:$((posLX+1)):3}]${lnSeed[$posY]:$((posLX+5))}"
			dispAll $CNST_YN_Y 
			
			while :
			do
				clrCmdLog
				getChrH
				case $inKey	in
					''						)	cmdMode=$CNST_CMDMODE_MENU2
												getCmdInMain $chcDir
												joinFrameOnStatus
												cmdMode=$CNST_CMDMODE_NRML0
												dispAll $CNST_YN_Y 
												break
												;;
					[0-9vzxcasdqweVZXCASDQWE])	case $inKey in
													[Zz]	)	chcDir='1';;
													[Xx]	)	chcDir='2';;
													[Cc]	)	chcDir='3';;
													[Aa]	)	chcDir='4';;
													[Ss]	)	chcDir='5';;
													[Dd]	)	chcDir='6';;
													[Qq]	)	chcDir='7';;
													[Ww]	)	chcDir='8';;
													[Ee]	)	chcDir='9';;
													[Vv]	)	chcDir='0';;
													*		)	chcDir=$inKey;;
												esac

												lnSeed[$posY]="${lnSeed[$posY]:0:$posLX} ${lnSeed[$posY]:$((posLX+1)):3} ${lnSeed[$posY]:$((posLX+5))}"
												eval 'posLX="${CNST_CSR_DIR_'$chcDir':0:2}"'
												posRX="$((posLX+4))"
												eval 'posY="${CNST_CSR_DIR_'$chcDir':3}"'
												lnSeed[$posY]="${lnSeed[$posY]:0:$posLX}[${lnSeed[$posY]:$((posLX+1)):3}]${lnSeed[$posY]:$((posLX+5))}"
												;;
					*						)	dspCmdLog "[$inKey]is_invalid.";;
				esac
				dispAll $CNST_YN_Y 
			done
			}
		}
	}
: '■画面表示系' && {
	: 'マップ表示内容' && {
		##################################################
		## initMapInfo
		##  表示上のマップ情報。レイヤー3。
		##   lnDspMap[]にマップ開示情報を格納する
		##################################################
		function dspMapInfo() {

			declare -a -g lnDspMap=() #15行60文字

			#「#」が未踏襲マス。それ以外は踏襲済み。
			#初期状態   000000000011111111112222222222333333333344444444445555555555
			#文字数     012345678901234567890123456789012345678901234567890123456789
			lnDspMap+=('############################################################') #00
			lnDspMap+=('############################################################') #01
			lnDspMap+=('############################################################') #02
			lnDspMap+=('############################################################') #03
			lnDspMap+=('############################################################') #04
			lnDspMap+=('############################################################') #05
			lnDspMap+=('############################################################') #06
			lnDspMap+=('############################################################') #07
			lnDspMap+=('############################################################') #18
			lnDspMap+=('############################################################') #19
			lnDspMap+=('############################################################') #10
			lnDspMap+=('############################################################') #11
			lnDspMap+=('############################################################') #12
			lnDspMap+=('############################################################') #13
			lnDspMap+=('############################################################') #14
			}
		}
	: 'マップ情報' && {
		##################################################
		## defDapInfo
		##  正解マップ定義。レイヤー2。
		##   lnMapInfo[]にマップ正解を格納する
		##################################################
		function defMapInfo() {

			declare -a -g lnMapInfo=()

			#初期状態    000000000011111111112222222222333333333344444444445555555555
			#文字数      012345678901234567890123456789012345678901234567890123456789+1
			lnMapInfo+=('+---------------------------+-----------------------+XXXXXXX') #00+1
			lnMapInfo+=('|                           D                       |XXXXXXX') #01+1
			lnMapInfo+=('|                           +-+-------------+D+-----+XXXXXXX') #02+1
			lnMapInfo+=('+                           |X|                     |XXXXXXX') #03+1
			lnMapInfo+=('#                           |X|                     |XXXXXXX') #04+1
			lnMapInfo+=('#                           |X+--+                  +----+XX') #05+1
			lnMapInfo+=('#                    a      |XXXX|                       |XX') #06+1
			lnMapInfo+=('+                   o       |XXXX|                  +--+ |XX') #07+1
			lnMapInfo+=('|                           |XXXX+------------------+XX| |XX') #08+1
			lnMapInfo+=('|v                          |XXXXXXXXXXXXXXXXXXXXXXXXXX| |XX') #09+1
			lnMapInfo+=('+---------------------------+--------------------------+D+XX') #10+1
			lnMapInfo+=('|                                                        |XX') #11+1
			lnMapInfo+=('+-+D+-+-------------------+D+---------------+            |XX') #12+1
			lnMapInfo+=('|     |XXXXXXXXXXXXXXXXXXX| |XXXXXXXXXXXXXXX+------------+XX') #13+1
			lnMapInfo+=('+-----+XXXXXXXXXXXXXXXXXXX+#+XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') #14+1
			}
		}						
	: 'アイテム欄表示内' && {
		##################################################
		## defItemInfo
		##  アイテム一覧表示。レイヤー2。
		##   lnItemInfo[]にアイテム一覧表示内容を格納する
		##################################################
		function defItemInfo() {

			declare -a -g lnItemInfo=()

			#初期状態     0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999
			#文字数       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			lnItemInfo+=('+------------------------------------------------+----------------------------------------------+--+') #00
			lnItemInfo+=('|   所持品  ページ目                             | 説明                                         |直|') #01
			lnItemInfo+=('+------------------------------------------------+----------------------------------------------+--+') #02
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #03
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #04
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #05
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #06
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #07
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #08
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #09
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #10
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #11
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #12
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #13
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #14
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #15
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #16
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #17
			lnItemInfo+=('|       　　　　　　　　　　 　　　　　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|  |') #18
			lnItemInfo+=('+============================================+===+==============================================+==+') #19+1
			}
		}						
	: 'ステータス表示内容' && {
		##################################################
		## defStatusInfo
		##  ステータス表示。レイヤー2。
		##   lnMapInfo[]にステータス表示内容を格納する
		##################################################
		function defStatusInfo() {

			declare -a -g lnStatusInfo=()

			#               00000000001111111111222222222233333
			#               01234567890123456789012345678901234+66
			lnStatusInfo+=('+------------+--------------------+') #00
			lnStatusInfo+=('|リグル      |むしむしファイター  |') #01
			lnStatusInfo+=('+--+---------+--------------------+') #02
			lnStatusInfo+=('|HP| 100/ 100|BLv: 1=     0/    10|') #03
			lnStatusInfo+=('|MP| 100/ 100|JLv: 1=     0/    10|') #04
			lnStatusInfo+=('+--+--+--+--++-+--++--+--+--+--+--+') #05
			lnStatusInfo+=('|絶|毒|黙|乱|眠|闇||攻|防|魔|速|運|') #06
			lnStatusInfo+=('+--+--+--+--+--+--++--+--+--+--+--+') #07
			lnStatusInfo+=('| 0| 0| 0| 0| 0| 0|| 0| 0| 0| 0| 0|') #08
			lnStatusInfo+=('+--+--+--+--+--+--++--+--+--+--+--+') #09
			lnStatusInfo+=('|  値 - ステ - パラ|物|地|水|火|風|') #10
			lnStatusInfo+=('|   2 < 腕力 > 物攻|10|10|10|10|10|') #11
			lnStatusInfo+=('|   2 < 知能 > 魔攻|10|10|10|10|10|') #12
			lnStatusInfo+=('|   3 < 体力 > 物防|10|10|10|10|10|') #13
			lnStatusInfo+=('|   1 < 精神 > 魔防|10|10|10|10|10|') #14
			lnStatusInfo+=('|   5 < 知覚 > 抵抗| 1  %+==+=====+') #15
			lnStatusInfo+=('|   1 < 器用 > 命中|10  %|金|    0|') #16
			lnStatusInfo+=('|   4 < 敏捷 > 回避|10  %|銀|    0|') #17
			lnStatusInfo+=('|   1 < 幸運 > クリ|10  %|銅|   50|') #18
			lnStatusInfo+=('+==================+=====+==+=====+') #19
			}
		}						
	: 'メニュー画面表示内容' && {
		##################################################
		## defMenuInfo
		##  メニュー画面表示。レイヤー2。
		##   lnMenuInfo[]にメニュー画面表示内容を格納する
		##################################################
		function defMenuInfo() {


			declare -a -g lnMenuInfo=()
			#メニュー内コマンド内容は、右を全角SPで埋めること
			#初期状態     00000000001111111111222222222233333
			#文字数       01234567890123456789012345678901234+66
			lnMenuInfo+=('+ M E N U ====================+===+') #00
			lnMenuInfo+=('| > 調べる　　　　　　　　　　|iv |') #01
			lnMenuInfo+=('|   開く　　　　　　　　　　　|op |') #02
			lnMenuInfo+=('|   閉じる　　　　　　　　　　|cl |') #03
			lnMenuInfo+=('|   話す　　　　　　　　　　　|tk |') #04
			lnMenuInfo+=('|   拾う　　　　　　　　　　　|pk |') #05
			lnMenuInfo+=('|   　　　　　　　　　　　　　|   |') #06
			lnMenuInfo+=('|   　　　　　　　　　　　　　|   |') #07
			lnMenuInfo+=('|   　　　　　　　　　　　　　|   |') #08
			lnMenuInfo+=('|   　　　　　　　　　　　　　|   |') #09
			lnMenuInfo+=('|   　　　　　　　　　　　　　|   |') #10
			lnMenuInfo+=('|   　　　　　　　　　　　　　|   |') #11
			lnMenuInfo+=('|   　　　　　　　　　　　　　|   |') #12
			lnMenuInfo+=('|   　　　　　　　　　　　　　|   |') #13
			lnMenuInfo+=('|   　　　　　　　　　　　　　|   |') #14
			lnMenuInfo+=('|   マニュアルを見る　　　　　|man|') #15
			lnMenuInfo+=('|   ヘルプ（コマンドリスト）　|?? |') #16
			lnMenuInfo+=('|   戻る　　　　　　　　　　　|cm |') #17
			lnMenuInfo+=('|   終了　　　　　　　　　　　|qqq|') #18
			lnMenuInfo+=('+=============================+===+') #19
			}
		}						
	: 'メニュー2画面表示内容(コマンド選択後_引数選択)' && {
		##################################################
		## defMenuInfo2
		##  メニュー画面2表示。レイヤー2。
		##   メニュー画面1で選択したコマンドの引数(方向とか)を選択する画面
		##   lnMenuInfo2[]にメニュー画面2表示内容を格納する
		##   メニュー画面1から1行ずらして表示する
		##################################################
		function defMenuInfo2() {

			declare -a -g lnMenuInfo2=()

			#              00000000001111111111222222222233333
			#              01234567890123456789012345678901234+66
			lnMenuInfo2+=('+ M E N U ========================+') #00
			lnMenuInfo2+=('|                                 |') #01
			lnMenuInfo2+=('+---------------------------------+') #02
			lnMenuInfo2+=('| 方向を指定してください          |') #03
			lnMenuInfo2+=('|                                 |') #04
			lnMenuInfo2+=('|    7Qq   8Ww   9Ee              |') #05
			lnMenuInfo2+=('|                                 |') #06
			lnMenuInfo2+=('|    4Aa   =¥=   6Dd              |') #07
			lnMenuInfo2+=('|                                 |') #08
			lnMenuInfo2+=('|    1Zz   2Xx   3Cc              |') #09
			lnMenuInfo2+=('|                                 |') #10
			lnMenuInfo2+=('|    0Vv > キャンセル             |') #11
			lnMenuInfo2+=('|                                 |') #12
			lnMenuInfo2+=('|                                 |') #13
			lnMenuInfo2+=('|                                 |') #14
			lnMenuInfo2+=('|                                 |') #15
			lnMenuInfo2+=('|                                 |') #16
			lnMenuInfo2+=('|                                 |') #17
			lnMenuInfo2+=('|                                 |') #18
			lnMenuInfo2+=('+=================================+') #19
			}
		}						

	: '初期表示' && {
		##################################################
		## initDispInfo
		##  画面の初期表示情報。レイヤー1。
		##   lnSeed[]に初期表示情報を格納する
		##################################################
		function initDispInfo() {

			declare -a -g lnSeed=() ##0から25までの26要素用意するつもり。

			#初期状態 0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999
			#文字数   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			lnSeed+=('+--+------------------------------------------------------------++---------------------------------+') #00
			lnSeed+=('|01|000000000111111111122222222223333333333444444444455555555556||                                 |') #01
			lnSeed+=('|01|123456789012345678901234567890123456789012345678901234567890||                                 |') #02
			lnSeed+=('+--+------------------------------------------------------------+|                                 |') #03
			lnSeed+=('|01|                                                            ||                                 |') #04
			lnSeed+=('|02|                                                            ||                                 |') #05
			lnSeed+=('|03|                                                            ||                                 |') #06
			lnSeed+=('|04|                                                            ||                                 |') #07
			lnSeed+=('|05|                                                            ||                                 |') #08
			lnSeed+=('|06|                                                            ||                                 |') #09
			lnSeed+=('|07|                                                            ||                                 |') #10
			lnSeed+=('|08|                                                            ||                                 |') #11
			lnSeed+=('|09|                                                            ||                                 |') #12
			lnSeed+=('|10|                                                            ||                                 |') #13
			lnSeed+=('|11|                                                            ||                                 |') #14
			lnSeed+=('|12|                                                            ||                                 |') #15
			lnSeed+=('|13|                                                            ||                                 |') #16
			lnSeed+=('|14|                                                            ||                                 |') #17
			lnSeed+=('|15|                                                            ||                                 |') #18
			lnSeed+=('+==+=========================================+===+==============++=================================+') #19
			lnSeed+=('|COMMAND>                                    |   |                                                 |') #20
			lnSeed+=('+==+======input [mn] to Menu.================+===+========================== input [??] to help.===+') #21
			lnSeed+=('|91|                                                                                               |') #22
			lnSeed+=('|92|                                                                                               |') #23
			lnSeed+=('|93|                                                                                               |') #24
			lnSeed+=('|94|                                                                                               |') #25
			lnSeed+=('|95|                                                                                               |') #26
			lnSeed+=('+--+-----------------------------------------------------------------------------------------------+') #27

			}
		}	
	: '全画面表示内容を退避' && {
		##################################################
		## escLnSeed
		##  lnSeedの内容を一時的に退避する。
		##################################################
		function escLnSeed() {
			declare -a -g escLnSeedInfo=()

			for ((i = 0; i <= 26; i++)) {
				escLnSeedInfo[i]="${lnSeed[i]}"
			}
		}
	}
	: '全画面表示内容を退避領域から復帰' && {
		##################################################
		## retLnSeed
		##  escLnSeedで退避した内容を復帰する
		##################################################
		function retLnSeed() {
			for ((i = 0; i <= 26; i++)) {
				lnSeed[i]="${escLnSeedInfo[i]}"
			}
		}
	}	
	: 'マップレイヤー結合' && {
		##################################################
		## joinFrameOnMap
		##  画面フレームと、マップ表示情報を結合する
		##   lnSeedのマップ枠の中にlnDspMapをはめ込む。
		##################################################
		function joinFrameOnMap (){
			
			for ((i = 0; i <= 14; i++)) {
				lnSeed[4+i]="${lnSeed[4+i]:0:4}${lnDspMap[i]}${lnSeed[4+i]:64}"
				}
			}
		}
	: 'ステータスレイヤー結合' && {
		##################################################
		## joinFrameOnStatus
		##  画面フレームと、ステータス表示情報を結合する
		##   lnSeedのマップ枠の中にlnStatusInfoをはめ込む。
		##################################################
		function joinFrameOnStatus (){
			
			for ((i = 0; i <= 19; i++)) {
				lnSeed[i]="${lnSeed[i]:0:65}${lnStatusInfo[i]}"
				}
			}
		}
	: 'アイテムレイヤー結合' && {
		##################################################
		## joinFrameOnItem
		##  画面フレームと、アイテム表示枠を結合する
		##   lnSeedのマップ枠の中にlnItemInfoをはめ込む。
		##   また、所持アイテムの情報をはめ込んでいく。		
		##################################################
		function joinFrameOnItem (){

			declare psnItemCnt=0
			declare spCnt1=0 #アイテム名称の後の半角相当SP数
			declare spCnt2=0 #アイテム説明の後の半角相当SP数
			declare itemName=''
			declare itemExp=''

			#現在の表示内容を退避し、アイテム枠を表示する。
			escLnSeed
			for ((i = 0; i <= 19; i++)) {
				lnSeed[i]="${lnItemInfo[i]}"
			}
			
			##所持アイテムリストの長さを取得
			psnItemCnt=${#psnItemList[*]}
			
			for ((i=0; i<$psnItemCnt; i++)) {

				#アイテム情報取得関数
				itemID=${psnItemList[i]}
				itemName="$(getItemDisp 0 $itemID)"
				itemExp="$(getItemDisp 1 $itemID)"

				spCnt1=$(( (24-(${#itemName}))*2 ))
				spCnt2=$(( (23-${#itemExp})*2 ))
				
				eval 'lnSeed[i+3]="${lnSeed[i+3]:0:4}'"$itemName"'`printf %${spCnt1}s`|$itemExp`printf %${spCnt2}s`|`printf "%2s" $i`|"'
			}

			#カーソル設置と、リグル表示のごみ消去
			lnSeed[3]="${lnSeed[3]:0:2}>${lnSeed[3]:3}"

			}
		}
	: 'メニューレイヤー結合' && {
		##################################################
		## joinFrameOnMenu
		##  画面フレームと、メニュー表示情報を結合する
		##   lnSeedのマップ枠の中にlnStatusInfoをはめ込む。
		##################################################
		function joinFrameOnMenu (){
			
			for ((i = 0; i <= 19; i++)) {
				lnSeed[i]="${lnSeed[i]:0:65}${lnMenuInfo[i]}"
				}
			}
		}
	: 'メニュー2レイヤー結合' && {
		##################################################
		## joinFrameOnMenu2
		##  画面フレームと、メニュー2表示情報を結合する
		##   lnSeedのマップ枠の中にlnStatusInfo2をはめ込む。
		##################################################
		function joinFrameOnMenu2 (){
			
			declare cmd=''

			cmd="${lnSeed[$selMenuId]:69:13}"

			lnSeed[0]="${lnSeed[0]:0:65}+ M E N U ========================+"
			lnSeed[1]="${lnSeed[1]:0:66}$cmd       |"

			for ((i = 2; i <= 19; i++)) {
				lnSeed[i]="${lnSeed[i]:0:65}${lnMenuInfo2[i]}"
				}
			
			dispAll $CNST_YN_Y 
			movDirCsr
			}
		}

	: '全画面更新' && {
		##################################################
		##dispAll $CNST_YN_Y
		## 画面の全情報を更新表示
		##  lnSeed[]で画面を更新する
		##  自キャラ位置に「¥」を強調表示で上書きする。
		##   $1:自キャラカーソルを再描画するかどうか
		##################################################
		function dispAll (){
			clear

			for ((i = 0; i < ${#lnSeed[*]}; i++)) {
				echo "${lnSeed[i]}"
				}

			declare posX=$((10#${lnSeed[1]:1:2}+3))
			declare posY=$((10#${lnSeed[2]:1:2}+3))

			if [ $1 = $CNST_YN_Y ] ; then
				tput sc
				tput cup $posY $posX
				tput setab 2
				tput setaf 0
				tput blink
				echo '¥'
				tput sgr0
				tput rc
			fi
		}
		}
	: 'システムエラー画面' && {
		##################################################
		##sysOut
		## 主にエラー表示用に別の画面を起動する。
		## termcapによって上にかぶせる
		##   $1 深刻度 Hundling [e]rror,
		##             ignoreable [w]arning,
		##             [i]nformation > 無視可能なエラーはdspCmdLogへ表示する方針
		##   $2 呼出元行数
		##   $3 表示内容
		##################################################
		function sysOut(){

			declare   errDiv=''
			declare   bColor=0
			declare   fColor=0
			declare wdthSize=0
			declare   MAPdth=0
			declare   lrWdth=0

			inKey=''

			tput smcup
			clear

			case "$1" in
					'e'	)	errDiv='エラー'
							bColor=1
							fColor=7
							;;
					'w'	)	errDiv='警告'
							bColor=7
							fColor=0
							;;
					#'i'	)	errDiv='Information';;
					*	)	errDiv='致命的なエラー'
							bColor=1
							fColor=0
							;;
			esac

			wdthSize=$(tput cols)
			MAPdth=$(getCntSingleWidth "<$errDiv>Line:$2[$3]")
			lrWdth=$((($wdthSize-$MAPdth)/2))

			echo ''
			echo ''
			echo ''
			tput setab $bColor
			tput setaf $fColor
			printf "%${lrWdth}s<$errDiv>Line:$2[$3]%${lrWdth}s"
			tput sgr0
			echo ''
			echo ''
			echo ''

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll $CNST_YN_Y
					break
				else
					echo '適合しない入力値. [q] キーで抜けます。'
				fi
			done
			}
		}
	: 'メッセージウィンドウのクリア' && {
		##################################################
		##clrMsgWin
		## lnSeed[22〜26]を初期表示の内容で上書きして画面をクリア更新する
		##################################################
		function clrMsgWin(){

			lnSeed[22]='|91|                                                                                               |' #22
			lnSeed[23]='|92|                                                                                               |' #23
			lnSeed[24]='|93|                                                                                               |' #24
			lnSeed[25]='|94|                                                                                               |' #25
			lnSeed[26]='|95|                                                                                               |' #26

			}
		}
	: 'コマンドログウィンドウのクリア' && {
		##################################################
		##clrCmdLog
		## lnSeed[20]を初期表示の内容で上書きして画面をクリア更新する
		##################################################
		function clrCmdLog(){

			declare maptipFoot="${lnSeed[20]:47:1}"

			lnSeed[20]='|COMMAND>                                    | '"$maptipFoot"' |                                                 |'

			}
		}
	: '現在座標、足元マップチップを画面に反映' && {
		###########################################
		##modDspWrglPos
		## Wriggleの現在座標情報を画面表示へ反映する
		## ・左上に現在座標
		## ・コマンドウィンドウの右に足元のマップチップ
		## この関数は座標移動処理を行う他の関数から呼び出されるのみで
		## 直接mainから呼び出されることはない
		##  $1 X座標(1 〜 CNST_MAP_SIZ_X)
		##  $2 Y座標(1 〜 CNST_MAP_SIZ_Y)
		##  $3 足元マップチップ表示
		###########################################
		function modDspWrglPos(){
			declare X=$(printf "%02d" "$1")
			declare Y=$(printf "%02d" "$2")

			declare row1Right="${lnSeed[1]:3}"
			declare row2Right="${lnSeed[2]:3}"

			declare  row20Left="${lnSeed[20]:0:47}"
			declare row20Right="${lnSeed[20]:48}"

			lnSeed[1]="|$X$row1Right"
			lnSeed[2]="|$Y$row2Right"
			lnSeed[20]="$row20Left$3$row20Right"
			}
		}
	: '周囲マス開示' && {
		###########################################
		##opnArndMaptip
		## 現在マスの周囲8方向(と足元)のマップを開示する
		##  lnSeed[xx]の8方向(と足元)へ、正解マップチップから転写する
		##  引数なし(左上の座標表示を使用)
		###########################################
		function opnArndMaptip(){
			declare posX=$((10#${lnSeed[1]:1:2}-1))
			declare posY=$((10#${lnSeed[2]:1:2}-1))

			#上の行、同じ行、下の行
			lnSeed[$((posY+3))]="${lnSeed[$((posY+3))]:0:$((posX+3))}${lnMapInfo[$((posY-1))]:$((posX-1)):3}${lnSeed[$((posY+3))]:$((posX+6))}"
			lnSeed[$((posY+4))]="${lnSeed[$((posY+4))]:0:$((posX+3))}${lnMapInfo[$((posY+0))]:$((posX-1)):3}${lnSeed[$((posY+4))]:$((posX+6))}"
			lnSeed[$((posY+5))]="${lnSeed[$((posY+5))]:0:$((posX+3))}${lnMapInfo[$((posY+1))]:$((posX-1)):3}${lnSeed[$((posY+5))]:$((posX+6))}"

			}
		}
	: 'メッセージウィンドウの内容変更' && {
		##################################################
		##modMsg
		## メッセージウィンドウの表示情報を変更する
		## 表示内容を変えるだけで表示の更新はしない
		## カウント前に、crctStrで不正文字を近い文字に置換する
		##  $1 メッセージウィンドウの何行目か
		##  $2 メッセージウィンドウ$1行目の何文字目からか
		##  $3 表示する文字
		##################################################
		function modMsg(){

			#バリデーション
			##引数の個数
			if [ $# -ne 3 ] ; then
				sysOut 'e' $LINENO '引数は3つ設定してください。'
				return
			fi
			##$1の範囲
			if [ $1 -lt 1 ] || [ $1 -gt $CNST_MSG_SIZ_X ]; then
				sysOut 'e' $LINENO "開始文字位置は1〜$CNST_MSG_SIZ_Xである必要があります。"
				return
			fi
			##$2の範囲
			if [ $2 -lt 1 ] || [ $2 -gt $CNST_MSG_SIZ_Y ]; then
				sysOut 'e' $LINENO "開始行は1〜$CNST_MSG_SIZ_Yである必要があります。"
				return
			fi

			declare tgtRow=$1
			declare tgtClmn=$(($2+3))
		eval declare tgtStr=$(crrctStr "$3")
			
			declare leftStr="${lnSeed[21+$tgtRow]:0:$tgtClmn}"

			#文字長が右端を出ないように切り捨てる。
			#半角相当の文字数が95以下になるまで、末尾から1文字ずつ切り捨て続ける
			#半角全角が混じる場合に正確に切り捨てる長さを指定できないため
			declare tmpStr="$tgtStr"
			declare tmpCntSingleWidth=0
			while :
			do
				tmpCntSingleWidth=$(getCntSingleWidth "$tmpStr")
				if [ $tmpCntSingleWidth -gt $(($CNST_MSG_SIZ_X-5)) ] ; then
					tmpStr="${tmpStr:0:-1}"
				else
					tgtStr="$tmpStr"
					break
				fi
			done

			declare spCnt=$((99-$(getCntSingleWidth "$leftStr$tgtStr")))
			#getCntSingleWidth()で半角相当の文字数をカウント
			#100文字-|1文字=99、-文字数でSPACEの反復数

			lnSeed[$((21+$tgtRow))]="$leftStr$tgtStr`printf %${spCnt}s`|"
			}
		}
	: 'コマンドログウィンドウの内容変更' && {
		###########################################
		##dspCmdLog
		## コマンド結果等簡易表示ウィンドウの更新
		##   $1 表示内容
		##################################################
		function dspCmdLog(){

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] ; then			
				sysOut 'e' $LINENO "Set 1 arguments. $1/$2"
				return
			fi

			declare tgtStr="$(crrctStr "$1")"
			declare leftStr="${lnSeed[20]:0:$CNST_CMDLGW_IDX}"

			#文字長が右端を出ないように切り捨てる。
			#半角相当の文字数が50以下になるまで、末尾から1文字ずつ切り捨て続ける
			#半角全角が混じる場合に正確に切り捨てる長さを指定できないため
			declare tmpStr="$tgtStr"
			declare tmpCntSingleWidth=0
			while :
			do
				tmpCntSingleWidth=$(getCntSingleWidth "$tmpStr")
				if [ $tmpCntSingleWidth -gt $(($CNST_CMDLGW_IDX-1)) ] ; then
					tmpStr="${tmpStr:0:-1}"
				else
					tgtStr="$tmpStr"
					break
				fi
			done

			declare spCnt=$((99-$(getCntSingleWidth "$leftStr$tgtStr")))
			#getCntSingleWidth()で半角相当の文字数をカウント
			#100文字-|1文字=99、-文字数でSPACEの反復数

			lnSeed[20]="$leftStr$tgtStr`printf %${spCnt}s`|"

			}
		}
	}
: '■ゲーム中ユーザが使用するコマンド' && {
	: 'コマンドヘルプ' && {
		##################################################
		##viewHelp
		## コマンドヘルプ
		##   termcapによって上にかぶせる
		##################################################
		function viewHelp(){

			inKey=''

			tput smcup

			clear
			echo '***コマンドリスト***  ※[q]キーで終了します'
			echo ''
			echo 'man [CMD]   : [CMD]で指定したコマンドのマニュアルを見る。'
			echo '[...]can    : can以前の入力すべてをキャンセルする。'
			echo 'qqq         : ゲームを終了する。'
			echo 'mv [n]      : [n]で指定した方向へ1歩移動する。'
			echo 'da [n]      : [n]で指定した方向へ直進する。'
			echo 'op [n]      : [n]で指定した方向にある扉を開ける(鍵が必要かも)。'
			echo 'cl [n]      : [n]で指定した方向にある扉を閉じる(鍵はかからない)。'
			echo 'ki [m][n]   : [n]で指定した方向に、強度[n]のリグルキックを放つ。'
			echo 'wp [n]      : [n]で指定した方向へ武器を振るう。'
			echo 'ct [m][n]   : [n]で指定した方向へ、[m]にセットした符術を使う。'
			echo 'iv [n]      : [n]で指定した方向を調べる。'
			echo 'gt [n]      : [n]で指定した方向にあるものを手に取る。'
			echo 'tr [m][n]   : [n]で指定した方向へ、[m]のアイテムを投げる。'
			echo 'tk [n]      : [n]で指定した方向へ話しかける。'
			echo 'pr [n]      : [n]で指定した対象へ祈る。'
			echo 'mn          : メニュー画面を開く。'
			echo 'ss          : 自殺する。次のリグルはもっと上手くやるでしょう。'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll $CNST_YN_Y
					break
				else
					echo "$inKey は無効な入力です。 [q]キーで戻る。"
				fi
			done

			}
		}
	: 'マニュアル参照' && {
		##################################################
		##man
		## マニュアル参照
		##  引数で渡されたコマンドのマニュアルを表示する。
		##   $1 参照先コマンド
		##################################################
		function man(){		
			case "$1" in
				'can'	)	man_can ;;
				'mv'	)	man_mv ;;
				'da'	)	man_da ;;
				'op'	)	man_op ;;
				'cl'	)	man_cl ;;
				'pp'	)	man_pp ;;
				'ki'	)	man_ki ;;
				'wp'	)	man_wp ;;
				'ct'	)	man_ct ;;
				'in'	)	man_in ;;
				'gt'	)	man_gt ;;
				'tr'	)	man_tr ;;
				'tk'	)	man_tk ;;
				'pr'	)	man_pr ;;
				'ss'	)	man_ss ;;
				'mn'	)	man_mn ;;
				'man'	)	man_man ;;
				*		)	dspCmdLog "[$1] :存在しないコマンド"
							dispAll $CNST_YN_Y;;
			esac
			}
		: '■マニュアル詳細' && {
				: 'canコマンドマニュアル' && {
					function man_can(){

						inKey=''
						tput smcup

						clear

						echo '*** canコマンド ***'
						echo '<文法>'
						echo ' [...]can'
						echo ' ※引数なし。全ての入力の後に付与する。'
						echo ''
						echo '<機能>'
						echo ' 入力コマンドの末尾を「can」で終了したとき、'
						echo ' 全ての入力をキャンセルします。'
						echo ' ――帰る覆水もあるってことですね。'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done	
						}
					}
				: 'svqコマンドマニュアル' && {
					function man_sq(){

						inKey=''
						tput smcup

						clear

						echo '*** svqコマンド ***'
						echo '<文法>'
						echo ' svq [n]'
						echo ' ※引数は1〜4。'
						echo ''
						echo '<機能>'
						echo ' [n]番のセーブデータに現在の状態を保存してゲームを終了します。'
						echo ' ――寝る前に日記をつけるのを忘れないようにね。'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done	
						}
					}
				: 'svコマンドマニュアル' && {
					function man_svq(){

						inKey=''
						tput smcup

						clear

						echo '*** svコマンド ***'
						echo '<文法>'
						echo ' sv [n]'
						echo ' ※引数:1〜4'
						echo ''
						echo '<機能>'
						echo ' [n]番のセーブデータに現在の状態を保存する。'
						echo ' ――日記は君を助けてくれる、誰かに中身を見られない限りは。'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done	
						}
					}
				: 'qqqコマンドマニュアル' && {
					function man_qqq(){

						inKey=''
						tput smcup

						clear

						echo '*** qqqコマンド ***'
						echo '<文法>'
						echo ' qqq'
						echo ' ※引数なし'
						echo ''
						echo '<機能>'
						echo ' セーブせず、その場でゲームを終了します。'
						echo ' ――ヤバっ、幽香さんだ！！'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'mvコマンドマニュアル' && {
					function man_mv(){

						inKey=''
						tput smcup

						clear

						echo '*** mvコマンド ***'
						echo '<文法>'
						echo ' mv [n]'
						echo ' ※引数は0〜9、vzxcasdqwe、VZXCASDQWE。'
						echo ''
						echo '<機能>'
						echo ' [n]で指定した方向に1歩移動する。'
						echo ' mv [n]と入力する代わりに、“ZXCASDQWE(大文字)”の1文字だけを入力してもいい。' 
						echo ' 5/S/sを指定するとその場で足踏みする。'
						echo ' 0/V/vを指定するとキャンセルする。'
						echo ' ――ダンジョン探索は足に始まり足に終わる...いや終わるのは死か？'
						echo ' 　　ピクニックはさぞ楽しいことだろう。GLHF!'
						echo ''
						echo ' 移動先指定...  \  ^  /   \  ^  /   \  ^  /'
						echo '                 7 8 9     q w e     Q W E '
						echo '                <4 5 6>   <a s d>   <A S D>'
						echo '                 3 2 1     z x c     A X C '
						echo '                /  v  \   /  v  \   /  v  \'
						echo '                [5]or[s]or[s]  :足踏み(移動なし)'
						echo '                [0]or[v]or[V]  :キャンセル'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'daコマンドマニュアル' && {
					function man_da(){

						inKey=''
						tput smcup

						clear

						echo '*** daコマンド ***'
						echo '<文法>'
						echo ' da [n]'
						echo ' ※引数は0〜9、vzxcasdqwe、VZXCASDQWE。'
						echo ''
						echo '<機能>'
						echo ' [n]で指定した方向へ直進する。通常の床以外の手前で停止する。' 
						echo ' 5/S/sを指定するとその場で足踏みする。'
						echo ' 0/V/vを指定するとキャンセルする。'
						echo ' ――ダンジョンでは慎重に歩かなければドラゴンの尾を踏むことになる。'
						echo ' 　　まあ彼にとっては木の根を踏む方が恐ろしいだろうがね。'
						echo ''
						echo ' ダッシュ方向...\  ^  /   \  ^  /   \  ^  /'
						echo '                 7 8 9     q w e     Q W E '
						echo '                <4 5 6>   <a s d>   <A S D>'
						echo '                 3 2 1     z x c     A X C '
						echo '                /  v  \   /  v  \   /  v  \'
						echo '                [5]or[s]or[s]  :足踏み(移動なし)'
						echo '                [0]or[v]or[V]  :キャンセル'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'opコマンドマニュアル' && {
					function man_op(){

						inKey=''
						tput smcup

						clear

						echo '*** opコマンド ***'
						echo '<文法>'
						echo ' op [n]'
						echo ' ※引数は0〜9、vzxcasdqwe、VZXCASDQWE。'
						echo ''
						echo '<機能>'
						echo ' [n]で指定した方向の扉を開ける。'
						echo ' 施錠された扉の場合は適合する鍵を所持している場合のみ、開く。'
						echo ' ――茨扉の向こう側が、いつも好意的であるとは限らない。'
						echo ''
						echo ' 扉の方向指示...  \  ^  /   \  ^  /   \  ^  /'
						echo '                   7 8 9     q w e     Q W E '
						echo '                  <4 ¥ 6>   <a ¥ d>   <A ¥ D>'
						echo '                   3 2 1     z x c     A X C '
						echo '                  /  v  \   /  v  \   /  v  \  *5/S/s は無効'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'clコマンドマニュアル' && {
					function man_cl(){

						inKey=''
						tput smcup

						clear

						echo '*** clコマンド ***'
						echo '<文法>'
						echo ' cl [n]'
						echo ' ※引数は0〜9、vzxcasdqwe、VZXCASDQWE。'
						echo ''
						echo '<機能>'
						echo ' [n]で指定した方向の扉を閉じる。'
						echo ' 開く前に施錠扉だったとしても、鍵をかけることはできない。'
						echo ' 鍵なしの扉として閉じ直す。'
						echo ' ――嫌な夢でも見たのかい？　その夢が漏れ出てこないようにね。'
						echo ''
						echo ' 扉の方向指示...  \  ^  /   \  ^  /   \  ^  /'
						echo '                   7 8 9     q w e     Q W E '
						echo '                  <4 ¥ 6>   <a ¥ d>   <A ¥ D>'
						echo '                   3 2 1     z x c     A X C '
						echo '                  /  v  \   /  v  \   /  v  \  *5/S/s は無効'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'kiコマンドマニュアル' && {
					function man_ki(){

						inKey=''
						tput smcup

						clear

						echo '*** kiコマンド ***'
						echo '<文法>'
						echo ' ki [n] [m]'
						echo ' ※引数1は0〜9(5以外)、vzxcadqwe、VZXCADQWE。'
						echo ' ※引数2は1〜9。'
						echo ''
						echo '<機能>'
						echo ' リグルキックです。'
						echo ' [n]で指定した方向を、強度[m]で蹴ります。'
						echo ' リグルキックは、連続で使うことができません。'
						echo ' 武器がないときには大いに助けになってくれると同時に'
						echo ' いくつかの敵はリグルキックでなければ打ち破ることができないでしょう。'
						echo ' ――見敵必殺！...でも必ずOHKOとは限らないよねえ'
						echo ''
						echo ' 蹴る方向...  \  ^  /'
						echo '               1 2 3 '
						echo '              <4 ¥ 6>'
						echo '               7 8 9 '
						echo '              /  v  \'
						echo ''
						echo '<消費MP>'
						echo '  +--------+---+---+---+---+---+---+---+---+---+'
						echo '  |強度    |  1|  2|  3|  4|  5|  6|  7|  8|  9|'
						echo '  +--------+---+---+---+---+---+---+---+---+---+'
						echo '  |消費MP  |  3|  3|  3|  7|  7|  7|  9|  9| 12|'
						echo '  +--------+-----------------------------------+'
						echo ''
						echo '<威力>'
						echo '  ([Atk]*[useLv]*1.2)+([Atk]*[useLv-9]*0.5)'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'wpコマンドマニュアル' && {
					function man_wp(){

						inKey=''

						tput smcup
						clear

						echo '*** wpコマンド ***'
						echo '<文法>'
						echo ' wp [n]'
						echo ' ※引数は0〜9、vzxcasdqwe、VZXCASDQWE。'
						echo ''
						echo '<機能>'
						echo ' [n]で指定した方向へ装備中の武器を振ります。'
						echo ' 威力や射程は装備中の武器に依存します。'
						echo ' 特定の武器についてはMPを消費することもとあるかもしれません。'
						echo ' ――彼はいつも、ダンジョンでストレスを発散しているように見える。'
						echo '     ストレスの原因は、彼の妻(達)だろうか...？'
						echo ''
						echo ' 武器を振る方向...  \  ^  /'
						echo '                     1 2 3 '
						echo '                    <4 ¥ 6>'
						echo '                     7 8 9 '
						echo '                    /  v  \   ※距離は武器依存'
						echo ''
						echo '<威力>'
						echo '  ([Atk]*[weponAtk])+(|Atk-50|*[weponAtk]*0.3)'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'ctコマンドマニュアル' && {
					function man_ct(){

						inKey=''

						tput smcup
						clear

						echo '*** ctコマンド ***'
						echo '<文法>'
						echo ' ct [n] [m]'
						echo ' ※引数1は1〜4'
						echo ' ※引数2は1〜9'
						echo ''
						echo '<機能>'
						echo ' [m]の方向へ、[n]の符術を使用する'
						echo ' [m]に5を指定した場合は、自分を対象とする。'
						echo ' 距離は使用した符術に依存する。[m]を必要としないものもある。'
						echo ' 符術は攻撃用とは限らない。'
						echo ' 回復、補助、あるいはもっと特別な効果を持つものもあるだろう。'
						echo ' いずれにしてもダンジョン探索には有用なものに違いない。'
						echo ' ――これ、湿布？'
						echo ''
						echo ' 射出方向...  \  ^  /'
						echo '               1 2 3 '
						echo '              <4 ¥ 6>'
						echo '               7 8 9 '
						echo '              /  v  \   ※射程は符術に依存'
						echo ''
						echo '<威力>'
						echo '  ([Mat]*[magicStr])+(|[Mat]-50|*[magicStr]*0.4)'
						echo ''
						echo '<消費MP>'
						echo '  消費MPは[Int]の値によって一定量軽減される。'
						echo '    +--------+---+-----------+----------+----+'
						echo '    |int     |~30|~60        |~98       |99  |'
						echo '    +--------+---+-----------+----------+----+'
						echo '    |消費MP  |-0%|-(int/20)% |-(int/10)%|-30%|'
						echo '    +--------+---+-----------+----------+----+'
						echo '    ※軽減値は少数切り上げ'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'ivコマンドマニュアル' && {
					function man_iv(){

						inKey=''

						tput smcup
						clear

						echo '*** ivコマンド ***'
						echo '<文法>'
						echo ' iv [n]'
						echo ' ※引数は0〜9、vzxcasdqwe、VZXCASDQWE。'
						echo ''
						echo '<機能>'
						echo ' [n]で指定した方向を調査します。'
						echo ' ある種の調査は、[Snc]の値によって成否が分かれるかもしれない。'
						echo ' [n]に5を指定した場合、足元か、あるいは自身を対象とする。'
						echo ' ――いつでも触覚はキレイに保っておくべきだね'
						echo ''
						echo ' 調査する方向...     \  ^  /'
						echo '                      7 8 9 '
						echo '                     <4 ¥ 6>'
						echo '                      3 2 1 '
						echo '                     /  v  \      ※[5]は足元か自身'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'gtコマンドマニュアル' && {
					function man_gt(){

						inKey=''

						tput smcup
						clear

						echo '*** gtコマンド ***'
						echo '<文法>'
						echo ' gt [n]'
						echo ' ※引数は1〜9'
						echo ''
						echo '<機能>'
						echo ' [n]の方向にあるものを拾い上げたり手に取ったりします。'
						echo ' [n]に5を指定した場合、足元か自身を対象とします。'
						echo ' ――童話「アリとキリギリス」は、'
						echo ' 　　巣で待つ妻(達)のために働くべきだと教訓を残している。...違ったっけ？'
						echo ''
						echo ' 取る方向...  \  ^  /'
						echo '               7 8 9 '
						echo '              <4 ¥ 6>'
						echo '               3 2 1 '
						echo '              /  v  \      *[5]は足元'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done	
						}
					}
				: 'trコマンドマニュアル' && {
					function man_tr(){

						inKey=''
						tput smcup
						clear

						echo '*** trコマンド ***'
						echo '<文法>'
						echo ' tr [n] [m]'
						echo ' ※引数1は1〜9'
						echo ' ※引数2は1〜9(5以外)'
						echo ''
						echo '<機能>'
						echo ' [m]の方向に向けて、[n]のアイテムを投げます。'
						echo ' 投げるアイテムと[STR]あるいはその他のステータス値によって、効果は変わります。'
						echo ' ――ものを投げつけるなら気をつけるべきだ。'
						echo ' 　　それが女性から受け取ったもだったら、妻が見つけたときに特に面倒を招く。'
						echo ''
						echo ' 投げる方向... \  ^  /'
						echo '                7 8 9 '
						echo '               <4 ¥ 6>'
						echo '                3 2 1 '
						echo '               /  v  \'
						echo ''
						echo '<威力>'
						echo '  Jewel     --- [金額]*1000.0                       :防御力を無視'
						echo '  Gold      --- [金額]*100.0                        :防御力を無視'
						echo '  Silver    --- [金額]*1.0                          :防御力を無視'
						echo '  武器      --- [Str]*[WeponAtk]*(RoundUp(Str/100))'
						echo '  防具      --- [Str]*[ArmorDef]*(RoundUp(Str/150))'
						echo '  薬など    --- [ItemRecovery]*1.0                  :ダメージではなく回復'
						echo '  他        --- 何が起こるかわからない！'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'tkコマンドマニュアル' && {
					function man_tk(){

						inKey=''
						tput smcup

						clear

						echo '*** tkコマンド ***'
						echo '<文法>'
						echo ' tk [n]'
						echo ' ※引数は1〜9(5以外)'
						echo ''
						echo '<機能>'
						echo ' [n]の方向へ話しかける。'
						echo ' 会話が上手なら誰とでも仲良くなれる。でも妻の視線に気をつけて。'
						echo ''
						echo ' 声をかける方向...  \  ^  /'
						echo '                     7 8 9 '
						echo '                    <4 ¥ 6>'
						echo '                     3 2 1 '
						echo '                    /  v  \'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'prコマンドマニュアル' && {
					function man_pr(){

						inKey=''
						tput smcup

						clear

						echo '*** prコマンド ***'
						echo '<文法>'
						echo ' pr [n]'
						echo ' ※引数は不明'
						echo ''
						echo '<機能>'
						echo ' 引数で示した対象に向けて祈り、奇蹟を乞う。'
						echo ' 何が起こるかわからないが[MND]値によって望ましい結果を引き寄せ易くなるだろう'
						echo ' 知っている偶像に対してしか祈ることはできない。'
						echo ' ――ある一つの偶像に祈っている限り罰が当たることはないだろうが、'
						echo ' 　　もしお祈りが過ぎると処されるかもしれない。妻に祈ってだめなら、諦めるべきだ。'
						echo ''
						echo '<祈りの対象(偶像)>'
						echo ' 不明'
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'ssコマンドマニュアル' && {
					function man_ss(){

						inKey=''

						tput smcup
						clear

						echo '*** ssコマンド ***'
						echo '<文法>'
						echo ' ss'
						echo ' ※引数なし'
						echo ''
						echo '<機能>'
						echo ' 自殺します。誰も彼を悲しまない。'
						echo ' ――次のリグルはもっと上手くやるでしょう'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done
						}
					}
				: 'mnコマンドマニュアル' && {
					function man_mn(){

						inKey=''

						tput smcup
						clear

						echo '*** mnコマンド ***'
						echo '<文法>'
						echo ' mn'
						echo ' ※引数なし'
						echo ''
						echo '<機能>'
						echo ' メニュー画面を開く。その後は上下カーソルで行動を選んで実行する。'
						echo ' 行動によっては追加で方向や対象を選択する必要がある。'
						echo ' ――今日のご飯は何だろう♪'
						echo ''
						echo '... 以上'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done	
						}
					}
				: 'manコマンドマニュアル' && {
					function man_man(){

						inKey=''

						tput smcup
						clear

						echo '…今使ってるだろ。'
						echo '[q]キーで終了します'
						
						while :
						do
							getChrH
							if [ "$inKey" = 'q' ]; then
								tput rmcup
								dispAll $CNST_YN_Y
								break
							else
								echo '[q]キーで終了します'
							fi
						done	
						}
					}
				}
		}
	: 'mvコマンド' && {
		###########################################
		##mv
		## キャラ('¥'で示す)が動く           7 8 9  q w e
		##  $1 移動先座標(1〜9,zxcasdqwe)    4 ¥ 6  a ¥ d
		##        ※大文字でも良い            3 2 1  z x c
		###########################################
		function mv(){
			declare goX=''
			declare goY=''
			declare direction="$1"
			declare args=()

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] || [ "$direction" = '' ]; then
				dspCmdLog '<mv>引数は1つだけ指定してください。'
				dispAll $CNST_YN_Y
				return
			fi

			##$1のバリエーション
			if  [ ! $(echo 'VZXCASDQWEvzxcasdqwe0123456789' | grep "$direction") ] ; then
				dspCmdLog '<mv>0〜9とvzxcasdqwe(と大文字)から1つ指定。'
				dispAll $CNST_YN_Y
				return
			fi

			tput civis

			#0Vvだったらキャンセル、5Ssだったら足踏み
			if  [ $(echo '0Vv' | grep "$direction") ] ; then
				dspCmdLog '<mv>キャンセルしました'
				return
			fi
			if  [ $(echo '5Ss' | grep "$direction") ] ; then
				dspCmdLog 'Hoppn'"'"'nnnnn!'
			else

				#移動先座標を,区切りで取得
				args=($(echo $(clcDirPos "$direction")|xargs -d,))
				goX=${args[0]}
				goY=${args[1]}
				

				#移動先が移動不可だったら「ぶつかりボイス」
				#そうでなければ移動する
				#移動後、足元マップチップごとの処理分岐を行う
				if	 [ "$(getMapInfo $goX $goY 'ENT')" = $CNST_YN_N ] ; then
					dspCmdLog "$(sayRnd $CNST_RND_WALL)"
				elif [ "$(getMapInfo $goX $goY 'CNM')" = 'JNT' ] ; then
					dspCmdLog "隣の部屋は未実装だってさ"
				else
					jmpPosWrgl $goX $goY
					divActByFoot $goX $goY					
				fi
			fi
		
			dispAll $CNST_YN_Y
			tput cvvis

		}
		}
	: 'opコマンド' && {
		###########################################
		##op
		## ドアを開く。但し、適合する鍵を持っている場合のみ。
		##  $1 開け先座標(1〜9,zxcasdqwe)
		##                        ※大文字でも良い
		###########################################
		function op(){

			declare opX=''
			declare opY=''
			declare direction="$1"
			declare args=()

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] || [ "$1" = '' ]; then
				dspCmdLog '<op>引数はひとつだけ指定してください。'
				dispAll $CNST_YN_Y
				return
			fi
			##$1のバリエーション
			if  [ ! $(echo 'VZXCASDQWEvzxcasdqwe0123456789' | grep "$1") ] ; then
				dspCmdLog '<op>0〜9とvzxcasdqwe(と大文字)から1つ指定。'
				dispAll $CNST_YN_Y
				return
			fi

			#0Vvだったらキャンセル、5Ssだったら無視
			if  [ $(echo '0Vv' | grep "$direction") ] ; then
				dspCmdLog '<op>キャンセルしました'
				return
			fi
			if  [ $(echo '5Ss' | grep "$1") ] ; then
				:
			else

				#移動先座標を,区切りで取得
				args=($(echo $(clcDirPos "$direction")|xargs -d,))
				opX=${args[0]}
				opY=${args[1]}

				if	[ "$(getMapInfo $opX $opY 'CNM')" != 'DOR' ] ; then
					dspCmdLog "$(sayRnd "$CNST_RND_DOOR")"
				elif
					[ "$(getMapInfo $opX $opY 'STS')" = '1' ] ; then
					dspCmdLog "もう開いてる。"
				else
					modMsg 1 1 'ひらけごま！'
					openDoor $opX $opY 
				fi
				dispAll $CNST_YN_Y
			fi
			}
		}
	: 'clコマンド' && {
		###########################################
		##cl
		## ドアを閉じる。施錠はできない。
		##  $1 閉じ先座標(1〜9,zxcasdqwe)
		##                        ※大文字でも良い
		###########################################
		function cl(){

			declare clX=''
			declare clY=''
			declare direction="$1"
			declare args=()

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] || [ "$1" = '' ]; then
				dspCmdLog '<cl>引数はひとつだけ指定してください。'
				dispAll $CNST_YN_Y
				return
			fi
			##$1のバリエーション
			if  [ ! $(echo 'VZXCASDQWEvzxcasdqwe0123456789' | grep "$1") ] ; then
				dspCmdLog '<cl>0〜9とvzxcasdqwe(と大文字)から1つ指定。'
				dispAll $CNST_YN_Y
				return
			fi

			#0Vvだったらキャンセル、5Ssだったら無視
			if  [ $(echo '0Vv' | grep "$direction") ] ; then
				dspCmdLog '<cl>キャンセルしました'
				return
			fi
			if  [ $(echo '5Ss' | grep "$1") ] ; then
				:
			else

				#移動先座標を,区切りで取得
				args=($(echo $(clcDirPos "$direction")|xargs -d,))
				clX=${args[0]}
				clY=${args[1]}

				if	[ "$(getMapInfo $clX $clY 'CNM')" != 'DOR' ] ; then
					dspCmdLog "$(sayRnd "$CNST_RND_DOOR")"
				elif
					[ "$(getMapInfo $clX $clY 'STS')" = '0' ] ; then
					dspCmdLog "閉まってるよ。"
				else				modMsg 1 1 'ばたん。'
					closeDoor $clX $clY 
				fi
				dispAll $CNST_YN_Y
			fi
			}
		}
	: 'ivコマンド' && {
		###########################################
		##iv
		## 調べる
		##  $1 調べる方向(1〜9,zxcasdqwe)
		##                        ※大文字でも良い
		###########################################
		function iv(){

			declare posX=$((10#${lnSeed[1]:1:2}-1))
			declare posY=$((10#${lnSeed[2]:1:2}-1))

			declare ivX=''
			declare ivY=''
			declare direction="$1"
			declare args=()

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] || [ "$direction" = '' ]; then
				dspCmdLog '<iv>引数はひとつだけ指定してください。'
				dispAll $CNST_YN_Y
				return
			fi
			##$1のバリエーション
			if  [ ! $(echo 'VZXCASDQWEvzxcasdqwe0123456789' | grep "$1") ] ; then
				dspCmdLog '<iv>0〜9とvzxcasdqwe(と大文字)から1つ指定。'
				dispAll $CNST_YN_Y
				return
			fi

			#0Vvだったらキャンセル、5Ssだったら足踏み
			if  [ $(echo '0Vv' | grep "$1") ] ; then
				dspCmdLog '<iv>キャンセルしました'
				return
			fi

			#移動先座標を,区切りで取得
			args=($(echo $(clcDirPos "$direction")|xargs -d,))
			ivX=${args[0]}
			ivY=${args[1]}

			if  [ $(echo '5Ss' | grep "$1") ] ; then
				##今は足元以外を調べる行動と足元を調べる行動は、マスが違うだけで処理内容は同じ。
				##いずれ足元と足元以外で範囲を変更するなどあるかもしれないのでif分岐は残置する
				dspCmdLog "$(($ivX+1)):$(($ivY+1))を調べた。"
				modMsg 1 1 "リグル:$(($ivX+1)):$(($ivY+1))は$(getMapInfo $ivX $ivY $NME)だ。"
			else
				
				dspCmdLog "$(($ivX+1)):$(($ivY+1))を調べた。"
				modMsg 1 1 "リグル:$(($ivX+1)):$(($ivY+1))には$(getMapInfo $ivX $ivY $NME)があるよ。"
			fi
			dispAll $CNST_YN_Y
			}
		}
	: 'pkコマンド' && {
		###########################################
		##pk
		## 拾う
		## 引数なし		
		###########################################
		function pk(){

			declare posX=${lnSeed[1]:1:2}
			declare posY=${lnSeed[2]:1:2}
			declare maptipFoot=${lnSeed[20]:47:1}

			if	[ $foot = '' ] ; then
				dipCmdLog 1 1 'なにもない。'
			else 
				modMsg 1 1 "リグル:$posX:$posYで$maptipFootを拾った。"
			fi
			
			dispAll $CNST_YN_Y
			}
		}
	: 'daコマンド' && {
		###########################################
		##da
		## キャラ('¥'で示す)がダッシュする
		## 進入不能マスに当たるか「+」マスに隣接するまで直進を続ける。
		##  $1 移動先座標(1〜9,zxcasdqwe)   
		##        ※大文字でも良い
		###########################################
		function da(){
			declare goX=''
			declare goY=''
			declare direction=$1

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] || [ "$direction" = '' ]; then
				dspCmdLog '<da>引数はひとつだけ指定してください。'
				dispAll $CNST_YN_Y
				return
			fi
			##$1のバリエーション
			if  [ ! $(echo 'VZXCASDQWEvzxcasdqwe0123456789' | grep "$1") ] ; then
				dspCmdLog '<da>0〜9とvzxcasdqwe(と大文字)から1つ指定。'
				dispAll $CNST_YN_Y
				return
			fi

			tput civis

			#0Vvだったらキャンセル、5Ssだったら足踏み
			if  [ $(echo '0Vv' | grep "$direction") ] ; then
				dspCmdLog '<da>キャンセルしました'
				return
			fi
			if  [ $(echo '5Ss' | grep "$direction") ] ; then
				dspCmdLog 'Hoppn'"'"'nnnnn!'
			else

				#移動先座標を,区切りで取得
				##最低1回は実行する
				args=($(echo $(clcDirPos "$direction")|xargs -d,))
				goX=${args[0]}
				goY=${args[1]}

				#進行方向が通常床である限り直進する
				while [ "$(getMapInfo $goX $goY 'DSP')" = ' ' ]
				do
					goAheadWrgl $goX $goY
					#移動先座標を,区切りで取得
					args=($(echo $(clcDirPos "$direction")|xargs -d,))
					goX=${args[0]}
					goY=${args[1]}
				done

				declare posX=$((10#${lnSeed[1]:1:2}))
				declare posY=$((10#${lnSeed[2]:1:2}))

				modDspWrglPos $posX $posY "$(getMapInfo $((posX-1)) $((posY-1)) 'DSP')"
				
				#実行メッセージ
				dspCmdLog $(sayRnd $CNST_RND_DASH)

			fi

			dispAll $CNST_YN_Y
			tput cvvis
			}
		}
	: 'mnコマンド' && {
		###########################################
		##mn
		## メニューを開く
		##  引数なし
		###########################################
		function mn(){
			cmdMode="$CNST_CMDMODE_MENU1"
			joinFrameOnMenu
			selMenuId=1
			dispAll $CNST_YN_Y
			}
		}
	: 'cmコマンド' && {
		###########################################
		##cm
		## メニューを閉じる（ステータス表示に戻る）
		##  引数なし
		###########################################
		function cm(){
			cmdMode="$CNST_CMDMODE_NRML0"
			joinFrameOnStatus
			dispAll $CNST_YN_Y
			}
		}
	: 'itコマンド' && {
		###########################################
		##it
		## アイテムを開く
		##  引数なし
		###########################################
		function it(){
			#cmdMode="$CNST_CMDMODE_NRML0"
			joinFrameOnItem
			dispAll $CNST_YN_N
			}
		}
	: 'ciコマンド' && {
		###########################################
		##ci
		## アイテムを閉じる（ステータス表示に戻る）
		##  引数なし
		###########################################
		function ci(){
			cmdMode="$CNST_CMDMODE_NRML0"
			retLnSeed
			dispAll $CNST_YN_Y
			}
		}
	: 'テストコマンド' && {
		##テストコマンドなので雑
		function te(){
			dspCmdLog 'aaaaaaaああああｱｱｱｱ'
			dispAll $CNST_YN_Y
			}
		}

	}
: '■主幹処理系' && {
	: 'メインループ' && {
		###########################################
		##mainLoop
		## 主処理の基幹
		## 移動とコマンド呼び出しを反復し続ける。
		###########################################
		mainLoop(){
			jmpPosWrgl 20 6
			dspCmdLog 'リグルくん爆誕！！'
			dispAll $CNST_YN_Y
			while :
			do
				tput cup $CNST_POS_CMDWIN
				getChrH
				#移動入力として1文字受け付ける。移動を指示しない入力だった場合
				#任意長のコマンド受付にリダイレクトされる。
				case "$cmdMode" in
					#通常時はmvコマンドのショートカットが有効
					"$CNST_CMDMODE_NRML0"	)
						case "$inKey" in
							[1Z]	)	mv 1;;
							[2X]	)	mv 2;;
							[3C]	)	mv 3;;
							[4A]	)	mv 4;;
							[5S]	)	mv 5;;
							[6D]	)	mv 6;;
							[7Q]	)	mv 7;;
							[8W]	)	mv 8;;
							[9E]	)	mv 9;;
							*	)	getCmdInMain;;
						esac
						;;

					"$CNST_CMDMODE_MENU1"	)
						#メニュー表示時はmvコマンドのショートカットが無効化され
						#メニューないカーソルの移動といくつかのコマンドが生存する
						case "$inKey" in
							''		)	
										case "$selMenuId" in
										16	)
											cmdMode=$CNST_CMDMODE_MENU2
											getCmdInMain $selMenuId
											cmdMode=$CNST_CMDMODE_NRML0
											joinFrameOnStatus
											;;
										17	)
											cmdMode=$CNST_CMDMODE_NRML0
											joinFrameOnStatus
											;;
										*	)
											joinFrameOnMenu2;;
										esac
										;;
							[2X]	)	movMenuCsr $CNST_CSR_MVTO_DN;;
							[8W]	)	movMenuCsr $CNST_CSR_MVTO_UP;;
							*		)	;;
						esac

						#いずれにしても全画面の更新再表示は行う
						dispAll $CNST_YN_Y
						;;
				esac
				clrCmdLog
			done
			}
		}
	: 'コマンド受付' && {
		###########################################
		##getCmdInMain
		## mainLoopから呼び出される任意長コマンド受付
		## 各種コマンド割り振りと制御
		##  $1:メニュー内コマンド選択で呼び出された場合の引数
		###########################################
		function getCmdInMain(){

			case "$cmdMode" in
				#通常時は続けてコマンドを取得し、各種コマンドを起動する
				"$CNST_CMDMODE_NRML0"	)
					inKey2="$inKey"
					printf "$inKey2"
					getChrV
					inKey="${inKey2}${inKey}"
	
					case "$inKey" in
						'man can')	man can;;
						*'can'	)	dspCmdLog 'OK、キャンセルしたよ:)'
									dispAll $CNST_YN_Y;;
						'te'	)	te;;
						'??'	)	viewHelp;; 
						'man'*	)	man "${inKey:4}";;
						'mv'*	)	mv "${inKey:3}";;
						'op'*	)	op "${inKey:3}";;
						'cl'*	)	cl "${inKey:3}";;
						'da'*	)	da "${inKey:3}";;
						'pk'*	)	pk;;
						'qq'	)	da 7;;
						'ww'	)	da 8;;
						'ee'	)	da 9;;
						'aa'	)	da 4;;
						'dd'	)	da 6;;
						'zz'	)	da 1;;
						'xx'	)	da 2;;
						'cc'	)	da 3;;
						'mn'	)	mn;;
						'it'*	)	it;;
						'ci'*	)	ci;;
						'sv'*	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'sq'*	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'ki'*	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'wp'*	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'ct'*	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'iv'*	)	iv "${inKey:3}";;
						'gt'*	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'tr'*	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'tk'*	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'pr'*	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'ss'	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						'qqq'	)	quitGame;;
						#'sv'	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						#'sq'	)	dspCmdLog "[$inKey]コマンドは未実装です";;
						''		)	dspCmdLog '入力してください。';;
						*		)	dspCmdLog "[$inKey]は無効です。";;
					esac;;

				#メニュー表示時は
				"$CNST_CMDMODE_MENU1"	)
					inKey2="$inKey"
					printf "$inKey2"
					getChrV
					inKey="${inKey2}${inKey}"

					case "$inKey" in
						'man can')	man can;;
						*'can'	)	dspCmdLog 'OK、キャンセルしたよ:)'
									dispAll $CNST_YN_Y;;
						'man'*	)	man "${inKey:4}";;
						'??'	)	viewHelp;; 
						'mv'*	)	mv "${inKey:3}";;
						'cm'	)	cm;;
						'qqq'	)	quitGame;;
						''		)	dspCmdLog '入力してください。';;
						*		)	dspCmdLog "[$inKey]は無効です。";;
					esac
					dispAll $CNST_YN_Y
					;;
				"$CNST_CMDMODE_MENU2"	)
					case $selMenuId in
						'1' )	iv $1;;
						'2' )	op $1;;
						'3' )	cl $1;;
						'4' )	dspCmdLog "[$selMenuId]は未実装です。";;
						'5' )	dspCmdLog "[$selMenuId]は未実装です。";;
						'6' )	dspCmdLog "[$selMenuId]は未実装です。";;
						'7' )	dspCmdLog "[$selMenuId]は未実装です。";;
						'8' )	dspCmdLog "[$selMenuId]は未実装です。";;
						'9' )	dspCmdLog "[$selMenuId]は未実装です。";;
						'10')	dspCmdLog "[$selMenuId]は未実装です。";;
						'11')	dspCmdLog "[$selMenuId]は未実装です。";;
						'12')	dspCmdLog "[$selMenuId]は未実装です。";;
						'13')	dspCmdLog "[$selMenuId]は未実装です。";;
						'14')	dspCmdLog "[$selMenuId]は未実装です。";;
						'15')	man ;;
						'16')	viewHelp ;;
						'17')	cm ;;
						'18')	quitGame ;;
						*		)	dspCmdLog "[$selMenuId]は無効です。";;
					esac
					dispAll $CNST_YN_Y
					;;
				*	) dspCmdLog "[$inKey]は無効です。";;
			esac
		}
		}
	}
: '■メイン' && {
	###########################################
	##main
	## mainLoopをキックする主制御
	###########################################
	
	clear
	trap 'quitGame' INT QUIT TSTP

	initDef
	defMapInfo
	defItemInfo
	defStatusInfo
	defMenuInfo
	defMenuInfo2
	dspMapInfo
	initDispInfo 
	joinFrameOnMap
	joinFrameOnStatus

	dispAll $CNST_YN_Y

	mainLoop
	#主処理

	#終了時に文字修飾を除去し、画面をクリアする
	quitGame
	}
