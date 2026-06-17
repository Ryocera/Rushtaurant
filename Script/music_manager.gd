extends AudioStreamPlayer2D

func _ready():
	play()

func stop_music():
	stop()

func change_music(new_stream: AudioStream):
	stream = new_stream
	play()
