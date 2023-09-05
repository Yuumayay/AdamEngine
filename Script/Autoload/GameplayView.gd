extends Node

## CONSTS ##
const note_spawn_y: Array = [-600, 1320]
const strum_pos_og: Array = [Vector2(150, 620), Vector2(150, 100)]
const version_text: String = "Adam Engine 1.0"
const version_text_color: Color = Color("ffb7ce")

const gfspeak := {
	"common": 
		["A",
		"B",
		"C"],
	"rare": [],
	"very_rare": []
}

const gfspeakJPN := {
	"common": 
		["Alt+Enterを押すと、フルスクリーンになるよ。",
		"操作キーを変えてみたら、意外と上手くなれるかも・・・？",
		"[concern]えっ？なんで「アダム」エンジンなのかって？\nう～ん、たしか変な白い生き物の名前だった気がするなぁ",
		"[happy]FNFには色んなMODがあるよ。隠れた良作を探してみよう！",
		"曲選択画面でShiftを押しながら左右キーを押すことで、\n曲の倍率を変えることができるよ。",
		"F12を押すと、ガイドを開けるよ！"],
	"rare": 
		["[concern]冷蔵庫のプリンがなくなってたんだけど、もしかして食べた？",
		"[happy]最近BFがかわいいんだよね～！\nいつもかわいいけど！めっちゃ愛でたい！",
		"[happy]オムライスたーべたい♪[wait]オムライスたーべたい♪",
		"[happy]ら～[wait]ららら～♪",
		"[happy]BFと一緒にいて、嫌なことはないよ！",
		"家の鍵かけたかすごい心配になるときない？",
		"美味しいものを食べると、幸せになれるよね。",
		"[concern]あ～、[wait]だらだらしたい。[wait]地面で寝転がりたい。",
		"[happy]Beeep。[wait]BFのマネだよ！どう？"],
	"very_rare": 
		["[concern]私、すごーくアヤシイやつらと会ったことがあるんだ。\nたしか、赤と緑のコンビで・・・そのほかは覚えてないなぁ",
		"[concern]私、頭が爆弾になってる人と会ったことがあるんだ。\n名前はね・・・あれ？なんだったっけ？",
		"[concern]私、ロボット少女と殺人ロボットに会ったことがあるんだ。\n覚えてるのは、殺人ロボットがすごいキレてたことかな。",
		"私、神に近い人とその飼い犬に会ったことがあるんだ。\nで、なんかドッキリに協力させられたよ",
		"私、スポーツで有名なスキンヘッドのおじさんに\n会ったことがあるんだ。すごく高速でラップしてたよ、すごかった！",
		"私、緑の帽子を被った農家と、車椅子に座った青い服の人に\n会ったことがあるんだ。何だか上の次元に行けた気がしたよ！",
		"私、すごいマイクを投げてくる棒人間と会ったことがあるんだ。\nその棒人間は本気を出せば強いタイプだったよ。",
		"[happy]私、有名なボーカロイドと会ったことがあるんだ。\n髪は水色で、ネギを持ってたよ。持ってたっけ。",
		"私からBFを奪おうとしてくる女の子に会ったことがあるんだ。\nその子に板に貼り付けにされてすごい痛かった！",
		"[happy]私、DDRをやってる猫ちゃんと会ったことがあるんだ。\nBFとの熱い対決、また見たいな！",
		"私、地獄みたいな場所でピエロと会ったことがあるんだ。\nなぜか私が縄で縛られて苦しかったよ！",
		"私、教会でトイレを探してたらとある２人に会ったことがあるんだ。\nほんとに漏れそうだったからそれ以上は覚えてないかな。",
		"私、不思議なタバコを吸うおじさんに会ったことがあるんだ。\nで、そのあとなぜかそのおじさん成仏したよ。多分。",
		"[angry]私、催眠術モンスターに会ったことがあるんだ。\nあいつのせいで１週間頭痛とめまいが止まらなかったんだよ！",
		"私、白い体とマイクを持ってる邪神に会ったことがあるんだ。\n私の能力を使って何とかBFと一緒に逃げたよ。"]
}

const SCREEN_X = 1280
const SCREEN_Y = 720

## VARIABLES ##
var strum_pos: Array
var gf_strum_pos: Array

