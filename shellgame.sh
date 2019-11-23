##################################################
## 画面の初期表示情報
##   lnSeed[]に初期表示情報を格納する
##################################################
function initDispInfo(){

	declare -a -g lnSeed=() ##0から25までの26要素用意するつもり。

	#初期状態 0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
	#文字数   1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	lnSeed+=("+--+------------------------------------------------------------++------------+----------+---------+") #00
	lnSeed+=("|//|000000000111111111122222222223333333333444444444455555555556||Wriggle     |Bug       |Fighter  |") #01
	lnSeed+=("|//|123456789012345678901234567890123456789012345678901234567890|+--+---------+----------+---------+") #02
	lnSeed+=("+--+------------------------------------------------------------+|HP| 100/ 100|BLv: 1=     0/    10|") #03
	lnSeed+=("|01|000000000000000000000000000000000000000000000000000000000000||MP| 100/ 100|JLv: 1=     0/    10|") #04
	lnSeed+=("|02|000000000000000000000000000000000000000000000000000000000000|+--+--+--+--++-+--++--+--+--+--+--+") #05
	lnSeed+=("|03|000000000000000000000000000000000000000000000000000000000000||✝|💊|💤|❔|🔇|👓||💪|🛡|🔯|🏃|🍀|") #06
	lnSeed+=("|04|000000000000000000000000000000000000000000000000000000000000|+--+--+--+--+--+--++--+--+--+--+--+") #07
	lnSeed+=("|05|000000000000000000000000000000000000000000000000000000000000|| 0| 0| 0| 0| 0| 0|| 0| 0| 0| 0| 0|") #08
	lnSeed+=("|06|000000000000000000000000000000000000000000000000000000000000|+--+--+--+--+--+--++--+--+--+--+--+") #09
	lnSeed+=("|07|000000000000000000000000000000000000000000000000000000000000||  VAL - STS - PAR |🔨|⛰|💧|🔥|🌪|") #10
	lnSeed+=("|08|000000000000000000000000000000000000000000000000000000000000||*  10 < Str > Atk |10|10|10|10|10|") #11
	lnSeed+=("|09|000000000000000000000000000000000000000000000000000000000000||   10 < Int > Mat |10|10|10|10|10|") #12
	lnSeed+=("|10|000000000000000000000000000000000000000000000000000000000000||   10 < Vit > Def |10|10|10|10|10|") #13
	lnSeed+=("|11|000000000000000000000000000000000000000000000000000000000000||   10 < Mnd > Mdf |10|10|10|10|10|") #14
	lnSeed+=("|12|000000000000000000000000000000000000000000000000000000000000||   10 < Snc > XBns| 1  %+==+=====+") #15
	lnSeed+=("|13|000000000000000000000000000000000000000000000000000000000000||   10 < Dex > Hit |10  %|Jw|    0|") #16
	lnSeed+=("|14|000000000000000000000000000000000000000000000000000000000000||   10 < Agi > Flee|10  %|Gd|    0|") #17
	lnSeed+=("|15|000000000000000000000000000000000000000000000000000000000000||   10 < Luk > Cri |10  %|Sv|   50|") #18
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
##sysOut
## 主にエラー表示用に別の画面を起動する。
## termcapによって上にかぶせる
##   $1 深刻度(Hundling [e]rror,
##             ignoreable [w]arning,
#              [i]nformation > 無視可能なエラーはdspCmdLogへ表示する方針
##   $2 呼出元行数
##   $3 表示内容
##################################################
#function sysOut(){
#
#	inKey=""
#
#	tput smcup
#	clear
#
#	local declare errDiv
#	case "$1" in
#			"e"	)	errDiv="Error";;
#			"w"	)	errDiv="Warning";;
#			#"i"	)	errDiv="Information";;
#			*	)	errDiv="FatalError";;
#	esac
#
#	echo "<$errDiv>Line:$2[$3]"
#
#	while :
#	do
#		getChrH
#		if [ "$inKey" = "q" ]; then
#			tput rmcup
#			dispAll
#			break
#		else
#			echo "Invalid input. press [q] to exit."
#		fi
#	done
#
#}
#

##################################################
##clrMsgWin
## 画面の初期表示情報
## lnSeed[22〜26]を初期表示の内容で上書きして画面を更新する
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
	if [ "$1" = "1" ] ; then
		dispAll
	fi

}


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
		*		) dspCmdLog "$1 is Invalid CMD." 1 ;;
	esac
}
#----------------------------------------------------------
# マニュアル表示用の子関数
#----------------------------------------------------------
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
			echo "              <4 W 6>"
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
			echo "              <4 W 6>"
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
			echo "                <4 W 6>"
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
			echo "              <4 W 6>"
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
			echo "                     <4 W 6>"
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
			echo "              <4 W 6>"
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
			echo "               <4 W 6>"
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
			echo "              <4 W 6>"
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
#---------------------------------------------------------



