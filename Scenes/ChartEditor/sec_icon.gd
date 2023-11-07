extends Sprite2D

var bf = preload("res://Assets/Images/Icons/icon-bf.png")
var dad = preload("res://Assets/Images/Icons/icon-dad.png")
var section : int = 0
var icontype :int = 0
@onready var Chart = $/root/"Chart Editor"

enum {MUST_HIT, GF_SECTION} # アイコンの種類。

# アイコンを押したときの処理
func _on_button_button_down():
	var sec = Chart.chartData.notes[section]
	match icontype:
		MUST_HIT: # MUSTHITが押された
			var mustHit = sec.mustHitSection
			#mustHit = !mustHit
			
			# すべてを反転する必要がある
			#for note in sec.sectionNotes:
			#	var fnfdir = note[Chart.DIR]
				
			#	var dir = Chart.rev_dir_fnfdir(mustHit, fnfdir)
			#	var t = Chart.rev_type_fnfdir(mustHit, fnfdir)
				
			#	var newfnfdir = Chart.calc_fnfdir(!mustHit, t, dir)
			#	note[Chart.DIR] = newfnfdir
			
			Chart.chartData.notes[section].mustHitSection = !mustHit
			
			Chart.redraw_notes()
			
		GF_SECTION:
			pass
	
	set_icon()
	print(Chart.chartData.notes[section].mustHitSection)

# アイコンの再描画。
func set_icon():
	var sec = Chart.chartData.notes[section]
	position.x = Chart.data[Chart.SECTION_INFO].texture_mass.position.x
	
	match icontype:
		MUST_HIT:
			if sec.mustHitSection:
				texture = bf
			else:
				texture = dad
		
		GF_SECTION:
			pass
