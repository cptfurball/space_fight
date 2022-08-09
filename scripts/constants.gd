extends Node


# A single code is made up of a combination of UP, DOWN, LEFT, RIGHT keys.
# Below are the definition of the keys.
const QTE_KEY_A: String = 'key_a'
const QTE_KEY_S: String = 'key_s'
const QTE_KEY_D: String = 'key_d'
const QTE_KEY_F: String = 'key_f'

# A list of the keys available to generate the code.
const QTE_COMBO_KEY_LIST: Array = [
	QTE_KEY_A, 
	QTE_KEY_S, 
	QTE_KEY_D, 
	QTE_KEY_F
]

# Defines the min max length of a single code.
const QTE_COMBO_MAX_LENGTH: int = 4
const QTE_COMBO_MIN_LENGTH: int = 1

const QTE_DIFFICULTY_TIMEOUT: Array = [
	4.0,
	3.0,
	2.0,
	1.0
]

const GROUP_ENEMY: String = 'enemy'