##################################################
##wk
## キー待ち
##  SPACEかENTERをまつ
##################################################
function wk(){

	tput civis
	tput cup 26 97
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
	tput cnorm

}

##################################################
## 画面の全情報を更新表示
##   lnSeed[]で画面を更新する
##################################################
function dispAll(){
	clear
	for ((i = 0; i < ${#lnSeed[*]}; i++)) {
		echo "${lnSeed[i]}"
	}

}

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
	tput cup 20 10
	getChrV
}

###########################################
##dspCmdLog
## コマンド結果等簡易表示ウィンドウの更新
##   $1 表示内容
##   $2 lnSeed更新後にmsgウィンドウを更新するか(1:する/他:しない)
##################################################
function dspCmdLog(){

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
	if [ "$2" = "1" ] ; then
		dispAll
	fi
}


###########################################
##modDspWrglPos
## Wriggleの現在座標を画面表示情報へ反映する
## この関数は座標移動処理を行う
## initPosWrgl/movePosWrgl/mvから呼び出されるのみで
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

}

###########################################
##jmpPosWrgl
## Wriggleの位置をx,y指定で移動する
## この関数は強制的に画面を再描画する。
##  $1 X座標(1〜60)
##  $2 Y座標(1〜15) 
###########################################
function jmpPosWrgl(){
#	if [ $1 -lt 1 ] || [ $1 -gt 60 ]; then
#		sysOut "e" $LINENO "X must be between 1 and 60."
#		return
#	fi
#	if [ $2 -lt 1 ] || [ $2 -gt 15 ]; then
#		sysOut "e" $LINENO "Y must be between 1 and 15."
#		return
#	fi

	local declare mapX=$1
	local declare mapY=$2

	local declare lStr="${lnSeed[$((mapY+3))]:0:$(($1+3))}"
	local declare rStr="${lnSeed[$((mapY+3))]:$(($1+4))}"

	lnSeed[$((mapY+3))]="${lStr}W${rStr}"
	
	modDspWrglPos $mapX $mapY

}


#########/##################################
##mv
## キャラ('W'で示す)が動く        7 8 9
##  $1 移動先座標(1〜9)           4 W 6
##                                3 2 1
###########################################
#function mv(){
#	
#	dispAll
#
#}



###########################################
##Main
## どうにかします
###########################################
	clear

#安定するまでは不測の無限ループ脱出のためコメントアウトする
#	trap '' INT QUIT TSTP 
	declare -g inKey=""

#	未実装
#	declare -a posWrgl=(1 1)

	initDispInfo 
	dispAll	

	while :
	do
		getCmd
		case "$inKey" in
			#ciはぶっちゃけテストコード
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
			#jwもテストコード
			"jw"	)	jmpPosWrgl 30 10
						dspCmdLog "Wriggle respowned in X:30/Y:10." 1
						;;
			"mv"	)	mv ;;                                 #mvコマンド
			"??"	)	viewHelp;;                            #コマンドリスト
			"man"*	)	man "${inKey:4}" ;;                   #マニュアル参照コマンド
			"Q"		)	break;;                               #ボスが来た
			""		)	dspCmdLog "input a key." 1 ;;         #エラー
			*		)	dspCmdLog "[$inKey]is invalid." 1 ;;  #エラー
		esac
	done

	#終了時に画面をクリアする
	clear
