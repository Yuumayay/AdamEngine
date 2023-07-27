extends ItemList

var tooltips: Dictionary = {
	"English": [
		"Attack:\nModchart of attacks that can be dodged with the space key, like sawblades in QT MOD.",
		"Bind Change:\nForces a change in key bindings.",
		"Cheating Modchart:\nThe position and direction of the arrows are messed up.",
		"Darkness:\nDarken the area around a given position or character.",
		"Disrupt Modchart:\nThe arrows are stretched and swing up, down, left, and right.",
		"Flash:\nFlash the area around a given position or character.",
		"Flip Arrow:\nReverse the arrows left and right.",
		"Flip Position:\nReverse the positions of Dad and BF, and reverse the position of the strum.",
		"Freeze:\nWhen the condition is met, the BF becomes frozen and inoperable.",
		"Game Crash:\nCrashes the game.",
		"Ghost Notes:\nMakes it difficult to see the notes.",
		"Health Drain:\nWhen an enemy hits a note, BF health is drained.",
		"Health Gain:\nIncrease the rate of increase in health.",
		"Hypno Pendelum:\nLike Hypno's pendulum, the space key must be pressed in rhythm or the game is over.",
		"Jumpscare:\nThe image is displayed on the entire screen and sound is played. BOO!",
		"Lyrics Modchart:\nDisplay the lyrics on the screen.",
		"Miss Limit:\nMake it so that the game is over if the number of misses exceeds the specified number, as in Black.",
		"No Character Editor:\nDisable debugging of the 0 key.",
		"No Cheat:\nDisable debugging of the 7 key.",
		"No Ghost Tapping:\nForces ghost tapping to turn off.",
		"No Hack:\nSwitches to prohibit unauthorized access from the chart editor.",
		"Poison:\nWhen the condition is met, the BF becomes poisoned.",
		"Popups:\nDisplays a popup on the screen that reduces visibility.",
		"Screen Shake:\nShake the screen.",
		"Sick Only:\nSick Only",
		"Trail:\nAttach a trail to the character.",
		"Unfairness Modchart:\nMake the strums go round and round."
	],
	"Japanese": [
		"攻撃:\nQT MODのノコギリのようなスペースキーでよける攻撃を出します。",
		"操作キー変更:\n操作キーを特定のキーに変更します。",
		"チーターなモッドチャート:\n矢印の向きと位置がめちゃくちゃになります。",
		"暗闇:\n指定位置またはキャラクターの周りを暗くします。",
		"ディスラプトなモッドチャート:\n矢印が引き延ばされ、上下左右にゆらゆらします。",
		"フラッシュ:\nカスタマイズ可能な光を出します。",
		"矢印反転:\n矢印と操作を左右反転させます。",
		"立場逆転:\nDad側とBF側が反転して左側が操作キャラになります。",
		"フリーズ:\n指定の条件を満たすとBFが凍って操作不能になります。",
		"ゲームクラッシュ:\nゲーム自体をクラッシュさせます。",
		"ゴーストノーツ:\nノーツを見えづらくします。",
		"ヘルスドレイン:\n敵がノーツを打つとヘルスが吸い取られます。",
		"ヘルスゲイン:\n自分のヘルス増加量が増えます。",
		"Hypnoの振り子:\nHypnoの振り子のように、タイミングを合わせてスペースキーを押さないとゲームオーバーにするようにします。",
		"脅かし:\n音を鳴らし、画像を画面全体に表示させます。",
		"歌詞:\n画面に歌詞を表示させます。",
		"Miss Limit:\nMake it so that the game is over if the number of misses exceeds the specified number, as in Black.",
		"No Character Editor:\nDisable debugging of the 0 key.",
		"No Cheat:\nDisable debugging of the 7 key.",
		"No Ghost Tapping:\nForces ghost tapping to turn off.",
		"No Hack:\nSwitches to prohibit unauthorized access from the chart editor.",
		"Poison:\nWhen the condition is met, the BF becomes poisoned.",
		"Popups:\nDisplays a popup on the screen that reduces visibility.",
		"Screen Shake:\nShake the screen.",
		"Sick Only:\nSick Only",
		"Trail:\nAttach a trail to the character.",
		"Unfairness Modchart:\nMake the strums go round and round."
	]
}

func _ready():
	for i in item_count:
		set_item_tooltip(i, tooltips[Game.language][i])
