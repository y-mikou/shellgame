: '■内部処理系' && {
	: '初期処理' && {
		###########################################
		## 初期処理
		##  主に定数定義など
		###########################################
		initDef(){
		: 'GLOBAL変数定義' && {
				declare -g  inKey=''
				declare -g inKey2=''
				
				#CONSTANT値
				##IFS
				##IFS=$' \t\n'
				declare -r -g CNST_IFS_DEFAULT=$IFS
			}
		: '画面レイアウト系コンスタント値定義' && {
				##座標							   XX YY
				declare -r -g     CNST_POS_CMDWIN='20 10' #コマンド入力ウィンドウ
				declare -r -g    CNST_POS_CMDWIN2='20 11' #コマンド入力ウィンドウ
				declare -r -g CNST_POS_MAPTIPFOOT='20 47' #現在マップチップ表示窓
				declare -r -g       CNST_POS_WKMK='26 97' #キー待ち記号表示位置

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

											#  0   1     2    3   4   5   6   7   8   9   
											#  DSP CNM   CID  STS ENT STY OPN DST EVE NME
				declare -r -g -a  CNST_MAP_0=('-' 'WAL' '00' '0' '0' '1' '1' '0' '1' 'Wall')
				declare -r -g -a  CNST_MAP_1=('+' 'WAL' '01' '0' '0' '1' '1' '0' '1' 'Wall')
				declare -r -g -a  CNST_MAP_2=('=' 'WAL' '02' '0' '0' '1' '1' '0' '1' 'Wall')
				declare -r -g -a  CNST_MAP_3=('|' 'WAL' '03' '0' '0' '1' '1' '0' '1' 'Wall')
				declare -r -g -a  CNST_MAP_4=('X' 'WAL' '04' '0' '0' '1' '1' '0' '1' 'Wall')
				declare -r -g -a  CNST_MAP_5=('F' 'FLR' '00' '0' '1' '0' '9' '0' '0' 'Floor') #' 'は意図通りに動かないため’F’に読み替える
				declare -r -g -a  CNST_MAP_6=('.' 'FLR' '01' '0' '1' '0' '0' '0' '0' 'Path')
				declare -r -g -a  CNST_MAP_7=('#' 'FLR' '02' '0' '1' '1' '1' '0' '0' 'Junction')
				declare -r -g -a  CNST_MAP_8=('D' 'DOR' '00' '0' '0' '1' '1' '1' '1' 'KeylessDoorClosed')
				declare -r -g -a  CNST_MAP_9=('[' 'DOR' '00' '1' '1' '1' '1' '1' '1' 'KeylessDoorOpend')
				declare -r -g -a CNST_MAP_10=('v' 'STD' '00' '1' '1' '1' '1' '1' '1' 'StairsDOWN')
				declare -r -g -a CNST_MAP_11=('^' 'STU' '00' '1' '1' '1' '1' '1' '1' 'StairsUP')
				declare -r -g -a CNST_MAP_99=('e' 'ERR' 'ee' 'e' 'e' 'e' 'e' 'e' 'e' 'Error')
				#declare -r -g -a  CNST_MAP_XX=('#' 'UNX' '00' '0' '0' '0' '0' '0' '0' 'Unexplored')

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

			}
		: 'その他コンスタント値定義' && { 
				##sayRnd関数の種別
				declare -r -g  CNST_RND_WALL='1' #壁激突音
				declare -r -g  CNST_RND_DOOR='2' #扉じゃないところを扉
				declare -r -g CNST_RND_WEMEN='3' #女性接触声
				declare -r -g  CNST_RND_DASH='4' #ダッシュ音
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

			local declare cntStr="$1"

			#半角英数記号以外の文字以外を消す=半角文字数
			local declare cntS=$(echo -n "$cntStr" | sed -e 's@[^A-Za-z0-9~!@#$%&_=:;><,*+.?{}()\ -|¥]@@g' | wc -m)

			#半角英数記号の文字を消す=全角文字数
			local declare cntW=$(echo -n "$cntStr" | sed -e 's@[A-Za-z0-9~!@#$%&_=:;><,*+.?{}()\ -|¥]@@g' | wc -m)

			#全角文字数を示すcntWは二倍して、2つを足す
			echo -n "$(($(($cntW * 2))+$cntS))"
		}
		}
	: '不正文字個別置換' && {
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
			local declare local tgtchip=''
			local declare local rslt=''

			local declare objDrction="${lnMapInfo[$((10#$2))]:$((10#$1)):1}"
			local declare local idx=99

			#対象マップチップとして’ ’が渡された場合、想定通りの動きをしないため
			#' 'の代わりに’F’とみなす。
			if [ "$objDrction" = ' ' ] ; then
				objDrction='F'
			fi

			for ((i = 0; i < 99; i++)) {
				if [ "$(eval 'echo ${CNST_MAP_'$i'[0]}')" = "$objDrction" ] ; then
					idx=i
					break
				fi
			}

			rslt=$(eval 'echo ${CNST_MAP_'$((idx))'[$(($3))]}')

			#表示内容を返すことはないと思うが、結果が’F’だった場合は、’ ’へ戻す。
			if [ "$rslt" = 'F' ] ; then
				echo ' '
			else
				echo "$rslt"
			fi

		}
		}

	: '指示マス座標計算' && {
		###########################################
		##clcDirPos
		## 進入マスの座標計算
		##  $1:方向指示(1-9,zxcasdqwe)
		###########################################
		function clcDirPos(){
			local declare posX=$((10#${lnSeed[1]:1:2}-1))
			local declare posY=$((10#${lnSeed[2]:1:2}-1))
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
						dspCmdLog 'Cmd canceled.'
						dispAll
						return
						;;
				*		)	sysOut 'e' $LINENO 'Direction value Error.'
			esac

			tgtX=$((10#$posX+dirX))
			tgtY=$((10#$posY+dirY))

			echo "$tgtX:$tgtY"

		}
		}
	: 'ドア開ける' && {
		###########################################
		##openDoor
		## ドアを消す
		##  $1:X座標
		##  $2:Y座標
		##   $1$2が指す座標がドアマスであることが確定してから呼ぶこと
		###########################################
		function openDoor(){

			local declare mapX=$((10#$1))
			local declare mapY=$((10#$2))

			#表示情報の更新
			local declare lStrD="${lnSeed[$((mapY+4))]:0:$((mapX+4))}"
			local declare rStrD="${lnSeed[$((mapY+4))]:$((mapX+5))}"
			#正解マップ情報への反映
			local declare lStrM="${lnMapInfo[$((mapY))]:0:$((mapX))}"
			local declare rStrM="${lnMapInfo[$((mapY))]:$((mapX+1))}"

			#ドアなど変化情報をセーブデータに残す必要のあるマップチップは、
			#lnSeedとlnMapInfoの両方を更新する必要がある。
			lnSeed[$((mapY+4))]="${lStrD}[${rStrD}"
			lnMapInfo[$((mapY))]="${lStrM}[${rStrM}"
			
			dispAll

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
				sysOut 'e' $LINENO 'Set 2 arguments.'
				return
			fi
			##$1の範囲
			if [ $1 -lt 0 ] || [ $1 -gt $CNST_MAP_SIZ_X ]; then
				sysOut 'e' $LINENO "'X' must be between 1 and $CNST_MAP_SIZ_X."'$1'"=$1"
				return
			fi
			##$2の範囲
			if [ $2 -lt 0 ] || [ $2 -gt $CNST_MAP_SIZ_Y ]; then
				sysOut 'e' $LINENO "'Y' must be between 1 and $CNST_MAP_SIZ_Y."'$2'"=$2"
				return
			fi

			local declare mapX=$((10#$1))
			local declare mapY=$((10#$2))

			local declare lStr="${lnSeed[$((mapY+4))]:0:$((mapX+4))}"
			local declare rStr="${lnSeed[$((mapY+4))]:$((mapX+5))}"
			local declare maptipFoot="$(getMapInfo $mapX $mapY 'DSP')"

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

			local declare mapX=$((10#$1))
			local declare mapY=$((10#$2))

			local declare lStr="${lnSeed[$((mapY+4))]:0:$((mapX+4))}"
			local declare rStr="${lnSeed[$((mapY+4))]:$((mapX+5))}"

			local declare X=$(printf "%02d" $(($1+1)))
			local declare Y=$(printf "%02d" $(($2+1)))

			local declare row1Right="${lnSeed[1]:3}"
			local declare row2Right="${lnSeed[2]:3}"

			lnSeed[1]="|$X$row1Right"
			lnSeed[2]="|$Y$row2Right"

			#ダッシュ移動中のマス開示は足元のマスのみ?
			opnArndMaptip
			#lnSeed[$((mapY+4))]="$lStr${lnMapInfo[$((mapY))]:$((mapX)):1}$rStr"

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
				$CNST_RND_DOOR	)	#扉じゃないところを開けようとする
						case "$rslt" in
							'0'	)	echo 'Open social window...?';;
							'1'	)	echo 'There is no door.';;
							'2'	)	echo 'There is no door.';;
							'3'	)	echo 'There is no door.';;
							'4'	)	echo 'There is no door.';;
							'5'	)	echo 'There is no door.';;
							'6'	)	echo 'There is no door.';;
							'7'	)	echo 'There is no door.';;
							'8'	)	echo 'There is no door.';;
							'9'	)	echo 'There is no door.';;
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
				$CNST_RND_DASH	)	#ダッシュ音
						case "$rslt" in
							'0'	)	echo 'ksksksksksksksk...';;
							'1'	)	echo 'Scurry...';;
							'2'	)	echo 'Scamper!!';;
							'3'	)	echo 'ksksksksksksksk...';;
							'4'	)	echo 'Zoooooooooom';;
							'5'	)	echo 'Zoooooooooom!';;
							'6'	)	echo 'ksksksksksksksk...';;
							'7'	)	echo 'ksksksksksksksk...';;
							'8'	)	echo 'Dashhhhh!';;
							'9'	)	echo 'Go!Go!Go!';;
							*	)	sysOut 'e' $LINENO '<sayRnd> Arg Error.'
						esac
						;;
				*	)	sysOut 'e' $LINENO '<sayRnd> Arg Error.'
			esac

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

			#初期状態    000000000011111111112222222222333333333344444444445555555555+1
			#文字数      012345678901234567890123456789012345678901234567890123456789+1
			lnMapInfo+=('+---------------------------+-----------------------+XXXXXXX') #00+1
			lnMapInfo+=('|                           D                       |XXXXXXX') #01+1
			lnMapInfo+=('|                           +-+-------------+D+-----+XXXXXXX') #02+1
			lnMapInfo+=('+                           |X|                     |XXXXXXX') #03+1
			lnMapInfo+=('#                           |X|                     |XXXXXXX') #04+1
			lnMapInfo+=('#                           |X+--+                  +----+XX') #05+1
			lnMapInfo+=('#                           |XXXX|                       |XX') #06+1
			lnMapInfo+=('+                           |XXXX|                  +--+ |XX') #07+1
			lnMapInfo+=('|                           |XXXX+------------------+XX| |XX') #18+1
			lnMapInfo+=('|v                          |XXXXXXXXXXXXXXXXXXXXXXXXXX| |XX') #19+1
			lnMapInfo+=('+---------------------------+--------------------------+D+XX') #10+1
			lnMapInfo+=('|                                                        |XX') #11+1
			lnMapInfo+=('+-+D+-+-------------------+D+---------------+            |XX') #12+1
			lnMapInfo+=('|     |XXXXXXXXXXXXXXXXXXX| |XXXXXXXXXXXXXXX+------------+XX') #13+1
			lnMapInfo+=('+-----+XXXXXXXXXXXXXXXXXXX+#+XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') #14+1
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
			lnSeed+=('+--+------------------------------------------------------------++------------+----------+---------+') #00
			lnSeed+=('|01|000000000111111111122222222223333333333444444444455555555556||Wriggle     |Bug       |Fighter  |') #01
			lnSeed+=('|01|123456789012345678901234567890123456789012345678901234567890|+--+---------+----------+---------+') #02
			lnSeed+=('+--+------------------------------------------------------------+|HP| 100/ 100|BLv: 1=     0/    10|') #03
			lnSeed+=('|01|                                                            ||MP| 100/ 100|JLv: 1=     0/    10|') #04
			lnSeed+=('|02|                                                            |+--+--+--+--++-+--++--+--+--+--+--+') #05
			lnSeed+=('|03|                                                            ||✝|💊|💤|❔|🔇|👓||💪|🛡|🔯|🏃|🍀|') #06
			lnSeed+=('|04|                                                            |+--+--+--+--+--+--++--+--+--+--+--+') #07
			lnSeed+=('|05|                                                            || 0| 0| 0| 0| 0| 0|| 0| 0| 0| 0| 0|') #08
			lnSeed+=('|06|                                                            |+--+--+--+--+--+--++--+--+--+--+--+') #09
			lnSeed+=('|07|                                                            ||  VAL - STS - PAR |🔨|⛰|💧|🔥|🌪|') #10
			lnSeed+=('|08|                                                            ||*  10 < Str > Atk |10|10|10|10|10|') #11
			lnSeed+=('|09|                                                            ||   10 < Int > Mat |10|10|10|10|10|') #12
			lnSeed+=('|10|                                                            ||   10 < Vit > Def |10|10|10|10|10|') #13
			lnSeed+=('|11|                                                            ||   10 < Mnd > Mdf |10|10|10|10|10|') #14
			lnSeed+=('|12|                                                            ||   10 < Snc > XBns| 1  %+==+=====+') #15
			lnSeed+=('|13|                                                            ||   10 < Dex > Hit |10  %|Jw|    0|') #16
			lnSeed+=('|14|                                                            ||   10 < Agi > Flee|10  %|Gd|    0|') #17
			lnSeed+=('|15|                                                            ||   10 < Luk > Cri |10  %|Sv|   50|') #18
			lnSeed+=('+==+=========================================+===+==============++==================+=====+==+=====+') #19
			lnSeed+=('|COMMAND>                                    |   |                                                 |') #20
			lnSeed+=('+==+=========================================+===+===========================input [??] to help.===+') #21
			lnSeed+=('|91|                                                                                               |') #22
			lnSeed+=('|92|                                                                                               |') #23
			lnSeed+=('|93|                                                                                               |') #24
			lnSeed+=('|94|                                                                                               |') #25
			lnSeed+=('|95|                                                                                               |') #26
			lnSeed+=('+--+-----------------------------------------------------------------------------------------------+') #27

			}
		}
	
	: 'マップレイヤー結合' && {
		##################################################
		## joinFrameOnMap
		##  画面フレームと、表示情報を結合する
		##   lnSeedのマップ枠の中にdspMapInfoをはめ込む。
		##################################################
		function joinFrameOnMap (){
			
			for ((i = 0; i <= 14; i++)) {
				lnSeed[4+i]="${lnSeed[4+i]:0:4}${lnDspMap[i]}${lnSeed[4+i]:64}"
				}
			}
		}
	: '全画面更新' && {
		##################################################
		## 画面の全情報を更新表示
		##  lnSeed[]で画面を更新する
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

			declare local maptipFoot="${lnSeed[20]:48:1}"

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
			local declare X=$(printf "%02d" "$1")
			local declare Y=$(printf "%02d" "$2")

			local declare row1Right="${lnSeed[1]:3}"
			local declare row2Right="${lnSeed[2]:3}"

			local declare  row20Left="${lnSeed[20]:0:47}"
			local declare row20Right="${lnSeed[20]:48}"

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
			local declare posX=$((10#${lnSeed[1]:1:2}-1))
			local declare posY=$((10#${lnSeed[2]:1:2}-1))

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
			echo '***Command List***  Press [q]key to exit.'
			echo ''
			echo 'man [CMD]   : [CMD] CommandManual'
			echo '[...]can    : Cancel a command being entered.'
			echo 'sv [n]      : Save to data [n] the current state.'
			echo 'svq [n]     : Save to data [n] the current state and quit this game.'
			echo 'qqq         : Quit this game (without save).'
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
				'op'	)	man_op ;;
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
				'man'	)	man_man ;;
				*		)	dspCmdLog "[$1] is Invalid CMD."
							dispAll;;
			esac
			}
		: '■マニュアル詳細' && {
			: 'canコマンドマニュアル' && {
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
				}
			: 'sqコマンドマニュアル' && {
				function man_sq(){

					inKey=''
					tput smcup

					clear

					echo '*** Command Manual:[svq] ***'
					echo '<Format>'
					echo ' svq [n]'
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
				}
			: 'svコマンドマニュアル' && {
				function man_svq(){

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
				}
			: 'qqqコマンドマニュアル' && {
				function man_qqq(){

					inKey=''
					tput smcup

					clear

					echo '*** Command Manual:[qqq] ***'
					echo '<Format>'
					echo ' qqq'
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
				}
			: 'mvコマンドマニュアル' && {
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
				}
			: 'opコマンドマニュアル' && {
				function man_op(){

					inKey=''
					tput smcup

					clear

					echo '*** Command Manual:[op] ***'
					echo '<Format>'
					echo ' op [arg]'
					echo ' * arg=1~9, [zxcasdqwe] or [ZXCASDQWE].'
					echo ''
					echo '<Function>'
					echo ' Wriggle opens the door in the direction of [9].'
					echo '      (for locked doors, only if you have a suitable key).'
					echo ' Consume 1 turn.'
					echo ' She over the door of the thorn is not always waiting for me favorably.'
					echo ''
					echo ' open the door...   \  ^  /   \  ^  /   \  ^  /'
					echo '                     7 8 9     q w e     Q W E '
					echo '                    <4 ¥ 6>   <a ¥ d>   <A ¥ D>'
					echo '                     3 2 1     z x c     A X C '
					echo '                    /  v  \   /  v  \   /  v  \  *5 is invalid.'
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
				}
			: 'kiコマンドマニュアル' && {
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
				}
			: 'wpコマンドマニュアル' && {
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
				}
			: 'ctコマンドマニュアル' && {
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
				}
			: 'ivコマンドマニュアル' && {
				function man_iv(){

					inKey=''

					tput smcup
					clear

					echo '*** Command Manual:[iv] ***'
					echo '<Format>'
					echo ' iv [arg]'
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
				}
			: 'gtコマンドマニュアル' && {
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
				}
			: 'trコマンドマニュアル' && {
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
				}
			: 'tkコマンドマニュアル' && {
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
				}
			: 'prコマンドマニュアル' && {
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
				}
			: 'ssコマンドマニュアル' && {
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
				}
			: 'manコマンドマニュアル' && {
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
				}
			}
			}
	: 'mvコマンド' && {
		###########################################
		##mv
		## キャラ('¥'で示す)が動く           7 8 9  q w e
		##  $1 移動先座標(1〜9,zxcasdqwe)    4 ¥ 6  a ¥ d
		##        ※大文字でも良い           3 2 1  z x c
		###########################################
		function mv(){
			local declare goX=''
			local declare goY=''
			local declare direction="$1"

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] || [ "$direction" = '' ]; then
				dspCmdLog '<mv> Set 1 arguments.'
				dispAll
				return
			fi

			##$1のバリエーション
			if  [ ! $(echo 'ZXCASDQWEzxcasdqwe123456789' | grep "$direction") ] ; then
				dspCmdLog '<mv> Enter 1-9 or 1 of"zxcasdqwe(or Capital)".'
				dispAll
				return
			fi

			tput civis

			#5Ssだったら足踏み
			if  [ $(echo '5Ss' | grep "$direction") ] ; then
				dspCmdLog 'Hoppn'"'"'nnnnn!'
			else
				#一時的に区切り文字を変更する
				IFS=':'
				set -- $(clcDirPos "$direction")
				goX=$1
				goY=$2
				#区切り文字を戻す
				IFS=$CNST_IFS_DEFAULT

				#移動先が移動不可だったら「ぶつかりボイス」
				#そうでなければ移動する
				if	[ "$(getMapInfo $goX $goY 'ENT')" = $CNST_YN_N ] ; then
						dspCmdLog "$(sayRnd $CNST_RND_WALL)"
				else
					case "$(getMapInfo $goX $goY 'DSP')" in
						'#'	)	#マップ切り替え
								modMsg 1 1 'マップ切替は未実装です';;
						'^'	)	#上り階段
								clrCmdLog
								jmpPosWrgl $goX $goY
								modMsg 1 1 '上り階段は未実装です';;
						'v'	)	#下り階段
								clrCmdLog
								jmpPosWrgl $goX $goY
								modMsg 1 1 '下り階段は未実装です';;
						*)		#他
								clrCmdLog
								jmpPosWrgl $goX $goY
					esac
				fi
			fi
		
			dispAll
			tput cvvis

		}
		}
	: 'opコマンド' && {
		###########################################
		##op
		## ドアを開く。但し、適合する鍵を持っている場合のみ。
		##  $1 移動先座標(1〜9,zxcasdqwe)
		##                        ※大文字でも良い
		###########################################
		function op(){

			local declare opX=''
			local declare opY=''

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] || [ "$1" = '' ]; then
				dspCmdLog '<op> Set 1 arguments.'
				dispAll
				return
			fi
			##$1のバリエーション
			if  [ ! $(echo 'ZXCASDQWEzxcasdqwe123456789' | grep "$1") ] ; then
				dspCmdLog '<op> Enter 1-9 or 1 of"zxcasdqwe(or Capital)".'
				dispAll
				return
			fi

			if  [ $(echo '5Ss' | grep "$1") ] ; then
				:
			else
				#一時的に区切り文字を変更する
				IFS=':'
				set -- $(clcDirPos "$1")
				opX=$1
				opY=$2
				#区切り文字を戻す
				IFS=$CNST_IFS_DEFAULT

				if	[ "$(getMapInfo $opX $opY 'CNM')" != 'DOR' ] ; then
					dspCmdLog "$(sayRnd "$CNST_RND_DOOR")"
				else
					clrCmdLog
					modMsg 1 1 'ひらけごま！'
					openDoor $opX $opY 
				fi
				dispAll
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

			local declare ivX=''
			local declare ivY=''

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] || [ "$1" = '' ]; then
				dspCmdLog '<op> Set 1 arguments.'
				dispAll
				return
			fi
			##$1のバリエーション
			if  [ ! $(echo 'ZXCASDQWEzxcasdqwe123456789' | grep "$1") ] ; then
				dspCmdLog '<op> Enter 1-9 or 1 of"zxcasdqwe(or Capital)".'
				dispAll
				return
			fi

			if  [ $(echo '5Ss' | grep "$1") ] ; then
				##今は足元以外を調べる行動と足元を調べる行動は、マスが違うだけで処理内容は同じ。
				##いずれ足元と足元以外で範囲を変更するなどあるかもしれないのでif分岐は残置する

				#一時的に区切り文字を変更する
				IFS=':'
				set -- $(clcDirPos "$1")
				ivX=$1
				ivY=$2
				#区切り文字を戻す
				IFS=$CNST_IFS_DEFAULT

				lnSeed[$ivY+4]=${lnSeed[$ivY+4]:0:$ivX+4}${lnMapInfo[$ivY]:$ivX:1}${lnSeed[$ivY+4]:$ivX+5}
				dspCmdLog "Wriggle has investigate for $(($ivX+1)):$(($ivY+1))"
				modMsg 1 1 "Wriggle : There is a $(getMapInfo $ivX $ivY $NME)."
			else
				#一時的に区切り文字を変更する
				IFS=':'
				set -- $(clcDirPos "$1")
				ivX=$1
				ivY=$2
				#区切り文字を戻す
				IFS=$CNST_IFS_DEFAULT

				lnSeed[$ivY+4]=${lnSeed[$ivY+4]:0:$ivX+4}${lnMapInfo[$ivY]:$ivX:1}${lnSeed[$ivY+4]:$ivX+5}
				dspCmdLog "Wriggle has investigate for $(($ivX+1)):$(($ivY+1))"
				modMsg 1 1 "Wriggle : There is a $(getMapInfo $ivX $ivY $NME)."
			fi
			dispAll

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
			local declare goX=''
			local declare goY=''
			local declare direction=$1

			#バリデーション
			##引数の個数
			if [ $# -ne 1 ] || [ "$direction" = '' ]; then
				dspCmdLog '<da> Set 1 arguments.'
				dispAll
				return
			fi
			##$1のバリエーション
			if  [ ! $(echo 'ZXCASDQWEzxcasdqwe123456789' | grep "$direction") ] ; then
				dspCmdLog '<da> Enter 1-9 or 1 of"zxcasdqwe(or Capital)".'
				dispAll
				return
			fi

			tput civis

			#5Ssだったら足踏み
			if  [ $(echo '5Ss' | grep "$direction") ] ; then
				dspCmdLog 'Hoppn'"'"'nnnnn!'
			else

				#一時的に区切り文字を変更する
				IFS=':'
				set -- $(clcDirPos "$direction")
				goX=$1
				goY=$2

				#進行方向が通常床である限り直進する
				while [ "$(getMapInfo $goX $goY 'DSP')" = ' ' ]
				do
					goAheadWrgl $goX $goY
					#jmpPosWrgl $goX $goY
					set -- $(clcDirPos "$direction")
					goX=$1
					goY=$2
				done

				local declare posX=$((10#${lnSeed[1]:1:2}))
				local declare posY=$((10#${lnSeed[2]:1:2}))

				modDspWrglPos $posX $posY "$(getMapInfo $((posX-1)) $((posY-1)) 'DSP')"
				
				#区切り文字を戻す
				IFS=$CNST_IFS_DEFAULT
				
				#実行メッセージ
				dspCmdLog $(sayRnd $CNST_RND_DASH)

			fi

			#終着マスのみ周囲開示
			#opnArndMaptip

			dispAll
			tput cvvis

		}
		}

	: 'テストコマンド' && {
		##テストコマンドなので雑
		function ci(){
			dspCmdLog 'チルノ？どうかした？'
			modMsg 1 1 'チルノ[え？]'
			dispAll
			wk
			modMsg 2 1 'チルノ[¥ど、どうもしねーよ……///]'
			dispAll
			wk
			modMsg 3 1 '!庭には一羽庭渡changがいる。庭には二羽庭渡changがいる。庭には三羽庭渡changがいる。庭には四羽庭渡changがいる。'
			dspCmdLog 'ローリーのローリングソバット!!昼に食べた麻辣担々麺でマーライオンに変身！'
			dispAll
			wk
			clrMsgWin
			dispAll
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
			dspCmdLog 'Wriggle respowned.'
			dispAll
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
		}
	: 'コマンド受付' && {
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
				*'can'	)	dspCmdLog 'Alright, Command canceled :)' dispAll;;
				'ci'	)	ci ;;
				'??'	)	viewHelp;; 
				'man'*	)	man "${inKey:4}";;
				'mv'*	)	mv "${inKey:3}";;
				'op'*	)	op "${inKey:3}";;
				'da'*	)	da "${inKey:3}";;
				'qq'	)	da 7;;
				'ww'	)	da 8;;
				'ee'	)	da 9;;
				'aa'	)	da 4;;
				'dd'	)	da 6;;
				'zz'	)	da 1;;
				'xx'	)	da 2;;
				'cc'	)	da 3;;
				'sv'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'sq'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'ki'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'wp'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'ct'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'iv'*	)	iv "${inKey:3}";;
				'gt'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'tr'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'tk'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'pr'*	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'ss'	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'sv'	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'svq'	)	dspCmdLog "Sorry, [$inKey]Cmd is not yet implemented.";;
				'qqq'	)	quitGame;;
				' '		)	dspCmdLog 'Input key.';;
				*		)	dspCmdLog "[$inKey]is invalid.";;
			esac
			dispAll
		}
		}
	}
: '■メイン' && {

	###########################################
	##main
	## mainLoopをキックする主制御
	###########################################

	clear
	#安定するまでは不測の無限ループ脱出のためコメントアウトする
	#trap '' INT QUIT TSTP 

	initDef
	defMapInfo
	dspMapInfo
	initDispInfo 
	joinFrameOnMap
	dispAll

	#主処理
	mainLoop

	#終了時に文字修飾を除去し、画面をクリアする
	quitGame
	}
