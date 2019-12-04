##処理の定義
	##################################################
	##getCntSingleWidth
	## 与えられた文字列が、半角文字相当で何文字分に当たるか判定する。
	## マルチバイト文字を2、それ以外を1としたいがよくわからないので、可能そうな記号のみ
	##  $1:カウント対象の文字
	##################################################
	function getCntSingleWidth(){

		local declare cntStr="$1"

		#半角英数記号以外の文字以外を消す=半角文字数
		local declare cntS=$(echo -n "$cntStr" | sed -e 's@[^A-Za-z0-9~!@#$%&_=:;><,*+.?{}()\ -|¥]@@g' | wc -m)

		#半角英数記号の文字を消す=全角文字数
		local declare cntW=$(echo -n "$cntStr" | sed -e 's@[A-Za-z0-9~!@#$%&_=:;><,*+.?{}()\ -|¥]@@g' | wc -m)

		#全角文字数を示すcntWは二倍して、2つを足す
		echo -n "$(($(($cntW * 2))+$cntS))"

	}

	##################################################
	##crrctStr
	## 使用頻度が高い障害文字を置換するためのもの。
	## 【できれば必須呼び出しにしたいがどうするか】
	## ・半角カタカナは全角カタカナにする。
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
		local declare cnvstr="$1"

		cnvstr=${cnvstr//'¥'/'￥'}      #¥
		cnvstr=$(echo "$cnvstr" | nkf)  #半角カナ
		cnvstr=${cnvstr//'['/'［'}		#[
		cnvstr=${cnvstr//']'/'］'}		#]
		cnvstr=${cnvstr//'…'/'...'}	   #三点リーダ
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

	###########################################
	##getChrV
	## 任意の文字数入力受付(エコーバックあり)。
	## mainで定義しているグローバルinKeyをクリアしてから、入力値で上書き
	###########################################
	function getChrV(){
		inKey=''
		read inKey
	}

	###########################################=
	##getChrH
	## なんか1文字の入力受付(エコーバックなし)。
	## mainで定義しているグローバルinKeyをクリアしてから、入力値で上書き
	###########################################
	function getChrH(){
		inKey=''
		read -s -n 1 inKey
	}

	###########################################
	##getCmd
	## コマンドを受け取る
	##  ただの getChrVのラッピング
	###########################################
	function getCmd(){
		tput cup $CNST_POS_CMDWIN
		getChrV
	}

	##################################################
	##wk
	## キー待ち
	##  キー待ち記号を天っ滅表示し、SPACEかENTERを待つ
	##################################################
	function wk(){

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
	###########################################
	##jgDrctn
	## 進入マスの判定
	## 対象のマスと判別種類ごとに応じた値を返却する
	##  $1:X座標
	##  $2:Y座標
	##  $3:判別種類(CNST_JGDIV_ACCESS:進入可否
	##              CNST_JGDIV_OBJECT:オブジェクト種類)
	###########################################
	function jgDrctn(){

		#バリデーション
		##引数の個数
		if [ $# -ne 3 ]; then
			sysOut 'e' $LINENO 'Set 2 arguments.'
			return
		fi
		##$1の範囲
		if [ $1 -lt 1 ] || [ $1 -gt $CNST_MAP_SIZ_X ]; then
			sysOut 'e' $LINENO "'X' must be between 1 and $CNST_MAP_SIZ_X."
			return
		fi
		##$2の範囲
		if [ $2 -lt 1 ] || [ $2 -gt $CNST_MAP_SIZ_Y ]; then
			sysOut 'e' $LINENO "'Y' must be between 1 and $CNST_MAP_SIZ_Y."
			return
		fi
		##$3の範囲
		if [ $3 -lt 1 ] || [ $3 -gt 2 ]; then
			sysOut 'e' $LINENO 'Choose 1 or 2.'
			return
		fi

		local declare objDrction="${lnSeed[$((10#$2+3))]:$((10#$1+3)):1}"

		#判定と返却
		case "$3" in
			$CNST_JGDIV_ACCESS	)	#進入可否判断
					case "$objDrction" in
						' '	)	echo $CNST_ACSS_ACCESSABLE ;;
						'#'	)	echo $CNST_ACSS_ACCESSABLE ;;
						'*'	)	echo $CNST_ACSS_ACCESSABLE ;; #マップ未開示状態の実装後、[*]は無条件進行可能ではなくなる
						'-'	)	echo $CNST_ACSS_CANTENTER  ;;
						'='	)	echo $CNST_ACSS_CANTENTER  ;;
						'+'	)	echo $CNST_ACSS_CANTENTER  ;;
						'|'	)	echo $CNST_ACSS_CANTENTER  ;;
						'X'	)	echo $CNST_ACSS_CANTENTER  ;;
						'D'	)	echo $CNST_ACSS_CANTENTER  ;; 
						*	)	dspCmdLog '<jgEntr> Unimplemented object.' $CNST_DSP_ON
					esac
					;;
			$CNST_JGDIV_OBJECT	)	#オブジェクト種類
					case "$objDrction" in
						' '	)	echo $CNST_FLOR_NORMALFLOOR ;;
						'#'	)	echo $CNST_FLOR_JUNCTION    ;;
						'*'	)	echo $CNST_FLOR_NORMALFLOOR ;; #マップ未開示状態の実装後、[*]は無条件通常床ではなくなる
						'-'	)	echo $CNST_FLOR_HEAVYWALL   ;;
						'='	)	echo $CNST_FLOR_HEAVYWALL   ;;
						'+'	)	echo $CNST_FLOR_HEAVYWALL   ;;
						'|'	)	echo $CNST_FLOR_HEAVYWALL   ;;
						'X'	)	echo $CNST_FLOR_HEAVYWALL   ;;
						'D'	)	echo $CNST_DOR_LOCKED1      ;; 
						*	)	dspCmdLog '<jgEntr> Unimplemented object.' $CNST_DSP_ON
					esac
					;;		
			*	)	dspCmdLog "<jgEntr> Invalid Div:$3" $CNST_DSP_ON
		esac
	}

	###########################################
	##clcDirPos
	## 進入マスの座標計算
	##  $1:方向指示(1-9,zxcasdqwe)
	###########################################
	function clcDirPos(){
		local declare posX=${lnSeed[1]:1:2}
		local declare posY=${lnSeed[2]:1:2}
		local declare dirct=$1
		local declare dirX=0
		local declare dirY=0
		local declare tgtX=0
		local declare tgtY=0

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
					dspCmdLog 'Cmd canceled.'  $CNST_DSP_ON
					return
					;;
			*		)	sysOut 'e' $LINENO 'Direction value Error.'
		esac

		tgtX=$((10#$posX+dirX))
		tgtY=$((10#$posY+dirY))

		echo "$tgtX:$tgtY"

	}

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
			sysOut 'e' $LINENO 'Set 2 arguments.'
			return
		fi
		##$1の範囲
		if [ $1 -lt 1 ] || [ $1 -gt $CNST_MAP_SIZ_X ]; then
			sysOut 'e' $LINENO "'X' must be between 1 and $CNST_MAP_SIZ_X."
			return
		fi
		##$2の範囲
		if [ $2 -lt 1 ] || [ $2 -gt $CNST_MAP_SIZ_Y ]; then
			sysOut 'e' $LINENO "'Y' must be between 1 and $CNST_MAP_SIZ_Y."
			return
		fi

		local declare mapX=$((10#$1))
		local declare mapY=$((10#$2))

		local declare lStr="${lnSeed[$((mapY+3))]:0:$((mapX+3))}"
		local declare rStr="${lnSeed[$((mapY+3))]:$((mapX+4))}"

		lnSeed[$((mapY+3))]="${lStr} ${rStr}"
		
		modDspWrglPos $1 $2
		dispAll

	}

	##################################################
	##sayRnd
	## ランダム出力表現生成
	##  何度も繰り返すことができる行動に対する出力を
	##  ランダム生成する。10パターン固定、減らす場合は結果重複で制限する
    ##   $1:出力するタイプ(CNST_RND_????)
	##################################################
	function sayRnd(){

		local declare rslt=$(($RANDOM % 10))
		
		case "$1" in
			$CNST_RND_WALL	)	#ぶつかる音
					case "$rslt" in
						'0'	)	echo 'Thud!';;
						'1'	)	echo 'Thump!!';;
						'2'	)	echo 'Bonk';;
						'3'	)	echo 'Ou!';;
						'4'	)	echo 'Ouch!';;
						'5'	)	echo 'Can not go any further.';;
						'6'	)	echo 'Do not push!';;
						'7'	)	echo 'Thud.';;
						'8'	)	echo 'Thud!!';;
						'9'	)	echo 'Bonk!';;
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
						*	)	sysOut 'e' $LINENO '<sayRnd> Arg Error.'
					esac
					;;
			*	)	sysOut 'e' $LINENO '<sayRnd> Arg Error.'
		esac

	}