# Gameplay Managerに移動
var keys: Dictionary

func _init():
	loadAssets()

func _ready():
	var l = "left"
	var d = "down"
	var u = "up"
	var r = "right"
	var l2 = "left2"
	var d2 = "down2"
	var u2 = "up2"
	var r2 = "right2"
	var s = "square"
	var rl = "rleft"
	var rd = "rdown"
	var ru = "rup"
	var rr = "rright"
	var rl2 = "rleft2"
	var rd2 = "rdown2"
	var ru2 = "rup2"
	var rr2 = "rright2"
	var p = "plus"
	keys = {
		"1k": [s],
		"2k": [l, r],
		"3k": [l, s, r],
		"4k": [l, d, u, r],
		"5k": [l, d, s, u, r],
		"6k": [l, d, r, l2, u2, r2],
		"7k": [l, d, r, s, l2, u2, r2],
		"8k": [l, d, u, r, l2, d2, u2, r2],
		"9k": [l, d, u, r, s, l2, d2, u2, r2],
		"10k": [l, d, u, r, rl, rr, l2, d2, u2, r2],
		"11k": [l, d, u, r, rl, s, rr, l2, d2, u2, r2],
		"12k": [l, d, u, r, rl, rd, ru, rr, l2, d2, u2, r2],
		"13k": [l, d, u, r, rl, rd, s, ru, rr, l2, d2, u2, r2],
		"14k": [l, d, u, r, rl, rd, rl2, rr2, ru, rr, l2, d2, u2, r2],
		"15k": [l, d, u, r, rl, rd, rl2, s, rr2, ru, rr, l2, d2, u2, r2],
		"16k": [l, d, u, r, rl, rd, ru, rr, rl2, rd2, ru2, rr2, l2, d2, u2, r2],
		"17k": [l, d, u, r, rl, rd, ru, rr, s, rl2, rd2, ru2, rr2, l2, d2, u2, r2],
		"18k": [l, d, u, r, rl, rd, ru, rr, s, p, rl2, rd2, ru2, rr2, l2, d2, u2, r2]
	}

var held: Array
var countdowns: Array
var num: Array
var arrow : AnimatedSprite2D
var arrowSpriteFrames: SpriteFrames
var splash : AnimatedSprite2D
var splashSpriteFrames: SpriteFrames
# 動的に画像を読み出す。
func loadAssets():
	arrow = Game.load_XMLSprite("Assets/Images/Notes/Default/default.xml")
	arrowSpriteFrames = arrow.sprite_frames
	
	splash = Game.load_XMLSprite("Assets/Images/Notes/Default/Note_Splashes.xml")
	splashSpriteFrames = splash.sprite_frames
	
	held = [Game.load_image("Assets/Images/Notes/Default/held/left hold0000.png"),
	Game.load_image("Assets/Images/Notes/Default/held/down hold0000.png"),
	Game.load_image("Assets/Images/Notes/Default/held/up hold0000.png"),
	Game.load_image("Assets/Images/Notes/Default/held/right hold0000.png")]
		
	countdowns = [Game.load_image("Assets/Images/Skins/FNF/Countdown/ready.png"),
	Game.load_image("Assets/Images/Skins/FNF/Countdown/set.png"),
	Game.load_image("Assets/Images/Skins/FNF/Countdown/go.png")]
	
	num = [Game.load_image("Assets/Images/Skins/FNF/Numbers/num0.png"),
	Game.load_image("Assets/Images/Skins/FNF/Numbers/num1.png"),
	Game.load_image("Assets/Images/Skins/FNF/Numbers/num2.png"),
	Game.load_image("Assets/Images/Skins/FNF/Numbers/num3.png"),
	Game.load_image("Assets/Images/Skins/FNF/Numbers/num4.png"),
	Game.load_image("Assets/Images/Skins/FNF/Numbers/num5.png"),
	Game.load_image("Assets/Images/Skins/FNF/Numbers/num6.png"),
	Game.load_image("Assets/Images/Skins/FNF/Numbers/num7.png"),
	Game.load_image("Assets/Images/Skins/FNF/Numbers/num8.png"),
	Game.load_image("Assets/Images/Skins/FNF/Numbers/num9.png")]
