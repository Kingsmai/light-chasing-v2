extends Node
class_name LevelGenerator
# Use to Generate Dungeon map


# 1. 随机得到一个房间数量
# 2. 创建一个根节点
# 3. 随机创建一棵树
	# 1. 确认当前节点所有的子孙节点数量 = 剩余房间数量 - 1
	# 2. 随机将子孙节点数量分半
	# 3. 从左节点下去创建一个新的节点，重复步骤 1
# 4. 返回整棵树