##画面系
	##################################################
	## 画面の初期表示情報
	##   lnSeed[]に初期表示情報を格納する
	##################################################
	function initDispInfo() {

		declare -a -g lnSeed=() ##0から25までの26要素用意するつもり。

		#初期状態 0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
		#文字数   1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		lnSeed+=('+--+------------------------------------------------------------++------------+----------+---------+') #00
		lnSeed+=('|01|000000000111111111122222222223333333333444444444455555555556||Wriggle     |Bug       |Fighter  |') #01
		lnSeed+=('|01|123456789012345678901234567890123456789012345678901234567890|+--+---------+----------+---------+') #02
		lnSeed+=('+--+------------------------------------------------------------+|HP| 100/ 100|BLv: 1=     0/    10|') #03
		lnSeed+=('|01|+---------------------------+-----------------------+XXXXXXX||MP| 100/ 100|JLv: 1=     0/    10|') #04
		lnSeed+=('|02||***************************D***********************|XXXXXXX|+--+--+--+--++-+--++--+--+--+--+--+') #05
		lnSeed+=('|03||***************************+-+-------------+D+-----+XXXXXXX||✝|💊|💤|❔|🔇|👓||💪|🛡|🔯|🏃|🍀|') #06
		lnSeed+=('|04|+***************************|X|*********************|XXXXXXX|+--+--+--+--+--+--++--+--+--+--+--+') #07
		lnSeed+=('|05|#***************************|X|*********************|XXXXXXX|| 0| 0| 0| 0| 0| 0|| 0| 0| 0| 0| 0|') #08
		lnSeed+=('|06|#***************************|X+--+******************+----+XX|+--+--+--+--+--+--++--+--+--+--+--+') #09
		lnSeed+=('|07|#***************************|XXXX|***********************|XX||  VAL - STS - PAR |🔨|⛰|💧|🔥|🌪|') #10
		lnSeed+=('|08|+***************************|XXXX|******************+--+*|XX||*  10 < Str > Atk |10|10|10|10|10|') #11
		lnSeed+=('|09||***************************|XXXX+------------------+XX|*|XX||   10 < Int > Mat |10|10|10|10|10|') #12
		lnSeed+=('|10||v**************************|XXXXXXXXXXXXXXXXXXXXXXXXXX|*|XX||   10 < Vit > Def |10|10|10|10|10|') #13
		lnSeed+=('|11|+---------------------------+--------------------------+D+XX||   10 < Mnd > Mdf |10|10|10|10|10|') #14
		lnSeed+=('|12||********************************************************|XX||   10 < Snc > XBns| 1  %+==+=====+') #15
		lnSeed+=('|13|+-+D+-+-------------------+*+---------------+************|XX||   10 < Dex > Hit |10  %|Jw|    0|') #16
		lnSeed+=('|14||*****|XXXXXXXXXXXXXXXXXXX|*|XXXXXXXXXXXXXXX+------------+XX||   10 < Agi > Flee|10  %|Gd|    0|') #17
		lnSeed+=('|15|+-----+XXXXXXXXXXXXXXXXXXX+#+XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX||   10 < Luk > Cri |10  %|Sv|   50|') #18
		lnSeed+=('+==+=============================================+==============++==================+=====+==+=====+') #19
		lnSeed+=('|COMMAND>                                        |                                                 |') #20
		lnSeed+=('+==+=============================================+===========================input [??] to help.===+') #21
		lnSeed+=('|91|                                                                                               |') #22
		lnSeed+=('|92|                                                                                               |') #23
		lnSeed+=('|93|                                                                                               |') #24
		lnSeed+=('|94|                                                                                               |') #25
		lnSeed+=('|95|                                                                                               |') #26
		lnSeed+=('+--+-----------------------------------------------------------------------------------------------+') #27
	}

	##################################################
	## 画面の全情報を更新表示
	##   lnSeed[]で画面を更新する
	##   自キャラ位置に「¥」を強調表示で上書きする。
	##################################################
	function dispAll(){
		clear

		for ((i = 0; i < ${#lnSeed[*]}; i++)) {
			echo "${lnSeed[i]}"
		}

		local declare posX=$((10#${lnSeed[1]:1:2}+3))
		local declare posY=$((10#${lnSeed[2]:1:2}+3))

		tput sc
		tput cup $posY $posX
		tput setab 2
		tput setaf 0
		tput blink
		echo '¥'
		tput sgr0
		tput rc

	}

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

		local declare   errDiv=''
		local declare   bColor=0
		local declare   fColor=0
		local declare wdthSize=0
		local declare   MAPdth=0
		local declare   lrWdth=0

		inKey=''

		tput smcup
		clear

		case "$1" in
				'e'	)	errDiv='Error'
						bColor=1
						fColor=7
						;;
				'w'	)	errDiv='Warning'
						bColor=7
						fColor=0
						;;
				#'i'	)	errDiv='Information';;
				*	)	errDiv='FatalError'
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
				dispAll
				break
			else
				echo 'Invalid input. press [q] to exit.'
			fi
		done
	}

	##################################################
	##clrMAPin
	## lnSeed[22〜26]を初期表示の内容で上書きして画面をクリア更新する
	##  $1 lnSeed更新後にmsgウィンドウを更新するか(CNST_DSP_ON:する/他:しない)
	##################################################
	function clrMAPin(){

		lnSeed[20]='|COMMAND>                                        |                                                 |' #20

		lnSeed[22]='|91|                                                                                               |' #22
		lnSeed[23]='|92|                                                                                               |' #23
		lnSeed[24]='|93|                                                                                               |' #24
		lnSeed[25]='|94|                                                                                               |' #25
		lnSeed[26]='|95|                                                                                               |' #26

		#引数が1だったら、画面を更新する。
		if [ "$1" = $CNST_DSP_ON ] ; then
			dispAll
		fi

	}

	##################################################
	##clrCmdLog
	## lnSeed[20]を初期表示の内容で上書きして画面をクリア更新する
	##  $1 lnSeed更新後にmsgウィンドウを更新するか(CNST_DSP_ON:する/他:しない)
	##################################################
	function clrCmdLog(){

		lnSeed[20]='|COMMAND>                                        |                                                 |'

		#引数が1だったら、画面を更新する。
		if [ "$1" = $CNST_DSP_ON ] ; then
			dispAll
		fi

	}

	###########################################
	##modDspWrglPos
	## Wriggleの現在座標を画面表示情報へ反映する
	## この関数は座標移動処理を行う他の関数から呼び出されるのみで
	## 直接mainから呼び出されることはない
	##  $1 X座標(1 〜 CNST_MAP_SIZ_X)
	##  $2 Y座標(1 〜 CNST_MAP_SIZ_Y)
	###########################################
	function modDspWrglPos(){
		local declare X=$(printf "%02d" "$1")
		local declare Y=$(printf "%02d" "$2")

		local declare row1Right="${lnSeed[1]:3}"
		local declare row2Right="${lnSeed[2]:3}"

		lnSeed[1]="|$X$row1Right"
		lnSeed[2]="|$Y$row2Right"
		dispAll

	}

	##################################################
	##modMsg
	## メッセージウィンドウの表示情報を変更する
	## 表示内容を変えるだけで表示の更新はしない
	## カウント前に、crctStrで不正文字を近い文字に置換する
	##  $1 メッセージウィンドウの何行目か
	##  $2 メッセージウィンドウ$1行目の何文字目からか
	##  $3 表示する文字
	##  $4 lnSeed更新後にmsgウィンドウを更新するか(CNST_DSP_ON:する/他:しない)
	##################################################
	function modMsg(){

		#バリデーション
		##引数の個数
		if [ $# -ne 4 ] ; then
			sysOut 'e' $LINENO 'Set 4 arguments.'
			return
		fi
		##$1の範囲
		if [ $1 -lt 1 ] || [ $1 -gt $CNST_MSG_SIZ_X ]; then
			sysOut 'e' $LINENO "StartColumnIndex must be between 1 and $CNST_MSG_SIZ_X."
			return
		fi
		##$2の範囲
		if [ $2 -lt 1 ] || [ $2 -gt $CNST_MSG_SIZ_Y ]; then
			sysOut 'e' $LINENO "StartRowIndex must be between 1 and $CNST_MSG_SIZ_Y."
			return
		fi

		local declare tgtRow=$1
		local declare tgtClmn=$(($2+3))
		local declare tgtStr=$(crrctStr "$3")
		
		local declare leftStr="${lnSeed[21+$tgtRow]:0:$tgtClmn}"

		#文字長が右端を出ないように切り捨てる。
		#半角相当の文字数が95以下になるまで、末尾から1文字ずつ切り捨て続ける
		#半角全角が混じる場合に正確に切り捨てる長さを指定できないため
		local declare tmpStr="$tgtStr"
		local declare tmpCntSingleWidth=0
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

		local declare spCnt=$((99-$(getCntSingleWidth "$leftStr$tgtStr")))
		#getCntSingleWidth()で半角相当の文字数をカウント
		#100文字-|1文字=99、-文字数でSPACEの反復数

		lnSeed[$((21+$tgtRow))]="$leftStr$tgtStr`printf %${spCnt}s`|"

		#引数4が1だったら、画面を更新する。
		if [ "$4" = $CNST_DSP_ON ] ; then
			dispAll
		fi

	}

	###########################################
	##dspCmdLog
	## コマンド結果等簡易表示ウィンドウの更新
	##   $1 表示内容
	##   $2 lnSeed更新後にmsgウィンドウを更新するか(CNST_DSP_ON:する/他:しない)
	##################################################
	function dspCmdLog(){

		#バリデーション
		##引数の個数
		if [ -z "$1" ] || [ -n "$3" ] ; then			
			sysOut 'e' $LINENO "Set 1 or 2 arguments. $1/$2"
			return
		fi

		local declare tgtStr="$(crrctStr "$1")"
		local declare leftStr="${lnSeed[20]:0:$CNST_CMDLGW_IDX}"


		#文字長が右端を出ないように切り捨てる。
		#半角相当の文字数が50以下になるまで、末尾から1文字ずつ切り捨て続ける
		#半角全角が混じる場合に正確に切り捨てる長さを指定できないため
		local declare tmpStr="$tgtStr"
		local declare tmpCntSingleWidth=0
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

		local declare spCnt=$((99-$(getCntSingleWidth "$leftStr$tgtStr")))
		#getCntSingleWidth()で半角相当の文字数をカウント
		#100文字-|1文字=99、-文字数でSPACEの反復数

		lnSeed[20]="$leftStr$tgtStr`printf %${spCnt}s`|"

		#引数2が1だったら、画面を更新する。
		if [ "$2" = $CNST_DSP_ON ] ; then
			dispAll
		fi
	}

##ゲーム中ユーザが使用するコマンド
	##################################################
	##viewHelp
	## コマンドヘルプ
	##   termcapによって上にかぶせる
	##################################################
	function viewHelp(){

		inKey=''

		tput smcup

		clear
		echo '***Command List***  Press [q]key to exit.'
		echo ''
		echo 'man [CMD]   : [CMD] CommandManual'
		echo '[...]can    : Cancel a command being entered.'
		echo 'sv [n]      : Save to data [n] the current state.'
		echo 'sq [n]      : Save to data [n] the current state and quit this game.'
		echo 'qq          : Quit this game (without save).'
		echo 'mv [n]      : Move in direction [n]'
		echo 'op [n]      : Open the door in the direction of [n] (by suitable key).'
		echo 'ki [m][n]   : Kick in direction [n] with [n]strength'
		echo 'wp [n]      : Attack in direction [n] with Wapon'
		echo 'ct [m][n]   : Cast [m]Magic in direction [n]'
		echo 'in [n]      : Inspect in direction [n]'
		echo 'gt [n]      : Get in direction [n]'
		echo 'tr [m][n]   : Throw [m] item in direction [n]'
		echo 'tk [n]      : Talk in direction [n]'
		echo 'pr [n]      : Pray for [n]'
		echo 'ss          : Suiside!'

		while :
		do
			getChrH
			if [ "$inKey" = 'q' ]; then
				tput rmcup
				dispAll
				break
			else
				echo "$inKey is invalid. press [q] to exit."
			fi
		done

	}
	##################################################
	##man
	## マニュアル参照
	##  引数で渡されたコマンドのマニュアルを表示する。
	##   $1 参照先コマンド
	##################################################
	function man(){		
		case "$1" in
			'can'	) man_can ;;
			'mv'	) man_mv ;;
#			'op'	) man_op ;;
			'pp'	) man_pp ;;
			'ki'	) man_ki ;;
			'wp'	) man_wp ;;
			'ct'	) man_ct ;;
			'in'	) man_in ;;
			'gt'	) man_gt ;;
			'tr'	) man_tr ;;
			'tk'	) man_tk ;;
			'pr'	) man_pr ;;
			'ss'	) man_ss ;;
			'man'	) man_man ;;
			''		) dspCmdLog 'no argment error.'  1 ;;
			*		) dspCmdLog "[$1] is Invalid CMD." 1 ;;
		esac
	}
	#-------------------------------------------------
	#manコマンドによって呼び出される子関数
	#-------------------------------------------------
		#-------------------------------------------------
		#man_can
		# canコマンドのマニュアル表示
		#-------------------------------------------------
		function man_can(){

            inKey=''
			tput smcup

			clear

			echo '*** Command Manual:[can] ***'
			echo '<Format>'
			echo ' [...]can'
			echo ' * no arg. For all previous inputs.'
			echo ''
			echo '<Function>'
			echo ' When the command input is completed with "can" at the end,'
			echo '      all input commands are canceled.'
			echo ' There seems to be milk returning from the floor to the cup.'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'
			
            while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}

		#-------------------------------------------------
		#man_sq
		# sqコマンドのマニュアル表示
		#-------------------------------------------------
		function man_sq(){

            inKey=''
			tput smcup

			clear

			echo '*** Command Manual:[sq] ***'
			echo '<Format>'
			echo ' sq [n]'
			echo ' * arg:1-4.'
			echo ''
			echo '<Function>'
			echo ' Save to data [n] the current state and quit this game.'
			echo ' Do not forget to write a diary before going to bed.'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'
			
            while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_sv
		# svコマンドのマニュアル表示
		#-------------------------------------------------
		function man_sv(){

            inKey=''
			tput smcup

			clear

			echo '*** Command Manual:[sv] ***'
			echo '<Format>'
			echo ' sv [n]'
			echo ' * arg:1-4.'
			echo ''
			echo '<Function>'
			echo ' Save to data [n] the current state.'
			echo ' The diary will help you, unless you look into it.'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'
			
            while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}

		#-------------------------------------------------
		#man_qq
		# qqコマンドのマニュアル表示
		#-------------------------------------------------
		function man_qq(){

            inKey=''
			tput smcup

			clear

			echo '*** Command Manual:[qq] ***'
			echo '<Format>'
			echo ' qq'
			echo ' * no arg.'
			echo ''
			echo '<Function>'
			echo ' Quit the game without save. A highly responsive exit command.'
			echo ' Holy cow, Yuka came!'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'
			
            while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_mv
		# mvコマンドのマニュアル表示
		#-------------------------------------------------
		function man_mv(){

            inKey=''
			tput smcup

			clear

			echo '*** Command Manual:[mv] ***'
			echo '<Format>'
			echo ' mv [arg]'
			echo ' * arg=1~9, [zxcasdqwe] or [ZXCASDQWE].'
			echo ''
			echo '<Function>'
			echo ' Wriggle moves 1 step [arg]. Consume 1 turn.'
			echo ' The direction of movement is determined by 1-9 or' 
			echo '     the “ZXCASDQWE” key on the left side of your keyboard'
			echo ' Enter [5]or[S]or[s] to step on the spot.'
			echo ' Entering [0] cancels the [mv] command continuation input.'
			echo ' You can move even if you omit "mv", but you may suffer from a disadvantage.'
			echo ' If [mv] is omitted, [ZXCASDQWE] must be shift qualified.'
			echo ' Even if "mv" is omitted, do not use shift qualification when specifying 0-9.'
			echo ' This means that instead of omitting "mv", you can simply enter 1-9 as usual or'
			echo '     enter the capital letter "ZXCASDQWE".'
			echo ' If you want to move carefully, it is recommended to move with the [mv] command.'
			echo ' Dungeon exploration begins with walking and ends with walking...'
			echo ' ...No, when is the end when I die? Make your picnic feel moderate. GLHF!'
			echo ''
			echo ' move to...   \  ^  /   \  ^  /   \  ^  /'
			echo '               7 8 9     q w e     Q W E '
			echo '              <4 5 6>   <a s d>   <A S D>'
			echo '               3 2 1     z x c     A X C '
			echo '              /  v  \   /  v  \   /  v  \'
			echo '              [5]or[s]or[s]  :skipThisTurn'
			echo '              [0]            :cancel'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'
			
            while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_op
		# opコマンドのマニュアル表示
		#-------------------------------------------------
#		function man_op(){
#
#            inKey=''
#			tput smcup
#
#			clear
#
#			echo '*** Command Manual:[op] ***'
#			echo '<Format>'
#			echo ' op [arg]'
#			echo ' * arg=1~9, [zxcasdqwe] or [ZXCASDQWE].'
#			echo ''
#			echo '<Function>'
#			echo ' Wriggle opens the door in the direction of [9].'
#			echo '      (for locked doors, only if you have a suitable key).'
#			echo ' Consume 1 turn.'
#			echo ' She over the door of the thorn is not always waiting for me favorably.'
#			echo ''
#			echo ' open the door...   \  ^  /   \  ^  /   \  ^  /'
#			echo '                     7 8 9     q w e     Q W E '
#			echo '                    <4 ¥ 6>   <a ¥ d>   <A ¥ D>'
#			echo '                     3 2 1     z x c     A X C '
#			echo '                    /  v  \   /  v  \   /  v  \  *5 is invalid.'
#			echo ''
#			echo '... over.'
#			echo 'Press [q]key to exit.'
#			
#            while :
#			do
#				getChrH
#				if [ "$inKey" = 'q' ]; then
#					tput rmcup
#					dispAll
#					break
#				else
#					echo 'Invalid input. press [q] to exit.'
#				fi
#			done	
#		}
		#-------------------------------------------------
		#man_ki
		# kiコマンドのマニュアル表示
		#-------------------------------------------------
		function man_ki(){

			inKey=''
			tput smcup

			clear

			echo '*** Command Manual:[ki] ***'
			echo '<Format>'
			echo ' ki [arg1] [arg2]'
			echo ' * arg1=1~9 except 5.'
			echo ' * arg2=1~9.'
			echo ''
			echo '<Function>'
			echo ' It is Called "WriggleKick".'
			echo ' Wriggle kicks [arg1] with a strength of [arg2].'
			echo ' Consume 1 turn.'
			echo ' Once used, the "WriggleKick" cannot be reused for one turn.'
			echo ' "WriggleKick" range is 1 square.'
			echo ' "Wrigglekick" is very helpful when you have no weapons.'
			echo ' Some enemies can only be defeated with "WriggleKick".'
			echo ' Because it is the first enemy, it is not necessarily OHKO.'
			echo ''
			echo ' kick to...   \  ^  /'
			echo '               1 2 3 '
			echo '              <4 ¥ 6>'
			echo '               7 8 9 '
			echo '              /  v  \'
			echo ''
			echo '<MP Cost Referance>'
			echo '  +--------+---+---+---+---+---+---+---+---+---+'
			echo '  |useLv   |  1|  2|  3|  4|  5|  6|  7|  8|  9|'
			echo '  +--------+---+---+---+---+---+---+---+---+---+'
			echo '  |Cost MP |  3|  3|  3|  7|  7|  7|  9|  9| 12|'
			echo '  +--------+-----------------------------------+'
			echo ''
			echo '<Strength>'
			echo '  ([Atk]*[useLv]*1.2)+([Atk]*[useLv-9]*0.5)'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_wp
		# wpコマンドのマニュアル表示
		#-------------------------------------------------
		function man_wp(){

			inKey=''

			tput smcup
			clear

			echo '*** Command Manual:[wp] ***'
			echo '<Format>'
			echo ' wp [arg]'
			echo ' * arg=1~9 except 5.'
			echo ''
			echo '<Function>'
			echo ' Wriggle uses a weapon to attack in [arg] directions.'
			echo ' Consume 1 turn.'
			echo ' The range depends on the weapon used.'
			echo ' There is no MP consumption except in special cases.'
			echo ' He seems to be trying to clear up the depression '
			echo '     that has always been abused by his wife(s) in the dungeon.'
			echo ''
			echo ' attack to...   \  ^  /'
			echo '                 1 2 3 '
			echo '                <4 ¥ 6>'
			echo '                 7 8 9 '
			echo '                /  v  \   *range depends wepon.'
			echo ''
			echo '<Strength>'
			echo '  ([Atk]*[weponAtk])+(|Atk-50|*[weponAtk]*0.3)'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done
		}
		#-------------------------------------------------
		#man_ct
		# ctコマンドのマニュアル表示
		#-------------------------------------------------
		function man_ct(){

			inKey=''

			tput smcup
			clear

			echo '*** Command Manual:[ct] ***'
			echo '<Format>'
			echo ' ct [arg1] [arg2]'
			echo ' * arg1=1~4.'
			echo ' * arg2=1~9.'
			echo ''
			echo '<Function>'
			echo ' Wriggle casts a [arg1] Magic in [arg2] directions.'
			echo ' When [5] is set, you are the subject.'
			echo ' Consume 1 turn.'
			echo ' The range depends on the mgic used.'
			echo ' Magic is not necessarily for attack.'
			echo ' There are also recovery, assistance, and some with more special effects.'
			echo ' Useful for exploring dungeons.'
			echo ''
			echo ' cast to...   \  ^  /'
			echo '               1 2 3 '
			echo '              <4 ¥ 6>'
			echo '               7 8 9 '
			echo '              /  v  \   *range depends magic.'
			echo ''
			echo '<Strength>'
			echo '  ([Mat]*[magicStr])+(|[Mat]-50|*[magicStr]*0.4)'
			echo ''
			echo '<MP Cost Referance>'
			echo '  MP consumed depends on the magic used, but can be reduced by [Int] value.'
			echo '    +--------+---+-----------+----------+----+'
			echo '    |int     |~30|~60        |~98       |99  |'
			echo '    +--------+---+-----------+----------+----+'
			echo '    |Cost MP |-0%|-(int/20)% |-(int/10)%|-30%|'
			echo '    +--------+---+-----------+----------+----+'
			echo '    *Reduction amount is rounded up to one decimal place.'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_in
		# inコマンドのマニュアル表示
		#-------------------------------------------------
		function man_in(){

			inKey=''

			tput smcup
			clear

			echo '*** Command Manual:[in] ***'
			echo '<Format>'
			echo ' in [arg]'
			echo ' * arg=1~9.'
			echo ''
			echo '<Function>'
			echo ' Wriggle investigates the direction of [arg]. Consume 1 turn.'
			echo ' Depending on the [Snc]value, success and failure may be separated.'
			echo ' When [5], it is foot of the Wriggle or Wriggleself.'
			echo ' Keep your antennae clean.'
			echo ''
			echo ' investigate to...   \  ^  /'
			echo '                      7 8 9 '
			echo '                     <4 ¥ 6>'
			echo '                      3 2 1 '
			echo '                     /  v  \      *[5], foot or self'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_gt
		# gtコマンドのマニュアル表示
		#-------------------------------------------------
		function man_gt(){

			inKey=''

			tput smcup
			clear

			echo '*** Command Manual:[gt] ***'
			echo '<Format>'
			echo ' gt [arg]'
			echo ' * arg=1~9.'
			echo ''
			echo '<Function>'
			echo ' Wriggle gets or picks up the one in the direction of [arg]. Consume 1 turn.'
			echo ' When [5], it is foot of the Wriggle or Wriggleself.'
			echo ' "The old tale of ants and grasshoppers" should have been that'
			echo '       the workers were exploited by wife(s) waiting in the nest. ...Is it different?'
			echo ''
			echo ' gets to...   \  ^  /'
			echo '               7 8 9 '
			echo '              <4 ¥ 6>'
			echo '               3 2 1 '
			echo '              /  v  \      *[5], foot'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_tr
		# trコマンドのマニュアル表示
		#-------------------------------------------------
		function man_tr(){

			inKey=''
			tput smcup
			clear

			echo '*** Command Manual:[tr] ***'
			echo '<Format>'
			echo ' tr [arg1] [arg2]'
			echo ' * arg1=1~9.'
			echo ' * arg2=1~9 except 5.'
			echo ''
			echo '<Function>'
			echo ' Wriggle throws [arg1] item in the direction of [arg2]. Consume 1 turn.'
			echo ' Depending on the [arg1] item type or [STR] value, the thrown item can be destroyed.'
			echo ' The winner will also take damage according to the [STR] value and [arg1] item.'
			echo ' If you are going to throw things away, be careful.'
			echo ' What I received from a woman is particularly troublesome when my wife finds it.'
			echo ''
			echo ' throw to...   \  ^  /'
			echo '                7 8 9 '
			echo '               <4 ¥ 6>'
			echo '                3 2 1 '
			echo '               /  v  \'
			echo ''
			echo '<Damege>'
			echo '  Jewel     --- [Value]*1000.0                       :Ignore the [Def].'
			echo '  Gold      --- [Value]*100.0                        :Ignore the [Def].'
			echo '  Silver    --- [Value]*1.0                          :Ignore the [Def].'
			echo '  Wepon     --- [Str]*[WeponAtk]*(RoundUp(Str/100))'
			echo '  Armor     --- [Str]*[ArmorDef]*(RoundUp(Str/150))'
			echo '  Medicine  --- [ItemRecovery]*1.0                   :Heal instead of damage.'
			echo '  OtherItem --- I do not know how to do it!'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_tk
		# tkコマンドのマニュアル表示
		#-------------------------------------------------
		function man_tk(){

			inKey=''
			tput smcup

			clear

			echo '*** Command Manual:[tk] ***'
			echo '<Format>'
			echo ' tk [arg]'
			echo ' * arg=1~9 except 5.'
			echo ''
			echo '<Function>'
			echo ' Wriggle speaks in the direction of [arg]. Consume 1 turn.'
			echo ' If you talk well, you may get along. But watch out for your wife'"'"'s gaze.'
			echo ''
			echo ' talk to...   \  ^  /'
			echo '               7 8 9 '
			echo '              <4 ¥ 6>'
			echo '               3 2 1 '
			echo '              /  v  \'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_pr
		# prコマンドのマニュアル表示
		#-------------------------------------------------
		function man_pr(){

			inKey=''
			tput smcup

			clear

			echo '*** Command Manual:[pr] ***'
			echo '<Format>'
			echo ' pr [arg]'
			echo ' * arg=1~9.'
			echo ''
			echo '<Function>'
			echo ' Wriggle prays for [arg] and asks for a miracle. Consume 1 turn.'
			echo ' I do not know what will happen, but the [Mnd] value makes it easy to do something good.'
			echo ' You can pray only to those who have idols.'
			echo ' And if you pray to one, then pray to another, you may be punished.'
			echo ' And if you pray too much, you will be punished.'
			echo ''
			echo '<Object to pray>'
			echo ' unknown'
			echo '... over.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_ss
		# ssコマンドのマニュアル表示
		#-------------------------------------------------
		function man_ss(){

			inKey=''

			tput smcup
			clear

			echo '*** Command Manual:[ss] ***'
			echo '<Format>'
			echo ' ss *no arg'
			echo ''
			echo '<Function>'
			echo ' Wriggle commits suicide. No one will be sad.'
			echo ''
			echo '... over.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}
		#-------------------------------------------------
		#man_man
		# manコマンドのマニュアル表示
		#-------------------------------------------------
		function man_man(){

			inKey=''

			tput smcup
			clear

			echo 'It is how to use it.'
			echo 'Press [q]key to exit.'

			while :
			do
				getChrH
				if [ "$inKey" = 'q' ]; then
					tput rmcup
					dispAll
					break
				else
					echo 'Invalid input. press [q] to exit.'
				fi
			done	
		}

	###########################################
	##mv
	## キャラ('W'で示す)が動く           7 8 9  q w e
	##  $1 移動先座標(1〜9,zxcasdqwe)    4 ¥ 6  a ¥ d
	##        ※大文字でも良い           3 2 1  z x c
	###########################################
	function mv(){
		local declare goX=''
		local declare goY=''

		#バリデーション
		##引数の個数
		if [ $# -ne 1 ] || [ "$1" = '' ]; then
			dspCmdLog '<mv> Set 1 arguments.' $CNST_DSP_ON
			return
		fi
		##$1のバリエーション
		if  [ ! $(echo 'ZXCASDQWEzxcasdqwe123456789' | grep "$1") ] ; then
			dspCmdLog '<mv> Enter 1-9 or 1 of"zxcasdqwe(or Capital)".' $CNST_DSP_ON
			return
		fi

		tput civis

		if  [ $(echo '5Ss' | grep "$1") ] ; then
			dspCmdLog 'Hoppn'"'"'nnnnn!' $CNST_DSP_ON
		else
			#一時的に区切り文字を変更する
			IFS=':'
			set -- $(clcDirPos "$1")
			goX=$1
			goY=$2
			#区切り文字を戻す
			IFS=$CNST_IFS_DEFAULT

			if	[ $goX -lt 1 ] || [ $goX -gt $CNST_MAP_SIZ_X ] || \
				[ $goY -lt 1 ] || [ $goY -gt $CNST_MAP_SIZ_Y ] || \
				[ "$(jgDrctn $goX $goY $CNST_JGDIV_ACCESS)" = $CNST_ACSS_CANTENTER ] ; then
							dspCmdLog "$(sayRnd $CNST_RND_WALL)" $CNST_DSP_ON
			else
				clrCmdLog $CNST_DSP_OFF
				jmpPosWrgl $goX $goY
			fi
		fi
	
		tput cvvis

	}

	###########################################
	##op
	## ドアを開く。但し、適合する鍵を持っている場合のみ。
	##  $1 移動先座標(1〜9,zxcasdqwe)
	##                        ※大文字でも良い
	###########################################
#	function op(){
#
#		local declare oldIFS=$IFS
#		local declare retPosStr=''
#		local declare opX=''
#		local declare opY=''
#
#		#バリデーション
#		##引数の個数
#		if [ $# -ne 1 ] || [ "$1" = '' ]; then
#			dspCmdLog '<op> Set 1 arguments.' $CNST_DSP_ON
#			return
#		fi
#		##$1のバリエーション
#		if  [ ! $(echo 'ZXCASDQWEzxcasdqwe123456789' | grep "$1") ] ; then
#			dspCmdLog '<op> Enter 1-9 or 1 of"zxcasdqwe(or Capital)".' $CNST_DSP_ON
#			return
#		fi
#
#		IFS=':'
#		retPosStr=$(clcDirPos)
#		set -- $retPosStr
#		opX="$1"
#		opY="$2"
#		IFS=$oldIFS
#
#		if	[ "$(jgDrctn $opX $opY $CNST_JGDIV_OBJECT)" != $CNST_DOR_LOCKED1 ] ; then
#						dspCmdLog "$(sayRnd "$CNST_RND_WALL")" $CNST_DSP_ON
#		else
#			clrCmdLog $CNST_DSP_OFF
#			modMsg 1 1 'ひらけごま！' $CNST_DSP_ON
#		fi
#
#	}

##主処理
	###########################################
	##mainLoop
	## 主処理の基幹
	## 移動とコマンド呼び出しを反復し続ける。
	###########################################
		mainLoop(){
			jmpPosWrgl 28 15
			dspCmdLog 'Wriggle respowned in X:30/Y:10.' $CNST_DSP_ON
			while :
			do
				tput cup $CNST_POS_CMDWIN
				getChrH
				#移動入力として1文字受け付ける。移動を指示しない入力だった場合
				#任意長のコマンド受付にリダイレクトされる。
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
			done
		}

	###########################################
	##getCmdInMain
	## mainLoopから呼び出される任意長コマンド受付
	## 各種コマンド割り振りと制御
	###########################################
	function getCmdInMain(){
		inKey2="$inKey"
		printf "$inKey2"
		getChrV
		inKey="${inKey2}${inKey}"
		case "$inKey" in
			'man can')	man can;;
			*'can'	)	dspCmdLog 'Alright, Command canceled :)' $CNST_DSP_ON;;
			'ci'	)	dspCmdLog 'チルノ？どうかした？' $CNST_DSP_OFF
						modMsg 1 1 'チルノ[え？]' $CNST_DSP_ON
						wk
						modMsg 2 1 'チルノ[¥ど、どうもしねーよ……///]' $CNST_DSP_ON
						wk
						modMsg 3 1 '!庭には一羽庭渡changがいる。庭には二羽庭渡changがいる。庭には三羽庭渡changがいる。庭には四羽庭渡changがいる。' $CNST_DSP_OFF
						dspCmdLog 'ローリーのローリングソバット!!昼に食べた麻辣担々麺でマーライオンに変身！' $CNST_DSP_ON
						wk
						clrMAPin $CNST_DSP_ON
						;;
			'??'	)	viewHelp;; 
			'man'*	)	man "${inKey:4}";;
			'mv'*	)	mv "${inKey:3}";;
#			'op'*	)	op "${inKey:3}";;
			'sv'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'sq'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'ki'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'wp'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'ct'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'in'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'gt'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'tr'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'tk'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'pr'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'ss'	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'sv'	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'sq'	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented." $CNST_DSP_ON ;;
			'qq'	)	exit;;
			' '		)	dspCmdLog 'Input key.' $CNST_DSP_ON ;;
			*		)	dspCmdLog "[$inKey]is invalid." $CNST_DSP_ON ;;
		esac
	}
	###########################################
	##init
	## 初期処理
	##  主に定義など
	###########################################
	#GLOBAL変数
	declare -g  inKey=''
	declare -g inKey2=''

	#CONSTANT値
	##IFS
	#declare -r CNST_IFS_DEFAULT=$' ¥t¥n'
	declare -r CNST_IFS_DEFAULT=$IFS

	##座標                       XX YY
	declare -r  CNST_POS_CMDWIN='20 10' #コマンド入力ウィンドウ
	declare -r CNST_POS_CMDWIN2='20 11' #コマンド入力ウィンドウ
	declare -r    CNST_POS_WKMK='26 97' #キー待ち記号表示位置

	##マップサイズ[MAP_SIZ]
	declare -r CNST_MAP_SIZ_X=60 #横
	declare -r CNST_MAP_SIZ_Y=15 #縦

	##メッセージウィンドウサイズ[MSG_SIZ]
	declare -r CNST_MSG_SIZ_X=99 #横
	declare -r CNST_MSG_SIZ_Y=5 #縦

	##全体サイズ[ALL_SIZ]
	declare -r CNST_ALL_SIZ_X=100 #横
	declare -r CNST_ALL_SIZ_Y=28 #縦

	##コマンドログ小窓の開始位置[CMDLGW_IDX]
	declare -r CNST_CMDLGW_IDX=50 #横

	##画面更新系関数の更新スイッチ[DSP]
	declare -r  CNST_DSP_ON='1' #再描画する
	declare -r CNST_DSP_OFF='0' #再描画しない

	##sayRnd関数の種別[RND]
	declare -r   CNST_RND_WALL='1' #壁激突音
	declare -r  CNST_RND_WEMEN='2' #女性接触声

	##jgDrctn関数の判断スイッチ[JGDIV]
	declare -r CNST_JGDIV_ACCESS='1' #進入可否
	declare -r CNST_JGDIV_OBJECT='2' #オブジェクト種類

	##進入可否[ACSS]
	declare -r  CNST_ACSS_ACCESSABLE='1' #進入可能
	declare -r   CNST_ACSS_CANTENTER='0' #進入不可

	##オブジェクト種類_床状態[FLOR]:0系
	declare -r   CNST_FLOR_HEAVYWALL='000' #[-][+][X][=]
	declare -r CNST_FLOR_NORMALFLOOR='010' #[ ][*]
	declare -r    CNST_FLOR_JUNCTION='020' #[#]

	##オブジェクト種類_扉[DOR]:1系
	##開閉状態を持つ
	declare -r CNST_DOR_LOCKED1='119' #[D] door
	declare -r CNST_DOR_OPENED1='110' #[:]
	declare -r CNST_DOR_LOCKED2='129' #[L] lock
	declare -r CNST_DOR_OPENED2='120' #[:]
	declare -r CNST_DOR_LOCKED3='139' #[K] keylock 
	declare -r CNST_DOR_OPENED3='130' #[:]
	##オブジェクト種類_封印[SEAL]:2系
	##一度開くと完全に消えるので開閉状態を持たない
	declare -r CNST_SEAL_LOCKED1='201' #[S]
	declare -r CNST_SEAL_LOCKED2='202' #[S]
	declare -r CNST_SEAL_LOCKED3='203' #[S]
	declare -r CNST_SEAL_LOCKED4='204' #[S]
	declare -r CNST_SEAL_LOCKED5='205' #[S]

	##オブジェクト種類_アイテム[ITM]:3系


	##オブジェクト種類_NPC[DOR]:5系
	declare -r    CNST_NPC_MEN='510' #[Y] (Look like)Men
	declare -r  CNST_NPC_WEMEN='511' #[A] (Look like)Wemen
	declare -r CNST_NPC_ANIMAL='520' #[m] Animal?

	##オブジェクト種類_敵[MOB]:6系
	declare -r  CNST_MOB_ENEMY='600'

	###########################################
	##main
	## mainLoopをキックする主制御
	###########################################

	clear
	initDispInfo 
	#安定するまでは不測の無限ループ脱出のためコメントアウトする
	#trap '' INT QUIT TSTP 

	#主処理
	mainLoop

	#終了時に文字修飾を除去し、画面をクリアする
	tput cvvis
	tput sgr0
	IFS=$CNST_IFS_DEFAULT
	clear
