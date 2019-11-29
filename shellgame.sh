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
		local declare cntS=$(echo -n "$cntStr" | sed -e 's@[^A-Za-z0-9~!@#$%&_=:;><,\*+.?{}()\ -\|]@@g' | wc -m)

		#半角英数記号の文字を消す=全角文字数
		local declare cntW=$(echo -n "$cntStr" | sed -e 's@[A-Za-z0-9~!@#$%&_=:;><,\*+.?{}()\ -\|]@@g' | wc -m)

		#全角文字数を示すcntWは二倍して、2つを足す
		echo -n "$(($((cntW * 2))+cntS))"

	}

	##################################################
	##crrctStr
	## 使用頻度が高い障害文字を置換するためのもの。
	## 【できれば必須呼び出しにしたいがどうするか】
	## ・半角カタカナは全角カタカナにする。
	## ・「…(三点リーダ)」の表示が詰まってしまうことがあるため、「...」(ピリオド3つ)にする
	## ・「[」「]」はbashでブラケットとして判断されるためそれぞれ「［」「］」へ置換する。
	## ・全角スペースは半角スペース2つへ置換する。
	## ・タブは半角スペース2つへ置換する。
	## ・ハイフンに似たいくつかの半角文字を半角ハイフンに置換する。
	##  返却は標準出力
	##   $1:入力文字
	##################################################
	function crrctStr(){
		local declare cnvstr="$1"

		cnvstr=$(echo "$cnvstr" | nkf)       #半角カナ
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
		inKey=""
		read inKey
	}

	###########################################=
	##getChrH
	## なんか1文字の入力受付(エコーバックなし)。
	## mainで定義しているグローバルinKeyをクリアしてから、入力値で上書き
	###########################################
	function getChrH(){
		inKey=""
		read -s -n 1 inKey
	}

	###########################################
	##getCmd
	## コマンドを受け取る
	###########################################
	function getCmd(){
		tput cup $CNST_POS_CMDWIN
		getChrV
	}

	##################################################
	##wk
	## キー待ち
	##  SPACEかENTERをまつ
	##################################################
	function wk(){

		tput civis
		tput cup $CNST_POS_WKMK
		tput blink
		
		echo -n "🐛"

		while :
		do
			getChrH
			if [ "$inKey" = "" ] || [ "$inKey" = " " ]; then
				break
			fi
		done

		tput sgr0
		tput setab 0
		tput setaf 7
		tput cnorm

	}

	###########################################
	##jgDrctn
	## 進入マスの判定
	## 対象のマスと判別種類ごとに応じた値を返却する
	##  $1:X座標
	##  $2:Y座標
	##  $3:判別種類(1:進入可否/2:オブジェクト種類)
	###########################################
	function jgDrctn(){

		#バリデーション
		##引数の個数
		if [ $# -ne 3 ]; then
			sysOut "e" $LINENO "Set 2 arguments."
			return
		fi
		##$1の範囲
		if [ $1 -lt 1 ] || [ $1 -gt $CNST_SIZ_X ]; then
			sysOut "e" $LINENO "'X' must be between 1 and $CNST_SIZ_X."
			return
		fi
		##$2の範囲
		if [ $2 -lt 1 ] || [ $2 -gt $CNST_SIZ_Y ]; then
			sysOut "e" $LINENO "'Y' must be between 1 and $CNST_SIZ_Y."
			return
		fi
		##$3の範囲
		if [ $3 -lt 1 ] || [ $3 -gt 2 ]; then
			sysOut "e" $LINENO "Choose 1 or 2."
			return
		fi

		local declare objDrction="${lnSeed[$(($2+3))]:$(($1+3)):1}"

		#判定と返却
		case "$3" in
			$CNST_JGDIV_ACCESS	)	#進入可否判断
					case "$objDrction" in
						" "	)	echo $CNST_ACSS_ACCESSABLE ;;
						"*"	)	echo $CNST_ACSS_ACCESSABLE ;; #マップ未開示状態の実装後、[*]は無条件進行可能ではなくなる
						"-"	)	echo $CNST_ACSS_CANTENTER  ;;
						"="	)	echo $CNST_ACSS_CANTENTER  ;;
						"+"	)	echo $CNST_ACSS_CANTENTER  ;;
						"|"	)	echo $CNST_ACSS_CANTENTER  ;;
						"#"	)	echo $CNST_ACSS_CANTENTER  ;;
						"D"	)	echo $CNST_ACSS_CANTENTER  ;; 
						*	)	dspCmdLog "<jgEntr> Unimplemented object." $CNST_DSP_ON
					esac
					;;
			$CNST_JGDIV_OBJECT	)	#オブジェクト種類
					case "$objDrction" in
						" "	)	echo $CNST_FLOR_NORMALFLOOR ;;
						"*"	)	echo $CNST_FLOR_NORMALFLOOR ;; #マップ未開示状態の実装後、[*]は無条件通常床ではなくなる
						"-"	)	echo $CNST_FLOR_HEAVYWALL   ;;
						"="	)	echo $CNST_FLOR_HEAVYWALL   ;;
						"+"	)	echo $CNST_FLOR_HEAVYWALL   ;;
						"|"	)	echo $CNST_FLOR_HEAVYWALL   ;;
						"#"	)	echo $CNST_FLOR_HEAVYWALL   ;;
						"D"	)	echo $CNST_DOR_LOCKED1      ;; 
						*	)	dspCmdLog "<jgEntr> Unimplemented object." $CNST_DSP_ON
					esac
					;;		
			*	)	dspCmdLog "<jgEntr> Invalid Div:$3" $CNST_DSP_ON
		esac
	}

	###########################################
	##jmpPosWrgl
	## Wriggleの位置をx,y指定で移動する
	## この関数は強制的に画面を再描画する。
	##  $1 X座標(1〜60)
	##  $2 Y座標(1〜15) 
	###########################################
	function jmpPosWrgl(){

		#バリデーション
		##引数の個数
		if [ $# -ne 2 ]; then
			sysOut "e" $LINENO "Set 2 arguments."
			return
		fi
		##$1の範囲
		if [ $1 -lt 1 ] || [ $1 -gt $CNST_SIZ_X ]; then
			sysOut "e" $LINENO "'X' must be between 1 and 60."
			return
		fi
		##$2の範囲
		if [ $2 -lt 1 ] || [ $2 -gt $CNST_SIZ_Y ]; then
			sysOut "e" $LINENO "'Y' must be between 1 and 15."
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
	##pcncMode
	## ピクニックモード
	##  mvの入力を省略して1〜9の入力のみで移動できる
	##  0で終了。
	##################################################
	function pcncMode(){
		tput civis
		dspCmdLog "Start picnic mode." $CNST_DSP_ON

		while :
		do
			getChrH
			case "$inKey" in
			"0"	)	dspCmdLog "Quit picnic mode." $CNST_DSP_ON
					wk
					tput cup $CNST_POS_CMDWIN
					tput cnorm
					break
					;;
			"1"	)	mv 1;;
			"2"	)	mv 2;;
			"3"	)	mv 3;;
			"4"	)	mv 4;;
			"5"	)	;;
			"6"	)	mv 6;;
			"7"	)	mv 7;;
			"8"	)	mv 8;;
			"9"	)	mv 9;;
			*	)	dspCmdLog "<pcnc> Enter 1~9, 5 or 0." $CNST_DSP_ON
			esac
		done

	}

	##################################################
	##sayRnd
	## ランダム出力表現生成
	##  何度も繰り返すことができる行動に対する出力を
	##  ランダム生成する。10パターン固定、減らす場合は結果重複で制限する
    ##   $1:出力するタイプ
	##################################################
	function sayRnd(){

		local declare rslt=$(($RANDOM % 10))
		
		case "$1" in
			"$CNST_RND_WALL"	)	#ぶつかる音
					case "$rslt" in
						"0"	)	echo "Thud!";;
						"1"	)	echo "Thump!!";;
						"2"	)	echo "Bonk";;
						"3"	)	echo "Ou!";;
						"4"	)	echo "Ouch!";;
						"5"	)	echo "Can't go any further.";;
						"6"	)	echo "Do not push!";;
						"7"	)	echo "Thud.";;
						"8"	)	echo "Thud!!";;
						"9"	)	echo "Bonk!";;
						*	)	sysOut "e" $LINENO "<sayRnd> Arg Error."
					esac
					;;
			"$CNST_RND_WEMEN"	)	#おさわり反応
					case "$rslt" in
						"0"	)	echo "";;
						"1"	)	echo "";;
						"2"	)	echo "";;
						"3"	)	echo "";;
						"4"	)	echo "";;
						"5"	)	echo "";;
						"6"	)	echo "";;
						"7"	)	echo "";;
						"8"	)	echo "";;
						"9"	)	echo "";;
						*	)	sysOut "e" $LINENO "<sayRnd> Arg Error."
					esac
					;;
			*	)	sysOut "e" $LINENO "<sayRnd> Arg Error."
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
		lnSeed+=("+--+------------------------------------------------------------++------------+----------+---------+") #00
		lnSeed+=("|01|000000000111111111122222222223333333333444444444455555555556||Wriggle     |Bug       |Fighter  |") #01
		lnSeed+=("|01|123456789012345678901234567890123456789012345678901234567890|+--+---------+----------+---------+") #02
		lnSeed+=("+--+------------------------------------------------------------+|HP| 100/ 100|BLv: 1=     0/    10|") #03
		lnSeed+=("|01|****************************D*******************************||MP| 100/ 100|JLv: 1=     0/    10|") #04
		lnSeed+=("|02|****************************+-+*+----------+-D-----------+--|+--+--+--+--++-+--++--+--+--+--+--+") #05
		lnSeed+=("|03|****************************|#|*|##########|*************|##||✝|💊|💤|❔|🔇|👓||💪|🛡|🔯|🏃|🍀|") #06
		lnSeed+=("|04|****************************|#|*++---------+--------+****|##|+--+--+--+--+--+--++--+--+--+--+--+") #07
		lnSeed+=("|05|****************************|#|*********************|****|##|| 0| 0| 0| 0| 0| 0|| 0| 0| 0| 0| 0|") #08
		lnSeed+=("|06|****************************|#+--+******************+----+##|+--+--+--+--+--+--++--+--+--+--+--+") #09
		lnSeed+=("|07|****************************|####|***********************|##||  VAL - STS - PAR |🔨|⛰|💧|🔥|🌪|") #10
		lnSeed+=("|08|****************************|####|******************+--+*|##||*  10 < Str > Atk |10|10|10|10|10|") #11
		lnSeed+=("|09|****************************|####+------------------+##|*|##||   10 < Int > Mat |10|10|10|10|10|") #12
		lnSeed+=("|10|*v**************************|##########################|*|##||   10 < Vit > Def |10|10|10|10|10|") #13
		lnSeed+=("|11|----------------------------+--------------------------+D+--||   10 < Mnd > Mdf |10|10|10|10|10|") #14
		lnSeed+=("|12|************************************************************||   10 < Snc > XBns| 1  %+==+=====+") #15
		lnSeed+=("|13|---D--+-------------------+*+---------------+***************||   10 < Dex > Hit |10  %|Jw|    0|") #16
		lnSeed+=("|14|******|###################|*|###############|***************||   10 < Agi > Flee|10  %|Gd|    0|") #17
		lnSeed+=("|15|******|###################|^|###############|***************||   10 < Luk > Cri |10  %|Sv|   50|") #18
		lnSeed+=("+==+=============================================+==============++==================+=====+==+=====+") #19
		lnSeed+=("|COMMAND>                                        |                                                 |") #20
		lnSeed+=("+==+=============================================+===========================input '??' to help.===+") #21
		lnSeed+=("|91|                                                                                               |") #22
		lnSeed+=("|92|                                                                                               |") #23
		lnSeed+=("|93|                                                                                               |") #24
		lnSeed+=("|94|                                                                                               |") #25
		lnSeed+=("|95|                                                                                               |") #26
		lnSeed+=("+--+-----------------------------------------------------------------------------------------------+") #27
	}

	##################################################
	## 画面の全情報を更新表示
	##   lnSeed[]で画面を更新する
	##   自キャラ位置に「W」を強調表示で上書きする。
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
		echo "¥"
		tput sgr0
		tput setab 0
		tput setaf 7
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

		local declare   errDiv=""
		local declare   bColor=0
		local declare   fColor=0
		local declare wdthSize=0
		local declare  msgWdth=0
		local declare   lrWdth=0

		inKey=""

		tput smcup
		clear

		case "$1" in
				"e"	)	errDiv="Error"
						bColor=1
						fColor=7
						;;
				"w"	)	errDiv="Warning"
						bColor=7
						fColor=0
						;;
				#"i"	)	errDiv="Information";;
				*	)	errDiv="FatalError"
						bColor=1
						fColor=0
						;;
		esac

		wdthSize=$(tput cols)
		msgWdth=$(getCntSingleWidth "<$errDiv>Line:$2[$3]")
		lrWdth=$((($wdthSize-$msgWdth)/2))

		echo ""
		echo ""
		echo ""
		tput setab $bColor
		tput setaf $fColor
		printf "%${lrWdth}s<$errDiv>Line:$2[$3]%${lrWdth}s"
		tput sgr0
		tput setab 0
		tput setaf 7
		echo ""
		echo ""
		echo ""

		while :
		do
			getChrH
			if [ "$inKey" = "q" ]; then
				tput rmcup
				dispAll
				break
			else
				echo "Invalid input. press [q] to exit."
			fi
		done
	}

	##################################################
	##clrMsgWin
	## lnSeed[22〜26]を初期表示の内容で上書きして画面をクリア更新する
	##  $1 lnSeed更新後にmsgウィンドウを更新するか(1:する/他:しない)
	##################################################
	function clrMsgWin(){

		lnSeed[20]="|COMMAND>                                        |                                                 |" #20

		lnSeed[22]="|91|                                                                                               |" #22
		lnSeed[23]="|92|                                                                                               |" #23
		lnSeed[24]="|93|                                                                                               |" #24
		lnSeed[25]="|94|                                                                                               |" #25
		lnSeed[26]="|95|                                                                                               |" #26

		#引数が1だったら、画面を更新する。
		if [ "$1" = "$CNST_DSP_ON" ] ; then
			dispAll
		fi

	}

	##################################################
	##clrCmdLog
	## lnSeed[20]を初期表示の内容で上書きして画面をクリア更新する
	##  $1 lnSeed更新後にmsgウィンドウを更新するか(1:する/他:しない)
	##################################################
	function clrCmdLog(){

		lnSeed[20]="|COMMAND>                                        |                                                 |"

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
	##  $1 X座標(1〜60)
	##  $2 Y座標(1〜15)
	###########################################
	function modDspWrglPos(){
		local declare X=$(printf "%02d" $1)
		local declare Y=$(printf "%02d" $2)

		local declare row1Right=${lnSeed[1]:3}
		local declare row2Right=${lnSeed[2]:3}

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
	##  $4 lnSeed更新後にmsgウィンドウを更新するか(1:する/他:しない)
	##################################################
	function modMsg(){

		#バリデーション
		##引数の個数
		if [ $# -ne 4 ] ; then
			sysOut "e" $LINENO "Set 4 arguments."
			return
		fi
		##$1の範囲
		if [ $1 -lt 1 ] || [ $1 -gt 99 ]; then
			sysOut "e" $LINENO "StartColumnIndex must be between 1 and 99."
			return
		fi
		##$2の範囲
		if [ $2 -lt 1 ] || [ $2 -gt 5 ]; then
			sysOut "e" $LINENO "StartRowIndex must be between 1 and 5."
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
			if [ $tmpCntSingleWidth -gt 95 ] ; then
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
		if [ "$4" = "1" ] ; then
			dispAll
		fi

	}

	###########################################
	##dspCmdLog
	## コマンド結果等簡易表示ウィンドウの更新
	##   $1 表示内容
	##   $2 lnSeed更新後にmsgウィンドウを更新するか(1:する/他:しない)
	##################################################
	function dspCmdLog(){

		#バリデーション
		##引数の個数
		if [ -z "$1" ] || [ -n "$3" ] ; then			
			sysOut "e" $LINENO "Set 1 or 2 arguments. $1/$2"
			return
		fi

		local declare tgtStr=$(crrctStr "$1")
		local declare leftStr="${lnSeed[20]:0:50}"


		#文字長が右端を出ないように切り捨てる。
		#半角相当の文字数が95以下になるまで、末尾から1文字ずつ切り捨て続ける
		#半角全角が混じる場合に正確に切り捨てる長さを指定できないため
		local declare tmpStr="$tgtStr"
		local declare tmpCntSingleWidth=0
		while :
		do
			tmpCntSingleWidth=$(getCntSingleWidth "$tmpStr")
			if [ $tmpCntSingleWidth -gt 49 ] ; then
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

		inKey=""

		tput smcup

		clear
		echo "***Command List***  Press [q]key to exit."
		echo ""
		echo "man [CMD]   : [CMD] CommandManual"
		echo "mv [n]      : Move in direction [n]"
		echo "pp          : Start Picnic Mode"
		echo "ki [m][n]   : Kick in direction [n] with [n]strength"
		echo "wp [n]      : Attack in direction [n] with Wapon"
		echo "ct [m][n]   : Cast [m]Magic in direction [n]"
		echo "in [n]      : Inspect in direction [n]"
		echo "gt [n]      : Get in direction [n]"
		echo "tr [m][n]   : Throw [m] item in direction [n]"
		echo "tk [n]      : Talk in direction [n]"
		echo "pr [n]      : Pray for [n]"
		echo "ss          : Suiside!"

		while :
		do
			getChrH
			if [ "$inKey" = "q" ]; then
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
			"mv"	) man_mv ;;
			"pp"	) man_pp ;;
			"ki"	) man_ki ;;
			"wp"	) man_wp ;;
			"ct"	) man_ct ;;
			"in"	) man_in ;;
			"gt"	) man_gt ;;
			"tr"	) man_tr ;;
			"tk"	) man_tk ;;
			"pr"	) man_pr ;;
			"ss"	) man_ss ;;
			"man"	) man_man ;;
			""		) dspCmdLog "no argment error."  1 ;;
			*		) dspCmdLog "[$1] is Invalid CMD." 1 ;;
		esac
	}
	#-------------------------------------------------
	#manコマンドによって呼び出される子関数
	#-------------------------------------------------
		#-------------------------------------------------
		#man_mv
		# mvコマンドのマニュアル表示
		#-------------------------------------------------
		function man_mv(){

            inKey=""
			tput smcup

			clear

			echo "*** Command Manual:[mv] ***"
			echo "<Format>"
			echo " mv [arg]"
			echo " * arg=1~9."
			echo ""
			echo "<Function>"
			echo " Wriggle moves 1 step [arg]. Consume 1 turn."
			echo " If select [5] then Switch to 'PicnicMode' what you can skip typing [Enter]key."
			echo " Entering [0] during picnic mode will exit 'PicnicMode'."
			echo " Dungeon exploration begins with walking and ends with walking..."
			echo " ...No, when is the end when I die? Make your picnic feel moderate. GLHF!"
			echo ""
			echo " move to...   \  ^  /"
			echo "               7 8 9 "
			echo "              <4 ¥ 6>"
			echo "               3 2 1 "
			echo "              /  v  \\    5/0:Switch 'PicniMode'"
			echo ""
			echo "... over."
			echo "Press [q]key to exit."
			
            while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_pp
		# ppコマンドのマニュアル表示
		#-------------------------------------------------
		function man_pp(){

            inKey=""
			tput smcup

			clear

			echo "*** Command Manual:[pp] ***"
			echo "<Format>"
			echo " pp"
			echo " * no arg."
			echo ""
			echo "<Function>"
			echo " Wriggle begins a picnic."
			echo " Wriggle walks without waiting for the Enter key after every [1]-[9] input."
			echo " * [5] is invalid. Enter [0] to exit picnic mode. Use one turn for each step."
			echo " If you don't walk forward, you'll step on the roots of a flower that is scarier than a dragon."
			echo " If you want to see her, don't stop ... rip."
			echo ""
			echo " move to...   \  ^  /"
			echo "               7 8 9 "
			echo "              <4 ¥ 6>"
			echo "               3 2 1 "
			echo "              /  v  \\    0:Quit 'PicniMode'"
			echo ""
			echo "... over."
			echo "Press [q]key to exit."
			
            while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_ki
		# kiコマンドのマニュアル表示
		#-------------------------------------------------
		function man_ki(){

			inKey=""
			tput smcup

			clear

			echo "*** Command Manual:[ki] ***"
			echo "<Format>"
			echo " ki [arg1] [arg2]"
			echo " * arg1=1~9 except 5."
			echo " * arg2=1~9."
			echo ""
			echo "<Function>"
			echo " It's Called 'WriggleKick'."
			echo " Wriggle kicks [arg1] with a strength of [arg2]."
			echo " Consume 1 turn."
			echo " Once used, the 'WriggleKick' cannot be reused for one turn."
			echo " 'WriggleKick' range is 1 square."
			echo " 'Wrigglekick' is very helpful when you have no weapons."
			echo " Some enemies can only be defeated with 'WriggleKick'."
			echo " Because it is the first enemy, it is not necessarily OHKO."
			echo ""
			echo " kick to...   \  ^  /"
			echo "               1 2 3 "
			echo "              <4 ¥ 6>"
			echo "               7 8 9 "
			echo "              /  v  \\"
			echo ""
			echo "<MP Cost Referance>"
			echo "  +--------+---+---+---+---+---+---+---+---+---+"
			echo "  |useLv   |  1|  2|  3|  4|  5|  6|  7|  8|  9|"
			echo "  +--------+---+---+---+---+---+---+---+---+---+"
			echo "  |Cost MP |  3|  3|  3|  7|  7|  7|  9|  9| 12|"
			echo "  +--------+-----------------------------------+"
			echo ""
			echo "<Strength>"
			echo "  ([Atk]*[useLv]*1.2)+([Atk]*[useLv-9]*0.5)"
			echo ""
			echo "... over."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_wp
		# wpコマンドのマニュアル表示
		#-------------------------------------------------
		function man_wp(){

			inKey=""

			tput smcup
			clear

			echo "*** Command Manual:[wp] ***"
			echo "<Format>"
			echo " wp [arg]"
			echo " * arg=1~9 except 5."
			echo ""
			echo "<Function>"
			echo " Wriggle uses a weapon to attack in [arg] directions."
			echo " Consume 1 turn."
			echo " The range depends on the weapon used."
			echo " There is no MP consumption except in special cases."
			echo " He seems to be trying to clear up the depression "
			echo "     that has always been abused by his wife(s) in the dungeon."
			echo ""
			echo " attack to...   \  ^  /"
			echo "                 1 2 3 "
			echo "                <4 ¥ 6>"
			echo "                 7 8 9 "
			echo "                /  v  \\   *range depends wepon."
			echo ""
			echo "<Strength>"
			echo "  ([Atk]*[weponAtk])+(|Atk-50|*[weponAtk]*0.3)"
			echo ""
			echo "... over."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done
		}
		#-------------------------------------------------
		#man_ct
		# ctコマンドのマニュアル表示
		#-------------------------------------------------
		function man_ct(){

			inKey=""

			tput smcup
			clear

			echo "*** Command Manual:[ct] ***"
			echo "<Format>"
			echo " ct [arg1] [arg2]"
			echo " * arg1=1~4."
			echo " * arg2=1~9."
			echo ""
			echo "<Function>"
			echo " Wriggle casts a [arg1] Magic in [arg2] directions."
			echo " When [5] is set, you are the subject."
			echo " Consume 1 turn."
			echo " The range depends on the mgic used."
			echo " Magic is not necessarily for attack."
			echo " There are also recovery, assistance, and some with more special effects."
			echo " Useful for exploring dungeons."
			echo ""
			echo " cast to...   \  ^  /"
			echo "               1 2 3 "
			echo "              <4 ¥ 6>"
			echo "               7 8 9 "
			echo "              /  v  \\   *range depends magic."
			echo ""
			echo "<Strength>"
			echo "  ([Mat]*[magicStr])+(|[Mat]-50|*[magicStr]*0.4)"
			echo ""
			echo "<MP Cost Referance>"
			echo "  MP consumed depends on the magic used, but can be reduced by [Int] value."
			echo "    +--------+---+-----------+----------+----+"
			echo "    |int     |~30|~60        |~98       |99  |"
			echo "    +--------+---+-----------+----------+----+"
			echo "    |Cost MP |-0%|-(int/20)% |-(int/10)%|-30%|"
			echo "    +--------+---+-----------+----------+----+"
			echo "    *Reduction amount is rounded up to one decimal place."
			echo ""
			echo "... over."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_in
		# inコマンドのマニュアル表示
		#-------------------------------------------------
		function man_in(){

			inKey=""

			tput smcup
			clear

			echo "*** Command Manual:[in] ***"
			echo "<Format>"
			echo " in [arg]"
			echo " * arg=1~9."
			echo ""
			echo "<Function>"
			echo " Wriggle investigates the direction of [arg]. Consume 1 turn."
			echo " Depending on the [Snc]value, success and failure may be separated."
			echo " When [5], it is foot of the Wriggle or Wriggleself."
			echo " Keep your antennae clean."
			echo ""
			echo " investigate to...   \  ^  /"
			echo "                      7 8 9 "
			echo "                     <4 ¥ 6>"
			echo "                      3 2 1 "
			echo "                     /  v  \\      *[5], foot or self"
			echo ""
			echo "... over."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_gt
		# gtコマンドのマニュアル表示
		#-------------------------------------------------
		function man_gt(){

			inKey=""

			tput smcup
			clear

			echo "*** Command Manual:[gt] ***"
			echo "<Format>"
			echo " gt [arg]"
			echo " * arg=1~9."
			echo ""
			echo "<Function>"
			echo " Wriggle gets or picks up the one in the direction of [arg]. Consume 1 turn."
			echo " When [5], it is foot of the Wriggle or Wriggleself."
			echo " 'The old tale of ants and grasshoppers' should have been that"
			echo "       the workers were exploited by wife(s) waiting in the nest. ...Is it different?"
			echo ""
			echo " gets to...   \  ^  /"
			echo "               7 8 9 "
			echo "              <4 ¥ 6>"
			echo "               3 2 1 "
			echo "              /  v  \\      *[5], foot"
			echo ""
			echo "... over."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_tr
		# trコマンドのマニュアル表示
		#-------------------------------------------------
		function man_tr(){

			inKey=""
			tput smcup
			clear

			echo "*** Command Manual:[tr] ***"
			echo "<Format>"
			echo " tr [arg1] [arg2]"
			echo " * arg1=1~9."
			echo " * arg2=1~9 except 5."
			echo ""
			echo "<Function>"
			echo " Wriggle throws [arg1] item in the direction of [arg2]. Consume 1 turn."
			echo " Depending on the [arg1] item type or [STR] value, the thrown item can be destroyed."
			echo " The winner will also take damage according to the [STR] value and [arg1] item."
			echo " If you're going to throw things away, be careful."
			echo " What I received from a woman is particularly troublesome when my wife finds it."
			echo ""
			echo " throw to...   \  ^  /"
			echo "                7 8 9 "
			echo "               <4 ¥ 6>"
			echo "                3 2 1 "
			echo "               /  v  \\"
			echo ""
			echo "<Damege>"
			echo "  Jewel     --- [Value]*1000.0                       :Ignore the [Def]."
			echo "  Gold      --- [Value]*100.0                        :Ignore the [Def]."
			echo "  Silver    --- [Value]*1.0                          :Ignore the [Def]."
			echo "  Wepon     --- [Str]*[WeponAtk]*(RoundUp(Str/100))"
			echo "  Armor     --- [Str]*[ArmorDef]*(RoundUp(Str/150))"
			echo "  Medicine  --- [ItemRecovery]*1.0                   :Heal instead of damage."
			echo "  OtherItem --- I don't know how to do it!"
			echo ""
			echo "... over."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_tk
		# tkコマンドのマニュアル表示
		#-------------------------------------------------
		function man_tk(){

			inKey=""
			tput smcup

			clear

			echo "*** Command Manual:[tk] ***"
			echo "<Format>"
			echo " tk [arg]"
			echo " * arg=1~9 except 5."
			echo ""
			echo "<Function>"
			echo " Wriggle speaks in the direction of [arg]. Consume 1 turn."
			echo " If you talk well, you may get along. But watch out for your wife's gaze."
			echo ""
			echo " talk to...   \  ^  /"
			echo "               7 8 9 "
			echo "              <4 ¥ 6>"
			echo "               3 2 1 "
			echo "              /  v  \\"
			echo ""
			echo "... over."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_pr
		# prコマンドのマニュアル表示
		#-------------------------------------------------
		function man_pr(){

			inKey=""
			tput smcup

			clear

			echo "*** Command Manual:[pr] ***"
			echo "<Format>"
			echo " pr [arg]"
			echo " * arg=1~9."
			echo ""
			echo "<Function>"
			echo " Wriggle prays for [arg] and asks for a miracle. Consume 1 turn."
			echo " I don't know what will happen, but the [Mnd] value makes it easy to do something good."
			echo " You can pray only to those who have idols."
			echo " And if you pray to one, then pray to another, you may be punished."
			echo " And if you pray too much, you will be punished."
			echo ""
			echo "<Object to pray>"
			echo " unknown"
			echo "... over."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_ss
		# ssコマンドのマニュアル表示
		#-------------------------------------------------
		function man_ss(){

			inKey=""

			tput smcup
			clear

			echo "*** Command Manual:[ss] ***"
			echo "<Format>"
			echo " ss *no arg"
			echo ""
			echo "<Function>"
			echo " Wriggle commits suicide. No one will be sad."
			echo ""
			echo "... over."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}
		#-------------------------------------------------
		#man_man
		# manコマンドのマニュアル表示
		#-------------------------------------------------
		function man_man(){

			inKey=""

			tput smcup
			clear

			echo "It is how to use it."
			echo "Press [q]key to exit."

			while :
			do
				getChrH
				if [ "$inKey" = "q" ]; then
					tput rmcup
					dispAll
					break
				else
					echo "Invalid input. press [q] to exit."
				fi
			done	
		}

	###########################################
	##mv
	## キャラ('W'で示す)が動く        7 8 9
	##  $1 移動先座標(1〜9)           4 W 6
	##                                3 2 1
	###########################################
	function mv(){

		#バリデーション
		##引数の個数
		if [ $# -ne 1 ] || [ "$1" = "" ]; then
			dspCmdLog "<mv> Set 1 arguments." $CNST_DSP_ON
			return
		fi
		##$1の範囲
		if [ $1 -lt 1 ] || [ $1 -gt 9 ]; then
			dspCmdLog "<mv> Enter 1~9, or 5." $CNST_DSP_ON
			return
		fi

		local declare posX=${lnSeed[1]:1:2}
		local declare posY=${lnSeed[2]:1:2}
		local declare dirct=$1
		local declare mvX=0
		local declare mvY=0
		local declare goX=0
		local declare goY=0

		case "$dirct" in
			"5"	)	#ピクニックモード
					pcncMode
					#ピクニックモード終了時のみ、posX/Yを更新する必要がある
					posX=${lnSeed[1]:1:2}
					posY=${lnSeed[2]:1:2}
					;;
			"1"	)	#↙
					mvX=-1
					mvY=1
					;;
			"2"	)	#↓
					mvX=0
					mvY=1
					;;
			"3"	)	#↘
					mvX=1
					mvY=1
					;;
			"4"	)	#←
					mvX=-1
					mvY=0
					;;
			"6"	)	#→
					mvX=1
					mvY=0
					;;
			"7"	)	#↖
					mvX=-1
					mvY=-1
					;;
			"8"	)	#↑
					mvX=0
					mvY=-1
					;;
			"9"	)	#↗
					mvX=1
					mvY=-1
					;;
			*	)	sysOut "e" $LINENO "Direction value Error."
		esac

		#割り出した座標へjmpPosWrgl関数で移動する。
		#但し、範囲外に出ることはしない。
		#侵入不可能マスだった場合も移動しない。
		##XYの範囲
		goX=$((10#$posX+mvX))
		goY=$((10#$posY+mvY))

		if	[ $goX -lt 1 ] || [ $goX -gt $CNST_SIZ_X ] || \
			[ $goY -lt 1 ] || [ $goY -gt $CNST_SIZ_Y ] || \
			[ $(jgDrctn $goX $goY $CNST_JGDIV_ACCESS) = $CNST_ACSS_CANTENTER ] ; then
						dspCmdLog "$(sayRnd $CNST_RND_WALL)" $CNST_DSP_ON
		else
			clrCmdLog $CNST_DSP_OFF
			jmpPosWrgl $goX $goY
		fi

	}
	###########################################
	##pp
	## ピクニックモードへのショートカット
	###########################################
	function pp(){
		:
		#ppコマンドは「mv 5」を発行するので、処理はない。
	}


##主処理
	###########################################
	##mainLoop
	## 主処理の基幹
	###########################################
	#このゲームは黒背景に白文字で稼働する
	mainLoop(){
	
		jmpPosWrgl 28 15
		dspCmdLog "Wriggle respowned in X:30/Y:10." 1

		while :
		do
			getCmd
			case "$inKey" in
				"ci"	)	dspCmdLog "チルノ？どうかした？" 0
							#modMsg 1 1 "チルノ[え？]" 1
							#wk
							modMsg 2 1 "チルノ[ど、どうもしねーよ……///]" 1
							#wk
							#modMsg 3 1 "!庭には一羽庭渡changがいる。庭には二羽庭渡changがいる。庭には三羽庭渡changがいる。庭には四羽庭渡changがいる。" 0
							#dspCmdLog "ローリーのローリングソバット!!昼に食べた麻辣担々麺でマーライオンに変身！" 1
							#wk
							#clrMsgWin 1
							;;
				"mv"*	)	mv "${inKey:3}";;                     #mvコマンド
				"pp"	)	mv 5;;                                #ピクニックモード
				"??"	)	viewHelp;;                            #コマンドリスト
				"man"*	)	man "${inKey:4}" ;;                   #マニュアル参照コマンド
				"Q"		)	break;;                               #ボスが来た
				""		)	dspCmdLog "Input key." $CNST_DSP_ON ;;           #エラー
				*		)	dspCmdLog "[$inKey]is invalid." $CNST_DSP_ON ;;  #エラー
			esac
		done
	}


	###########################################
	##init
	## 初期処理
	##  主に定義など
	###########################################
	#GLOBAL変数
	declare -g inKey=""

	#CONSTANT値

	##座標
	declare -r CNST_POS_CMDWIN="20 10" #コマンド入力ウィンドウ
	declare -r   CNST_POS_WKMK="26 97" #キー待ち記号表示位置

	##メッセージウィンドウサイズ[SIZ]
	declare -r CNST_SIZ_X="60" #再描画する
	declare -r CNST_SIZ_Y="15" #再描画しない

	##画面更新系関数の更新スイッチ[DSP]
	declare -r  CNST_DSP_ON="1" #再描画する
	declare -r CNST_DSP_OFF="0" #再描画しない

	##sayRnd関数の種別[RND]
	declare -r   CNST_RND_WALL="1" #壁激突音
	declare -r  CNST_RND_WEMEN="2" #女性接触声

	##jgDrctn関数の判断スイッチ[JGDIV]
	declare -r CNST_JGDIV_ACCESS="1" #進入可否
	declare -r CNST_JGDIV_OBJECT="2" #オブジェクト種類

	##進入可否[ACSS]
	declare -r  CNST_ACSS_ACCESSABLE="1" #進入可能
	declare -r   CNST_ACSS_CANTENTER="0" #進入不可

	##オブジェクト種類_床状態[FLOR]:0系
	declare -r   CNST_FLOR_HEAVYWALL="000" #[-][+][#][=]
	declare -r CNST_FLOR_NORMALFLOOR="010" #[ ][*]

	##オブジェクト種類_扉[DOR]:1系
	declare -r CNST_DOR_LOCKED1="119" #[D] door
	declare -r CNST_DOR_OPENED1="110" #[:]
	declare -r CNST_DOR_LOCKED2="129" #[L] lock
	declare -r CNST_DOR_OPENED2="120" #[:]
	declare -r CNST_DOR_LOCKED3="139" #[S] seal 
	declare -r CNST_DOR_OPENED3="130" #[:]

	##オブジェクト種類_アイテム[ITM]:3系


	##オブジェクト種類_NPC[DOR]:5系
	declare -r    CNST_NPC_MEN="510" #[Y] (Look like)Men
	declare -r  CNST_NPC_WEMEN="511" #[A] (Look like)Wemen
	declare -r CNST_NPC_ANIMAL="520" #[m] Animal?

	##オブジェクト種類_敵[MOB]:6系
	declare -r  CNST_MOB_ENEMY="600"

	###########################################
	##main
	## mainLoopをキックする主制御
	###########################################
	tput setab 0
	tput setaf 7

	clear
	initDispInfo 
	
	#安定するまでは不測の無限ループ脱出のためコメントアウトする
	#trap '' INT QUIT TSTP 

	#主処理
	mainLoop

	#終了時に文字修飾を除去し、画面をクリアする
	tput cnorm
	tput sgr0
	#clear
